Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077Ab0EDRXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 13:23:15 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60704 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463Ab0EDRXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 13:23:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YXVwP9Gh3jrGPhEAgFgqWa9T9lifa/xP4l/J4uilBPsdTitE1wFYvcxGFrfbH33/H1
         ZdpBHq2MIB7dqaV6EUrMwZE/Se48sgzPRyoYujo0tOjV4mI9Zl1r7xCYcOVxRJnMBf4Y
         kNX7KyAucYGtfMgp8TzhZ0avjrBstqJs0NSjg=
Date: Tue, 4 May 2010 10:23:02 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bastien Nocera <hadess@hadess.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Vojtech Pavlik <vojtech@suse.cz>,
       Robert Hancock <hancockrwd@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, pjones@redhat.com
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
Message-ID: <20100504172302.GA29428@core.coreip.homeip.net>
References: <1264011793.1735.3683.camel@localhost.localdomain>
 <4B57A2D4.9030204@gmail.com>
 <20100121185544.GB11996@core.coreip.homeip.net>
 <51f3faa71001211339t4652700ct34659c37479cd67e@mail.gmail.com>
 <20100121221701.GA15293@core.coreip.homeip.net>
 <20100125163433.GB31957@suse.cz>
 <4B5E0DFA.8080705@zytor.com>
 <20100125221520.GA30307@core.coreip.homeip.net>
 <1272992801.13354.214.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272992801.13354.214.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 06:06:41PM +0100, Bastien Nocera wrote:
> On Mon, 2010-01-25 at 14:15 -0800, Dmitry Torokhov wrote:
> > On Mon, Jan 25, 2010 at 01:32:42PM -0800, H. Peter Anvin wrote:
> > > On 01/25/2010 08:34 AM, Vojtech Pavlik wrote:
> > > > 
> > > > Thus I believe that the right fix here is to figure out why the accesses
> > > > to the ports 0x60/0x64 take a long time or forever on a Mac. Is it just
> > > > that the kernel is timing out waiting for the i8042? Or is it something
> > > > more sinister?
> > > > 
> > > 
> > > In the A20 code in the setup code, I look for 0xFF coming back and
> > > terminate the "wait for ready" loop much sooner than for other values.
> > > 0xFF is a *possible* status value, but not a very *likely* one
> > > (especially for repeated reads), as it would represent:
> > > 
> > > parity error + receive timeout + transmit timeout + keyboard lock +
> > > command + selftest OK + input full + output full.
> > > 
> > 
> > You allow up to 32 0xFFs while i8042 driver does maximum 16 reads of
> > whatever - if OBF is still raised we assume i8042 is not there. Does
> > that mean that reads from 0x60 is what hurts on Macs?
> > 
> > Bastien, could you try modifying drivers/input/serio/i8042.c::
> > i8042_flush() to not call i8042_read_data() when str is 0xff and see if
> > it helps with lockups?
> 
> Doesn't seem to make any difference. It still hangs after saying:
> PNP: No PS/2 controller found. Probing ports directly.
> 
> The patch looks like:
>          udelay(50);
> +        if (str == 0xff)
> +             continue;
>          data = i8042_read_data();
> 
> Not sure that's what you meant above.
> 
> Pressing the power button doesn't make it carry on for me, as it used
> to. Let me know if there's anything more you want me to try.
> 

> In the meantime, I'll try to get my original patch into my distribution
> so I don't get bitten by half-booted kernels in the near future.
> 

Mind resending the original patch? Apparently current situation causes
issues and I guess DMI is not the wost way of taking care of it.

-- 
Dmitry
