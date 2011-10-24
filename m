Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab1JXVhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 17:37:08 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12659 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab1JXVhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 17:37:07 -0400
Date: Mon, 24 Oct 2011 23:41:37 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: Markus Grabner <grabner@icg.tugraz.at>, Peter Huewe <peterhuewe@gmx.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] line6: fix memory leaks in line6_init_midi()
Message-ID: <alpine.LNX.2.00.1110242339500.19795@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the first call to line6_midibuf_init() fails we'll leak a little
bit of memory. If the second call fails we'll leak a bit more. This
happens when we return from the function and the local variable
'line6midi' goes out of scope.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/line6/midi.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/line6/midi.c b/drivers/staging/line6/midi.c
index e554a2d..86c50cf 100644
--- a/drivers/staging/line6/midi.c
+++ b/drivers/staging/line6/midi.c
@@ -391,12 +391,17 @@ int line6_init_midi(struct usb_line6 *line6)
 		return -ENOMEM;
 
 	err = line6_midibuf_init(&line6midi->midibuf_in, MIDI_BUFFER_SIZE, 0);
-	if (err < 0)
+	if (err < 0) {
+		kfree(line6midi);
 		return err;
+	}
 
 	err = line6_midibuf_init(&line6midi->midibuf_out, MIDI_BUFFER_SIZE, 1);
-	if (err < 0)
+	if (err < 0) {
+		kfree(line6midi->midibuf_in.buf);
+		kfree(line6midi);
 		return err;
+	}
 
 	line6midi->line6 = line6;
 	line6midi->midi_mask_transmit = 1;
-- 
1.7.7


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

