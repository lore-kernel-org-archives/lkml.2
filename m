Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab2FAFrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 01:47:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:64913 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630Ab2FAFrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 01:47:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="159424890"
Message-ID: <4FC85780.9070200@intel.com>
Date: Fri, 01 Jun 2012 08:47:44 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: linux-mtd@lists.infradead.org, tglx@linutronix.de, dedekind1@gmail.com,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        tim.bird@am.sony.com
Subject: Re: [PATCH] [RFC] UBI: Implement Fastmap support
References: <1337771191-95358-1-git-send-email-richard@nod.at> <1337771191-95358-2-git-send-email-richard@nod.at>
In-Reply-To: <1337771191-95358-2-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/05/12 14:06, Richard Weinberger wrote:
> Fastmap (aka checkpointing) allows attaching of an UBI volume in nearly
> constant time. Only a fixed number of PEBs has to be scanned.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/mtd/ubi/Makefile    |    2 +-
>  drivers/mtd/ubi/attach.c    |   34 +-
>  drivers/mtd/ubi/build.c     |   25 +
>  drivers/mtd/ubi/eba.c       |   18 +-
>  drivers/mtd/ubi/fastmap.c   | 1240 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/mtd/ubi/ubi-media.h |  119 +++++
>  drivers/mtd/ubi/ubi.h       |   68 +++-
>  drivers/mtd/ubi/wl.c        |  184 +++++++-
>  8 files changed, 1667 insertions(+), 23 deletions(-)
>  create mode 100644 drivers/mtd/ubi/fastmap.c
> 

...

> diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
> new file mode 100644
> index 0000000..7757e5a
> --- /dev/null
> +++ b/drivers/mtd/ubi/fastmap.c

...

> +/**
> + * ubi_update_fastmap - will be called by UBI if a volume changes or
> + * a fastmap pool becomes full.
> + * @ubi: UBI device object
> + */
> +int ubi_update_fastmap(struct ubi_device *ubi)
> +{
> +	int ret, i;
> +	struct ubi_fastmap_layout *new_fm;
> +
> +	if (ubi->ro_mode)
> +		return 0;
> +
> +	new_fm = kzalloc(sizeof(*new_fm), GFP_KERNEL);
> +	if (!new_fm)
> +		return -ENOMEM;
> +
> +	new_fm->size = sizeof(struct ubi_fm_hdr) + \
> +			sizeof(struct ubi_fm_scan_pool) + \
> +			(ubi->peb_count * sizeof(struct ubi_fm_ec)) + \
> +			(sizeof(struct ubi_fm_eba) + \
> +			(ubi->peb_count * sizeof(__be32))) + \
> +			sizeof(struct ubi_fm_volhdr) * UBI_MAX_VOLUMES;
> +	new_fm->size = roundup(new_fm->size, ubi->leb_size);
> +
> +	new_fm->used_blocks = new_fm->size / ubi->leb_size;
> +
> +	for (i = 0; i < new_fm->used_blocks; i++) {
> +		new_fm->e[i] = kmem_cache_alloc(ubi_wl_entry_slab, GFP_KERNEL);
> +		if (!new_fm->e[i]) {
> +			while (i--)
> +				kfree(new_fm->e[i]);
> +
> +			kfree(new_fm);
> +			return -ENOMEM;
> +		}
> +	}
> +
> +	ubi->old_fm = ubi->fm;
> +	ubi->fm = NULL;
> +
> +	spin_lock(&ubi->wl_lock);
> +	new_fm->e[0]->pnum = ubi_wl_get_fm_peb(ubi, UBI_FM_MAX_START);
> +	spin_unlock(&ubi->wl_lock);
> +
> +	if (ubi->old_fm) {
> +		/* no fresh early PEB was found, reuse the old one */
> +		if (new_fm->e[0]->pnum < 0) {
> +			struct ubi_ec_hdr *ec_hdr;
> +
> +			ec_hdr = kzalloc(ubi->ec_hdr_alsize, GFP_KERNEL);
> +			if (!ec_hdr) {
> +				kfree(new_fm);
> +
> +				return -ENOMEM;
> +			}
> +
> +			/* we have to erase the block by hand */
> +
> +			ret = ubi_io_read_ec_hdr(ubi, ubi->old_fm->e[0]->pnum,
> +				ec_hdr, 0);
> +			if (ret) {
> +				ubi_err("Unable to read EC header");
> +				kfree(new_fm);
> +				kfree(ec_hdr);
> +
> +				return ret;
> +			}
> +
> +			ret = ubi_io_sync_erase(ubi, ubi->old_fm->e[0]->pnum,
> +				0);
> +			if (ret < 0) {
> +				ubi_err("Unable to erase old SB");
> +				kfree(new_fm);
> +				kfree(ec_hdr);
> +
> +				return ret;
> +			}
> +
> +			ec_hdr->ec += ret;
> +			if (ec_hdr->ec > UBI_MAX_ERASECOUNTER) {
> +				ubi_err("Erase counter overflow!");
> +				kfree(new_fm);
> +				kfree(ec_hdr);
> +
> +				return -EINVAL;
> +			}
> +
> +			ret = ubi_io_write_ec_hdr(ubi, ubi->old_fm->e[0]->pnum,
> +				ec_hdr);
> +			kfree(ec_hdr);
> +			if (ret) {
> +				ubi_err("Unable to write new EC header");
> +				kfree(new_fm);
> +
> +				return ret;
> +			}
> +
> +			new_fm->e[0]->pnum = ubi->old_fm->e[0]->pnum;
> +			new_fm->e[0]->ec = ubi->old_fm->e[0]->ec;
> +		} else {
> +			/* we've got a new early PEB, return the old one */
> +			ubi_wl_put_fm_peb(ubi, ubi->old_fm->e[0]->pnum, 0);
> +			new_fm->e[0]->ec = get_ec(ubi, new_fm->e[0]->pnum);
> +		}
> +
> +		/* return all other fastmap block to the wl system */
> +		for (i = 1; i < ubi->old_fm->used_blocks; i++)
> +			ubi_wl_put_fm_peb(ubi, ubi->old_fm->e[i]->pnum, 0);

It looks like, if you lose power at this point, the old fastmap may have
been erased but the new fastmap has not been written.  That would mean
you lose the fastmap.  Is that correct?  I guess you need to write the
new fastmap first and then erase the old one.

> +	} else {
> +		if (new_fm->e[0]->pnum < 0) {
> +			ubi_err("Could not find an early PEB");
> +			kfree(new_fm);
> +
> +			return -ENOSPC;
> +		}
> +		new_fm->e[0]->ec = get_ec(ubi, new_fm->e[0]->pnum);
> +	}
> +
> +	if (new_fm->used_blocks > UBI_FM_MAX_BLOCKS) {
> +		ubi_err("Fastmap too large");
> +		kfree(new_fm);
> +
> +		return -ENOSPC;
> +	}
> +
> +	/* give the wl subsystem a chance to produce some free blocks */
> +	cond_resched();
> +
> +	for (i = 1; i < new_fm->used_blocks; i++) {
> +		spin_lock(&ubi->wl_lock);
> +		new_fm->e[i]->pnum = ubi_wl_get_fm_peb(ubi, -1);
> +		spin_unlock(&ubi->wl_lock);
> +
> +		if (new_fm->e[i]->pnum < 0) {
> +			ubi_err("Could not get any free erase block");
> +
> +			while (i--) {
> +				ubi_wl_put_fm_peb(ubi, new_fm->e[i]->pnum, 0);
> +				kfree(new_fm->e[i]);
> +			}
> +
> +			kfree(new_fm);
> +
> +			return -ENOSPC;
> +		}
> +
> +		new_fm->e[i]->ec = get_ec(ubi, new_fm->e[i]->pnum);
> +	}
> +
> +	if (ubi->old_fm) {
> +		for (i = 0; i < ubi->old_fm->used_blocks; i++)
> +			kfree(ubi->old_fm->e[i]);
> +
> +		kfree(ubi->old_fm);
> +		ubi->old_fm = NULL;
> +	}
> +
> +	return ubi_write_fastmap(ubi, new_fm);
> +}
