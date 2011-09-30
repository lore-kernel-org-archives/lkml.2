Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab1I3RR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 13:17:29 -0400
Received: from smtp-out.google.com ([216.239.44.51]:1738 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab1I3RR1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 13:17:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=F57AVe8ZYli8d1cAA+NhOJOhnHrQ06mXyiFRzGN3p/UoOeKuRkXtyGQs2UvO4ld8l
	2dEJn3wFUi+6+3cTt35tg==
MIME-Version: 1.0
In-Reply-To: <CAMaF-rOBgHvZudOqrBu_LT+MQJ4sejpNHEL-JeCsP4p54ZnJeA@mail.gmail.com>
References: <4E82017C.3010304@redhat.com> <CAPoiz9w4LyTkmAACHQYR5GSJ+TmN7ePJSb-UuRQ7EjY=QYVn5Q@mail.gmail.com>
 <4E8215B6.1020108@redhat.com> <20110930001633.GA11436@myri.com>
 <CAErSpo7Vw94PfhDO8kXtNCPm+m2oXL42R51X9bCh_YvkG=k3ZA@mail.gmail.com> <CAMaF-rOBgHvZudOqrBu_LT+MQJ4sejpNHEL-JeCsP4p54ZnJeA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 30 Sep 2011 11:17:02 -0600
Message-ID: <CAErSpo4Nj_dQv=7M=2-4j8UJN8NqbiEpc2MdPNffZxbK2UmL7w@mail.gmail.com>
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

On Fri, Sep 30, 2011 at 9:35 AM, Jon Mason <mason@myri.com> wrote:
>
> On Fri, Sep 30, 2011 at 12:01 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > On Thu, Sep 29, 2011 at 6:16 PM, Jon Mason <mason@myri.com> wrote:
> >> Hey Avi,
> >> Can you try this patch?  It should resolve the issue you are seeing.
> >>
> >> Thanks,
> >> Jon
> >>
> >>    PCI: Workaround for Intel MPS errata
> >>
> >>    Intel 5000 and 5100 series memory controllers have a known issue if read
> >>    completion coalescing is enabled (the default setting) and the PCI-E
> >>    Maximum Payload Size is set to 256B.  To work around this issue, disable
> >>    read completion coalescing if the MPS is 256B.
> >
> > I'd much rather see this done as an early quirk so it doesn't clutter probe.c.
> >
> > I don't know how you decide whether
> >    - no coalescing with MPS=256, or
> >    - coalescing with MPS=128
> > is better.  I suspect that having a quirk that doesn't change the
> > setting, but merely limits MPS to 128 if the BIOS enabled coalescing,
> > would be simplest and would stay in the best-tested chipset
> > configuration.
>
> This is what I was debating yesterday.  Is it better to disable
> coalescing and get better throughput (which could be a net negative if
> the MPS isn't 256) or never allow it to be greater than 128?  There is
> no way of knowing at quirk time if the disable is necessary or not,
> only when setting the MPS is it known (which is why I did it this
> way).  I could, as you suggest, simply read the bit and see if it is
> enabled by the BIOS (which I'd bet it is every single time), and then
> limit the MPS to 128 as a quirk.  This would be fairly simple to do.
> However, the errata from Intel says Windows 2008 always disables the
> coalescing and sets the MPS to 256B.  With this known, Linux's I/O
> performance would be less than Windows on these systems. ...

Presumably coalescing improves performance, too, and I don't have the
evidence that says "no coalescing with MPS=256" performs better than
"coalescing with MPS=128."

But the fact that Windows 2008 disables coalescing is worth a lot (if
this is in a public erratum, a URL would be good).  Given that, I'd
probably go with "no coalescing and MPS=256" just as you did.

Maybe the quirk could be moved out of the generic code by making
pcie_set_mps() a weak function, so x86 could supply a version that
disables coalescing if MPS=256?

No news from Avi?  Were you able to reproduce the problem and verify
that the quirk fixes it?  I wish the kernel.org bugzilla were back.
Since it's not, maybe we should include the LKML URL
(https://lkml.org/lkml/2011/9/27/274) in the changelog.

Bjorn
