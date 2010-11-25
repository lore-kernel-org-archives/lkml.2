Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab0KYInq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 03:43:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:43417 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab0KYInp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 03:43:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,253,1288594800"; 
   d="scan'208";a="680936898"
From: Chen Gong <gong.chen@linux.intel.com>
To: x86@kernel.org
Cc: hpa@zytor.com, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        Chen Gong <gong.chen@linux.intel.com>
Subject: [PATCH] x86/MCE: don't let EDAC bypass the handle from MCE
Date: Thu, 25 Nov 2010 16:46:33 +0800
Message-Id: <1290674793-8346-1-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.7.3.1.120.g38a18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

currently EDAC bypass userspace handler intentionally if it can
deal with it, but this kind of operation will confuse users.
Some errors such as memory errors will be decoded by EDAC but
userspace handler (such as mcelog) knows nothing about it. At
least the kernel should give userspace a chance to know what
happens.

Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 7a35b72..78eba57 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -169,14 +169,7 @@ void mce_log(struct mce *mce)
 	for (;;) {
 		entry = rcu_dereference_check_mce(mcelog.next);
 		for (;;) {
-			/*
-			 * If edac_mce is enabled, it will check the error type
-			 * and will process it, if it is a known error.
-			 * Otherwise, the error will be sent through mcelog
-			 * interface
-			 */
-			if (edac_mce_parse(mce))
-				return;
+			edac_mce_parse(mce);
 
 			/*
 			 * When the buffer fills up discard new entries.
-- 
1.7.3.1.120.g38a18

