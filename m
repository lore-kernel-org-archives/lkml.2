Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab1IGQdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:33:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867Ab1IGQde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:33:34 -0400
Date: Wed, 7 Sep 2011 11:56:57 -0400
From: Don Zickus <dzickus@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
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
Message-ID: <20110907155657.GX5795@redhat.com>
References: <1314974826.1861.1.camel@twins>
 <4E612EA1.20007@goop.org>
 <1314996468.8255.0.camel@twins>
 <4E614FBD.2030509@goop.org>
 <20110906151408.GA7459@redhat.com>
 <4E66615E.8070806@goop.org>
 <20110906182758.GR5795@redhat.com>
 <4E66EF86.9070200@redhat.com>
 <20110907134411.GV5795@redhat.com>
 <4E678992.5050709@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E678992.5050709@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 06:11:14PM +0300, Avi Kivity wrote:
> On 09/07/2011 04:44 PM, Don Zickus wrote:
> >>
> >>  Is there a way to tell whether an NMI was internally or externally
> >>  generated?
> >>
> >>  I don't think so, especially as two or more NMIs can be coalesced.
> >>  So any NMI received on this first cpu has to check the NMI reason
> >>  port?
> >
> >Well we cheat and execute all the nmi handlers first.  If they come back
> >as handled, we skip the check for the external NMI.
> 
> And hope that no other NMI was generated while we're handling this
> one.  It's a little... fragile?

No.  If another NMI is generated while we are processing the current one
it should get latched.  Upon completion of the current one, the cpu should
jump right back into the nmi exception routine again.  The only downside
is when multiple NMIs come in during the processing of the current one.
Only one can be latched, so the others get dropped.  But we are addressing
that.

Cheers,
Don

> 
> >But you are right, other than checking the reason port, there isn't a way
> >to determine if an NMI is internally or externally generated.
> 
> Ouch.
> 
> >
> >>
> >>  >>
> >>  >>   But on the other hand, I don't really care if you can say that this path
> >>  >>   will never be called in a virtual machine.
> >>  >
> >>  >Does virtual machines support hot remove of cpus?  Probably not
> >>  >considering bare-metal barely supports it.
> >>  >
> >>
> >>  They do.
> >
> >But vcpus probably don't have the notion of a bsp cpu, so perhaps virtual
> >machines can get away with it easier?  (I don't know enough about the hot
> >cpu remove code to really explain it, just enough to know it can cause
> >problems and people are trying to address it).
> >
> 
> The concept of a bsp exists in exactly the same way as on real hardware.
> 
> -- 
> error compiling committee.c: too many arguments to function
> 
