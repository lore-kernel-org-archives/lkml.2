Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715Ab1BPBf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:35:56 -0500
Received: from kroah.org ([198.145.64.141]:39155 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757018Ab1BPAUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:20:46 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:35 2011
Message-Id: <20110216001435.006490685@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Torokhov <dtor@mail.ru>
Subject: [099/272] Input: rc-keymap - return KEY_RESERVED for unknown mappings
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 54e74b87e2a9941c6fa82189f270b47cceeba714 upstream.

Do not respond with -EINVAL to EVIOCGKEYCODE for not-yet-mapped
scancodes, but rather return KEY_RESERVED.

This fixes breakage with Ubuntu's input-kbd utility that stopped
returning full keymaps for remote controls.

Tested-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Tested-by: Mark Lord <kernel@teksavvy.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/media/IR/ir-keytable.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -374,21 +374,27 @@ static int ir_getkeycode(struct input_de
 		index = ir_lookup_by_scancode(rc_tab, scancode);
 	}
 
-	if (index >= rc_tab->len) {
-		if (!(ke->flags & INPUT_KEYMAP_BY_INDEX))
-			IR_dprintk(1, "unknown key for scancode 0x%04x\n",
-				   scancode);
+	if (index < rc_tab->len) {
+		entry = &rc_tab->scan[index];
+
+		ke->index = index;
+		ke->keycode = entry->keycode;
+		ke->len = sizeof(entry->scancode);
+		memcpy(ke->scancode, &entry->scancode, sizeof(entry->scancode));
+
+	} else if (!(ke->flags & INPUT_KEYMAP_BY_INDEX)) {
+		/*
+		 * We do not really know the valid range of scancodes
+		 * so let's respond with KEY_RESERVED to anything we
+		 * do not have mapping for [yet].
+		 */
+		ke->index = index;
+		ke->keycode = KEY_RESERVED;
+	} else {
 		retval = -EINVAL;
 		goto out;
 	}
 
-	entry = &rc_tab->scan[index];
-
-	ke->index = index;
-	ke->keycode = entry->keycode;
-	ke->len = sizeof(entry->scancode);
-	memcpy(ke->scancode, &entry->scancode, sizeof(entry->scancode));
-
 	retval = 0;
 
 out:


