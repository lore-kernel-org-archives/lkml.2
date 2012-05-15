Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965273Ab2EOCp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:45:56 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53451 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965214Ab2EOCRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:32 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 113/179] si4713-i2c: avoid potential buffer overflow on si4713
Date: Mon, 14 May 2012 22:13:29 -0400
Message-ID: <1337048075-6132-114-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit dc6b845044ccb7e9e6f3b7e71bd179b3cf0223b6 upstream.

While compiling it with Fedora 15, I noticed this issue:

  inlined from ‘si4713_write_econtrol_string’ at drivers/media/radio/si4713-i2c.c:1065:24:
  arch/x86/include/asm/uaccess_32.h:211:26: error: call to ‘copy_from_user_overflow’ declared with attribute error: copy_from_user() buffer size is not provably correct

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Acked-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Acked-by: Eduardo Valentin <edubezval@gmail.com>
Reviewed-by: Eugene Teo <eugeneteo@kernel.sg>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/media/radio/si4713-i2c.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/si4713-i2c.c b/drivers/media/radio/si4713-i2c.c
index ab63dd5..6ce2fb1 100644
--- a/drivers/media/radio/si4713-i2c.c
+++ b/drivers/media/radio/si4713-i2c.c
@@ -1004,7 +1004,7 @@ static int si4713_write_econtrol_string(struct si4713_device *sdev,
 		char ps_name[MAX_RDS_PS_NAME + 1];
 
 		len = control->size - 1;
-		if (len > MAX_RDS_PS_NAME) {
+		if (len < 0 || len > MAX_RDS_PS_NAME) {
 			rval = -ERANGE;
 			goto exit;
 		}
@@ -1026,7 +1026,7 @@ static int si4713_write_econtrol_string(struct si4713_device *sdev,
 		char radio_text[MAX_RDS_RADIO_TEXT + 1];
 
 		len = control->size - 1;
-		if (len > MAX_RDS_RADIO_TEXT) {
+		if (len < 0 || len > MAX_RDS_RADIO_TEXT) {
 			rval = -ERANGE;
 			goto exit;
 		}
-- 
1.7.9.6

