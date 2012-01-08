Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab2AHDa3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 22:30:29 -0500
Received: from nm28-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.22]:32566 "HELO
	nm28-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751178Ab2AHDa2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 22:30:28 -0500
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Jan 2012 22:30:28 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 817280.3463.bm@omp1011.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=TeC8MvePB3sE7VWsKjOGlhNHOMMUvWuzjctrBY1wMtF4f9d4uGmOYyj57Kt7kHUUNy8v1rqMraMDW6q3sJygUQC2LO18xlft84TVdmib/BjQncHn7XI1kKTHK6X4j8dj6O/qeB/TF3Ej17EhKsmjsNLx0h2IofuqNtlVqnrLVnI=;
X-YMail-OSG: 0PZlYGwVM1l.YmFQs5vZYmF1kQxHdyO26axgL_ASTc_OQcf
 8VN10rEuo6SnOa9Ywvgg9g4oedjAD5CBoX92d.vMMhE52JpOWktoWp0NSJRD
 FSig2TU4ykfIwfukoG2EcBCbl6gkjXw5yIFLCf.Y_DyTvt45mNheRbH5rurC
 lGDOlW.TVBUZvrkYNrEPyoyVR6JEyMppjAriW0EnE30SklCy7piWHZ8Hsb9X
 WenOY2QvE4GpnfEyDSyyMxysureaC30lJaWpR6Jrj.eR1AVo6hnpS4kBbT6H
 _.4W3HY2bvc_ePsuJzQKJuryjrJRkNTZ1jxF1AHH3IiFnvhUa6BWxp5x_oQe
 PVVX95S_NzssG1z0MscZXjljFNdag7yDpTk921ydi7mm_SyD0oCULeZWKAYe
 Ti1hVxv2a5s0s.lUDmNoAxg1FmOVGNBmtRjz0caaZpyDLSl6xGPFOQW_KAvk
 -
X-Mailer: YahooMailWebService/0.8.115.331698
Message-ID: <1325993012.29526.YahooMailNeo@web38004.mail.mud.yahoo.com>
Date: Sat, 7 Jan 2012 19:23:32 -0800 (PST)
From: Shantanu Goel <sgoel01@yahoo.com>
Reply-To: Shantanu Goel <sgoel01@yahoo.com>
Subject: [PATCH] ext4: Fix up range_end offset in range cyclic writeback
To: Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi,

The patch below fixes the range_end calculation which should be a byte offset and not a page index.  Also, the patch updates the `end' index as well when looping again in range cyclic mode.

Signed-off-by: Shantanu Goel <sgoel01@yahoo.com>

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2324,9 +2324,10 @@ retry:
        blk_finish_plug(&plug);
        if (!io_done && !cycled) {
                cycled = 1;
+               end = index - 1;
                index = 0;
-               wbc->range_start = index << PAGE_CACHE_SHIFT;
-               wbc->range_end  = mapping->writeback_index - 1;
+               wbc->range_start = 0;
+               wbc->range_end  = ((loff_t)(end + 1) << PAGE_CACHE_SHIFT) - 1;
                goto retry;
        }
