Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984Ab2EVPBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:01:34 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49734 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239Ab2EVPBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:01:31 -0400
Date: Tue, 22 May 2012 18:01:19 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, dedekind1@gmail.com,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        tim.bird@am.sony.com, tglx@linutronix.de
Subject: Re: [PATCH] [RFC] UBI: Implement Fastmap support
Message-ID: <20120522180119.2c2a10a8@pixies.home.jungo.com>
In-Reply-To: <1337608916-49771-2-git-send-email-richard@nod.at>
References: <1337608916-49771-1-git-send-email-richard@nod.at>
	<1337608916-49771-2-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Richard,

Just reviewed your patch, besides fastmap.c and ubi-media.h (will get to
them soon).
Some comments below.

On Mon, 21 May 2012 16:01:56 +0200 Richard Weinberger <richard@nod.at> wrote:
> Fastmap (aka checkpointing) allows attaching of an UBI volume in nearly
> constant time. Only a fixed number of PEBs has to be scanned.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/mtd/ubi/Makefile    |    2 +-
>  drivers/mtd/ubi/attach.c    |   68 +++-
>  drivers/mtd/ubi/build.c     |   23 +
>  drivers/mtd/ubi/eba.c       |   18 +-
>  drivers/mtd/ubi/fastmap.c   | 1132 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/mtd/ubi/ubi-media.h |  118 +++++
>  drivers/mtd/ubi/ubi.h       |   61 +++-
>  drivers/mtd/ubi/wl.c        |  170 +++++++-
>  8 files changed, 1568 insertions(+), 24 deletions(-)
>  create mode 100644 drivers/mtd/ubi/fastmap.c

The Kconfig changes are not present in this patch.

> @@ -977,7 +977,12 @@ static int scan_peb(struct ubi_device *ubi, struct ubi_attach_info *ai,
>  	}
>  
>  	vol_id = be32_to_cpu(vidh->vol_id);
> -	if (vol_id > UBI_MAX_VOLUMES && vol_id != UBI_LAYOUT_VOLUME_ID) {
> +
> +	if (vol_id > UBI_MAX_VOLUMES &&
> +		vol_id != UBI_LAYOUT_VOLUME_ID &&
> +		((vol_id != UBI_FM_SB_VOLUME_ID &&
> +		vol_id != UBI_FM_DATA_VOLUME_ID) ||
> +		ubi->attached_by_scanning == true)) {

I think it would be easier to understand if 'attached_by_scanning' is
evaluated first:

+		(ubi->attached_by_scanning == true ||
+		(vol_id != UBI_FM_SB_VOLUME_ID &&
+		vol_id != UBI_FM_DATA_VOLUME_ID))) {

>  /**
> - * ubi_attach - attach an MTD device.
> - * @ubi: UBI device descriptor
> + * scan_fastmap - attach MTD device using fastmap.
> + * @ubi: UBI device description object
>   *
> - * This function returns zero in case of success and a negative error code in
> - * case of failure.
> + * This function attaches a MTD device using a fastmap and returns complete
> + * information about it in form of a "struct ubi_attach_info" object. In case
> + * of failure, an error code is returned.
>   */
> -int ubi_attach(struct ubi_device *ubi)
> +static struct ubi_attach_info *scan_fastmap(struct ubi_device *ubi)
> +{
> +	int fm_start;
> +
> +	fm_start = ubi_find_fastmap(ubi);
> +	if (fm_start < 0)
> +		return ERR_PTR(-ENOENT);
> +
> +	return ubi_read_fastmap(ubi, fm_start);
> +}

I think the fastmap should include the bad peb count.
(formerly, it was detected by scanning all pebs).
Otherwise UBI is unaware of the correct number of good/available
pebs (reflected in good_peb_count/avail_pebs).

> diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
> index 2c5ed5c..ef5d7b7 100644
> --- a/drivers/mtd/ubi/build.c
> +++ b/drivers/mtd/ubi/build.c
> @@ -144,6 +144,16 @@ int ubi_volume_notify(struct ubi_device *ubi, struct ubi_volume *vol, int ntype)
>  
>  	ubi_do_get_device_info(ubi, &nt.di);
>  	ubi_do_get_volume_info(ubi, vol, &nt.vi);
> +
> +	switch (ntype) {
> +	case UBI_VOLUME_ADDED:
> +	case UBI_VOLUME_REMOVED:
> +	case UBI_VOLUME_RESIZED:
> +	case UBI_VOLUME_RENAMED:
> +		if (ubi_update_fastmap(ubi))
> +			ubi_err("Unable to update fastmap!");

In the error case, what are the consequences leaving the older on-flash
fastmap? Shouldn't it be invalidated?

> +int ubi_update_fastmap(struct ubi_device *ubi)
> +{
> +	int ret, i;
> +	struct ubi_fastmap *new_fm;
> +
> +	if (ubi->ro_mode)
> +		return 0;
> +
> +	new_fm = kmalloc(sizeof(*new_fm), GFP_KERNEL);
> +	if (!new_fm)
> +		return -ENOMEM;
> +
> +	ubi->old_fm = ubi->fm;
> +	ubi->fm = NULL;
> +
> +	if (ubi->old_fm) {
> +		spin_lock(&ubi->wl_lock);
> +		new_fm->peb[0] = ubi_wl_get_fm_peb(ubi, UBI_FM_MAX_START);
> +		spin_unlock(&ubi->wl_lock);

Same 3 lines are found later, in the 'else' clause.
You can place these prior the 'if (ubi->old_fm)'.

> diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
> index 5275632..299a601 100644
> --- a/drivers/mtd/ubi/ubi.h
> +++ b/drivers/mtd/ubi/ubi.h
> @@ -202,6 +202,39 @@ struct ubi_rename_entry {
>  struct ubi_volume_desc;
>  
>  /**
> + * struct ubi_fastmap - in-memory fastmap data structure.
> + * @peb: PEBs used by the current fastamp

s/fastamp/fastmap/

> + * @ec: the erase counter of each used PEB
> + * @size: size of the fastmap in bytes
> + * @used_blocks: number of used PEBs
> + */
> +struct ubi_fastmap {

Suggestion: maybe ubi_fastmap_location / ubi_fastmap_layout /
ubi_fastmap_position ? slightly more explanatory than 'ubi_fastmap'.

> @@ -427,6 +467,12 @@ struct ubi_device {
>  	struct rb_root ltree;
>  	struct mutex alc_mutex;
>  
> +	/* Fastmap stuff */
> +	struct ubi_fastmap *fm;
> +	struct ubi_fastmap *old_fm;
> +	struct ubi_fm_pool fm_pool;
> +	bool attached_by_scanning;

Convention around MTD is 'int' for booleans.

> @@ -670,6 +717,9 @@ int ubi_wl_scrub_peb(struct ubi_device *ubi, int pnum);
>  int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai);
>  void ubi_wl_close(struct ubi_device *ubi);
>  int ubi_thread(void *u);
> +int ubi_wl_get_fm_peb(struct ubi_device *ubi, int max_pnum);
> +int ubi_wl_put_fm_peb(struct ubi_device *ubi, int pnum, int torture);
> +int ubi_is_fm_block(struct ubi_device *ubi, int pnum);

No users of 'ubi_is_fm_block' outside of wl.c (where it is defined).
Is it deliberately a part of the ubi interface?

> @@ -367,13 +386,70 @@ static struct ubi_wl_entry *find_wl_entry(struct rb_root *root, int diff)
>  }
>  
>  /**
> - * ubi_wl_get_peb - get a physical eraseblock.
> + * find_early_wl_entry - find wear-leveling entry with a low pnum.

s/a low/the lowest/

> + * @root: the RB-tree where to look for
> + * @max_pnum: highest possible pnum
> + *
> + * This function looks for a wear leveling entry containing a eb which
> + * is in front of the memory.

IMO can remove the last comment.

> +static struct ubi_wl_entry *find_early_wl_entry(struct rb_root *root,
> +						int max_pnum)
> +{
> +	struct rb_node *p;
> +	struct ubi_wl_entry *e, *victim = NULL;
> +
> +	ubi_rb_for_each_entry(p, e, root, u.rb) {
> +		if (e->pnum < max_pnum) {
> +			victim = e;
> +			max_pnum = e->pnum;
> +		}
> +	}
> +
> +	return victim;
> +}
> +
> +/**
> + * ubi_wl_get_fm_peb - find a physical erase block with a given maximal number.
> + * @ubi: UBI device description object
> + * @max_pnum: the highest acceptable erase block number
> + *
> + * The function returns a physical erase block with a given maximal number
> + * and removes it from the wl subsystem.
> + * Must be called with wl_lock held!
> + */
> +int ubi_wl_get_fm_peb(struct ubi_device *ubi, int max_pnum)
> +{
> +	int ret = -ENOSPC;
> +	struct ubi_wl_entry *e;
> +
> +	if (!ubi->free.rb_node) {
> +		ubi_err("no free eraseblocks");
> +
> +		goto out;
> +	}
> +
> +	e = find_early_wl_entry(&ubi->free, max_pnum);

This picks the eb with the lowest pnum within 'ubi->free'.

When called with INT_MAX (for the FM_DATA), why do you need to pick a
free eb with the minimal pnum? The FM_DATA EBs may reside everywhere (as
the FM_SB holds their location).
So why not pick the eb with a medium EC value (as done for standard
get_peb calls)? That might be better wear-leveling wise.

> +/* ubi_wl_get_peb - works exaclty like __ubi_wl_get_peb but keeps track of
> + * the fastmap pool.
> + */
> +int ubi_wl_get_peb(struct ubi_device *ubi)
> +{
> +	struct ubi_fm_pool *pool = &ubi->fm_pool;
> +
> +	/* pool contains no free blocks, create a new one
> +	 * and write a fastmap */
> +	if (pool->used == pool->size || !pool->size) {
> +		for (pool->size = 0; pool->size < pool->max_size;
> +				pool->size++) {
> +			pool->pebs[pool->size] = __ubi_wl_get_peb(ubi);
> +			if (pool->pebs[pool->size] < 0)
> +				break;
> +		}
> +
> +		pool->used = 0;
> +		ubi_update_fastmap(ubi);
> +	}
> +
> +	/* we got not a single free PEB */
> +	if (!pool->size)
> +		return -1;

Returning -ENOSPC is more appropriate and consistent with former
ubi_wl_get_peb implementation.

>  /**
> + * ubi_wl_put_fm_peb - returns a PEB used in a fastmap to the wear-leveling
> + * sub-system.
> + *
> + * see: ubi_wl_put_peb()
> + */
> +int ubi_wl_put_fm_peb(struct ubi_device *ubi, int pnum, int torture)
> +{
> +	int i, err = 0;
> +	struct ubi_wl_entry *e;
> +
> +	dbg_wl("PEB %d", pnum);
> +	ubi_assert(pnum >= 0);
> +	ubi_assert(pnum < ubi->peb_count);
> +
> +	spin_lock(&ubi->wl_lock);
> +	e = ubi->lookuptbl[pnum];
> +
> +	/* This can happen if we recovered from a fastmap the very
> +	 * frist time and writing now a new one. In this case the wl system

s/frist/first/

> +	 * has never seen any PEB used by the original fastmap.
> +	 */
> +	if (!e) {
> +		ubi_assert(ubi->old_fm);
> +		e = kmem_cache_alloc(ubi_wl_entry_slab, GFP_ATOMIC);

Must it be GFP_ATOMIC?

> +		if (!e) {
> +			spin_unlock(&ubi->wl_lock);
> +			return -ENOMEM;

This is traumatic; you must return the PEB back to WL, but fail to do so
due to an internal error.
(BTW the return value of ubi_wl_put_fm_peb is not tested at the call
sites)
The system is left with a missing PEB.
Can't we guarantee ubi_wl_put_fm_peb is called only after wl_init is
completed?

Regards,
Shmulik
