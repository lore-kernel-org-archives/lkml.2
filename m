Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab0KZVh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 16:37:57 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34418 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab0KZVhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 16:37:55 -0500
Date: Fri, 26 Nov 2010 21:37:49 +0000
From: James Hogan <james@albanarts.com>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] winbond-cir: fix extended NEC scancode encoding
Message-ID: <20101126213749.GB21473@gandalf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This changes the scancode encoding behaviour for extended NEC on
winbond-cir by swapping the address bytes. This makes it consistent with
the software NEC decoder in drivers/media/IR, but changes the scancodes
for extended NEC. Comments in the code suggest NEC wasn't tested, and
I'm not sure if it has any users using extended NEC, so hopefully this
won't be a problem?

Note: i'm not able to test this patch other than compiling it.

Thanks
James
--
Swap the placement of the address bytes in the scancodes for extended
NEC in winbond-cir.

After comparing the extended NEC scancode construction of the software
NEC decoder (in media/IR) and winbond-cir it appears winbond-cir is
putting the two address bytes the wrong way around.

Here's how the decoders previously generated scancodes:
winbond-cir normal NEC:   msb [ 0x0,      0x0, address1, command ] lsb
soft normal NEC:          msb [ 0x0,      0x0, address1, command ] lsb
winbond-cir extended NEC: msb [ 0x0, address2, address1, command ] lsb
soft extended NEC:        msb [ 0x0, address1, address2, command ] lsb

A NEC data sheet [1] describes the first byte (address1) of extended NEC
as 'Higher 8 bits of custom code' and the second byte (address2) as
'Lower 8 bits of custom code'.

[1] http://www.datasheetcatalog.org/datasheet/nec/UPD6122G-002.pdf

Signed-off-by: James Hogan <james@albanarts.com>
---
 drivers/input/misc/winbond-cir.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/input/misc/winbond-cir.c b/drivers/input/misc/winbond-cir.c
index 64f1de7..01a9069 100644
--- a/drivers/input/misc/winbond-cir.c
+++ b/drivers/input/misc/winbond-cir.c
@@ -851,8 +851,8 @@ wbcir_parse_nec(struct device *dev, struct wbcir_data *data)
 	 * and Command2 was the inverse of Command1 and were used as
 	 * an error check.
 	 *
-	 * With NEC extended, Address1 is the LSB of the Address and
-	 * Address2 is the MSB, Command parsing remains unchanged.
+	 * With NEC extended, Address1 is the MSB of the Address and
+	 * Address2 is the LSB, Command parsing remains unchanged.
 	 *
 	 * A repeat message is coded as:
 	 * Leader		- 9 ms burst
@@ -916,7 +916,7 @@ wbcir_parse_nec(struct device *dev, struct wbcir_data *data)
 	/* Check for extended NEC protocol */
 	address = address1;
 	if (address1 != ~address2)
-		address |= address2 << 8;
+		address = address << 8 | address2;
 
 	scancode = address << 8 | command1;
 
-- 
1.7.3.2

