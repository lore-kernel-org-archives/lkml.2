Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965Ab2BHAHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 19:07:24 -0500
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:41266 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756661Ab2BHAHW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 19:07:22 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Apple Message framework v1257)
Subject: Direct i/o changes break all non-GPL file systems
From: Anton Altaparmakov <anton@tuxera.com>
Date: Wed, 8 Feb 2012 00:07:15 +0000
Cc: Szabolcs Szakacsits <szaka@tuxera.com>,
        =?iso-8859-1?Q?Janne_Kalliom=E4ki?= <janne@tuxera.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <92291682-5422-4AE2-9608-97775603E7FD@tuxera.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, Andrew, Christoph,

With kernel 3.1, Christoph removed i_alloc_sem and replaced it with calls (namely inode_dio_wait() and inode_dio_done()) which are EXPORT_SYMBOL_GPL() thus they cannot be used by non-GPL file systems and further inode_dio_wait() was pushed from notify_change() into the file system ->setattr() method but no non-GPL file system can make this call.

That means non-GPL file systems cannot exist any more unless they do not use any VFS functionality related to reading/writing as far as I can tell or at least as long as they want to implement direct i/o.

What are commercial file systems meant to do now?

For example Tuxera exFAT uses the generic write code which means that read/write use the generic direct_IO functions however Tuxera exFAT's setattr() method cannot call inode_dio_wait() and there are places where exfat_truncate() is called directly with i_alloc_sem held and now this needs to be replaced with calls to inode_dio_wait() but we cannot do that as the function is GPL only.

Previously when APIs have been changed that were accessible to non-GPL modules it was made sure those APIs remained that way but this does not appear to be the case here.

Do all non-GPL file systems now really have to re-implement the entire read-write code paths for themselves for the sake of two GPL only exports in the direct i/o code?  That seems a bit harsh!

Have I missed something?  If not would you accept a patch to change the two needed GPL only symbols into EXPORT_SYMBOL() ones?

Thanks a lot in advance!

Best regards,

	Anton
-- 
Anton Altaparmakov <anton at tuxera.com> (replace at with @)
Senior Kernel Developer, Tuxera Inc., http://www.tuxera.com/
Linux NTFS maintainer, http://www.linux-ntfs.org/

