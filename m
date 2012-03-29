Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101Ab2C2QZG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 12:25:06 -0400
Received: from co202.xi-lite.net ([149.6.83.202]:40937 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443Ab2C2QZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 12:25:01 -0400
Message-ID: <4F748CD6.4080704@parrot.com>
Date: Thu, 29 Mar 2012 18:24:54 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: Joel Reardon <joel@clambassador.com>
CC: Artem Bityutskiy <dedekind1@gmail.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] UBI: allow atomic updates to sychronously erase old PEB
References: <alpine.DEB.2.00.1203291653210.912@eristoteles.iwoars.net>
In-Reply-To: <alpine.DEB.2.00.1203291653210.912@eristoteles.iwoars.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

what happen if there is a power cut between the atomic update and the erase ?
Is the leb is deleted during the recovery ?

Matthieu

Joel Reardon a écrit :
> This is a proposal for adding an immediate mode for atomic updates of LEBs in
> UBI. The idea is that, if the erase parameter is non-zero, then the old PEB will
> be erase after the new PEB is written, but before the function returns. It
> will not go into a work queue. This is for security-relevant situations where,
> for instance, the user needs assurance that sensitive information on an
> eraseblock is actually gone after the update.
> 
> The function schedule_erase always returns zero, because the actual error
> during erasure is not known at the time. Now, if it is immediate, then it has
> the ability to return an error if that fails. This would mean some functions
> higher up (i.e., change_leb), will be able to return "old PEB is now bad"
> messages, indicating that the secure erasure has failed.  I want to check now
> that this would be okay, or should the old PEB fail be ignored, or handled in
> some other way.
> 
> Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>
> ---
>  drivers/mtd/ubi/eba.c   |   20 +++++++++++---------
>  drivers/mtd/ubi/kapi.c  |    7 ++++---
>  drivers/mtd/ubi/ubi.h   |    5 +++--
>  drivers/mtd/ubi/upd.c   |    5 +++--
>  drivers/mtd/ubi/wl.c    |   25 +++++++++++++++----------
>  fs/ubifs/debug.c        |    4 ++--
>  fs/ubifs/debug.h        |    2 +-
>  fs/ubifs/io.c           |    6 +++---
>  fs/ubifs/log.c          |    5 +++--
>  fs/ubifs/lpt.c          |   10 +++++-----
>  fs/ubifs/orphan.c       |    2 +-
>  fs/ubifs/recovery.c     |   12 ++++++------
>  fs/ubifs/sb.c           |    4 ++--
>  fs/ubifs/tnc_commit.c   |    2 +-
>  fs/ubifs/ubifs.h        |    2 +-
>  include/linux/mtd/ubi.h |    6 +++---
>  16 files changed, 64 insertions(+), 53 deletions(-)
> 
> diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
> index cd26da8..6e44cfe 100644
> --- a/drivers/mtd/ubi/eba.c
> +++ b/drivers/mtd/ubi/eba.c
> @@ -341,7 +341,7 @@ int ubi_eba_unmap_leb(struct ubi_device *ubi, struct ubi_volume *vol,
>         dbg_eba("erase LEB %d:%d, PEB %d", vol_id, lnum, pnum);
> 
>         vol->eba_tbl[lnum] = UBI_LEB_UNMAPPED;
> -       err = ubi_wl_put_peb(ubi, pnum, 0);
> +       err = ubi_wl_put_peb(ubi, pnum, 0, 0);
> 
>  out_unlock:
>         leb_write_unlock(ubi, vol_id, lnum);
> @@ -550,7 +550,7 @@ retry:
>         ubi_free_vid_hdr(ubi, vid_hdr);
> 
>         vol->eba_tbl[lnum] = new_pnum;
> -       ubi_wl_put_peb(ubi, pnum, 1);
> +       ubi_wl_put_peb(ubi, pnum, 1, 0);
> 
>         ubi_msg("data was successfully recovered");
>         return 0;
> @@ -558,7 +558,7 @@ retry:
>  out_unlock:
>         mutex_unlock(&ubi->buf_mutex);
>  out_put:
> -       ubi_wl_put_peb(ubi, new_pnum, 1);
> +       ubi_wl_put_peb(ubi, new_pnum, 1, 0);
>         ubi_free_vid_hdr(ubi, vid_hdr);
>         return err;
> 
> @@ -568,7 +568,7 @@ write_error:
>          * get another one.
>          */
>         ubi_warn("failed to write to PEB %d", new_pnum);
> -       ubi_wl_put_peb(ubi, new_pnum, 1);
> +       ubi_wl_put_peb(ubi, new_pnum, 1, 0);
>         if (++tries > UBI_IO_RETRIES) {
>                 ubi_free_vid_hdr(ubi, vid_hdr);
>                 return err;
> @@ -687,7 +687,7 @@ write_error:
>          * eraseblock, so just put it and request a new one. We assume that if
>          * this physical eraseblock went bad, the erase code will handle that.
>          */
> -       err = ubi_wl_put_peb(ubi, pnum, 1);
> +       err = ubi_wl_put_peb(ubi, pnum, 1, 0);
>         if (err || ++tries > UBI_IO_RETRIES) {
>                 ubi_ro_mode(ubi);
>                 leb_write_unlock(ubi, vol_id, lnum);
> @@ -807,7 +807,7 @@ write_error:
>                 return err;
>         }
> 
> -       err = ubi_wl_put_peb(ubi, pnum, 1);
> +       err = ubi_wl_put_peb(ubi, pnum, 1, 0);
>         if (err || ++tries > UBI_IO_RETRIES) {
>                 ubi_ro_mode(ubi);
>                 leb_write_unlock(ubi, vol_id, lnum);
> @@ -828,6 +828,7 @@ write_error:
>   * @buf: data to write
>   * @len: how many bytes to write
>   * @dtype: data type
> + * @erase: if this physical eraseblock should be syncronously erased
>   *
>   * This function changes the contents of a logical eraseblock atomically. @buf
>   * has to contain new logical eraseblock data, and @len - the length of the
> @@ -839,7 +840,8 @@ write_error:
>   * LEB change may be done at a time. This is ensured by @ubi->alc_mutex.
>   */
>  int ubi_eba_atomic_leb_change(struct ubi_device *ubi, struct ubi_volume *vol,
> -                             int lnum, const void *buf, int len, int dtype)
> +                             int lnum, const void *buf, int len, int dtype,
> +                             int erase)
>  {
>         int err, pnum, tries = 0, vol_id = vol->vol_id;
>         struct ubi_vid_hdr *vid_hdr;
> @@ -905,7 +907,7 @@ retry:
>         }
> 
>         if (vol->eba_tbl[lnum] >= 0) {
> -               err = ubi_wl_put_peb(ubi, vol->eba_tbl[lnum], 0);
> +               err = ubi_wl_put_peb(ubi, vol->eba_tbl[lnum], 0, erase);
>                 if (err)
>                         goto out_leb_unlock;
>         }
> @@ -930,7 +932,7 @@ write_error:
>                 goto out_leb_unlock;
>         }
> 
> -       err = ubi_wl_put_peb(ubi, pnum, 1);
> +       err = ubi_wl_put_peb(ubi, pnum, 1, erase);
>         if (err || ++tries > UBI_IO_RETRIES) {
>                 ubi_ro_mode(ubi);
>                 goto out_leb_unlock;
> diff --git a/drivers/mtd/ubi/kapi.c b/drivers/mtd/ubi/kapi.c
> index 9fdb353..7be2044 100644
> --- a/drivers/mtd/ubi/kapi.c
> +++ b/drivers/mtd/ubi/kapi.c
> @@ -487,6 +487,7 @@ EXPORT_SYMBOL_GPL(ubi_leb_write);
>   * @buf: data to write
>   * @len: how many bytes to write
>   * @dtype: expected data type
> + * @erase: if non-zero then blocks until old block is erased
>   *
>   * This function changes the contents of a logical eraseblock atomically. @buf
>   * has to contain new logical eraseblock data, and @len - the length of the
> @@ -497,7 +498,7 @@ EXPORT_SYMBOL_GPL(ubi_leb_write);
>   * code in case of failure.
>   */
>  int ubi_leb_change(struct ubi_volume_desc *desc, int lnum, const void *buf,
> -                  int len, int dtype)
> +                  int len, int dtype, int erase)
>  {
>         struct ubi_volume *vol = desc->vol;
>         struct ubi_device *ubi = vol->ubi;
> @@ -524,8 +525,8 @@ int ubi_leb_change(struct ubi_volume_desc *desc, int lnum, const void *buf,
> 
>         if (len == 0)
>                 return 0;
> -
> -       return ubi_eba_atomic_leb_change(ubi, vol, lnum, buf, len, dtype);
> +       return ubi_eba_atomic_leb_change(ubi, vol, lnum, buf,
> +                                        len, dtype, erase);
>  }
>  EXPORT_SYMBOL_GPL(ubi_leb_change);
> 
> diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
> index d51d75d..cbe9082 100644
> --- a/drivers/mtd/ubi/ubi.h
> +++ b/drivers/mtd/ubi/ubi.h
> @@ -532,14 +532,15 @@ int ubi_eba_write_leb_st(struct ubi_device *ubi, struct ubi_volume *vol,
>                          int lnum, const void *buf, int len, int dtype,
>                          int used_ebs);
>  int ubi_eba_atomic_leb_change(struct ubi_device *ubi, struct ubi_volume *vol,
> -                             int lnum, const void *buf, int len, int dtype);
> +                             int lnum, const void *buf, int len, int dtype,
> +                             int erase);
>  int ubi_eba_copy_leb(struct ubi_device *ubi, int from, int to,
>                      struct ubi_vid_hdr *vid_hdr);
>  int ubi_eba_init_scan(struct ubi_device *ubi, struct ubi_scan_info *si);
> 
>  /* wl.c */
>  int ubi_wl_get_peb(struct ubi_device *ubi, int dtype);
> -int ubi_wl_put_peb(struct ubi_device *ubi, int pnum, int torture);
> +int ubi_wl_put_peb(struct ubi_device *ubi, int pnum, int torture, int erase);
>  int ubi_wl_flush(struct ubi_device *ubi);
>  int ubi_wl_scrub_peb(struct ubi_device *ubi, int pnum);
>  int ubi_wl_init_scan(struct ubi_device *ubi, struct ubi_scan_info *si);
> diff --git a/drivers/mtd/ubi/upd.c b/drivers/mtd/ubi/upd.c
> index 425bf5a..7584aed 100644
> --- a/drivers/mtd/ubi/upd.c
> +++ b/drivers/mtd/ubi/upd.c
> @@ -187,7 +187,7 @@ int ubi_start_leb_change(struct ubi_device *ubi, struct ubi_volume *vol,
>                 vol->vol_id, req->lnum, req->bytes);
>         if (req->bytes == 0)
>                 return ubi_eba_atomic_leb_change(ubi, vol, req->lnum, NULL, 0,
> -                                                req->dtype);
> +                                                req->dtype, 0);
> 
>         vol->upd_bytes = req->bytes;
>         vol->upd_received = 0;
> @@ -421,7 +421,8 @@ int ubi_more_leb_change_data(struct ubi_device *ubi, struct ubi_volume *vol,
>                        len - vol->upd_bytes);
>                 len = ubi_calc_data_len(ubi, vol->upd_buf, len);
>                 err = ubi_eba_atomic_leb_change(ubi, vol, vol->ch_lnum,
> -                                               vol->upd_buf, len, UBI_UNKNOWN);
> +                                               vol->upd_buf, len,
> +                                               UBI_UNKNOWN, 0);
>                 if (err)
>                         return err;
>         }
> diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
> index 0696e36..fa973f6 100644
> --- a/drivers/mtd/ubi/wl.c
> +++ b/drivers/mtd/ubi/wl.c
> @@ -469,7 +469,6 @@ retry:
>                 ubi_err("new PEB %d does not contain all 0xFF bytes", e->pnum);
>                 return err;
>         }
> -
>         return e->pnum;
>  }
> 
> @@ -629,12 +628,13 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
>   * @ubi: UBI device description object
>   * @e: the WL entry of the physical eraseblock to erase
>   * @torture: if the physical eraseblock has to be tortured
> + * @blocking: schedule the work immediately and return after completion
>   *
>   * This function returns zero in case of success and a %-ENOMEM in case of
>   * failure.
>   */
>  static int schedule_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
> -                         int torture)
> +                         int torture, int blocking)
>  {
>         struct ubi_work *wl_wrk;
> 
> @@ -649,7 +649,11 @@ static int schedule_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
>         wl_wrk->e = e;
>         wl_wrk->torture = torture;
> 
> -       schedule_ubi_work(ubi, wl_wrk);
> +       if (blocking)
> +               erase_worker(ubi, wl_wrk, 0);
> +       else
> +               schedule_ubi_work(ubi, wl_wrk);
> +
>         return 0;
>  }
> 
> @@ -847,7 +851,7 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
>         ubi->move_to_put = ubi->wl_scheduled = 0;
>         spin_unlock(&ubi->wl_lock);
> 
> -       err = schedule_erase(ubi, e1, 0);
> +       err = schedule_erase(ubi, e1, 0, 0);
>         if (err) {
>                 kmem_cache_free(ubi_wl_entry_slab, e1);
>                 if (e2)
> @@ -862,7 +866,7 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
>                  */
>                 dbg_wl("PEB %d (LEB %d:%d) was put meanwhile, erase",
>                        e2->pnum, vol_id, lnum);
> -               err = schedule_erase(ubi, e2, 0);
> +               err = schedule_erase(ubi, e2, 0, 0);
>                 if (err) {
>                         kmem_cache_free(ubi_wl_entry_slab, e2);
>                         goto out_ro;
> @@ -901,7 +905,7 @@ out_not_moved:
>         spin_unlock(&ubi->wl_lock);
> 
>         ubi_free_vid_hdr(ubi, vid_hdr);
> -       err = schedule_erase(ubi, e2, torture);
> +       err = schedule_erase(ubi, e2, torture, 0);
>         if (err) {
>                 kmem_cache_free(ubi_wl_entry_slab, e2);
>                 goto out_ro;
> @@ -1058,7 +1062,7 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
>                 int err1;
> 
>                 /* Re-schedule the LEB for erasure */
> -               err1 = schedule_erase(ubi, e, 0);
> +               err1 = schedule_erase(ubi, e, 0, 0);
>                 if (err1) {
>                         err = err1;
>                         goto out_ro;
> @@ -1128,13 +1132,14 @@ out_ro:
>   * @ubi: UBI device description object
>   * @pnum: physical eraseblock to return
>   * @torture: if this physical eraseblock has to be tortured
> + * @erase: if this physical eraseblock should be synchronously erased
>   *
>   * This function is called to return physical eraseblock @pnum to the pool of
>   * free physical eraseblocks. The @torture flag has to be set if an I/O error
>   * occurred to this @pnum and it has to be tested. This function returns zero
>   * in case of success, and a negative error code in case of failure.
>   */
> -int ubi_wl_put_peb(struct ubi_device *ubi, int pnum, int torture)
> +int ubi_wl_put_peb(struct ubi_device *ubi, int pnum, int torture, int erase)
>  {
>         int err;
>         struct ubi_wl_entry *e;
> @@ -1199,8 +1204,8 @@ retry:
>                 }
>         }
>         spin_unlock(&ubi->wl_lock);
> +       err = schedule_erase(ubi, e, torture, erase);
> 
> -       err = schedule_erase(ubi, e, torture);
>         if (err) {
>                 spin_lock(&ubi->wl_lock);
>                 wl_tree_add(e, &ubi->used);
> @@ -1465,7 +1470,7 @@ int ubi_wl_init_scan(struct ubi_device *ubi, struct ubi_scan_info *si)
>                 e->pnum = seb->pnum;
>                 e->ec = seb->ec;
>                 ubi->lookuptbl[e->pnum] = e;
> -               if (schedule_erase(ubi, e, 0)) {
> +               if (schedule_erase(ubi, e, 0, 0)) {
>                         kmem_cache_free(ubi_wl_entry_slab, e);
>                         goto out_free;
>                 }
> diff --git a/fs/ubifs/debug.c b/fs/ubifs/debug.c
> index 1934084..415a04f 100644
> --- a/fs/ubifs/debug.c
> +++ b/fs/ubifs/debug.c
> @@ -2697,7 +2697,7 @@ int dbg_leb_write(struct ubifs_info *c, int lnum, const void *buf,
>  }
> 
>  int dbg_leb_change(struct ubifs_info *c, int lnum, const void *buf,
> -                  int len, int dtype)
> +                  int len, int dtype, int erase)
>  {
>         int err;
> 
> @@ -2705,7 +2705,7 @@ int dbg_leb_change(struct ubifs_info *c, int lnum, const void *buf,
>                 return -EROFS;
>         if (power_cut_emulated(c, lnum, 1))
>                 return -EROFS;
> -       err = ubi_leb_change(c->ubi, lnum, buf, len, dtype);
> +       err = ubi_leb_change(c->ubi, lnum, buf, len, dtype, erase);
>         if (err)
>                 return err;
>         if (power_cut_emulated(c, lnum, 1))
> diff --git a/fs/ubifs/debug.h b/fs/ubifs/debug.h
> index 9f71765..64950a7 100644
> --- a/fs/ubifs/debug.h
> +++ b/fs/ubifs/debug.h
> @@ -309,7 +309,7 @@ int dbg_check_nondata_nodes_order(struct ubifs_info *c, struct list_head *head);
>  int dbg_leb_write(struct ubifs_info *c, int lnum, const void *buf, int offs,
>                   int len, int dtype);
>  int dbg_leb_change(struct ubifs_info *c, int lnum, const void *buf, int len,
> -                  int dtype);
> +                  int dtype, int erase);
>  int dbg_leb_unmap(struct ubifs_info *c, int lnum);
>  int dbg_leb_map(struct ubifs_info *c, int lnum, int dtype);
> 
> diff --git a/fs/ubifs/io.c b/fs/ubifs/io.c
> index 9228950..9ea6741 100644
> --- a/fs/ubifs/io.c
> +++ b/fs/ubifs/io.c
> @@ -136,7 +136,7 @@ int ubifs_leb_write(struct ubifs_info *c, int lnum, const void *buf, int offs,
>  }
> 
>  int ubifs_leb_change(struct ubifs_info *c, int lnum, const void *buf, int len,
> -                    int dtype)
> +                    int dtype, int erase)
>  {
>         int err;
> 
> @@ -144,9 +144,9 @@ int ubifs_leb_change(struct ubifs_info *c, int lnum, const void *buf, int len,
>         if (c->ro_error)
>                 return -EROFS;
>         if (!dbg_is_tst_rcvry(c))
> -               err = ubi_leb_change(c->ubi, lnum, buf, len, dtype);
> +               err = ubi_leb_change(c->ubi, lnum, buf, len, dtype, erase);
>         else
> -               err = dbg_leb_change(c, lnum, buf, len, dtype);
> +               err = dbg_leb_change(c, lnum, buf, len, dtype, erase);
>         if (err) {
>                 ubifs_err("changing %d bytes in LEB %d failed, error %d",
>                           len, lnum, err);
> diff --git a/fs/ubifs/log.c b/fs/ubifs/log.c
> index f9fd068..a3d4660 100644
> --- a/fs/ubifs/log.c
> +++ b/fs/ubifs/log.c
> @@ -623,7 +623,7 @@ static int add_node(struct ubifs_info *c, void *buf, int *lnum, int *offs,
>                 int sz = ALIGN(*offs, c->min_io_size), err;
> 
>                 ubifs_pad(c, buf + *offs, sz - *offs);
> -               err = ubifs_leb_change(c, *lnum, buf, sz, UBI_SHORTTERM);
> +               err = ubifs_leb_change(c, *lnum, buf, sz, UBI_SHORTTERM, 0);
>                 if (err)
>                         return err;
>                 *lnum = ubifs_next_log_lnum(c, *lnum);
> @@ -702,7 +702,8 @@ int ubifs_consolidate_log(struct ubifs_info *c)
>                 int sz = ALIGN(offs, c->min_io_size);
> 
>                 ubifs_pad(c, buf + offs, sz - offs);
> -               err = ubifs_leb_change(c, write_lnum, buf, sz, UBI_SHORTTERM);
> +               err = ubifs_leb_change(c, write_lnum, buf,
> +                                      sz, UBI_SHORTTERM, 0);
>                 if (err)
>                         goto out_free;
>                 offs = ALIGN(offs, c->min_io_size);
> diff --git a/fs/ubifs/lpt.c b/fs/ubifs/lpt.c
> index 66d59d0..c974211 100644
> --- a/fs/ubifs/lpt.c
> +++ b/fs/ubifs/lpt.c
> @@ -702,7 +702,7 @@ int ubifs_create_dflt_lpt(struct ubifs_info *c, int *main_lebs, int lpt_first,
>                         set_ltab(c, lnum, c->leb_size - alen, alen - len);
>                         memset(p, 0xff, alen - len);
>                         err = ubifs_leb_change(c, lnum++, buf, alen,
> -                                              UBI_SHORTTERM);
> +                                              UBI_SHORTTERM, 0);
>                         if (err)
>                                 goto out;
>                         p = buf;
> @@ -733,7 +733,7 @@ int ubifs_create_dflt_lpt(struct ubifs_info *c, int *main_lebs, int lpt_first,
>                                             alen - len);
>                                 memset(p, 0xff, alen - len);
>                                 err = ubifs_leb_change(c, lnum++, buf, alen,
> -                                                      UBI_SHORTTERM);
> +                                                      UBI_SHORTTERM, 0);
>                                 if (err)
>                                         goto out;
>                                 p = buf;
> @@ -781,7 +781,7 @@ int ubifs_create_dflt_lpt(struct ubifs_info *c, int *main_lebs, int lpt_first,
>                         set_ltab(c, lnum, c->leb_size - alen, alen - len);
>                         memset(p, 0xff, alen - len);
>                         err = ubifs_leb_change(c, lnum++, buf, alen,
> -                                              UBI_SHORTTERM);
> +                                              UBI_SHORTTERM, 0);
>                         if (err)
>                                 goto out;
>                         p = buf;
> @@ -806,7 +806,7 @@ int ubifs_create_dflt_lpt(struct ubifs_info *c, int *main_lebs, int lpt_first,
>                 alen = ALIGN(len, c->min_io_size);
>                 set_ltab(c, lnum, c->leb_size - alen, alen - len);
>                 memset(p, 0xff, alen - len);
> -               err = ubifs_leb_change(c, lnum++, buf, alen, UBI_SHORTTERM);
> +               err = ubifs_leb_change(c, lnum++, buf, alen, UBI_SHORTTERM, 0);
>                 if (err)
>                         goto out;
>                 p = buf;
> @@ -826,7 +826,7 @@ int ubifs_create_dflt_lpt(struct ubifs_info *c, int *main_lebs, int lpt_first,
> 
>         /* Write remaining buffer */
>         memset(p, 0xff, alen - len);
> -       err = ubifs_leb_change(c, lnum, buf, alen, UBI_SHORTTERM);
> +       err = ubifs_leb_change(c, lnum, buf, alen, UBI_SHORTTERM, 0);
>         if (err)
>                 goto out;
> 
> diff --git a/fs/ubifs/orphan.c b/fs/ubifs/orphan.c
> index c542c73..a0ec4ed 100644
> --- a/fs/ubifs/orphan.c
> +++ b/fs/ubifs/orphan.c
> @@ -249,7 +249,7 @@ static int do_write_orph_node(struct ubifs_info *c, int len, int atomic)
>                 ubifs_prepare_node(c, c->orph_buf, len, 1);
>                 len = ALIGN(len, c->min_io_size);
>                 err = ubifs_leb_change(c, c->ohead_lnum, c->orph_buf, len,
> -                                      UBI_SHORTTERM);
> +                                      UBI_SHORTTERM, 0);
>         } else {
>                 if (c->ohead_offs == 0) {
>                         /* Ensure LEB has been unmapped */
> diff --git a/fs/ubifs/recovery.c b/fs/ubifs/recovery.c
> index 2a935b3..0531112 100644
> --- a/fs/ubifs/recovery.c
> +++ b/fs/ubifs/recovery.c
> @@ -213,10 +213,10 @@ static int write_rcvrd_mst_node(struct ubifs_info *c,
>         mst->flags |= cpu_to_le32(UBIFS_MST_RCVRY);
> 
>         ubifs_prepare_node(c, mst, UBIFS_MST_NODE_SZ, 1);
> -       err = ubifs_leb_change(c, lnum, mst, sz, UBI_SHORTTERM);
> +       err = ubifs_leb_change(c, lnum, mst, sz, UBI_SHORTTERM, 0);
>         if (err)
>                 goto out;
> -       err = ubifs_leb_change(c, lnum + 1, mst, sz, UBI_SHORTTERM);
> +       err = ubifs_leb_change(c, lnum + 1, mst, sz, UBI_SHORTTERM, 0);
>         if (err)
>                 goto out;
>  out:
> @@ -556,7 +556,7 @@ static int fix_unclean_leb(struct ubifs_info *c, struct ubifs_scan_leb *sleb,
>                                 }
>                         }
>                         err = ubifs_leb_change(c, lnum, sleb->buf, len,
> -                                              UBI_UNKNOWN);
> +                                              UBI_UNKNOWN, 0);
>                         if (err)
>                                 return err;
>                 }
> @@ -941,7 +941,7 @@ static int recover_head(struct ubifs_info *c, int lnum, int offs, void *sbuf)
>                 err = ubifs_leb_read(c, lnum, sbuf, 0, offs, 1);
>                 if (err)
>                         return err;
> -               return ubifs_leb_change(c, lnum, sbuf, offs, UBI_UNKNOWN);
> +               return ubifs_leb_change(c, lnum, sbuf, offs, UBI_UNKNOWN, 0);
>         }
> 
>         return 0;
> @@ -1071,7 +1071,7 @@ static int clean_an_unclean_leb(struct ubifs_info *c,
>         }
> 
>         /* Write back the LEB atomically */
> -       err = ubifs_leb_change(c, lnum, sbuf, len, UBI_UNKNOWN);
> +       err = ubifs_leb_change(c, lnum, sbuf, len, UBI_UNKNOWN, 0);
>         if (err)
>                 return err;
> 
> @@ -1472,7 +1472,7 @@ static int fix_size_in_place(struct ubifs_info *c, struct size_entry *e)
>                 len -= 1;
>         len = ALIGN(len + 1, c->min_io_size);
>         /* Atomically write the fixed LEB back again */
> -       err = ubifs_leb_change(c, lnum, c->sbuf, len, UBI_UNKNOWN);
> +       err = ubifs_leb_change(c, lnum, c->sbuf, len, UBI_UNKNOWN, 0);
>         if (err)
>                 goto out;
>         dbg_rcvry("inode %lu at %d:%d size %lld -> %lld",
> diff --git a/fs/ubifs/sb.c b/fs/ubifs/sb.c
> index 771f7fb..e38d72e 100644
> --- a/fs/ubifs/sb.c
> +++ b/fs/ubifs/sb.c
> @@ -518,7 +518,7 @@ int ubifs_write_sb_node(struct ubifs_info *c, struct ubifs_sb_node *sup)
>         int len = ALIGN(UBIFS_SB_NODE_SZ, c->min_io_size);
> 
>         ubifs_prepare_node(c, sup, UBIFS_SB_NODE_SZ, 1);
> -       return ubifs_leb_change(c, UBIFS_SB_LNUM, sup, len, UBI_LONGTERM);
> +       return ubifs_leb_change(c, UBIFS_SB_LNUM, sup, len, UBI_LONGTERM, 0);
>  }
> 
>  /**
> @@ -691,7 +691,7 @@ static int fixup_leb(struct ubifs_info *c, int lnum, int len)
>         if (err)
>                 return err;
> 
> -       return ubifs_leb_change(c, lnum, c->sbuf, len, UBI_UNKNOWN);
> +       return ubifs_leb_change(c, lnum, c->sbuf, len, UBI_UNKNOWN, 0);
>  }
> 
>  /**
> diff --git a/fs/ubifs/tnc_commit.c b/fs/ubifs/tnc_commit.c
> index 4c15f07..485a283 100644
> --- a/fs/ubifs/tnc_commit.c
> +++ b/fs/ubifs/tnc_commit.c
> @@ -323,7 +323,7 @@ static int layout_leb_in_gaps(struct ubifs_info *c, int *p)
>         if (err)
>                 return err;
>         err = ubifs_leb_change(c, lnum, c->ileb_buf, c->ileb_len,
> -                              UBI_SHORTTERM);
> +                              UBI_SHORTTERM, 1);
>         if (err)
>                 return err;
>         dbg_gc("LEB %d wrote %d index nodes", lnum, tot_written);
> diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
> index 0cc1180..d7a2827 100644
> --- a/fs/ubifs/ubifs.h
> +++ b/fs/ubifs/ubifs.h
> @@ -1470,7 +1470,7 @@ int ubifs_leb_read(const struct ubifs_info *c, int lnum, void *buf, int offs,
>  int ubifs_leb_write(struct ubifs_info *c, int lnum, const void *buf, int offs,
>                     int len, int dtype);
>  int ubifs_leb_change(struct ubifs_info *c, int lnum, const void *buf, int len,
> -                    int dtype);
> +                    int dtype, int erase);
>  int ubifs_leb_unmap(struct ubifs_info *c, int lnum);
>  int ubifs_leb_map(struct ubifs_info *c, int lnum, int dtype);
>  int ubifs_is_mapped(const struct ubifs_info *c, int lnum);
> diff --git a/include/linux/mtd/ubi.h b/include/linux/mtd/ubi.h
> index db4836b..2387c8a 100644
> --- a/include/linux/mtd/ubi.h
> +++ b/include/linux/mtd/ubi.h
> @@ -210,7 +210,7 @@ int ubi_leb_read(struct ubi_volume_desc *desc, int lnum, char *buf, int offset,
>  int ubi_leb_write(struct ubi_volume_desc *desc, int lnum, const void *buf,
>                   int offset, int len, int dtype);
>  int ubi_leb_change(struct ubi_volume_desc *desc, int lnum, const void *buf,
> -                  int len, int dtype);
> +                  int len, int dtype, int erase);
>  int ubi_leb_erase(struct ubi_volume_desc *desc, int lnum);
>  int ubi_leb_unmap(struct ubi_volume_desc *desc, int lnum);
>  int ubi_leb_map(struct ubi_volume_desc *desc, int lnum, int dtype);
> @@ -239,12 +239,12 @@ static inline int ubi_write(struct ubi_volume_desc *desc, int lnum,
> 
>  /*
>   * This function is the same as the 'ubi_leb_change()' functions, but it does
> - * not have the data type argument.
> + * not have the data type argument or the immediate erase argument.
>   */
>  static inline int ubi_change(struct ubi_volume_desc *desc, int lnum,
>                                     const void *buf, int len)
>  {
> -       return ubi_leb_change(desc, lnum, buf, len, UBI_UNKNOWN);
> +       return ubi_leb_change(desc, lnum, buf, len, UBI_UNKNOWN, 0);
>  }
> 
>  #endif /* !__LINUX_UBI_H__ */
> --
> 1.7.5.4
> 
> 
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/
> 
