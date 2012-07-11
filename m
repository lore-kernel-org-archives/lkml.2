Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139Ab2GKMmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 08:42:00 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:42447 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab2GKMl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 08:41:58 -0400
Date: Wed, 11 Jul 2012 08:41:39 -0400 (EDT)
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Rik van Riel <riel@redhat.com>, S390 <linux-s390@vger.kernel.org>,
        Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH RFC 1/2] kvm vcpu: Note down pause loop exit
Message-ID: <d0f10496-d51c-4ba6-8f78-8021f3cf5a15@zmail17.collab.prod.int.phx2.redhat.com>
In-Reply-To: <4FFD69DF.1070107@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.36.7.202]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> >
> > Hm, suppose we're the next-in-line for a ticket lock and exit due
> > to
> > PLE.  The lock holder completes and unlocks, which really assigns
> > the
> > lock to us.  So now we are the lock owner, yet we are marked as
> > don't
> > yield-to-us in the PLE code.
> 
> Yes.. off-topic but that is solved by kicked flag in PV spinlocks.
> 

Yeah, this is a different, but related, topic. pvticketlocks not
only help yield spinning vcpus, but also allow the use of ticketlocks
for the guaranteed fairness. If we want that fairness we'll always
need some pv-ness, even if it's a mostly PLE solution. I see that as
a reasonable reason to take the pvticketlock series, assuming it
performs at least as well as PLE. The following options have all been
brought up at some point by various people, and all have their own
pluses and minuses;

PLE-only best-effort:
   + hardware-only, algorithm improvements can be made independent of
     guest OSes
   - has limited info about spinning vcpus, making it hard to improve
     the algorithm (improved with an auto-adjusting ple_window?)
   - perf enhancement/degradation is workload/ple_window dependant
   - impossible? to guarantee FIFO order

pvticketlocks:
   - have to maintain pv code, both hosts and guests
   + perf is only workload dependant (should disable ple to avoid
     interference?)
   + guarantees FIFO order
   + can fall-back on PLE-only if the guest doesn't support it

hybrid:
   + takes advantage of the hw support
   - still requires host and guest pv code
   - will likely make perf dependant on ple_window again
   + guarantees FIFO order

???: did I miss any?

I think more benchmarking of PLE vs. pvticketlocks is needed, which
I'm working on. If we see that it performs just as well or better,
then IMHO, we should consider committing Raghu's latest version of
the pvticketlock series, perhaps with and additional patch that
auto-disables PLE when pvticketlocks are enabled.

Drew
