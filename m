Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759450Ab2AGEjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 23:39:21 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48998 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab2AGEjT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 23:39:19 -0500
MIME-Version: 1.0
In-Reply-To: <20120106134658.7589dec177541808dad20eb9@canb.auug.org.au>
References: <20120106134658.7589dec177541808dad20eb9@canb.auug.org.au>
From: Eric Van Hensbergen <ericvh@gmail.com>
Date: Fri, 6 Jan 2012 22:38:57 -0600
Message-ID: <CAFkjPTndww2mu16gCa9cn7V=0t0wvYgPQ1wQGz0q0B=Fk6xQbA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the vfs tree with the v9fs tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What's typically the right process for me to prep the merge for Linus?
Should I pull Al's patchset and then apply mine on top of it so I can
merge your merge fix or just have my for-linus tree based on his
current working merge (which I assume has Al's by now).  Just a bit
confused because rebasing was discouraged last merge window -- but not
sure how to deal with the conflict without a rebase....

         -eric

On Thu, Jan 5, 2012 at 8:46 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Al,
>
> Today's linux-next merge of the vfs tree got conflicts in
> fs/9p/vfs_inode.c and fs/9p/vfs_inode_dotl.c between commit 5d3851530d6d
> ("9p: Reduce object size with CONFIG_NET_9P_DEBUG") from the v9fs tree
> and commits c2837de73e80 ("9p: don't bother with unixmode2p9mode() for
> link() and symlink()") and 3eda0de677b5 ("9p: propagate umode_t") from
> the vfs tree.
>
> I fixed it up (see below) and can carry the fix as necessary.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc fs/9p/vfs_inode.c
> index c8fe480,e0f20de..0000000
> --- a/fs/9p/vfs_inode.c
> +++ b/fs/9p/vfs_inode.c
> @@@ -127,14 -94,14 +122,14 @@@ static int p9mode2perm(struct v9fs_sess
>   * @rdev: major number, minor number in case of device files.
>   *
>   */
> - static int p9mode2unixmode(struct v9fs_session_info *v9ses,
> -                          struct p9_wstat *stat, dev_t *rdev)
> + static umode_t p9mode2unixmode(struct v9fs_session_info *v9ses,
> +                              struct p9_wstat *stat, dev_t *rdev)
>  {
>        int res;
> -       int mode = stat->mode;
> +       u32 mode = stat->mode;
>
>  -      res = mode & S_IALLUGO;
>        *rdev = 0;
>  +      res = p9mode2perm(v9ses, stat);
>
>        if ((mode & P9_DMDIR) == P9_DMDIR)
>                res |= S_IFDIR;
> @@@ -352,8 -329,8 +346,8 @@@ int v9fs_init_inode(struct v9fs_session
>
>                break;
>        default:
> -               p9_debug(P9_DEBUG_ERROR, "BAD mode 0x%x S_IFMT 0x%x\n",
>  -              P9_DPRINTK(P9_DEBUG_ERROR, "BAD mode 0x%hx S_IFMT 0x%x\n",
>  -                         mode, mode & S_IFMT);
> ++              p9_debug(P9_DEBUG_ERROR, "BAD mode 0x%hx S_IFMT 0x%x\n",
>  +                       mode, mode & S_IFMT);
>                err = -EINVAL;
>                goto error;
>        }
> @@@ -375,7 -352,7 +369,7 @@@ struct inode *v9fs_get_inode(struct sup
>        struct inode *inode;
>        struct v9fs_session_info *v9ses = sb->s_fs_info;
>
> -       p9_debug(P9_DEBUG_VFS, "super block: %p mode: %o\n", sb, mode);
>  -      P9_DPRINTK(P9_DEBUG_VFS, "super block: %p mode: %ho\n", sb, mode);
> ++      p9_debug(P9_DEBUG_VFS, "super block: %p mode: %ho\n", sb, mode);
>
>        inode = new_inode(sb);
>        if (!inode) {
> @@@ -1362,10 -1333,10 +1355,10 @@@ static int v9fs_vfs_mkspecial(struct in
>  static int
>  v9fs_vfs_symlink(struct inode *dir, struct dentry *dentry, const char *symname)
>  {
>  -      P9_DPRINTK(P9_DEBUG_VFS, " %lu,%s,%s\n", dir->i_ino,
>  -                                      dentry->d_name.name, symname);
>  +      p9_debug(P9_DEBUG_VFS, " %lu,%s,%s\n",
>  +               dir->i_ino, dentry->d_name.name, symname);
>
> -       return v9fs_vfs_mkspecial(dir, dentry, S_IFLNK, symname);
> +       return v9fs_vfs_mkspecial(dir, dentry, P9_DMSYMLINK, symname);
>  }
>
>  /**
> @@@ -1419,14 -1391,16 +1412,16 @@@ clunk_fid
>   */
>
>  static int
> - v9fs_vfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t rdev)
> + v9fs_vfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, dev_t rdev)
>  {
> +       struct v9fs_session_info *v9ses = v9fs_inode2v9ses(dir);
>        int retval;
>        char *name;
> +       u32 perm;
>
> -       p9_debug(P9_DEBUG_VFS, " %lu,%s mode: %x MAJOR: %u MINOR: %u\n",
>  -      P9_DPRINTK(P9_DEBUG_VFS,
>  -              " %lu,%s mode: %hx MAJOR: %u MINOR: %u\n", dir->i_ino,
>  -              dentry->d_name.name, mode, MAJOR(rdev), MINOR(rdev));
> ++      p9_debug(P9_DEBUG_VFS, " %lu,%s mode: %hx MAJOR: %u MINOR: %u\n",
>  +               dir->i_ino, dentry->d_name.name, mode,
>  +               MAJOR(rdev), MINOR(rdev));
>
>        if (!new_valid_dev(rdev))
>                return -EINVAL;
> diff --cc fs/9p/vfs_inode_dotl.c
> index 73488fb,8ef152a..0000000
> --- a/fs/9p/vfs_inode_dotl.c
> +++ b/fs/9p/vfs_inode_dotl.c
> @@@ -283,8 -283,8 +283,8 @@@ v9fs_vfs_create_dotl(struct inode *dir
>        }
>
>        name = (char *) dentry->d_name.name;
> -       p9_debug(P9_DEBUG_VFS, "name:%s flags:0x%x mode:0x%x\n",
> -                name, flags, omode);
>  -      P9_DPRINTK(P9_DEBUG_VFS, "v9fs_vfs_create_dotl: name:%s flags:0x%x "
> ++      p9_debug(P9_DEBUG_VFS, "v9fs_vfs_create_dotl: name:%s flags:0x%x "
> +                       "mode:0x%hx\n", name, flags, omode);
>
>        dfid = v9fs_fid_lookup(dentry->d_parent);
>        if (IS_ERR(dfid)) {
> @@@ -810,9 -813,9 +810,9 @@@ v9fs_vfs_mknod_dotl(struct inode *dir,
>        struct dentry *dir_dentry;
>        struct posix_acl *dacl = NULL, *pacl = NULL;
>
> -       p9_debug(P9_DEBUG_VFS, " %lu,%s mode: %x MAJOR: %u MINOR: %u\n",
>  -      P9_DPRINTK(P9_DEBUG_VFS,
>  -              " %lu,%s mode: %hx MAJOR: %u MINOR: %u\n", dir->i_ino,
>  -              dentry->d_name.name, omode, MAJOR(rdev), MINOR(rdev));
> ++      p9_debug(P9_DEBUG_VFS, " %lu,%s mode: %hx MAJOR: %u MINOR: %u\n",
>  +               dir->i_ino, dentry->d_name.name, omode,
>  +               MAJOR(rdev), MINOR(rdev));
>
>        if (!new_valid_dev(rdev))
>                return -EINVAL;
