Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965217Ab1JFRkI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:40:08 -0400
Received: from claw.goop.org ([74.207.240.146]:33724 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965182Ab1JFRkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:40:06 -0400
Message-ID: <4E8DE7F1.3050108@goop.org>
Date: Thu, 06 Oct 2011 10:40:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jan Beulich <JBeulich@suse.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        the arch/x86 maintainers <x86@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 00/10] [PATCH RFC V2] Paravirtualized ticketlocks
References: <cover.1315878463.git.jeremy.fitzhardinge@citrix.com> <201109282008.17722.stephan.diestelhorst@amd.com> <CA+55aFwm7ESNfrHhEHrAKcjcPUq8YxtuEkJd5PzAekYo2dMYNw@mail.gmail.com> <2707952.s3VYcmPHUN@chlor>
In-Reply-To: <2707952.s3VYcmPHUN@chlor>
X-Enigmail-Version: 1.3.2
Content-Type: multipart/mixed;
 boundary="------------090103080803000506040300"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090103080803000506040300
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/06/2011 07:04 AM, Stephan Diestelhorst wrote:
> On Wednesday 28 September 2011, 14:49:56 Linus Torvalds wrote:
>> Which certainly should *work*, but from a conceptual standpoint, isn't
>> it just *much* nicer to say "we actually know *exactly* what the upper
>> bits were".
> Well, we really do NOT want atomicity here. What we really rather want
> is sequentiality: free the lock, make the update visible, and THEN
> check if someone has gone sleeping on it.
>
> Atomicity only conveniently enforces that the three do not happen in a
> different order (with the store becoming visible after the checking
> load).
>
> This does not have to be atomic, since spurious wakeups are not a
> problem, in particular not with the FIFO-ness of ticket locks.
>
> For that the fence, additional atomic etc. would be IMHO much cleaner
> than the crazy overflow logic.

All things being equal I'd prefer lock-xadd just because its easier to
analyze the concurrency for, crazy overflow tests or no.  But if
add+mfence turned out to be a performance win, then that would obviously
tip the scales.

However, it looks like locked xadd is also has better performance:  on
my Sandybridge laptop (2 cores, 4 threads), the add+mfence is 20% slower
than locked xadd, so that pretty much settles it unless you think
there'd be a dramatic difference on an AMD system.

(On Nehalem it was much less dramatic 2% difference, but still in favour
of locked xadd.)

This is with dumb-as-rocks run it in a loop with "time" benchmark, but
the results are not very subtle.

    J

--------------090103080803000506040300
Content-Type: text/x-csrc;
 name="add-barrier.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="add-barrier.c"

#include <stdio.h>

struct {
	unsigned char flag;
	unsigned char val;
} l;

int main(int argc, char **argv)
{
	int i;

	for (i = 0; i < 100000000; i++) {
		l.val += 2;
		asm volatile("mfence" : : : "memory");
		if (l.flag)
			break;
		asm volatile("" : : : "memory");
	}

	return 0;
}

--------------090103080803000506040300
Content-Type: text/x-csrc;
 name="locked-xadd.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="locked-xadd.c"

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

	for (i = 0; i < 100000000; i++) {
		unsigned short inc = 2;
		if (l.val >= (0x100 - 2))
			inc += -1 << 8;
		asm volatile("lock; xadd %1,%0" : "+m" (l.lock), "+r" (inc) : );
		if (inc & 0x100)
			break;
		asm volatile("" : : : "memory");
	}

	return 0;
}

--------------090103080803000506040300--
