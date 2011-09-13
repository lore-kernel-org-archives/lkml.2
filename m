Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299Ab1IMSlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 14:41:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932101Ab1IMSlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 14:41:22 -0400
Date: Tue, 13 Sep 2011 14:40:44 -0400
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
Message-ID: <20110913184044.GN5795@redhat.com>
References: <20110906151408.GA7459@redhat.com>
 <4E66615E.8070806@goop.org>
 <20110906182758.GR5795@redhat.com>
 <4E66EF86.9070200@redhat.com>
 <20110907134411.GV5795@redhat.com>
 <4E678992.5050709@redhat.com>
 <20110907155657.GX5795@redhat.com>
 <4E679AF4.50209@redhat.com>
 <20110907165203.GQ6838@redhat.com>
 <4E67A551.4000502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E67A551.4000502@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 08:09:37PM +0300, Avi Kivity wrote:
> >But then the downside
> >here is we accidentally handle an NMI that was latched.  This would cause
> >a 'Dazed on confused' message as that NMI was already handled by the
> >previous NMI.
> >
> >We are working on an algorithm to detect this condition and flag it
> >(nothing complicated).  But it may never be perfect.
> >
> >On the other hand, what else are we going to do with an edge-triggered
> >shared interrupt line?
> >
> 
> How about, during NMI, save %rip to a per-cpu variable.  Handle just
> one cause.  If, on the next NMI, we hit the same %rip, assume
> back-to-back NMI has occured and now handle all causes.

So I got around to implementing this and it seems to work great.  The back
to back NMIs are detected properly using the %rip and that info is passed to
the NMI notifier.  That info is used to determine if only the first
handler to report 'handled' is executed or _all_ the handlers are
executed.

I think all the 'unknown' NMIs I generated with various perf runs have
disappeared.  I'll post a new version of my nmi notifier rewrite soon.

Thanks for the great suggestion Avi!

Cheers,
Don
