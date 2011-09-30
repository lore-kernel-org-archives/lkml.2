Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab1I3R6I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 13:58:08 -0400
Received: from smtp-out.google.com ([216.239.44.51]:20886 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab1I3R6F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 13:58:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=PIbiPZvtQ9IO8F1xXkHylxLqVsvpVGE5EUCJ6aUQ/Cnw8Asaf29xcfitWtOS//b/c
	zH8R/xT+M5b42KwSuheZQ==
MIME-Version: 1.0
In-Reply-To: <CAMaF-rPBM8nJpJ14jSyc4ki=sy2q-uxrJU_7=KGvvUrDp3EUBA@mail.gmail.com>
References: <4E82017C.3010304@redhat.com> <CAPoiz9w4LyTkmAACHQYR5GSJ+TmN7ePJSb-UuRQ7EjY=QYVn5Q@mail.gmail.com>
 <4E8215B6.1020108@redhat.com> <20110930001633.GA11436@myri.com>
 <CAErSpo7Vw94PfhDO8kXtNCPm+m2oXL42R51X9bCh_YvkG=k3ZA@mail.gmail.com>
 <CAMaF-rOBgHvZudOqrBu_LT+MQJ4sejpNHEL-JeCsP4p54ZnJeA@mail.gmail.com>
 <CAErSpo4Nj_dQv=7M=2-4j8UJN8NqbiEpc2MdPNffZxbK2UmL7w@mail.gmail.com> <CAMaF-rPBM8nJpJ14jSyc4ki=sy2q-uxrJU_7=KGvvUrDp3EUBA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 30 Sep 2011 11:57:37 -0600
Message-ID: <CAErSpo5=LOxrcSZZy2+9rTNcgJvzTXMoYBDPHNvz+e+j9P5xkg@mail.gmail.com>
Subject: Re: Workaround for Intel MPS errata
To: Jon Mason <mason@myri.com>
Cc: Avi Kivity <avi@redhat.com>, Sven Schnelle <svens@stackframe.org>,
        Simon Kirby <sim@hostway.ca>, Eric Dumazet <eric.dumazet@gmail.com>,
        Niels Ole Salscheider <niels_ole@salscheider-online.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Ben Hutchings <bhutchings@solarflare.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 11:38 AM, Jon Mason <mason@myri.com> wrote:
>
> On Fri, Sep 30, 2011 at 12:17 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > On Fri, Sep 30, 2011 at 9:35 AM, Jon Mason <mason@myri.com> wrote:
> >>
> >> On Fri, Sep 30, 2011 at 12:01 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> >> > On Thu, Sep 29, 2011 at 6:16 PM, Jon Mason <mason@myri.com> wrote:
> >> >> Hey Avi,
> >> >> Can you try this patch?  It should resolve the issue you are seeing.
> >> >>
> >> >> Thanks,
> >> >> Jon
> >> >>
> >> >>    PCI: Workaround for Intel MPS errata
> >> >>
> >> >>    Intel 5000 and 5100 series memory controllers have a known issue if read
> >> >>    completion coalescing is enabled (the default setting) and the PCI-E
> >> >>    Maximum Payload Size is set to 256B.  To work around this issue, disable
> >> >>    read completion coalescing if the MPS is 256B.
> >> >
> >> > I'd much rather see this done as an early quirk so it doesn't clutter probe.c.
> >> >
> >> > I don't know how you decide whether
> >> >    - no coalescing with MPS=256, or
> >> >    - coalescing with MPS=128
> >> > is better.  I suspect that having a quirk that doesn't change the
> >> > setting, but merely limits MPS to 128 if the BIOS enabled coalescing,
> >> > would be simplest and would stay in the best-tested chipset
> >> > configuration.
> >>
> >> This is what I was debating yesterday.  Is it better to disable
> >> coalescing and get better throughput (which could be a net negative if
> >> the MPS isn't 256) or never allow it to be greater than 128?  There is
> >> no way of knowing at quirk time if the disable is necessary or not,
> >> only when setting the MPS is it known (which is why I did it this
> >> way).  I could, as you suggest, simply read the bit and see if it is
> >> enabled by the BIOS (which I'd bet it is every single time), and then
> >> limit the MPS to 128 as a quirk.  This would be fairly simple to do.
> >> However, the errata from Intel says Windows 2008 always disables the
> >> coalescing and sets the MPS to 256B.  With this known, Linux's I/O
> >> performance would be less than Windows on these systems. ...
> >
> > Presumably coalescing improves performance, too, and I don't have the
> > evidence that says "no coalescing with MPS=256" performs better than
> > "coalescing with MPS=128."
> >
> > But the fact that Windows 2008 disables coalescing is worth a lot (if
> > this is in a public erratum, a URL would be good).  Given that, I'd
>
> The URLs were in the top of the patch, but perhaps they weren't obvious. ...
> Search for "MPS", as they are several pages into the errata chapter.

I saw the errata, but searching for "Windows" failed.  But now I see
the "Microsoft Server 2008" reference in the 5100 errata.  The wording
is interesting, though...  it says:

    Microsoft Server 2008* forces the maximum payload size to 256 B in the
    PEXDEVCTRL register; therefore, the workaround with coalescing disabled
    must be used for Microsoft Server 2008*.

I would read that as saying "Windows Server 2008 always sets MPS to
256 but doesn't do anything with the coalescing setting.  Therefore,
if you want to run Server 2008 on your system, make sure the BIOS
leaves coalescing disabled."

> > Maybe the quirk could be moved out of the generic code by making
> > pcie_set_mps() a weak function, so x86 could supply a version that
> > disables coalescing if MPS=256?
>
> Not sure what you mean here.  Are you saying to make the function
> defined differently on each arch?

You can define the generic pcie_set_mps() with the __weak attribute in
drivers/pci/probe.c.  Then if you put a normal (non-weak)
pcie_set_mps() definition in the arch code, it will be used instead of
the weak definition.  If the arch doesn't supply a definition, the
generic weak version will be used.

Bjorn
