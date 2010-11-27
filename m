Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab0K0D5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 22:57:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:6921 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab0K0D5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 22:57:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,264,1288594800"; 
   d="scan'208";a="681417799"
Date: Sat, 27 Nov 2010 11:56:59 +0800
From: Yan Li <yan.i.li@intel.com>
To: linux-input@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        jian-feng.ding@intel.com, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        meego-kernel@lists.meego.com
Subject: [PATCH] Input: Lenovo S10-3t's touchpad support
Message-ID: <aefc1833eeede37ae6ea4a9ddeaa602eb7d31101.1290823698.git.yan.i.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is for kernel bug #18122 and MeeGo bug #4807.

Current code detects Clickpad by checking the 8 and 20 bits of 0x0c
cap. However, the code returns true if either of those bits is 1,
while it should only return true when both are 1. This has lead to the
touchpad on Lenovo S10-3t be mistakenly recognized as Clickpad and its
BTN_LEFT and BTN_RIGHT blocked.

So far we've found that the S10-3ts are shipped with two slightly
different models of touchpads, of which the 0x0c cap is either
0x5a0400 or 0x4a0500. They are not Clickpad and return BTN_LEFT and
BTN_RIGHT normally.

This patch fixed this issue by checking both sign bits are 1. Tested
on my S10-3t and worked well.

Signed-off-by: Yan Li <yan.i.li@intel.com>
---
 drivers/input/mouse/synaptics.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
index 613a365..0c1083c 100644
--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -51,7 +51,11 @@
 #define SYN_EXT_CAP_REQUESTS(c)		(((c) & 0x700000) >> 20)
 #define SYN_CAP_MULTI_BUTTON_NO(ec)	(((ec) & 0x00f000) >> 12)
 #define SYN_CAP_PRODUCT_ID(ec)		(((ec) & 0xff0000) >> 16)
-#define SYN_CAP_CLICKPAD(ex0c)		((ex0c) & 0x100100)
+/* Synaptics' ClickPad has both 8th and 20th bits set in the 0x0c
+ * cap. Other models (like those shipped with Lenovo S10-3t) may have
+ * either one of them set but not both, and they are *not* ClickPad
+ * although they look similar. */
+#define SYN_CAP_CLICKPAD(ex0c)		((ex0c) & 0x100100 == 0x100100)
 #define SYN_CAP_MAX_DIMENSIONS(ex0c)	((ex0c) & 0x020000)
 
 /* synaptics modes query bits */
-- 
1.7.2.3


-- 
Best regards,
Li, Yan

MeeGo Team, Opensource Technology Center, SSG, Intel
Office tel.: +86-10-82171695 (inet: 8-758-1695)
OpenPGP key: 5C6C31EF
IRC: yanli on network irc.freenode.net
