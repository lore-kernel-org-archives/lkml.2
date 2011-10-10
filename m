Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab1JJODI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 10:03:08 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:20991
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754159Ab1JJODG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 10:03:06 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zzbb2dK9371Kc85fh1432Nc857h98dKzz1202hzzz32i668h839ha3cs34h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,0,0,0,0,0,0,
X-WSS-ID: 0LSUSBL-01-54G-02
X-M-MSG: 
From: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
To: <xen-devel@lists.xensource.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        "Andi@domain.invalid" <Andi@domain.invalid>,
        Nick Piggin <npiggin@kernel.dk>, KVM <kvm@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Kleen <andi@firstfloor.org>,
        Avi Kivity <avi@redhat.com>, Jan Beulich <JBeulich@suse.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the@domain.invalid" <the@domain.invalid>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [Xen-devel] [PATCH 00/10] [PATCH RFC V2] Paravirtualized ticketlocks
Date: Mon, 10 Oct 2011 16:01:50 +0200
Message-ID: <2222671.j13duhYQpt@d-allen>
Organization: AMD OSRC
User-Agent: KMail/4.7.1 (Linux/3.0.4-030004-generic; KDE/4.7.1; x86_64; ; )
In-Reply-To: <2523929.AGG4U997NO@d-allen>
References: <cover.1315878463.git.jeremy.fitzhardinge@citrix.com> <4E8DE7F1.3050108@goop.org> <2523929.AGG4U997NO@d-allen>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1396890.6bZkbSRBX5"
Content-Transfer-Encoding: 7Bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1396890.6bZkbSRBX5
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Monday 10 October 2011, 07:00:50 Stephan Diestelhorst wrote:
> On Thursday 06 October 2011, 13:40:01 Jeremy Fitzhardinge wrote:
> > On 10/06/2011 07:04 AM, Stephan Diestelhorst wrote:
> > > On Wednesday 28 September 2011, 14:49:56 Linus Torvalds wrote:
> > >> Which certainly should *work*, but from a conceptual standpoint, isn't
> > >> it just *much* nicer to say "we actually know *exactly* what the upper
> > >> bits were".
> > > Well, we really do NOT want atomicity here. What we really rather want
> > > is sequentiality: free the lock, make the update visible, and THEN
> > > check if someone has gone sleeping on it.
> > >
> > > Atomicity only conveniently enforces that the three do not happen in a
> > > different order (with the store becoming visible after the checking
> > > load).
> > >
> > > This does not have to be atomic, since spurious wakeups are not a
> > > problem, in particular not with the FIFO-ness of ticket locks.
> > >
> > > For that the fence, additional atomic etc. would be IMHO much cleaner
> > > than the crazy overflow logic.
> > 
> > All things being equal I'd prefer lock-xadd just because its easier to
> > analyze the concurrency for, crazy overflow tests or no.  But if
> > add+mfence turned out to be a performance win, then that would obviously
> > tip the scales.
> > 
> > However, it looks like locked xadd is also has better performance:  on
> > my Sandybridge laptop (2 cores, 4 threads), the add+mfence is 20% slower
> > than locked xadd, so that pretty much settles it unless you think
> > there'd be a dramatic difference on an AMD system.
> 
> Indeed, the fences are usually slower than locked RMWs, in particular,
> if you do not need to add an instruction. I originally missed that
> amazing stunt the GCC pulled off with replacing the branch with carry
> flag magic. It seems that two twisted minds have found each other
> here :)
> 
> One of my concerns was adding a branch in here... so that is settled,
> and if everybody else feels like this is easier to reason about...
> go ahead :) (I'll keep my itch to myself then.)

Just that I can't... if performance is a concern, adding the LOCK
prefix to the addb outperforms the xadd significantly:

With mean over 100 runs... this comes out as follows
(on my Phenom II)

locked-add   0.648500 s   80%
add-rmwtos   0.707700 s   88%
locked-xadd  0.807600 s  100%
add-barrier  1.270000 s  157%

With huge read contention added in (as cheaply as possible):
locked-add.openmp  0.640700 s  84%
add-rmwtos.openmp  0.658400 s  86%
locked-xadd.openmp 0.763800 s 100%

And the numbers for write contention are crazy, but also feature the
locked-add version:
locked-add.openmp  0.571400 s  71%
add-rmwtos.openmp  0.699900 s  87%
locked-xadd.openmp 0.800200 s 100%

Stephan
-- 
Stephan Diestelhorst, AMD Operating System Research Center
stephan.diestelhorst@amd.com, Tel. +49 (0)351 448 356 719

Advanced Micro Devices GmbH
Einsteinring 24
85609 Aschheim
Germany

Geschaeftsfuehrer: Alberto Bozzo;
Sitz: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632, WEEE-Reg-Nr: DE 12919551 
--nextPart1396890.6bZkbSRBX5
Content-Disposition: attachment; filename="add-rmwtos.c"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-csrc; charset="UTF-8"; name="add-rmwtos.c"
Content-Description: add-rmwtos.c

#include <stdio.h>

struct {
	unsigned char flag;
	unsigned char val;
} l;

int main(int argc, char **argv)
{
	int i;

	{
		{
			for (i = 0; i < 100000000; i++) {
				l.val += 2;
				asm volatile("lock or $0x0,(%%rsp)" : : : "memory");
				if (l.flag)
					break;
				asm volatile("" : : : "memory");
			}
			l.flag = 1;
		}
	}
	return 0;
}

--nextPart1396890.6bZkbSRBX5
Content-Disposition: attachment; filename="add-rmwtos.openmp.c"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-csrc; charset="UTF-8"; name="add-rmwtos.openmp.c"
Content-Description: add-rmwtos.openmp.c

#include <stdio.h>

struct {
	unsigned char flag;
	unsigned char val;
} l;

int main(int argc, char **argv)
{
	int i;

#   pragma omp sections 
	{
#       pragma omp section
		{
			for (i = 0; i < 100000000; i++) {
				l.val += 2;
				asm volatile("lock or $0x0,(%%rsp)" : : : "memory");
				if (l.flag)
					break;
				asm volatile("" : : : "memory");
			}
			l.flag = 1;
		}
#       pragma omp section
		while(!l.flag)
			asm volatile("":::"memory");
			//asm volatile("lock orb $0x0, %0"::"m"(l.flag):"memory");
	}
	return 0;
}

--nextPart1396890.6bZkbSRBX5
Content-Disposition: attachment; filename="locked-add.c"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-csrc; charset="UTF-8"; name="locked-add.c"
Content-Description: locked-add.c

#include <stdio.h>

struct {
	unsigned char flag;
	unsigned char val;
} l;

int main(int argc, char **argv)
{
	int i;
	{
		{
			for (i = 0; i < 100000000; i++) {
				asm volatile("lock addb %1, %0":"+m"(l.val):"r"((char)2):"memory");
				if (l.flag)
					break;
				asm volatile("" : : : "memory");
			}
			l.flag = 1;
		}
	}
	return 0;
}

--nextPart1396890.6bZkbSRBX5
Content-Disposition: attachment; filename="locked-xadd.openmp.c"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-csrc; charset="UTF-8"; name="locked-xadd.openmp.c"
Content-Description: locked-xadd.openmp.c

#include <stdio.h>

union {
	struct {
		unsigned char val;
		unsigned char flag;
	};
	unsigned short lock;
} l = { 0,0 };

int main(int argc, char **argv)
{
	int i;
#   pragma omp sections 
	{
#       pragma omp section
	    {

			for (i = 0; i < 100000000; i++) {
				unsigned short inc = 2;
				if (l.val >= (0x100 - 2))
					inc += -1 << 8;
				asm volatile("lock; xadd %1,%0" : "+m" (l.lock), "+r" (inc) : );
				if (inc & 0x100)
					break;
				asm volatile("" : : : "memory");
			}
			l.flag = 1;
		}
#       pragma omp section
	    while(!l.flag)
		    asm volatile("":::"memory");
			//asm volatile("lock orb $0x0, %0"::"m"(l.flag):"memory");
	}
	return 0;
}

--nextPart1396890.6bZkbSRBX5
Content-Disposition: attachment; filename="locked-add.openmp.c"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-csrc; charset="UTF-8"; name="locked-add.openmp.c"
Content-Description: locked-add.openmp.c

#include <stdio.h>

struct {
	unsigned char flag;
	unsigned char val;
} l;

int main(int argc, char **argv)
{
	int i;
#   pragma omp sections 
	{
#       pragma omp section
		{
			for (i = 0; i < 100000000; i++) {
				asm volatile("lock addb %1, %0":"+m"(l.val):"r"((char)2):"memory");
				if (l.flag)
					break;
				asm volatile("" : : : "memory");
			}
			l.flag = 1;
		}
#       pragma omp section
		while(!l.flag)
			asm volatile("":::"memory");
			//asm volatile("lock orb $0x0, %0"::"m"(l.flag):"memory");
	}
	return 0;
}

--nextPart1396890.6bZkbSRBX5
Content-Disposition: attachment; filename="locked-xadd.c"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-csrc; charset="UTF-8"; name="locked-xadd.c"
Content-Description: locked-xadd.c

#include <stdio.h>

union {
	struct {
		unsigned char val;
		unsigned char flag;
	};
	unsigned short lock;
} l = { 0,0 };

int main(int argc, char **argv)
{
	int i;
	{
	    {

			for (i = 0; i < 100000000; i++) {
				unsigned short inc = 2;
				if (l.val >= (0x100 - 2))
					inc += -1 << 8;
				asm volatile("lock; xadd %1,%0" : "+m" (l.lock), "+r" (inc) : );
				if (inc & 0x100)
					break;
				asm volatile("" : : : "memory");
			}
			l.flag = 1;
		}
	}
	return 0;
}

--nextPart1396890.6bZkbSRBX5--
