Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab0KZNj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 08:39:57 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:27504 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751328Ab0KZNj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 08:39:56 -0500
Date: Fri, 26 Nov 2010 08:39:25 -0500
Subject: Re: [PATCH] ir-nec-decoder: fix extended NEC scancodes
Message-ID: <7m5j914h31hev0dqkj085vd7.1290777731791@email.android.com>
From: Andy Walls <awalls@md.metrocast.net>
To: James Hogan <james@albanarts.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
        Jarod Wilson <jarod@redhat.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=utf-8
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-11-26_06:2010-11-26,2010-11-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=8
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1010190000 definitions=main-1011260040
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oAQDe9jL024229

You might want to check the handling against this NEC datasheet

http://www.datasheetcatalog.org/datasheet/nec/UPD6122G-002.pdf

The datasheet calls the address bytes "custom code" (high byte apparently) and "custom code'" (low byte apparently) with both bytes sent lsb first.  It appears the high byte is sent first when using 16 bit codes.

I'm away from my computer so I can't check much more.

Regards,
Andy


James Hogan <james@albanarts.com> wrote:

>Could somebody check this as I'm unable to test it.
>
>I'm also not entirely certain it isn't winbond-cir that is in error
>instead of ir-nec-decoder.
>
>Cheers
>James
>--
>After comparing the extended NEC scancode construction of the software
>decoder and winbond-cir it appears the software decoder is putting the
>two address bytes the wrong way around.
>
>Here's how the decoders currently generate scancodes:
>winbond-cir normal NEC:   msb [ 0x0,      0x0,     addr, cmd ] lsb
>soft normal NEC:          msb [ 0x0,      0x0,     addr, cmd ] lsb
>winbond-cir extended NEC: msb [ 0x0, not_addr,     addr, cmd ] lsb
>soft extended NEC:        msb [ 0x0,     addr, not_addr, cmd ] lsb
>
>The soft decider is not consistent with [1], assuming the "Address high"
>byte (not_addr) should be more significant than the "Address low" byte
>(addr) in the scancode.
>
>[1] http://www.sbprojects.com/knowledge/ir/nec.htm
>
>Signed-off-by: James Hogan <james@albanarts.com>
>---
> drivers/media/IR/ir-nec-decoder.c |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/media/IR/ir-nec-decoder.c
>b/drivers/media/IR/ir-nec-decoder.c
>index 70993f7..11d3e78 100644
>--- a/drivers/media/IR/ir-nec-decoder.c
>+++ b/drivers/media/IR/ir-nec-decoder.c
>@@ -166,8 +166,8 @@ static int ir_nec_decode(struct input_dev
>*input_dev, struct ir_raw_event ev)
>
> 		if ((address ^ not_address) != 0xff) {
> 			/* Extended NEC */
>-			scancode = address     << 16 |
>-				   not_address <<  8 |
>+			scancode = not_address << 16 |
>+				   address     <<  8 |
> 				   command;
> 			IR_dprintk(1, "NEC (Ext) scancode 0x%06x\n", scancode);
> 		} else {
>-- 
>1.7.2.3
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
