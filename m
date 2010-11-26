Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab0KZNMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 08:12:48 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:47697 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab0KZNMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 08:12:46 -0500
MIME-Version: 1.0
X-Originating-IP: [87.194.181.195]
Date: Fri, 26 Nov 2010 13:12:45 +0000
Message-ID: <AANLkTimWnKVCUKAYz9YZB27ObbCfKSgv9Bz5yofa2w-V@mail.gmail.com>
Subject: [PATCH] ir-nec-decoder: fix extended NEC scancodes
From: James Hogan <james@albanarts.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
        Jarod Wilson <jarod@redhat.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could somebody check this as I'm unable to test it.

I'm also not entirely certain it isn't winbond-cir that is in error
instead of ir-nec-decoder.

Cheers
James
--
After comparing the extended NEC scancode construction of the software
decoder and winbond-cir it appears the software decoder is putting the
two address bytes the wrong way around.

Here's how the decoders currently generate scancodes:
winbond-cir normal NEC:   msb [ 0x0,      0x0,     addr, cmd ] lsb
soft normal NEC:          msb [ 0x0,      0x0,     addr, cmd ] lsb
winbond-cir extended NEC: msb [ 0x0, not_addr,     addr, cmd ] lsb
soft extended NEC:        msb [ 0x0,     addr, not_addr, cmd ] lsb

The soft decider is not consistent with [1], assuming the "Address high"
byte (not_addr) should be more significant than the "Address low" byte
(addr) in the scancode.

[1] http://www.sbprojects.com/knowledge/ir/nec.htm

Signed-off-by: James Hogan <james@albanarts.com>
---
 drivers/media/IR/ir-nec-decoder.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/IR/ir-nec-decoder.c
b/drivers/media/IR/ir-nec-decoder.c
index 70993f7..11d3e78 100644
--- a/drivers/media/IR/ir-nec-decoder.c
+++ b/drivers/media/IR/ir-nec-decoder.c
@@ -166,8 +166,8 @@ static int ir_nec_decode(struct input_dev
*input_dev, struct ir_raw_event ev)

 		if ((address ^ not_address) != 0xff) {
 			/* Extended NEC */
-			scancode = address     << 16 |
-				   not_address <<  8 |
+			scancode = not_address << 16 |
+				   address     <<  8 |
 				   command;
 			IR_dprintk(1, "NEC (Ext) scancode 0x%06x\n", scancode);
 		} else {
-- 
1.7.2.3
