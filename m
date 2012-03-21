Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031207Ab2CUOZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 10:25:17 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:7532
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757745Ab2CUOZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 10:25:15 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zzbb2dI1432N98dKzz1202hzz8275bh8275dh5eeeKz2dh668h839h93fhd2bh)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M18O1S-02-5LD-02
X-M-MSG: 
From: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
To: Attilio Rao <attilio.rao@citrix.com>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH RFC V6 1/11]  x86/spinlock: replace pv spinlocks with pv ticketlocks
Date: Wed, 21 Mar 2012 15:25:04 +0100
Message-ID: <1363312.nixp29LUbv@chlor>
Organization: AMD OSRC
User-Agent: KMail/4.8.0 (Linux/3.0.0-17-generic; KDE/4.8.1; x86_64; ; )
In-Reply-To: <4F69DC68.6080200@citrix.com>
References: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com> <2425963.NBpIGX9T40@chlor> <4F69DC68.6080200@citrix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 March 2012, 13:49:28 Attilio Rao wrote:
> On 21/03/12 13:22, Stephan Diestelhorst wrote:
> > On Wednesday 21 March 2012, 13:04:25 Attilio Rao wrote:
> >    
> >> On 21/03/12 10:20, Raghavendra K T wrote:
> >>      
> >>> From: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>
> >>>
> >>> Rather than outright replacing the entire spinlock implementation in
> >>> order to paravirtualize it, keep the ticket lock implementation but add
> >>> a couple of pvops hooks on the slow patch (long spin on lock, unlocking
> >>> a contended lock).
> >>>
> >>> Ticket locks have a number of nice properties, but they also have some
> >>> surprising behaviours in virtual environments.  They enforce a strict
> >>> FIFO ordering on cpus trying to take a lock; however, if the hypervisor
> >>> scheduler does not schedule the cpus in the correct order, the system can
> >>> waste a huge amount of time spinning until the next cpu can take the lock.
> >>>
> >>> (See Thomas Friebel's talk "Prevent Guests from Spinning Around"
> >>> http://www.xen.org/files/xensummitboston08/LHP.pdf  for more details.)
> >>>
> >>> To address this, we add two hooks:
> >>>    - __ticket_spin_lock which is called after the cpu has been
> >>>      spinning on the lock for a significant number of iterations but has
> >>>      failed to take the lock (presumably because the cpu holding the lock
> >>>      has been descheduled).  The lock_spinning pvop is expected to block
> >>>      the cpu until it has been kicked by the current lock holder.
> >>>    - __ticket_spin_unlock, which on releasing a contended lock
> >>>      (there are more cpus with tail tickets), it looks to see if the next
> >>>      cpu is blocked and wakes it if so.
> >>>
> >>> When compiled with CONFIG_PARAVIRT_SPINLOCKS disabled, a set of stub
> >>> functions causes all the extra code to go away.
> >>>
> >>>        
> >> I've made some real world benchmarks based on this serie of patches
> >> applied on top of a vanilla Linux-3.3-rc6 (commit
> >> 4704fe65e55fb088fbcb1dc0b15ff7cc8bff3685), with both
> >> CONFIG_PARAVIRT_SPINLOCK=y and n, which means essentially 4 versions
> >> compared:
> >> * vanilla - CONFIG_PARAVIRT_SPINLOCK - patch
> >> * vanilla + CONFIG_PARAVIRT_SPINLOCK - patch
> >> * vanilla - CONFIG_PARAVIRT_SPINLOCK + patch
> >> * vanilla + CONFIG_PARAVIRT_SPINLOCK + patch
> >>
> >>      
> > [...]
> >    
> >> == Results
> >> This test points in the direction that Jeremy's rebased patches don't
> >> introduce a peformance penalty at all, but also that we could likely
> >> consider CONFIG_PARAVIRT_SPINLOCK option removal, or turn it on by
> >> default and suggest disabling just on very old CPUs (assuming a
> >> performance regression can be proven there).
> >>      
> > Very interesting results, in particular knowing that in the one guest
> > case things do not get (significantly) slower due to the added logic
> > and LOCKed RMW in the unlock path.
> >
> > AFAICR, the problem really became apparent when running multiple guests
> > time sharing the physical CPUs, i.e., two guests with eight vCPUs each
> > on an eight core machine.  Did you look at this setup with your tests?
> >
> >    
> 
> Please note that my tests are made on native Linux, without XEN involvement.
> 
> You maybe meant that the spinlock paravirtualization became generally 
> useful in the case you mentioned? (2 guests, 8vpcu + 8vcpu)?

Yes, that is what I meant.  Just to clarify why you do not see any
speed-ups, and were wondering why.  If the whole point of the exercise
was to see that there are no perforamnce regressions, fine.  In that
case I misunderstood.

Stephan
-- 
Stephan Diestelhorst, AMD Operating System Research Center
stephan.diestelhorst@amd.com
Tel. +49 (0)351 448 356 719

Advanced Micro Devices GmbH
Einsteinring 24
85609 Aschheim
Germany

Geschaeftsfuehrer: Alberto Bozzo
Sitz: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632, WEEE-Reg-Nr: DE 12919551


