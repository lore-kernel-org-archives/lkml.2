Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab0CYJjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 05:39:45 -0400
Received: from daytona.panasas.com ([67.152.220.89]:21470 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751588Ab0CYJjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 05:39:44 -0400
Message-ID: <4BAB2F5A.30409@panasas.com>
Date: Thu, 25 Mar 2010 11:39:38 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Doug Nazar <nazard.lkml@gmail.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [pnfs] [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT
 case to use of do_last()
References: <4BAA3828.2070506@panasas.com> <20100324160754.GQ30031@ZenIV.linux.org.uk> <4BAA398C.5050901@panasas.com> <20100324163948.GR30031@ZenIV.linux.org.uk> <4BAA48A3.1030801@panasas.com> <4BAA4CAC.6060104@panasas.com> <4BAA5035.1060906@panasas.com> <4BAA52A8.2080304@panasas.com> <20100324180622.GS30031@ZenIV.linux.org.uk> <4BAA5955.4000001@gmail.com> <20100324185604.GT30031@ZenIV.linux.org.uk>
In-Reply-To: <20100324185604.GT30031@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2010 09:39:40.0812 (UTC) FILETIME=[17B1FCC0:01CACBFF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2010 08:56 PM, Al Viro wrote:
> On Wed, Mar 24, 2010 at 02:26:29PM -0400, Doug Nazar wrote:
>> I also see it....didn't bisect it yet since I was in a rush and had
>> a simple work around. I was doing a git pull between two
>> repositories on a NFS 4 w/krb5 security. Got the error about
>> .git/objects/pack (error: unable to open object pack directory:
>> .git/objects/pack: Is a directory). If I then run 'ls
>> .git/objects/pack', and then the 'git pull' again it works.
> 
> Very interesting...  The damn thing *is* a directory, which should have
> made NFS skip all lookup_instantiate_filp() tricks completely.  IOW, it's
> not hitting anything intent-related at that case.
> 
> I really wonder where the hell does EISDIR come from; no matter how screwed
> the cached attributes are, there's not a lot of places where we can return
> that sucker.  It either comes from something in NFS itself, or it's
> may_open() getting MAY_WRITE on that object or it has to see O_CREAT in
> open_flag.  And acc_mode is not modified after it's set in do_filp_open().
> If that calculation (acc_mode by open_flag) would be buggered for O_RDONLY,
> we'd be seeing a lot more breakage, starting with ls(1) ;-)
> 
> One possibility is that shit hits the fan a bit earlier and git really passes
> something odd to that open() as the result of bogus stat(), etc.
> 
> Folks, could you try the following: in do_last() move case LAST_DOT:
> to immediately after follow_dotdot(nd); and see if that changes anything?
> It shouldn't, but if nfs is playing odd tricks with ->d_revalidate() for
> directories acting differently depending on LOOKUP_PARENT in flags...
> 
> IOW, replace
>         case LAST_DOTDOT:  
>                 follow_dotdot(nd);
>                 dir = nd->path.dentry;
>                 if (nd->path.mnt->mnt_sb->s_type->fs_flags & FS_REVAL_DOT) {
>                         if (!dir->d_op->d_revalidate(dir, nd)) {
>                                 error = -ESTALE;
>                                 goto exit;
>                         }
>                 }
>                 /* fallthrough */
>         case LAST_DOT:
>         case LAST_ROOT:
> with
>         case LAST_DOTDOT:  
>                 follow_dotdot(nd);
>                 /* fallthrough */
>         case LAST_DOT:
>                 dir = nd->path.dentry;
>                 if (nd->path.mnt->mnt_sb->s_type->fs_flags & FS_REVAL_DOT) {
>                         if (!dir->d_op->d_revalidate(dir, nd)) {
>                                 error = -ESTALE;
>                                 goto exit;
>                         }
>                 }
>                 /* fallthrough */
>         case LAST_ROOT:
> and see what'll change.

(Below is what I changed)

It makes no difference, fails just the same. Would an "strace" help?

I will now setup an ext2 export. exofs is an heavy ext2 copy paste in every
thing meta-data and nfs-export. I hope to strimline to the basics.

You have asked before, if the failure is reproducible. Yes it fails every
time in exactly the same way. "git status" on that tree has never succeeded
from the 2.6.34-rc2 client.

Boaz
---
diff --git a/fs/namei.c b/fs/namei.c
index 1c0fca6..e8a6a7b 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1618,8 +1618,10 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	int error = -EISDIR;
 
 	switch (nd->last_type) {
-	case LAST_DOTDOT:
+	case LAST_DOTDOT:  
 		follow_dotdot(nd);
+		/* fallthrough */
+	case LAST_DOT:
 		dir = nd->path.dentry;
 		if (nd->path.mnt->mnt_sb->s_type->fs_flags & FS_REVAL_DOT) {
 			if (!dir->d_op->d_revalidate(dir, nd)) {
@@ -1628,7 +1630,6 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 			}
 		}
 		/* fallthrough */
-	case LAST_DOT:
 	case LAST_ROOT:
 		if (open_flag & O_CREAT)
 			goto exit;
@@ -1650,6 +1651,12 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 		error = do_lookup(nd, &nd->last, path);
 		if (error)
 			goto exit;
+
+		if (IS_ERR(nd->intent.open.file)) {
+			printk(KERN_ERR "foo: %s", pathname);
+			WARN_ON(1);
+		}
+
 		error = -ENOENT;
 		if (!path->dentry->d_inode)
 			goto exit_dput;
