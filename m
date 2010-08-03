Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab0HCJxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 05:53:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:52368 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755695Ab0HCJxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 05:53:43 -0400
Message-ID: <4C57E722.5060809@kernel.org>
Date: Tue, 03 Aug 2010 11:53:38 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: stable@kernel.org, Vladislav Bolkhovitin <vst@vlnb.net>,
        Bryan Mesich <bryan.mesich@ndsu.edu>, scst-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, Neil Brown <neilb@suse.de>
Subject: [PATCH 1/2 block#for-2.6.36] bio, fs: update RWA_MASK, READA and
 SWRITE to match the corresponding BIO_RW_* bits
References: <20100628010346.GA2376@atlantis.cc.ndsu.nodak.edu>	<4C28EFD6.2070203@vlnb.net>	<20100714190325.GA25148@atlantis.cc.ndsu.nodak.edu>	<4C3EF3AD.5070509@vlnb.net>	<20100723191844.GB31152@atlantis.cc.ndsu.nodak.edu>	<4C4D7DF5.9060909@vlnb.net>	<20100727220110.GF31152@atlantis.cc.ndsu.nodak.edu>	<4C5073F3.1060406@vlnb.net>	<4C52A98A.7060507@kernel.org> <20100802104227.79340b49@notabene> <4C56D397.8010305@kernel.org> <4C5724E8.9010204@kernel.dk>
In-Reply-To: <4C5724E8.9010204@kernel.dk>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 03 Aug 2010 09:53:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a82afdf (block: use the same failfast bits for bio and request)
moved BIO_RW_* bits around such that they match up with REQ_* bits.
Unfortunately, fs.h hard coded RW_MASK, RWA_MASK, READ, WRITE, READA
and SWRITE as 0, 1, 2 and 3, and expected them to match with BIO_RW_*
bits.  READ/WRITE didn't change but BIO_RW_AHEAD was moved to bit 4
instead of bit 1, breaking RWA_MASK, READA and SWRITE.

This patch updates RWA_MASK, READA and SWRITE such that they match the
BIO_RW_* bits again.  A follow up patch will update the definitions to
directly use BIO_RW_* bits so that this kind of breakage won't happen
again.

Neil also spotted missing RWA_MASK conversion.

Stable: The offending commit a82afdf was released with v2.6.32, so
this patch should be applied to all kernels since then but it must
_NOT_ be applied to kernels earlier than that.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-and-bisected-by: Vladislav Bolkhovitin <vst@vlnb.net>
Root-caused-by: Neil Brown <neilb@suse.de>
Cc: Jens Axobe <axboe@kernel.dk>
Cc: stable@kernel.org
---
Here's the regenerated version also w/ the missing RWA_MASK conversion
Neil spotted.

Thanks.

 include/linux/fs.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: work/include/linux/fs.h
===================================================================
--- work.orig/include/linux/fs.h
+++ work/include/linux/fs.h
@@ -145,12 +145,12 @@ struct inodes_stat_t {
  *
  */
 #define RW_MASK			1
-#define RWA_MASK		2
+#define RWA_MASK		16

 #define READ			0
 #define WRITE			1
-#define READA			2 /* readahead  - don't block if no resources */
-#define SWRITE			3 /* for ll_rw_block() - wait for buffer lock */
+#define READA			16 /* readahead - don't block if no resources */
+#define SWRITE			17 /* for ll_rw_block(), wait for buffer lock */

 #define READ_SYNC		(READ | REQ_SYNC | REQ_UNPLUG)
 #define READ_META		(READ | REQ_META)
