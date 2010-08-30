Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab0H3S1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 14:27:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755972Ab0H3S1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 14:27:10 -0400
Date: Mon, 30 Aug 2010 14:26:30 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Karel Zak <kzak@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VFS: Sanity check mount flags passed to change_mnt_propagation()
Message-ID: <20100830182629.GA2444@shell>
References: <20100826200318.GA13636@shell> <20100827011436.GB3521@parisc-linux.org> <AANLkTi=400UGaZZNnNaDM-=gF5VrZ=myROZDgS=UnFV0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=400UGaZZNnNaDM-=gF5VrZ=myROZDgS=UnFV0@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 02:23:51PM -0700, Linus Torvalds wrote:
> On Thu, Aug 26, 2010 at 6:14 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> >
> > ? ? ? ?/* Only one propagation flag should be set, and no others */
> > ? ? ? ?if (hweight32(type) != 1
> 
> Guys, stop with "teh crazy".
> 
> What the f*ck kind of expression is that? We don't do this kind of
> crap. Even if it's possible that the compiler might be able to
> optimize it, it's just crazy to call "hweight32()" for something like
> this.
> 
> Please think about what you're really after for a second, and realize
> that "one bit set" is just another way of saying "power of two". And
> then sit back, relax, and realize that there are way better ways to
> say "is this is a power of two" than counting bits, for chrissake!

I considered is_power_of_2() initially but rejected it as not
particularly readable.  But hey, this is VFS code!

-VAL

commit ce3708ab514d850b0d0939f3fa6c64daad306a15
Author: Valerie Aurora <vaurora@redhat.com>
Date:   Thu Aug 26 11:07:22 2010 -0700

    VFS: Sanity check mount flags passed to change_mnt_propagation()
    
    Sanity check the flags passed to change_mnt_propagation().  Exactly
    one flag should be set.  Return EINVAL otherwise.
    
    Userspace can pass in arbitrary combinations of MS_* flags to mount().
    do_change_type() is called if any of MS_SHARED, MS_PRIVATE, MS_SLAVE,
    or MS_UNBINDABLE is set.  do_change_type() clears MS_REC and then
    calls change_mnt_propagation() with the rest of the user-supplied
    flags.  change_mnt_propagation() clearly assumes only one flag is set
    but do_change_type() does not check that this is true.  For example,
    mount() with flags MS_SHARED | MS_RDONLY does not actually make the
    mount shared or read-only but does clear MNT_UNBINDABLE.
    
    Signed-off-by: Valerie Aurora <vaurora@redhat.com>

diff --git a/fs/namespace.c b/fs/namespace.c
index de402eb..ddc5565 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1484,13 +1484,29 @@ out_unlock:
 }
 
 /*
+ * Sanity check the flags to change_mnt_propagation.
+ */
+
+static int flags_to_propagation_type(int flags) {
+	int type = flags & ~MS_REC;
+
+	/* Fail if any non-propagation flags are set */
+	if (type & ~(MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
+		return 0;
+	/* Only one propagation flag should be set */
+	if (!is_power_of_2(type))
+		return 0;
+	return type;
+}
+
+/*
  * recursively change the type of the mountpoint.
  */
 static int do_change_type(struct path *path, int flag)
 {
 	struct vfsmount *m, *mnt = path->mnt;
 	int recurse = flag & MS_REC;
-	int type = flag & ~MS_REC;
+	int type;
 	int err = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -1499,6 +1515,10 @@ static int do_change_type(struct path *path, int flag)
 	if (path->dentry != path->mnt->mnt_root)
 		return -EINVAL;
 
+	type = flags_to_propagation_type(flag);
+	if (!type)
+		return -EINVAL;
+
 	down_write(&namespace_sem);
 	if (type == MS_SHARED) {
 		err = invent_group_ids(mnt, recurse);
