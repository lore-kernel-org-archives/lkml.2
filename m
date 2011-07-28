Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab1G1Xxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:53:31 -0400
Received: from mga14.intel.com ([143.182.124.37]:7788 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756150Ab1G1XoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="32808952"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: mchehab@redhat.com, sakari.ailus@maxwell.research.nokia.com,
        edubezval@gmail.com, eugeneteo@kernel.sg,
        torvalds@linux-foundation.org, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [17/50] si4713-i2c: avoid potential buffer overflow on si4713
Message-Id: <20110728234421.989AB2403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Mauro Carvalho Chehab <mchehab@redhat.com>

[ upstream commit dc6b845044ccb7e9e6f3b7e71bd179b3cf0223b6 ]
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

While compiling it with Fedora 15, I noticed this issue:

  inlined from ‘si4713_write_econtrol_string’ at drivers/media/radio/si4713-i2c.c:1065:24:
  arch/x86/include/asm/uaccess_32.h:211:26: error: call to ‘copy_from_user_overflow’ declared with attribute error: copy_from_user() buffer size is not provably correct

Cc: stable@kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Acked-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Acked-by: Eduardo Valentin <edubezval@gmail.com>
Reviewed-by: Eugene Teo <eugeneteo@kernel.sg>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/drivers/media/radio/si4713-i2c.c
===================================================================
--- linux-2.6.35.y.orig/drivers/media/radio/si4713-i2c.c
+++ linux-2.6.35.y/drivers/media/radio/si4713-i2c.c
@@ -1004,7 +1004,7 @@ static int si4713_write_econtrol_string(
 		char ps_name[MAX_RDS_PS_NAME + 1];
 
 		len = control->size - 1;
-		if (len > MAX_RDS_PS_NAME) {
+		if (len < 0 || len > MAX_RDS_PS_NAME) {
 			rval = -ERANGE;
 			goto exit;
 		}
@@ -1026,7 +1026,7 @@ static int si4713_write_econtrol_string(
 		char radio_text[MAX_RDS_RADIO_TEXT + 1];
 
 		len = control->size - 1;
-		if (len > MAX_RDS_RADIO_TEXT) {
+		if (len < 0 || len > MAX_RDS_RADIO_TEXT) {
 			rval = -ERANGE;
 			goto exit;
 		}
