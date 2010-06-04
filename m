Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab0FDPdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 11:33:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36138 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab0FDPd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 11:33:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kEL0eNLA/fo7Olm0U2WqYJKhleiDuwjloI49A7im3GvDxohQQP3WKvIl7y/x7R8B8J
         B0Mlntxzpm/tiijKXQAxPU9k0mW1OppQuiaw7fuzRMpV+zrkHJIjiMnTEI3V8RVYJNRS
         OAMNaddYxutVsOz86ZdA1xMMDBoZ86qe+dbb0=
Subject: Re: [PATCH] mmc: make sdhci work with ricoh mmc controller
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Philip Langdale <philipl@overt.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, adq_dvb@lidskialf.net,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
In-Reply-To: <20100604080551.3dba90af@fido5>
References: <1275516180.30272.4.camel@maxim-laptop>
	 <1275527787-3783-1-git-send-email-maximlevitsky@gmail.com>
	 <20100603091113.7b1d6fc0@fido5> <1275582709.2563.19.camel@maxim-laptop>
	 <20100603093914.3397ac42@fido5> <20100603100510.37d02c2b@fido5>
	 <1275586531.2594.3.camel@maxim-laptop> <20100603214223.61325b5d@fido5>
	 <1275646048.26010.22.camel@maxim-laptop>  <20100604080551.3dba90af@fido5>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Jun 2010 18:33:22 +0300
Message-ID: <1275665602.4596.14.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-04 at 08:05 -0700, Philip Langdale wrote: 
> On Fri, 04 Jun 2010 13:07:28 +0300
> Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> 
> > > 
> > > On this subject:
> > > 
> > > 1) Would it make sense to have the hard-coded caps reflect the full
> > > set of caps you see on the sdhci side?
> > This would be ugly cause two driver instances would have to talk one
> > with another. A global variable will be necessary.
> 
> Instead of doing it at runtime, we could read them offline and then
> write them in. Of course, I suspect there's some variation in
> capabilities of Ricoh parts - I know there's at least two generations
> of MMC controllers with the same PCI IDs. :-/
Nothing against that, although the caps on main controller are broken
too, since it doesn't advertise DMA support...

> 
> > 
> > > 
> > > 2) We ought to be able to set the MMC high-speed flag for this
> > > controller; I've tried it out and it works fine. The default sdhci
> > > code will never set this flag. I think it would need to an
> > > additional quirk. Pierre argued against setting it on the basis
> > > that SD high speed has slightly different timings; I haven't seen
> > > hardware where this has been an issue.
> > > 
> > > > However that suspend/resume race is tough one.
> > > > The problem seems that controller doesn't like both devices to be
> > > > poked at same time, and normally they won't, but here on resume
> > > > both are tested for a card, and this is done asynchronously by
> > > > mmc core.
> > > > 
> > > > I will get to bottom of this sooner or later (I hope).
> > > 
> > > Hmm. So, if the issue is the test, then you should be able to
> > > serialize in mmc core instead of forcing sync resume in general. An
> > > ugly way would be a quirk that says to serialize all card tests if
> > > the controller is present in the system. In practice it would be
> > > fine as systems won't have arbitrary other sdhci controllers if
> > > they have this ricoh mmc thing. But yes, it isn't clean. :-P
> > This seems to be worse that I thought.
> > The problem is that mmc controller tells that card is removed on
> > resume (after a while it reappears)
> > 
> > This brings a question though, are MMC and SD cards electrically
> > different?
> > If not them its interesting how the controller distinguishes between
> > them.
> 
> They are not. I suspect the controller pokes the card using SPI mode
> just enough to tell them apart.
>  
> > 
> > This isn't a show stopper though, cause the cards are
> > removed/reinserted anyway unless CONFIG_MMC_UNSAFE_RESUME is set.
> > The fact that this triggers system hang is another story, and sooner
> > or later will be fixed ether by some hack in mmc code or by making
> > del_gendisk not hang when userspace is frozen.
> > 
> > 
> > It not due to interleaving, because I tried binding sdhci-pci to only
> > mmc interface, and yet same problem happens.
> > 
> > Magically, if async suspend is disabled everything works, and it well
> > tested. and that despite me disabling async suspend on all 4
> > functions. (And I know that this works, and makes pm core suspend
> > them in order from 0 to 4 and synchronously.
> > I tried adding large delays to simulate delays caused by waiting for
> > other devices, but it didn't help.
> > 
> > I''l get to bottom of this.
> 
> I'm not familiar with what pm core allows but can you tell it to
> serialise the functions but still handle the device asynchronously?
> That would still allow the maximum possible asynchrony.
I did that, and I am quite confident that its timing that makes the
difference.
(Or, and this is the worst thing to happen, there is an unrelated device
that must be enabled before mmc....)

Since controller like I suspected from the beginning pokes at the card,
it might be tricky to keep mmc card alive after suspend.
I leave this problem as is for now, and in future when I finish exams, I
am going to understand exactly what is going on.

Still, despite that feel I have just opened a can of worms, still I
think that its better to stick to the way things are done in windows
because hackish or not, things were tested by vendor well enough.

And just to think that all the trouble is literally due to
Microsoft..... grrrrrr.

Best regards,
Maxim Levitsky

