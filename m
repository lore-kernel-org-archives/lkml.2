Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab1IGQxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:53:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab1IGQxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:53:49 -0400
Date: Wed, 7 Sep 2011 12:52:03 -0400
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
Message-ID: <20110907165203.GQ6838@redhat.com>
References: <1314996468.8255.0.camel@twins>
 <4E614FBD.2030509@goop.org>
 <20110906151408.GA7459@redhat.com>
 <4E66615E.8070806@goop.org>
 <20110906182758.GR5795@redhat.com>
 <4E66EF86.9070200@redhat.com>
 <20110907134411.GV5795@redhat.com>
 <4E678992.5050709@redhat.com>
 <20110907155657.GX5795@redhat.com>
 <4E679AF4.50209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E679AF4.50209@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 07:25:24PM +0300, Avi Kivity wrote:
> On 09/07/2011 06:56 PM, Don Zickus wrote:
> >>
> >>  And hope that no other NMI was generated while we're handling this
> >>  one.  It's a little... fragile?
> >
> >No.  If another NMI is generated while we are processing the current one
> >it should get latched.  Upon completion of the current one, the cpu should
> >jump right back into the nmi exception routine again.  The only downside
> >is when multiple NMIs come in during the processing of the current one.
> >Only one can be latched, so the others get dropped.
> 
> Ah, yes, I remember now.
> 
> >But we are addressing
> >that.
> >
> 
> May I ask how?  Detecting a back-to-back NMI?

Pretty boring actually.  Currently we execute an NMI handler until one of
them returns handled.  Then we stop.  This may cause us to miss an NMI in
the case of multiple NMIs at once.  Now we are changing it to execute
_all_ the handlers to make sure we didn't miss one.  But then the downside
here is we accidentally handle an NMI that was latched.  This would cause
a 'Dazed on confused' message as that NMI was already handled by the
previous NMI.

We are working on an algorithm to detect this condition and flag it
(nothing complicated).  But it may never be perfect.

On the other hand, what else are we going to do with an edge-triggered
shared interrupt line?

Cheers,
Don
