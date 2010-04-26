Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab0DZXZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 19:25:19 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:59676 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752746Ab0DZXZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 19:25:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=d/h4P+zbp/QGoaHy6GhWqPeFze82n3UvcTpUK+PsQ8bt/TGGSNEF0Qn9gKZqr2Dnb/GhQcYKxplDJk8Lj2Nt5jyUNeOc3su8OkjSDU4VIb9HuqQ6feH0xeR3y+DtTrqG;
Date: Mon, 26 Apr 2010 16:25:17 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Andy Isaacson <adi@hexapodia.org>,
       "R. Andrew Bailey" <bailey@akamai.com>, Yinghai <yinghai.lu@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>, yaneti@declera.com
Subject: Re: [PATCH] x86/PCI: never allocate PCI MMIO resources below  
 BIOS_END
Message-ID: <20100426162517.4ad308ff@virtuousgeek.org>
In-Reply-To: <2b1eecc3-75b8-4ab3-8932-fdf7cc1e181b@email.android.com>
References: <2b1eecc3-75b8-4ab3-8932-fdf7cc1e181b@email.android.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, sounds like we're talking about a few different things here:
  1) devices which sit in e820 reserved space (whether at < 1M or > 1M)
  2) devices which sit in e820 ram or other space below 1M
  3) how to hand out space from the 0-1M region

Bjorn's patch fixes (3) so that regular PCI devices don't get space
there, which makes sense.

Some devices may be in the special region, but were pointed there by
the BIOS.  Generally this should be ok, so drivers requesting this
space should be allowed to get at it, but we should avoid putting
anything else there.

And below it sounds like you're talking about (1).  If so, then yes I
guess we need a solution there, which will allow drivers to bind to
these "reserved" devices, even though the BIOS has marked them as off
limits, at least as far as e820 goes.

So perhaps both (1) and (2) could be put into a new, special IO
resource space, or could use a new flag, since "busy" doesn't really
reflect what's going on there very well, as Bjorn pointed out.

Jesse

On Mon, 26 Apr 2010 16:02:57 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> I don't think it's sufficient, actually.  We regularly see machines where devices point into e820_reserved memory above 1 MB - because it's a platform device or because firmware (e.g. smm) is touching the device.  I think Bjorn's fix is great for .34, but longer term I think we need to structure the code to actually handle reserved regions differently from occupied/forbidden regions.
> 
> "Jesse Barnes" <jbarnes@virtuousgeek.org> wrote:
> 
> >On Mon, 26 Apr 2010 14:44:50 -0700
> >"H. Peter Anvin" <hpa@zytor.com> wrote:
> >
> >> >
> >> > Agreed.  The trickier part is handling any platform devices that
> >> > request_resource against that space.  But maybe we don't need to do
> >> > anything special; just making sure we avoid it in the PCI "BIOS" code
> >> > as Bjorn did may be sufficient.
> >> >
> >> 
> >> Why is that hard?  If a platform device does a request_resource against
> >> that space, it's a request for specific address space and it should be
> >> granted.
> >
> >I was thinking if we made it a special resource type we'd have to
> >change any platform drivers to use it; i.e. it wouldn't be
> >IORESOURCE_MEM or IORESOURCE_IO but IORESOURCE_DRAGONS.  That way it
> >wouldn't be part of the normal resource space.
> >
> >But that's definitely overkill.  I think Bjorn's fix is sufficient.
> >
> >-- 
> >Jesse Barnes, Intel Open Source Technology Center
> 


-- 
Jesse Barnes, Intel Open Source Technology Center
