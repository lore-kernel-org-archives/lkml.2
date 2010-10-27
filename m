Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933588Ab0J0Alo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 20:41:44 -0400
Received: from kanga.kvack.org ([205.233.56.17]:50459 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933391Ab0J0Aln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 20:41:43 -0400
X-Greylist: delayed 1613 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Oct 2010 20:41:43 EDT
Date: Tue, 26 Oct 2010 20:14:48 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] add atkbd.terminal parameter for IBM Terminal keyboards
Message-ID: <20101027001448.GC18653@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many of the IBM Terminal keyboards from the 1980s and early 1990s communicate 
using a protocol similar, but not identical to the AT keyboard protocol. 
(Models known to be like this include 6110344, 6110668, 1390876, 1386887, and 
possibly others.)

When the connector is rewired or adapter to an AT-DIN or PS/2 connector, they 
can be connected to a standard PC, with three caveats:

a) They can only use scancode set 3; requests to use anything else are 
quietly ignored.
b) The AT Command to request Make, Break and Repeat codes is not properly 
interpreted.
c) The top function keys on a 122 key keyboard, and the arrow/edit keys in 
the middle of the board send non-standard scancodes.

C) is easily taken care of in userspace, by use of setkeycodes
B) can be taken care of by a userspace hack (that makes the kernel complain 
in dmesg)
A) is fixable in theory, but on the keyboard i tested on (6110668), it seems 
to be detected unoverridably as Set 2, causing userspace oddities that make 
it harder to fix C).

Enclosed is a small patch to the kernel that fixes A) and B) in the kernel, 
making it much easier to fix C) in userspace. It adds a single kernel 
command line parameter that overrides the detection that sets these boards 
as set 2, and instead of sending the Make-break-repeat command to the 
keyboard, it sends the make-break command, which is properly recognized by 
these keyboards. Software level key repeating seems to make up for the lack 
of hardware repeat codes perfectly.

Without manually setting the command line parameter (tentatively named 
atkbd.terminal), this code has no effect, and the driver works exactly as 
before.

See also:

http://www.seasip.info/VintagePC/ibm_1390876.html
http://www.seasip.info/VintagePC/ibm_6110344.html
http://geekhack.org/showwiki.php?title=Island:7306

Signed-off-by: Erika Quinn <erikas.aubade@gmail.com>
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index d358ef8..024fe8b 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -63,6 +63,10 @@ static bool atkbd_extra;
 module_param_named(extra, atkbd_extra, bool, 0);
 MODULE_PARM_DESC(extra, "Enable extra LEDs and keys on IBM RapidAcces, EzKey and similar keyboards");
 
+static int atkbd_terminal;
+module_param_named(terminal, atkbd_terminal, bool, 0);
+MODULE_PARM_DESC(terminal, "Enable break codes on an IBM Terminal keyboard connected via AT/PS2");
+
 /*
  * Scancode to keycode tables. These are just the default setting, and
  * are loadable via a userland utility.
@@ -137,6 +141,7 @@ static const unsigned short atkbd_unxlate_table[128] = {
 #define ATKBD_CMD_RESET_DIS	0x00f5	/* Reset to defaults and disable */
 #define ATKBD_CMD_RESET_DEF	0x00f6	/* Reset to defaults */
 #define ATKBD_CMD_SETALL_MBR	0x00fa
+#define ATKBD_CMD_SETALL_MB	0x00f8
 #define ATKBD_CMD_RESET_BAT	0x02ff
 #define ATKBD_CMD_RESEND	0x00fe
 #define ATKBD_CMD_EX_ENABLE	0x10ea
@@ -764,6 +769,11 @@ static int atkbd_select_set(struct atkbd *atkbd, int target_set, int allow_extra
 		}
 	}
 
+	if (atkbd_terminal) {
+		ps2_command(ps2dev, param, ATKBD_CMD_SETALL_MB);
+		return 3;
+	}		
+
 	if (target_set != 3)
 		return 2;
 
