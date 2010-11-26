Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab0KZVMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 16:12:25 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37189 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab0KZVMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 16:12:21 -0500
Date: Fri, 26 Nov 2010 21:12:13 +0000
From: James Hogan <james@albanarts.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
        Jarod Wilson <jarod@redhat.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] ir-nec-decoder: fix extended NEC scancodes
Message-ID: <20101126211213.GA21473@gandalf>
References: <7m5j914h31hev0dqkj085vd7.1290777731791@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7m5j914h31hev0dqkj085vd7.1290777731791@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(expanded cc list)

On Fri, Nov 26, 2010 at 08:39:25AM -0500, Andy Walls wrote:
> You might want to check the handling against this NEC datasheet
> 
> http://www.datasheetcatalog.org/datasheet/nec/UPD6122G-002.pdf
> 
> The datasheet calls the address bytes "custom code" (high byte apparently) and "custom code'" (low byte apparently) with both bytes sent lsb first.  It appears the high byte is sent first when using 16 bit codes.

Thanks for the link Andy. You appear to be correct, which suggests that
winbond-cir is the "wrong" one. Curiously there is a comment in
winbond-cir.c which explicitly mentions which byte is which:

854 * With NEC extended, Address1 is the LSB of the Address and
855 * Address2 is the MSB, Command parsing remains unchanged.

but then it also says:

25 *  To do:
26 *    o Test NEC and RC5

I suppose its all a matter of convention, but I think they should at
least be consistent, so I'll go by the NEC datasheet and submit a patch
to winbond-cir instead.

Cheers
James

> James Hogan <james@albanarts.com> wrote:
> 
> >Could somebody check this as I'm unable to test it.
> >
> >I'm also not entirely certain it isn't winbond-cir that is in error
> >instead of ir-nec-decoder.
> >
> >Cheers
> >James
> >--
> >After comparing the extended NEC scancode construction of the software
> >decoder and winbond-cir it appears the software decoder is putting the
> >two address bytes the wrong way around.
> >
> >Here's how the decoders currently generate scancodes:
> >winbond-cir normal NEC:   msb [ 0x0,      0x0,     addr, cmd ] lsb
> >soft normal NEC:          msb [ 0x0,      0x0,     addr, cmd ] lsb
> >winbond-cir extended NEC: msb [ 0x0, not_addr,     addr, cmd ] lsb
> >soft extended NEC:        msb [ 0x0,     addr, not_addr, cmd ] lsb
> >
> >The soft decider is not consistent with [1], assuming the "Address high"
> >byte (not_addr) should be more significant than the "Address low" byte
> >(addr) in the scancode.
> >
> >[1] http://www.sbprojects.com/knowledge/ir/nec.htm
> >
> >Signed-off-by: James Hogan <james@albanarts.com>
> >---
> > drivers/media/IR/ir-nec-decoder.c |    4 ++--
> > 1 files changed, 2 insertions(+), 2 deletions(-)
> >
> >diff --git a/drivers/media/IR/ir-nec-decoder.c
> >b/drivers/media/IR/ir-nec-decoder.c
> >index 70993f7..11d3e78 100644
> >--- a/drivers/media/IR/ir-nec-decoder.c
> >+++ b/drivers/media/IR/ir-nec-decoder.c
> >@@ -166,8 +166,8 @@ static int ir_nec_decode(struct input_dev
> >*input_dev, struct ir_raw_event ev)
> >
> > 		if ((address ^ not_address) != 0xff) {
> > 			/* Extended NEC */
> >-			scancode = address     << 16 |
> >-				   not_address <<  8 |
> >+			scancode = not_address << 16 |
> >+				   address     <<  8 |
> > 				   command;
> > 			IR_dprintk(1, "NEC (Ext) scancode 0x%06x\n", scancode);
> > 		} else {
