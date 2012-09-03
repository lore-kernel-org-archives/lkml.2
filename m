Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab2ICQlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 12:41:37 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59419 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab2ICQlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 12:41:35 -0400
From: Bernhard Schmidt <bschmidt@techwires.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] ipmi: fix message retry timeout
Date: Mon, 3 Sep 2012 18:42:07 +0200
User-Agent: KMail/1.13.7 (FreeBSD/9.1-RC1; KDE/4.7.4; amd64; ; )
Cc: Corey Minyard <minyard@acm.org>, stable@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201209031842.07266.bschmidt@techwires.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After ddac44b7 the condition in check_msg_timeout() which
does the actual timeout verification is always false.
Both ent->timeout and timeout_period have the value 1000.
This leads to messages erroneously being retried each time
ipmi_timeout_handler() is invoked while a response to a
previously sent message is expected, which is always the
case once a message has been sent.

Address this by only resending messages once the timeout
reaches a negative value. This ensures that at least one
period passes with the current timeout of 1000 ms.

Signed-off-by: Bernhard Schmidt <bschmidt@techwires.net>
Cc: Corey Minyard <minyard@acm.org>
Cc: stable@vger.kernel.org
---
This issue is especially noticable with double briging
over KCS because the time between a send and the response
is rather large which gives the retry timer a higher chance
to interfere. With DEBUG_MSG for ipmi_mshandler.c defined
and some printk()s added, dmesg of a doubled bridged
"ipmitool fru" command looks like the following snippet.
The resends happens everytime the retry timer kicks in
(every second), no matter how old the message is.

[ 2465.119132] ipmi_si ipmi_si.0: Found new BMC (man_id: 0x002839, prod_id: 0x5603, dev_id: 0x3c)
[ 2465.119152] ipmi_si ipmi_si.0: IPMI kcs interface initialized
[ 2465.119157] ipmi_si: Found default kcs state machine at i/o address 0xca2
[ 2465.119163] ipmi_si: Adding default-specified smic state machine
[ 2465.119173] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[ 2465.119184] ipmi_si: Interface detection failed
[ 2465.149857] ipmi_si: Adding default-specified bt state machine
[ 2465.149873] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[ 2465.149886] ipmi_si: Interface detection failed
[ 2466.522195] ipmi device interface
[ 2469.605640] Send:   18 34 07 20 18 c8 20 02 01 dd
[ 2470.012172] Recv:   1c 33 00 07 1e 6c 20 00 01 c1 1e
[ 2470.012431] Send:   18 34 07 20 18 c8 20 06 34 47 7a 18 6e ff 00 01 00 5f
[ 2470.061072] Resend: 18 34 07 20 18 c8 20 06 34 47 7a 18 6e ff 00 01 00 5f
[ 2470.071474] Recv:   1c 33 00 07 1e 6c 20 04 34 00 20 1c c4 7a 00 01 00 11 81 01 0e 51 29 39 28 00 01 54 b4 a8
[ 2470.071540] Send:   18 34 07 20 18 c8 20 0a 34 47 7a 28 5e ff 00 10 00 f1 5b
[ 2470.482704] Recv:   1c 33 00 07 1e 6c 20 04 34 00 20 1c c4 7a 00 01 00 11 81 01 0e 51 29 39 28 00 01 54 b4 a8
[ 2470.485956] Recv:   1c 33 00 07 1e 6c 20 08 34 00 20 2c b4 7a 00 10 00 f0 01 00 85 a4
[ 2470.486004] Send:   18 34 07 20 18 c8 20 0e 34 47 7a 28 5e ff 00 11 00 00 00 08 e8 57
[ 2470.898083] Recv:   1c 33 00 07 1e 6c 20 0c 34 00 20 2c b4 7a 00 11 00 08 01 00 00 01 08 15 00 e1 6d a0
[ 2470.898142] Send:   18 34 07 20 18 c8 20 12 34 47 7a 28 5e ff 00 11 00 08 00 02 e6 53
[ 2471.060094] Resend: 18 34 07 20 18 c8 20 12 34 47 7a 28 5e ff 00 11 00 08 00 02 e6 53
[ 2471.070417] Recv:   1c 33 00 07 1e 6c 20 10 34 00 20 2c b4 7a 00 11 00 02 01 07 6b 9c
[ 2471.070471] Send:   18 34 07 20 18 c8 20 16 34 47 7a 28 5e ff 00 11 00 08 00 10 d8 4f
[ 2471.480946] Recv:   1c 33 00 07 1e 6c 20 10 34 00 20 2c b4 7a 00 11 00 02 01 07 6b 9c
[ 2471.484298] Recv:   1c 33 00 07 1e 6c 20 14 34 00 20 2c b4 7a 00 11 ca 43
[ 2471.484390] Send:   18 34 07 20 18 c8 20 1a 34 47 7a 28 5e ff 00 11 00 08 00 0f d9 4b
[ 2471.892308] Recv:   1c 33 00 07 1e 6c 20 18 34 00 20 2c b4 7a 00 11 ca 3f
[ 2471.892371] Send:   18 34 07 20 18 c8 20 1e 34 47 7a 28 5e ff 00 11 00 08 00 0e da 47
[ 2472.059123] Resend: 18 34 07 20 18 c8 20 1e 34 47 7a 28 5e ff 00 11 00 08 00 0e da 47
[ 2472.069185] Recv:   1c 33 00 07 1e 6c 20 1c 34 00 20 2c b4 7a 00 11 ca 3b
[ 2472.069201] Send:   18 34 07 20 18 c8 20 22 34 47 7a 28 5e ff 00 11 00 08 00 0d db 43
[ 2472.480090] Recv:   1c 33 00 07 1e 6c 20 1c 34 00 20 2c b4 7a 00 11 ca 3b
[ 2472.483140] Recv:   1c 33 00 07 1e 6c 20 20 34 00 20 2c b4 7a 00 11 ca 37
[ 2472.483230] Send:   18 34 07 20 18 c8 20 26 34 47 7a 28 5e ff 00 11 00 08 00 0c dc 3f
[ 2472.892354] Recv:   1c 33 00 07 1e 6c 20 24 34 00 20 2c b4 7a 00 11 00 0c 01 07 19 2b 36 77 c8 41 44 56 41 4e 3e 88
[ 2472.892428] Send:   18 34 07 20 18 c8 20 2a 34 47 7a 28 5e ff 00 11 00 14 00 0c d0 3b
[ 2473.058147] Resend: 18 34 07 20 18 c8 20 2a 34 47 7a 28 5e ff 00 11 00 14 00 0c d0 3b
[...]

 drivers/char/ipmi/ipmi_msghandler.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 2c29942..75dfc7f 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -3978,7 +3978,7 @@ static void check_msg_timeout(ipmi_smi_t intf, struct seq_table *ent,
 		return;
 
 	ent->timeout -= timeout_period;
-	if (ent->timeout > 0)
+	if (ent->timeout >= 0)
 		return;
 
 	if (ent->retries_left == 0) {
-- 
1.7.9.6
