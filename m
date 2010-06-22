Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab0FVSpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 14:45:10 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39210 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab0FVSpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 14:45:08 -0400
Date: Tue, 22 Jun 2010 19:44:26 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       David Quan <David.Quan@atheros.com>, Bob Copeland <me@bobcopeland.com>,
       "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
       ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jonathan May <jonathan.may@atheros.com>,
       Tim Gardner <tim.gardner@canonical.com>
Subject: Re: [ath5k-devel] [PATCH v2] ath5k: disable ASPM
Message-ID: <20100622184426.GA24546@srcf.ucam.org>
References: <20100621233333.21262abjfxl8j1xc@hayate.sektori.org> <AANLkTikkt4dqYWrwtTCJ8tJZLB1kZXgF1KvaPsIOO3Dl@mail.gmail.com> <20100622163138.GD20668@srcf.ucam.org> <AANLkTikQkLFdpusfcLVOpyZHFrxwB5akr-ggFB7Fjm08@mail.gmail.com> <20100622165213.GA21842@srcf.ucam.org> <AANLkTikHLBBWrhCP_1f5Jv7zE9RKPvdsl5nSyfkeMfLl@mail.gmail.com> <20100622172545.GA22680@srcf.ucam.org> <AANLkTilEHJ5qRD8ov0gIK0Zc4o-gJUPYkvHdyD1uZUon@mail.gmail.com> <20100622175058.GA23499@srcf.ucam.org> <AANLkTinE0BiOa5cpcIerbias7K-aDzj3x4qaeDpzy2CQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinE0BiOa5cpcIerbias7K-aDzj3x4qaeDpzy2CQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 11:28:20AM -0700, Luis R. Rodriguez wrote:
> On Tue, Jun 22, 2010 at 10:50 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > People who use "force" deserve whatever they get,
> 
> Heh, this whole patch and thread was started because Jussi tested
> ath5k with  pcie_aspm=force (on a pre PCIE 1.1 device (?)) . I have
> been trying to explain all along why this is a terrible idea to the
> point we should probably just remove that code from the kernel. Hence
> my side rants and explanations to justify my reasonings.

Well, there's two things here. If you use force then you might get 
inappropriate ASPM. But if your BIOS enables ASPM on an old device, then 
booting *without* CONFIG_PCIE_ASPM will leave it turned on, and booting 
*with* CONFIG_PCIE_ASPM will turn it off. The Kconfig description is 
confusing - reality is that CONFIG_PCIE_ASPM enables logic that allows 
the kernel to modify the BIOS default, and disabling it makes the 
assumption that your BIOS did something sensible.

> Where is "powersave"?
> 
> I do see a "powersave" but its an ASPM policy string and it implies
> you want to enable L1 and L0s when the device's LinkCap supports it,
> see pcie_config_aspm_link() and its users. So in other words powersave
> seems to imply you are using pcie_aspm=force, no?

No. pcie_aspm=force will enable ASPM even if (a) the device is pre-1.1, 
(b) the firmware has the FADT flag set to tell you not to and (c) the 
firmware doesn't grant control via _OSC. The powersave policy will 
enable ASPM even if the BIOS didn't, but only if something else doesn't 
tell us not to.

> > Fedora's defaulted to that for a while now - we've hit
> > issues with aacraid, but that's pretty much it in terms of cases where
> > the heuristics don't work. Maxim's problems wouldn't be triggered
> > because CONFIG_PCIE_ASPM disables it on pre-1.1 devices regardless of
> > the BIOS setup.
> 
> I don't expect all distributions to have CONFIG_PCIE_ASPM enabled, in
> fact I was unaware of this sanity check being included as part of
> CONFIG_PCIE_ASPM, I recommend we consider just enabling the sanity
> check all the time. The fact that CONFIG_PCIE_ASPM is even an option
> seems confusing to me given that apart from this sanity check the only
> other thing that I see useful in it is the forcing of ASPM settings
> and as I noted I think pcie_aspm=force is pretty dangerous.

You're right, it shouldn't be an option. It's vital for making sure that 
ASPM is disabled when it should be. I'd be happy with pcie_aspm=force 
tainting the kernel.

> > With the patch I've just sent, they should also all be used for Linux as
> > well.
> 
> Oh nice! It'll be part of 2.6.36?

As long as Jesse picks it up.

> > If the same problems would appear under Windows then it's not a problem
> > that I'm hugely concerned about as yet
> 
> Yes, these issues would also be part of Windows. But should also note
> this also means for those people working on their own BIOSes it means
> you also have to take these things into more serious consideration.

There's a standardised mechanism for BIOS authors to tell us not to 
touch their ASPM configuration, and people that ignore that really do 
deserve to have things break.

> Me neither, ASPM should just work with default settings, which is why
> I also do not like that the sanity check on the PCIE 1.1 spec is done
> through CONFIG_PCIE_ASPM, it makes no sense given that ASPM *will*
> work even if you do not have CONFIG_PCIE_ASPM but the device has
> functional ASPM.

I agree. I'll send a patch that moves it under CONFIG_EMBEDDED and 
defaults to on.

> I do think we should be depending on userspace to do development
> testing and forcing ASPM on, because the only other alternative is
> pcie_aspm=force and as noted this is just not a good idea unless you
> *seriously* know what you are doing.

If you set the powersave policy and ASPM doesn't get enabled, then 
that's because we've got a really strong belief that ASPM shouldn't be 
enabled. Is your concern just that pcie_aspm=force is too easy for users 
to get at?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
