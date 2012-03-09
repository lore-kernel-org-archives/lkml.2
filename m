Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab2CIDlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 22:41:11 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:59417 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab2CIDlJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 22:41:09 -0500
MIME-Version: 1.0
In-Reply-To: <m1haxywz8y.fsf_-_@fess.ebiederm.org>
References: <20120130222717.GA6393@kroah.com> <m18vkoirv9.fsf@fess.ebiederm.org>
 <4F27C6EB.2070305@suse.cz> <m14nvc82jo.fsf@fess.ebiederm.org>
 <CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com>
 <m1wr87ywex.fsf@fess.ebiederm.org> <m1ehueyz20.fsf_-_@fess.ebiederm.org>
 <CA+55aFyNQnXrL7fWhBt4LYBuoHD_x+j=Af-N=ueFMBkymy9Rnw@mail.gmail.com>
 <CA+55aFzZX544ZDN9vN3jWMWZ=_9ZtpZ9cR6gNEzUnx9RCqR5LQ@mail.gmail.com>
 <4F54BFEC.6000206@suse.cz> <20120305160953.GA3870@kroah.com>
 <m1r4x2wzdt.fsf_-_@fess.ebiederm.org> <m1linawza5.fsf_-_@fess.ebiederm.org> <m1haxywz8y.fsf_-_@fess.ebiederm.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 8 Mar 2012 19:40:47 -0800
X-Google-Sender-Auth: rLFSUMi-Dn6hzr_RWZWPqCFzwWw
Message-ID: <CA+55aFzP3VWRXQ0ZN7GqcKhxdWLSWSMRHnb=KdYRZGusQ-B4gA@mail.gmail.com>
Subject: Re: [PATCH 3/3] sysfs: Remove SYSFS_FLAG_REMOVED and use sd->s_nlink
 == 0 instead.
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Jiri Slaby <jirislaby@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is this safe?

What's the serialization with sysfs_link_sibling(), which you just made do

   sd->s_nlink++;
   if (!sd->s_nlink)
      sd->s_nlink = 1;

in your previous patch?

Yes, sysfs_link_sibling() runs under sysfs_mutex, but
sysfs_dentry_delete() does not.

So what protects sysfs_dentry_delete() from never seeing that bogus 0
due to the overflow?

                     Linus

On Thu, Mar 8, 2012 at 1:37 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Now that we have a nlink field in sysfs_dirent report deleted
> files and directories the traditional way with nlink == 0.
>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  fs/sysfs/dir.c   |   11 +++++------
>  fs/sysfs/sysfs.h |    1 -
>  2 files changed, 5 insertions(+), 7 deletions(-)
>
> diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
> index 1526567..b5471d1 100644
> --- a/fs/sysfs/dir.c
> +++ b/fs/sysfs/dir.c
> @@ -202,7 +202,7 @@ static void sysfs_deactivate(struct sysfs_dirent *sd)
>        DECLARE_COMPLETION_ONSTACK(wait);
>        int v;
>
> -       BUG_ON(!(sd->s_flags & SYSFS_FLAG_REMOVED));
> +       BUG_ON(sd->s_nlink != 0);
>
>        if (!(sysfs_type(sd) & SYSFS_ACTIVE_REF))
>                return;
> @@ -279,7 +279,7 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
>  static int sysfs_dentry_delete(const struct dentry *dentry)
>  {
>        struct sysfs_dirent *sd = dentry->d_fsdata;
> -       return !!(sd->s_flags & SYSFS_FLAG_REMOVED);
> +       return sd->s_nlink == 0;
>  }
>
>  static int sysfs_dentry_revalidate(struct dentry *dentry, struct nameidata *nd)
> @@ -294,7 +294,7 @@ static int sysfs_dentry_revalidate(struct dentry *dentry, struct nameidata *nd)
>        mutex_lock(&sysfs_mutex);
>
>        /* The sysfs dirent has been deleted */
> -       if (sd->s_flags & SYSFS_FLAG_REMOVED)
> +       if (sd->s_nlink == 0)
>                goto out_bad;
>
>        /* The sysfs dirent has been moved? */
> @@ -534,7 +534,7 @@ void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
>  {
>        struct sysfs_inode_attrs *ps_iattr;
>
> -       BUG_ON(sd->s_flags & SYSFS_FLAG_REMOVED);
> +       BUG_ON(sd->s_nlink == 0);
>
>        sysfs_unlink_sibling(sd);
>
> @@ -546,7 +546,6 @@ void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
>        }
>
>        sd->s_nlink = 0;
> -       sd->s_flags |= SYSFS_FLAG_REMOVED;
>        sd->u.removed_list = acxt->removed;
>        acxt->removed = sd;
>  }
> @@ -946,7 +945,7 @@ static struct sysfs_dirent *sysfs_dir_pos(const void *ns,
>        struct sysfs_dirent *parent_sd, loff_t hash, struct sysfs_dirent *pos)
>  {
>        if (pos) {
> -               int valid = !(pos->s_flags & SYSFS_FLAG_REMOVED) &&
> +               int valid = (pos->s_nlink > 0) &&
>                        pos->s_parent == parent_sd &&
>                        hash == pos->s_hash;
>                sysfs_put(pos);
> diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
> index 71f9bf7..db2c5c5 100644
> --- a/fs/sysfs/sysfs.h
> +++ b/fs/sysfs/sysfs.h
> @@ -98,7 +98,6 @@ struct sysfs_dirent {
>  #define SYSFS_NS_TYPE_SHIFT            4
>
>  #define SYSFS_FLAG_MASK                        ~(SYSFS_NS_TYPE_MASK|SYSFS_TYPE_MASK)
> -#define SYSFS_FLAG_REMOVED             0x080
>
>  static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
>  {
> --
> 1.7.2.5
>
