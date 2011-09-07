Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774Ab1IGEP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 00:15:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938Ab1IGEPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 00:15:52 -0400
Message-ID: <4E66EF86.9070200@redhat.com>
Date: Wed, 07 Sep 2011 07:13:58 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Marcelo Tosatti <mtosatti@redhat.com>,
        KVM <kvm@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH 08/13] xen/pvticketlock: disable interrupts while blocking
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com> <38bb37e15f6e5056d5238adac945bc1837a996ec.1314922370.git.jeremy.fitzhardinge@citrix.com> <1314974826.1861.1.camel@twins> <4E612EA1.20007@goop.org> <1314996468.8255.0.camel@twins> <4E614FBD.2030509@goop.org> <20110906151408.GA7459@redhat.com> <4E66615E.8070806@goop.org> <20110906182758.GR5795@redhat.com>
In-Reply-To: <20110906182758.GR5795@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2011 09:27 PM, Don Zickus wrote:
> On Tue, Sep 06, 2011 at 11:07:26AM -0700, Jeremy Fitzhardinge wrote:
> >  >>  But, erm, does that even make sense?  I'm assuming the NMI reason port
> >  >>  tells the CPU why it got an NMI.  If multiple CPUs can get NMIs and
> >  >>  there's only a single reason port, then doesn't that mean that either 1)
> >  >>  they all got the NMI for the same reason, or 2) having a single port is
> >  >>  inherently racy?  How does the locking actually work there?
> >  >  The reason port is for an external/system NMI.  All the IPI-NMI don't need
> >  >  to access this register to process their handlers, ie perf.  I think in
> >  >  general the IOAPIC is configured to deliver the external NMI to one cpu,
> >  >  usually the bsp cpu.  However, there has been a slow movement to free the
> >  >  bsp cpu from exceptions like this to allow one to eventually hot-swap the
> >  >  bsp cpu.  The spin locks in that code were an attempt to be more abstract
> >  >  about who really gets the external NMI.  Of course SGI's box is setup to
> >  >  deliver an external NMI to all cpus to dump the stack when the system
> >  >  isn't behaving.
> >  >
> >  >  This is a very low usage NMI (in fact almost all cases lead to loud
> >  >  console messages).
> >  >
> >  >  Hope that clears up some of the confusion.
> >
> >  Hm, not really.
> >
> >  What does it mean if two CPUs go down that path?  Should one do some NMI
> >  processing while the other waits around for it to finish, and then do
> >  some NMI processing on its own?
>
> Well the time the second one gets to the external NMI it should have been
> cleared by the first cpu, which would of course lead to the second cpu
> causing a 'Dazed and confused' message.  But on most x86 machines only one
> cpu should be routed the external NMI.  Though there is an SGI box that is
> designed to send an external NMI to all of its cpus.

Is there a way to tell whether an NMI was internally or externally 
generated?

I don't think so, especially as two or more NMIs can be coalesced.  So 
any NMI received on this first cpu has to check the NMI reason port?

> >
> >  But on the other hand, I don't really care if you can say that this path
> >  will never be called in a virtual machine.
>
> Does virtual machines support hot remove of cpus?  Probably not
> considering bare-metal barely supports it.
>

They do.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

