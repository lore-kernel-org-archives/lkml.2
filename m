Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493Ab1CVWFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 18:05:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932476Ab1CVWFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 18:05:33 -0400
Date: Tue, 22 Mar 2011 18:05:05 -0400
From: Don Zickus <dzickus@redhat.com>
To: Jack Steiner <steiner@sgi.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86, UV: Fix NMI handler for UV platforms
Message-ID: <20110322220505.GB13453@redhat.com>
References: <20110321160135.GA31562@sgi.com>
 <20110321161425.GC23614@elte.hu>
 <4D877C4B.9090602@gmail.com>
 <20110321175110.GL1239@redhat.com>
 <20110321182235.GA14562@sgi.com>
 <20110321193740.GN1239@redhat.com>
 <20110322171118.GA6294@sgi.com>
 <20110322184450.GU1239@redhat.com>
 <20110322212519.GA12076@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110322212519.GA12076@sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 04:25:19PM -0500, Jack Steiner wrote:
> > > AFAICT, the UV nmi handler is not consuming extra NMI interrupts. I can't
> > > rule out that I'm missing something but I don't see it.
> > 
> > What happens if you put the UV nmi handler below the hw_perf handler in
> > priority?  I assume the DIE_NMIUNKNOWN snippet in the hw_perf handler will
> > swallow some of the UV NMIs, but more importantly does it still generate
> > the hang you see?
> 
> I verified that the failures ("perf top" stops) are the same on both RHEL6.1 & the
> latest x86 2.6.38+ tree.

Thanks for testing that.

> 
> I switched priorities & as expected, "perf top" no longer hangs. I see an occassional
> missed UV NMI - about 1 every minute. I also see a few "dazed" messages as
> well - 3 in a 5 minute period. This testing was done on a 2.6.38+ kernel.
> 
> I'm running on a 48p system.
> 
> Ideas?

Wow, interesting.

The first thing is in 'uv_handle_nmi' can you change that from
DIE_NMIUNKNOWN back to DIE_NMI.  Originally I set it to DIE_NMIUNKNOWN
because I didn't think you guys had the ability to determine if your BMC
generated the NMI or not.  Recently George B. said you guys add a register
bit to determine this, so I am wondering if by promoting this would fix
the missed UV NMI.  I am speculating this is being swallowed by the
hw_perf DIE_NMIUNKNOWN exception path.

Second the "dazed" messages are being seen on other machines (currently
core2quads) when using perf with lots of NMI events.  So you might be
seeing a second more common issue there.  I still need to find time to
debug that.

Finally, I am trying to scratch my head about the 'perf top' no longer
hangs part.  The only thing I can think of is under high perf load (with
out extra NMIs by your BMC), we have seen extra NMIs get generated while
processing the current NMI (mainly because Nehalems have I think 4 or 8
PMUs that can be activate at once, so multiple NMIs can trigger here).
But we can recover from this because we check _all_ the PMIs during the
NMI (which currently always comes from the PMU).

Now this extra NMI from the PMU can also happen on a singlely activated
PMU because we reload the PMU, then check the events to see if we should
disable it.  By the time we finish checking (and determine we are not done
yet), the event could have rolled over and generated another NMI before we
have finished processing the current one.

So throw in an external NMI into the above situation (which gets dropped
as the third NMI I believe if I read the history of these NMI things
correctly), then it is possible that if uv_handle_nmi is called first it
could swallow the extra NMI as its own and leave the hw_perf hanging.
(that's a mouthful, huh?)

Then again with the priorities switched I guess the opposite is true too,
that your BMC is left missing an event.

This sort of supports the need for your patch earlier or something similar
which says ignore the handler's return code and process all the events on
the die_chain anyway.  And if noone has handled the NMI, then trigger an
unknown NMI.

Unless there is a way to determine if an NMI is latched or not before
issuing the iret and if so assumed we dropped an NMI and process everyone.

I'll need to think of a way to prove all this in the morning (or maybe
later).

I hope that makes some sense as it is late and my brain is shutting down.

Cheers,
Don
