Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab1GSIqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 04:46:01 -0400
Received: from gate.crashing.org ([63.228.1.57]:57685 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab1GSIqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 04:46:00 -0400
Subject: RE: [RFC/PATCH] mm/futex: Fix futex writes on archs with SW
 trackingof dirty & young
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Shan Hai <haishan.bai@gmail.com>, tony.luck@intel.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        cmetcalf@tilera.com, dhowells@redhat.com, paulus@samba.org,
        tglx@linutronix.de, walken@google.com, linuxppc-dev@lists.ozlabs.org,
        akpm@linux-foundation.org
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6D8ADFF@saturn3.aculab.com>
References: <AE90C24D6B3A694183C094C60CF0A2F6D8ADFF@saturn3.aculab.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jul 2011 18:45:22 +1000
Message-ID: <1311065122.25044.412.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-19 at 09:26 +0100, David Laight wrote:
> > Got it, if the fault_in_user_writeable() is designed to catch the
> > exact same write permission fault problem we discuss here, so
> > your patch fixed that very nicely, we should fixup it by directly
> > calling handle_mm_fault like what you did because we are for sure
> > to know what just happened(permission violation), its not necessary
> > to check what's happened by calling gup-->follow_page, and
> > further the follow_page failed to report the fault :-)
> 
> One thought I've had - and I don't know enough about the data
> area in use to know if it is a problem - is what happens if
> a different cpu faults on the same user page and has already
> marked it 'valid' between the fault happening and the fault
> handler looking at the page tables to find out why.
> If any of the memory areas are shared, it might be that the
> PTE (etc) might already show the page a writable by the
> time the fault handler is looking at them - this might confuse it!

The same way handle_mm_fault() deals with two CPUs faulting on the same
page at the same time :-)

All the necessary locking is in there, handle_mm_fault() and friends
will walk the page tables, take the PTE lock, will notice it's already
been all fixed up (well that it doesn't need to do a page fault at
least), will then call ptep_set_access_flags() which will itself notice
there's nothing to do ... etc

So all you'll hit is the spurious fault TLB invalidate in the write
case, which is necessary on some archs (well, we think it is tho I don't
know which archs really :-)

Cheers,
Ben.

