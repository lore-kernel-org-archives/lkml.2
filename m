Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab1FMVTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 17:19:47 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:44263 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab1FMVTp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 17:19:45 -0400
X-Greylist: delayed 391 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jun 2011 17:19:44 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=N43GKQMrDZ77OCgCsmvKlzoYUNwRn4vIZJujwxvvLPa2XRJc7jEJn5R+Zv2QVdvYKF
         iRXqwazWjqbiiaJLhCFFbu0T2C2gvM8kTZ8Wu8n09aPexGhhPE4/k1sRUFnUmOt/e3Yj
         6TPQPiK385xWPrxy1wsf9IRYL8I70mA8euKbo=
MIME-Version: 1.0
In-Reply-To: <1307383308-5773-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1307383308-5773-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1307383308-5773-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
From: Eric Van Hensbergen <ericvh@gmail.com>
Date: Mon, 13 Jun 2011 16:12:52 -0500
Message-ID: <BANLkTinevUGj7QYY2aodOWUtObaoUaHydA@mail.gmail.com>
Subject: Re: [V9fs-developer] [PATCH 3/3] 9p: add 9P2000.L unlinkat operation
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could be wrong, but a quick regression check of your patches fails
against a legacy server.  Are you making sure the new operations are
properly protected by a .L flag?

         -eric


On Mon, Jun 6, 2011 at 1:01 PM, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
> unlinkat - Remove a directory entry
>
> size[4] Tunlinkat tag[2] dirfid[4] name[s] flag[4]
> size[4] Runlinkat tag[2]
>
> older Tremove have the below request format
>
> size[4] Tremove tag[2] fid[4]
>
> The remove message is used to remove a directory entry either file or directory
> The remove opreation is actually a directory opertation and should ideally have
> dirfid, if not we cannot represent the fid on server with anything other than
> name. We will have to derive the directory name from fid in the Tremove request.
>
> NOTE: The operation doesn't clunk the unlink fid.
>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/9p/vfs_inode.c       |   43 ++++++++++++++++++++++++++-----------------
>  include/net/9p/9p.h     |    2 ++
>  include/net/9p/client.h |    1 +
>  net/9p/client.c         |   23 +++++++++++++++++++++++
>  4 files changed, 52 insertions(+), 17 deletions(-)
>
> diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
> index ded6309..f40fdc3 100644
> --- a/fs/9p/vfs_inode.c
> +++ b/fs/9p/vfs_inode.c
> @@ -492,38 +492,47 @@ v9fs_inode_from_fid(struct v9fs_session_info *v9ses, struct p9_fid *fid,
>  /**
>  * v9fs_remove - helper function to remove files and directories
>  * @dir: directory inode that is being deleted
> - * @file:  dentry that is being deleted
> + * @dentry:  dentry that is being deleted
>  * @rmdir: removing a directory
>  *
>  */
>
> -static int v9fs_remove(struct inode *dir, struct dentry *file, int rmdir)
> +static int v9fs_remove(struct inode *dir, struct dentry *dentry, int flags)
>  {
>        int retval;
> -       struct p9_fid *v9fid;
> -       struct inode *file_inode;
> -
> -       P9_DPRINTK(P9_DEBUG_VFS, "inode: %p dentry: %p rmdir: %d\n", dir, file,
> -               rmdir);
> +       struct inode *inode;
> +       struct p9_fid *v9fid, *dfid;
>
> -       file_inode = file->d_inode;
> -       v9fid = v9fs_fid_clone(file);
> -       if (IS_ERR(v9fid))
> -               return PTR_ERR(v9fid);
> +       P9_DPRINTK(P9_DEBUG_VFS, "inode: %p dentry: %p rmdir: %x\n",
> +                  dir, dentry, flags);
>
> -       retval = p9_client_remove(v9fid);
> +       inode = dentry->d_inode;
> +       dfid = v9fs_fid_lookup(dentry->d_parent);
> +       if (IS_ERR(dfid)) {
> +               retval = PTR_ERR(dfid);
> +               P9_DPRINTK(P9_DEBUG_VFS, "fid lookup failed %d\n", retval);
> +               return retval;
> +       }
> +       retval = p9_client_unlinkat(dfid, dentry->d_name.name, flags);
> +       if (retval == -EOPNOTSUPP) {
> +               /* Try the one based on path */
> +               v9fid = v9fs_fid_clone(dentry);
> +               if (IS_ERR(v9fid))
> +                       return PTR_ERR(v9fid);
> +               retval = p9_client_remove(v9fid);
> +       }
>        if (!retval) {
>                /*
>                 * directories on unlink should have zero
>                 * link count
>                 */
> -               if (rmdir) {
> -                       clear_nlink(file_inode);
> +               if (flags & AT_REMOVEDIR) {
> +                       clear_nlink(inode);
>                        drop_nlink(dir);
>                } else
> -                       drop_nlink(file_inode);
> +                       drop_nlink(inode);
>
> -               v9fs_invalidate_inode_attr(file_inode);
> +               v9fs_invalidate_inode_attr(inode);
>                v9fs_invalidate_inode_attr(dir);
>        }
>        return retval;
> @@ -814,7 +823,7 @@ int v9fs_vfs_unlink(struct inode *i, struct dentry *d)
>
>  int v9fs_vfs_rmdir(struct inode *i, struct dentry *d)
>  {
> -       return v9fs_remove(i, d, 1);
> +       return v9fs_remove(i, d, AT_REMOVEDIR);
>  }
>
>  /**
> diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
> index 094c3dd..fe1efa6 100644
> --- a/include/net/9p/9p.h
> +++ b/include/net/9p/9p.h
> @@ -177,6 +177,8 @@ enum p9_msg_t {
>        P9_RMKDIR,
>        P9_TRENAMEAT = 74,
>        P9_RRENAMEAT,
> +       P9_TUNLINKAT = 76,
> +       P9_RUNLINKAT,
>        P9_TVERSION = 100,
>        P9_RVERSION,
>        P9_TAUTH = 102,
> diff --git a/include/net/9p/client.h b/include/net/9p/client.h
> index 5353cbc..976d12a 100644
> --- a/include/net/9p/client.h
> +++ b/include/net/9p/client.h
> @@ -234,6 +234,7 @@ int p9_client_create_dotl(struct p9_fid *ofid, char *name, u32 flags, u32 mode,
>  int p9_client_clunk(struct p9_fid *fid);
>  int p9_client_fsync(struct p9_fid *fid, int datasync);
>  int p9_client_remove(struct p9_fid *fid);
> +int p9_client_unlinkat(struct p9_fid *dfid, const char *name, int flags);
>  int p9_client_read(struct p9_fid *fid, char *data, char __user *udata,
>                                                        u64 offset, u32 count);
>  int p9_client_write(struct p9_fid *fid, char *data, const char __user *udata,
> diff --git a/net/9p/client.c b/net/9p/client.c
> index 677ae8d..d225158 100644
> --- a/net/9p/client.c
> +++ b/net/9p/client.c
> @@ -1281,6 +1281,29 @@ error:
>  }
>  EXPORT_SYMBOL(p9_client_remove);
>
> +int p9_client_unlinkat(struct p9_fid *dfid, const char *name, int flags)
> +{
> +       int err = 0;
> +       struct p9_req_t *req;
> +       struct p9_client *clnt;
> +
> +       P9_DPRINTK(P9_DEBUG_9P, ">>> TUNLINKAT fid %d %s %d\n",
> +                  dfid->fid, name, flags);
> +
> +       clnt = dfid->clnt;
> +       req = p9_client_rpc(clnt, P9_TUNLINKAT, "dsd", dfid->fid, name, flags);
> +       if (IS_ERR(req)) {
> +               err = PTR_ERR(req);
> +               goto error;
> +       }
> +       P9_DPRINTK(P9_DEBUG_9P, "<<< RUNLINKAT fid %d %s\n", dfid->fid, name);
> +
> +       p9_free_req(clnt, req);
> +error:
> +       return err;
> +}
> +EXPORT_SYMBOL(p9_client_unlinkat);
> +
>  int
>  p9_client_read(struct p9_fid *fid, char *data, char __user *udata, u64 offset,
>                                                                u32 count)
> --
> 1.7.4.1
>
>
> ------------------------------------------------------------------------------
> Simplify data backup and recovery for your virtual environment with vRanger.
> Installation's a snap, and flexible recovery options mean your data is safe,
> secure and there when you need it. Discover what all the cheering's about.
> Get your free trial download today.
> http://p.sf.net/sfu/quest-dev2dev2
> _______________________________________________
> V9fs-developer mailing list
> V9fs-developer@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/v9fs-developer
>
