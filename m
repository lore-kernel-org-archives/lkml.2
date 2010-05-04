Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760058Ab0EDRHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 13:07:18 -0400
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:44406 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759962Ab0EDRHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 13:07:16 -0400
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.41
X-Originating-IP: 82.8.179.104
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
From: Bastien Nocera <hadess@hadess.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Vojtech Pavlik <vojtech@suse.cz>,
       Robert Hancock <hancockrwd@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, pjones@redhat.com
In-Reply-To: <20100125221520.GA30307@core.coreip.homeip.net>
References: <1264011793.1735.3683.camel@localhost.localdomain>
	 <4B57A2D4.9030204@gmail.com>
	 <20100121185544.GB11996@core.coreip.homeip.net>
	 <51f3faa71001211339t4652700ct34659c37479cd67e@mail.gmail.com>
	 <20100121221701.GA15293@core.coreip.homeip.net>
	 <20100125163433.GB31957@suse.cz> <4B5E0DFA.8080705@zytor.com>
	 <20100125221520.GA30307@core.coreip.homeip.net>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 04 May 2010 18:06:41 +0100
Message-ID: <1272992801.13354.214.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.0.1 (2.30.0-3.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-25 at 14:15 -0800, Dmitry Torokhov wrote:
> On Mon, Jan 25, 2010 at 01:32:42PM -0800, H. Peter Anvin wrote:
> > On 01/25/2010 08:34 AM, Vojtech Pavlik wrote:
> > > 
> > > Thus I believe that the right fix here is to figure out why the accesses
> > > to the ports 0x60/0x64 take a long time or forever on a Mac. Is it just
> > > that the kernel is timing out waiting for the i8042? Or is it something
> > > more sinister?
> > > 
> > 
> > In the A20 code in the setup code, I look for 0xFF coming back and
> > terminate the "wait for ready" loop much sooner than for other values.
> > 0xFF is a *possible* status value, but not a very *likely* one
> > (especially for repeated reads), as it would represent:
> > 
> > parity error + receive timeout + transmit timeout + keyboard lock +
> > command + selftest OK + input full + output full.
> > 
> 
> You allow up to 32 0xFFs while i8042 driver does maximum 16 reads of
> whatever - if OBF is still raised we assume i8042 is not there. Does
> that mean that reads from 0x60 is what hurts on Macs?
> 
> Bastien, could you try modifying drivers/input/serio/i8042.c::
> i8042_flush() to not call i8042_read_data() when str is 0xff and see if
> it helps with lockups?

Doesn't seem to make any difference. It still hangs after saying:
PNP: No PS/2 controller found. Probing ports directly.

The patch looks like:
         udelay(50);
+        if (str == 0xff)
+             continue;
         data = i8042_read_data();

Not sure that's what you meant above.

Pressing the power button doesn't make it carry on for me, as it used
to. Let me know if there's anything more you want me to try.

In the meantime, I'll try to get my original patch into my distribution
so I don't get bitten by half-booted kernels in the near future.

Cheers

