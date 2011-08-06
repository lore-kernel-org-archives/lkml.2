Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab1HFAIi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:08:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39073 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932122Ab1HFAId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:08:33 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:02:49 2011
Message-Id: <20110806000249.780424574@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:01:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
        Eduardo Valentin <edubezval@gmail.com>
Subject: [09/55] si4713-i2c: avoid potential buffer overflow on si4713
In-Reply-To: <20110806000257.GA25498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Mauro Carvalho Chehab <mchehab@redhat.com>

commit dc6b845044ccb7e9e6f3b7e71bd179b3cf0223b6 upstream.

While compiling it with Fedora 15, I noticed this issue:

  inlined from ‘si4713_write_econtrol_string’ at drivers/media/radio/si4713-i2c.c:1065:24:
  arch/x86/include/asm/uaccess_32.h:211:26: error: call to ‘copy_from_user_overflow’ declared with attribute error: copy_from_user() buffer size is not provably correct

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Acked-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Acked-by: Eduardo Valentin <edubezval@gmail.com>
Reviewed-by: Eugene Teo <eugeneteo@kernel.sg>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/radio/si4713-i2c.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/radio/si4713-i2c.c
+++ b/drivers/media/radio/si4713-i2c.c
@@ -1003,7 +1003,7 @@ static int si4713_write_econtrol_string(
 		char ps_name[MAX_RDS_PS_NAME + 1];
 
 		len = control->size - 1;
-		if (len > MAX_RDS_PS_NAME) {
+		if (len < 0 || len > MAX_RDS_PS_NAME) {
 			rval = -ERANGE;
 			goto exit;
 		}
@@ -1025,7 +1025,7 @@ static int si4713_write_econtrol_string(
 		char radio_text[MAX_RDS_RADIO_TEXT + 1];
 
 		len = control->size - 1;
-		if (len > MAX_RDS_RADIO_TEXT) {
+		if (len < 0 || len > MAX_RDS_RADIO_TEXT) {
 			rval = -ERANGE;
 			goto exit;
 		}


