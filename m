Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab1EFAY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:24:56 -0400
Received: from kroah.org ([198.145.64.141]:36795 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932230Ab1EFAYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:53 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:10 2011
Message-Id: <20110506002210.602176788@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Torokhov <dtor@mail.ru>
Subject: [055/143] Input: elantech - relax signature checks
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit a083632eaf6231162b33e40561cfec6a9c156945 upstream.

Apparently there are Elantech touchpads that report non-zero in the 2nd byte
of their signature. Adjust the detection routine so that if 2nd byte is
zero and 3rd byte contains value that is not a valid report rate, we still
assume that signature is valid.

Tested-by: Eric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
[bwh: Adjust context for 2.6.32]
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/input/mouse/elantech.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -574,6 +574,24 @@ static struct attribute_group elantech_a
 	.attrs = elantech_attrs,
 };
 
+static bool elantech_is_signature_valid(const unsigned char *param)
+{
+	static const unsigned char rates[] = { 200, 100, 80, 60, 40, 20, 10 };
+	int i;
+
+	if (param[0] == 0)
+		return false;
+
+	if (param[1] == 0)
+		return true;
+
+	for (i = 0; i < ARRAY_SIZE(rates); i++)
+		if (param[2] == rates[i])
+			return false;
+
+	return true;
+}
+
 /*
  * Use magic knock to detect Elantech touchpad
  */
@@ -617,7 +635,7 @@ int elantech_detect(struct psmouse *psmo
 	pr_debug("elantech.c: Elantech version query result 0x%02x, 0x%02x, 0x%02x.\n",
 		 param[0], param[1], param[2]);
 
-	if (param[0] == 0 || param[1] != 0) {
+	if (!elantech_is_signature_valid(param)) {
 		if (!force_elantech) {
 			pr_debug("elantech.c: Probably not a real Elantech touchpad. Aborting.\n");
 			return -1;


