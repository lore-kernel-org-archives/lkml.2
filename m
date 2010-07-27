Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab0G0A3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 20:29:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752411Ab0G0A3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 20:29:38 -0400
Date: Mon, 26 Jul 2010 17:29:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] V7: Add support for non-PDP11 v7 filesystems
Message-Id: <20100726172916.50ab7356.akpm@linux-foundation.org>
In-Reply-To: <1280189955.26200.5.camel@localhost.localdomain>
References: <20100724135128.GA11645@ZenIV.linux.org.uk>
	<1280098756-26522-1-git-send-email-lkundrak@v3.sk>
	<20100726165231.ea38062e.akpm@linux-foundation.org>
	<1280189955.26200.5.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jul 2010 02:19:15 +0200 Lubomir Rintel <lkundrak@v3.sk> wrote:

> On Mon, 2010-07-26 at 16:52 -0700, Andrew Morton wrote:
> > On Mon, 26 Jul 2010 00:59:16 +0200
> > Lubomir Rintel <lkundrak@v3.sk> wrote:
> > 
> > > This adds byte order autodetection (of PDP-11 and LE filesystems).
> > > No attempt is made to detect big-endian filesystems -- were there any?
> > > Tested with PDP-11 v7 filesystems and PC-IX maintenance floppy.
> > 
> > Which kernel is this against?  My v7_fill_super() is significantly
> > different from yours.
> 
> This depends on [PATCH] V7: Adjust sanity checks for some volumes
> <1279761108-302-1-git-send-email-lkundrak@v3.sk>.
> 
> It might be that I've messed up something in the communication so that
> the dependency was not immediately clear. To be honest, I'm not very
> familiar with the way reviews and adjustements to patches are tracked.
> What have I done wrong, here? How am I supposed to follow up with a
> change to a single patch of a multi-patch (be it just two in this case)
> set?

ah, OK, I managed to confuse myself with
fs-sysv-v7-adjust-sanity-checks-for-some-volumes-checkpatch-fixes.patch.

This new patch triggers many warnings also:

ERROR: do not use assignment in if condition
#52: FILE: fs/sysv/super.c:456:
+	if ((bh2 = sb_bread(sb, 2)) == NULL) {

WARNING: braces {} are not necessary for single statement blocks
#52: FILE: fs/sysv/super.c:456:
+	if ((bh2 = sb_bread(sb, 2)) == NULL) {
+		return 0;
+	}

ERROR: code indent should use tabs where possible
#61: FILE: fs/sysv/super.c:465:
+             sizeof (struct sysv_dir_entry))) {$

WARNING: please, no space for starting a line, 
				excluding comments
#61: FILE: fs/sysv/super.c:465:
+             sizeof (struct sysv_dir_entry))) {$

WARNING: space prohibited between function name and open parenthesis '('
#61: FILE: fs/sysv/super.c:465:
+             sizeof (struct sysv_dir_entry))) {

WARNING: space prohibited between function name and open parenthesis '('
#97: FILE: fs/sysv/super.c:504:
+	if (v7_sanity_check (sb, bh))

WARNING: space prohibited between function name and open parenthesis '('
#115: FILE: fs/sysv/super.c:509:
+	if (v7_sanity_check (sb, bh))

WARNING: printk() should include KERN_ facility level
#128: FILE: fs/sysv/super.c:521:
+	printk("VFS: could not find a valid V7 on %s.\n", sb->s_id);

total: 2 errors, 6 warnings, 109 lines checked

./patches/v7-add-support-for-non-pdp11-v7-filesystems.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.




--- a/fs/sysv/super.c~fs-sysv-superc-add-support-for-non-pdp11-v7-filesystems-checkpatch-fixes
+++ a/fs/sysv/super.c
@@ -453,16 +453,16 @@ static int v7_sanity_check(struct super_
 
 	/* plausibility check on root inode: it is a directory,
 	   with a nonzero size that is a multiple of 16 */
-	if ((bh2 = sb_bread(sb, 2)) == NULL) {
+	bh2 = sb_bread(sb, 2);
+	if (bh2 == NULL)
 		return 0;
-	}
 
 	v7i = (struct sysv_inode *)(bh2->b_data + 64);
 	if ((fs16_to_cpu(sbi, v7i->i_mode) & ~0777) != S_IFDIR ||
 	    (fs32_to_cpu(sbi, v7i->i_size) == 0) ||
 	    (fs32_to_cpu(sbi, v7i->i_size) & 017) ||
 	    (fs32_to_cpu(sbi, v7i->i_size) > V7_NFILES *
-             sizeof (struct sysv_dir_entry))) {
+	     sizeof(struct sysv_dir_entry))) {
 		brelse(bh2);
 		return 0;
 	}
@@ -501,12 +501,12 @@ static int v7_fill_super(struct super_bl
 
 	/* Try PDP-11 UNIX */
 	sbi->s_bytesex = BYTESEX_PDP;
-	if (v7_sanity_check (sb, bh))
+	if (v7_sanity_check(sb, bh))
 		goto detected;
 
 	/* Try PC/IX, v7/x86 */
 	sbi->s_bytesex = BYTESEX_LE;
-	if (v7_sanity_check (sb, bh))
+	if (v7_sanity_check(sb, bh))
 		goto detected;
 
 	goto failed;
@@ -518,7 +518,8 @@ detected:
 		return 0;
 
 failed:
-	printk("VFS: could not find a valid V7 on %s.\n", sb->s_id);
+	printk(KERN_ERR "VFS: could not find a valid V7 on %s.\n",
+		sb->s_id);
 	brelse(bh);
 	kfree(sbi);
 	return -EINVAL;
_

