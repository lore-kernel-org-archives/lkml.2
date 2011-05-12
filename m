Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab1ELOAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:00:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54848 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757260Ab1ELOAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:00:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=mbo4qYBhZyrGAgwWlza45gGkyTlCQE8hHkg6z1Ffa/4c6PqIA2QCZyHaYMdzH1gFbz
         ph7RbwN+vF50tJyza2ftFpzFz+lpKDLEzb7tQ0Hg93Y7maNTFZ0A+diNsaOqzmTDp5VJ
         N7WT1uaEGYQFhybWLVbd8fZkP16PsVDCnGahU=
From: Miklos Szeredi <miklos@szeredi.hu>
To: Hugh Dickins <hughd@google.com>
Cc: Michal Suchanek <hramrach@centrum.cz>, Andreas Dilger <adilger@dilger.ca>,
        Jiri Kosina <jkosina@suse.cz>, Ric Wheeler <ricwheeler@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Ian Kent <ikent@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Eric Paris <eparis@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [PATCH] tmpfs: implement generic xattr support
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
	<4DA4B6A8.7030804@gmail.com>
	<BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
	<alpine.LRH.2.00.1104131618170.6953@twin.jikos.cz>
	<BANLkTindBULU9KAVWPJQ7oQvfCNQU-BuAg@mail.gmail.com>
	<BANLkTin6CVFOAECWwYg3B5V2AfscFfjt8w@mail.gmail.com>
	<BANLkTik7jasnvqFQohRdU-3crM8fr9pBXg@mail.gmail.com>
	<BANLkTikF_hgYSaZJbZosWwcs715tLXYfmQ@mail.gmail.com>
	<BANLkTikTUo17RncV7bushPTri=LEykep5g@mail.gmail.com>
	<BANLkTikUe_2Uo2_tSYdfNoNXKYO4Bj30iQ@mail.gmail.com>
	<C450CD68-10AE-4527-B6BF-A5D5F0BF005F@dilger.ca>
	<BANLkTinMNL8Q+_MCHDqAGSdYNAvHB2GdLw@mail.gmail.com>
	<87tydu3t4p.fsf_-_@tucsk.pomaz.szeredi.hu>
	<alpine.LSU.2.00.1105112023560.1424@sister.anvils>
	<87sjskm7dk.fsf@tucsk.pomaz.szeredi.hu>
Date: Thu, 12 May 2011 16:00:40 +0200
In-Reply-To: <87sjskm7dk.fsf@tucsk.pomaz.szeredi.hu> (Miklos Szeredi's message
	of "Thu, 12 May 2011 14:27:19 +0200")
Message-ID: <87oc38m31z.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

>>> +	info = SHMEM_I(dentry->d_inode);
>>> +
>>> +	spin_lock(&dentry->d_inode->i_lock);
>>
>> Not important, but I suggest you use info->lock throughout for this,
>> instead of dentry->d_inode->i_lock: in each case you need "info" for
>> info->xattr_list (and don't need "inode" at all I think), so info->lock
>> seems appropriate, and may be in the same cacheline once I make
>> shmem_inode_info smaller.  But don't worry if you'd prefer to leave
>> it.
>
> Makes sense.  I updated the locking.

This uncovered a nasty bug lurking in there: the "info" area, including
lock and xattr_list, may be overwritten by inline symlinks.  Because
xattr_list is near the end, this wasn't noticed with casual testing, but
info->lock would immediately Oops on getxattr for symlinks.

I propose the following solution.  It results in slightly less space for
inline symlinks, but correct operation for xattrs.  Does the anonymous
union/struct solution look acceptable?

Thanks,
Miklos

Index: linux-2.6/include/linux/shmem_fs.h
===================================================================
--- linux-2.6.orig/include/linux/shmem_fs.h	2011-05-12 15:59:08.000000000 +0200
+++ linux-2.6/include/linux/shmem_fs.h	2011-05-12 15:58:25.000000000 +0200
@@ -11,15 +11,39 @@
 
 struct shmem_inode_info {
 	spinlock_t		lock;
-	unsigned long		flags;
-	unsigned long		alloced;	/* data pages alloced to file */
-	unsigned long		swapped;	/* subtotal assigned to swap */
-	unsigned long		next_index;	/* highest alloced index + 1 */
-	struct shared_policy	policy;		/* NUMA memory alloc policy */
-	struct page		*i_indirect;	/* top indirect blocks page */
-	swp_entry_t		i_direct[SHMEM_NR_DIRECT]; /* first blocks */
-	struct list_head	swaplist;	/* chain of maybes on swap */
-	struct list_head	xattr_list;	/* list of shmem_xattr */
+
+	/* list of shmem_xattr */
+	struct list_head	xattr_list;
+
+	union {
+		char			inline_symlink[0];
+
+		/* Members not used by inline symlinks: */
+		struct {
+			unsigned long		flags;
+
+			/* data pages alloced to file */
+			unsigned long		alloced;
+
+			/* subtotal assigned to swap */
+			unsigned long		swapped;
+
+			/* highest alloced index + 1 */
+			unsigned long		next_index;
+
+			/* NUMA memory alloc policy */
+			struct shared_policy	policy;
+
+			/* top indirect blocks page */
+			struct page		*i_indirect;
+
+			/* first blocks */
+			swp_entry_t		i_direct[SHMEM_NR_DIRECT];
+
+			/* chain of maybes on swap */
+			struct list_head	swaplist;
+		};
+	};
 	struct inode		vfs_inode;
 };
 
Index: linux-2.6/mm/shmem.c
===================================================================
--- linux-2.6.orig/mm/shmem.c	2011-05-12 15:59:08.000000000 +0200
+++ linux-2.6/mm/shmem.c	2011-05-12 15:50:10.000000000 +0200
@@ -2029,9 +2029,9 @@ static int shmem_symlink(struct inode *d
 
 	info = SHMEM_I(inode);
 	inode->i_size = len-1;
-	if (len <= (char *)inode - (char *)info) {
+	if (len <= (char *)inode - info->inline_symlink) {
 		/* do it inline */
-		memcpy(info, symname, len);
+		memcpy(info->inline_symlink, symname, len);
 		inode->i_op = &shmem_symlink_inline_operations;
 	} else {
 		error = shmem_getpage(inode, 0, &page, SGP_WRITE, NULL);
@@ -2057,7 +2057,7 @@ static int shmem_symlink(struct inode *d
 
 static void *shmem_follow_link_inline(struct dentry *dentry, struct nameidata *nd)
 {
-	nd_set_link(nd, (char *)SHMEM_I(dentry->d_inode));
+	nd_set_link(nd, SHMEM_I(dentry->d_inode)->inline_symlink);
 	return NULL;
 }
 



