Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab1IGUsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 16:48:05 -0400
Received: from peace.netnation.com ([204.174.223.2]:51593 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab1IGUsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 16:48:04 -0400
Date: Wed, 7 Sep 2011 13:47:54 -0700
From: Simon Kirby <sim@hostway.ca>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Jon Mason <mason@myri.com>
Cc: Josh Boyer <jwboyer@gmail.com>, Sven Schnelle <svens@stackframe.org>,
        linux-kernel@vger.kernel.org, Jordan_Hargrave@dell.com
Subject: Re: [3.1-rc4] Bus Fatal Error caused by "PCI: Set PCI-E Max
	Payload Size on fabric"
Message-ID: <20110907204754.GA21603@hostway.ca>
References: <20110906173605.GA12577@hostway.ca> <87aaag9vb8.fsf@begreifnix.stackframe.org> <CA+5PVA5aEAgdKexWK_cg2zRJk5CFsg6rhp9Wx+80GjR7iaLkOA@mail.gmail.com> <20110907104432.2f9d8b0a@jbarnes-x220> <20110907191859.GB14950@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110907191859.GB14950@hostway.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 12:18:59PM -0700, Simon Kirby wrote:

> On Wed, Sep 07, 2011 at 10:44:32AM -0700, Jesse Barnes wrote:
> 
> > On Wed, 7 Sep 2011 12:52:25 -0400
> > Josh Boyer <jwboyer@gmail.com> wrote:
> > 
> > > On Wed, Sep 7, 2011 at 12:22 PM, Sven Schnelle <svens@stackframe.org>
> > > wrote:
> > > > Simon Kirby <sim@hostway.ca> writes:
> > > >
> > > >> Hello!
> > > >>
> > > >> Since trying 3.1-rc4 on a few Dell servers, all of them have
> > > >> booted up with the amber error LED lit. "ipmitool sel list" shows:
> > > >>
> > > >> ?? ??1 | 09/06/2011 | 17:21:56 | Event Logging Disabled #0x72 | Log
> > > >> area reset/cleared | Asserted 2 | 09/06/2011 | 17:25:38 | Critical
> > > >> Interrupt #0x18 | Bus Fatal Error | Asserted 3 | 09/06/2011 |
> > > >> 17:25:38 | Unknown #0x1a | 4 | 09/06/2011 | 17:25:38 | Unknown
> > > >> #0x1a |
> > > >
> > > > I'm seeing exact the same issue on a Dell 1950 Server. If anyone
> > > > wants me to try additional debugging/patches, feel free to do
> > > > so. Unfortunately i don't have the time/knowledge to debug that by
> > > > myself.
> > > 
> > > I thought Jesse or Jon had a revert or partial fix queued up to send
> > > to Linus, but I don't see anything in or post -rc5 yet.  That was
> > > indicated in https://bugzilla.kernel.org/show_bug.cgi?id=42162
> > > 
> > > Jesse, Jon?
> > 
> > kernel.org is still down and I haven't pushed anything to github.  I
> > asked Jon to send his patch directly to Linus today instead.
> 
> FWIW, this patch didn't seem to fix it:
> https://bugzilla.kernel.org/attachment.cgi?id=71222
> 
> dmesg used to say:
> 
> pci 0000:00:02.0: Dev MPS 128 MPSS 256 MRRS 128
> pci 0000:00:02.0: Dev MPS 256 MPSS 256 MRRS 128
> pci 0000:06:00.0: Dev MPS 128 MPSS 256 MRRS 4096
> pci 0000:06:00.0: Dev MPS 256 MPSS 256 MRRS 128
> pci 0000:07:00.0: Dev MPS 128 MPSS 256 MRRS 4096
> pci 0000:07:00.0: Dev MPS 256 MPSS 256 MRRS 128
> pci 0000:08:00.0: Dev MPS 128 MPSS 128 MRRS 128
> pci 0000:08:00.0: MPS configured higher than maximum supported by the device.  If a bus issue occurs, try running with pci=pcie_bus_safe.
> pci 0000:08:00.0: Dev MPS 256 MPSS 256 MRRS 128
> Uhhuh. NMI received for unknown reason 21 on CPU 0.
> Do you have a strange power saving mode enabled?
> Dazed and confused, but trying to continue

Ok, I commented out the "pcie_write_mps(dev, mps);" line and the error
stopped, but this made me realize that the pci=pcie_bus_safe option must
have been missing. It turns out I had hacked a custom grub entry to load
the newest kernel into grub instead of the one with the highest version
number (grumble), so the default kopt didn't apply there.

So, pci=pcie_bus_safe DOES fix this case, and I've confirmed that the
MRRS-dissabling patch makes no difference in this case.

Can we just make pci=pcie_bus_safe (as in previous behavior) the default,
or make it not change where it would otherwise warn, or does that
basically make the thing useless?

Simon-
