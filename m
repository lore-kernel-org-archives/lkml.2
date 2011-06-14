Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab1FNPQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 11:16:26 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48007 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab1FNPQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 11:16:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=NDI9BJ2b565o8P6AsHdDvtl+larNy0vb4ylAO46ansggs5rItoSBiyUlNv0FqBO168
         VpHVaIYcFPwrVIAkEwtwmp8rWcG5eAfWwlfcVXjo13olITq4+XPItNGM/8L19akThBnn
         VwPSIK1ePA9En9dtHM41WdAMMbCUlYmqzdsZ4=
MIME-Version: 1.0
In-Reply-To: <87oc20ew5b.fsf@linux.vnet.ibm.com>
References: <1307383308-5773-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1307383308-5773-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <BANLkTinevUGj7QYY2aodOWUtObaoUaHydA@mail.gmail.com> <87oc20ew5b.fsf@linux.vnet.ibm.com>
From: Eric Van Hensbergen <ericvh@gmail.com>
Date: Tue, 14 Jun 2011 10:14:55 -0500
Message-ID: <BANLkTikn+O0P6SOhR0r7hCNP_U45iQ6-dQ@mail.gmail.com>
Subject: Re: [V9fs-developer] [PATCH 3/3] 9p: add 9P2000.L unlinkat operation
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 1:59 AM, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
> On Mon, 13 Jun 2011 16:12:52 -0500, Eric Van Hensbergen <ericvh@gmail.com> wrote:
>> Could be wrong, but a quick regression check of your patches fails
>> against a legacy server.  Are you making sure the new operations are
>> properly protected by a .L flag?
>
> How about below diff
>
> [3.0-pending@v9fs]$ git diff
> diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
> index f40fdc3..436699e 100644
> --- a/fs/9p/vfs_inode.c
> +++ b/fs/9p/vfs_inode.c
> @@ -499,13 +499,15 @@ v9fs_inode_from_fid(struct v9fs_session_info *v9ses, struct p9_fid *fid,
>
>  static int v9fs_remove(struct inode *dir, struct dentry *dentry, int flags)
>  {
> -       int retval;
>        struct inode *inode;
> +       int retval = -EOPNOTSUPP;
>        struct p9_fid *v9fid, *dfid;
> +       struct v9fs_session_info *v9ses;
>
>        P9_DPRINTK(P9_DEBUG_VFS, "inode: %p dentry: %p rmdir: %x\n",
>                   dir, dentry, flags);
>
> +       v9ses = v9fs_inode2v9ses(dir);
>        inode = dentry->d_inode;
>        dfid = v9fs_fid_lookup(dentry->d_parent);
>        if (IS_ERR(dfid)) {
> @@ -513,7 +515,8 @@ static int v9fs_remove(struct inode *dir, struct dentry *dentry, int flags)
>                P9_DPRINTK(P9_DEBUG_VFS, "fid lookup failed %d\n", retval);
>                return retval;
>        }
> -       retval = p9_client_unlinkat(dfid, dentry->d_name.name, flags);
> +       if (v9fs_proto_dotl(v9ses))
> +               retval = p9_client_unlinkat(dfid, dentry->d_name.name, flags);
>        if (retval == -EOPNOTSUPP) {
>                /* Try the one based on path */
>                v9fid = v9fs_fid_clone(dentry);
>

Looks right.
>
> related to renameat i have updated to check for -EOPNOTSUPP instead of
> -ENOSYS. I am not sure any other dotl server out there is returning
> -ENOSYS. We haven't documented what the server should return in case it
> doesn't support any specific operation.
>

Yeah, the real tricky thing is I'm not sure what the other 9p servers
will send back since there are so many of them.  I guess for dotl all
we need to do is look at diod and see what they are returning
(however, I'm sure they'll change if we want to make EOPNOTSUPP
standard).

          -eric
