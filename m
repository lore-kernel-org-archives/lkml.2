Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab1AUQy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 11:54:29 -0500
Received: from mail.openrapids.net ([64.15.138.104]:43827 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754486Ab1AUQy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 11:54:28 -0500
Date: Fri, 21 Jan 2011 11:54:25 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Tejun Heo <tj@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Christoph Lameter <cl@linux.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for
	this_cpu_cmpxchg_double
Message-ID: <20110121165425.GB11687@Krystal>
References: <20110106204525.222395863@linux.com> <4D263C91.30709@zytor.com> <alpine.DEB.2.00.1101070907060.3014@router.home> <20110107180419.GB23082@Krystal> <alpine.DEB.2.00.1101071227450.3014@router.home> <20110108172453.GF13269@mtj.dyndns.org> <4D393636.4040607@cs.helsinki.fi> <20110121092649.GA2832@htj.dyndns.org> <4D39A6EB.70705@zytor.com> <20110121154831.GE2832@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110121154831.GE2832@htj.dyndns.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:26:59 up 58 days, 21:30,  4 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tejun Heo (tj@kernel.org) wrote:
> Hello, Peter.
> 
> On Fri, Jan 21, 2011 at 07:31:55AM -0800, H. Peter Anvin wrote:
> > I really object to passing two pointers where one of them has to be a
> > fixed offset to the other.  That really doesn't make any sense.
> 
> Yeah, I hear you, but it really comes down to which ugliness disgusts
> one the most.  That, unfortunately, is inherently very subjective when
> there's no significantly better choice.
> 
> For me, the double parameter thing at least seems to have the
> advantages of being able to verify the two intended memory locations
> to be used actually are together and looking ugly reflecting its true
> nature.
> 
> The inherent ugliness stems from the fact that we don't have the
> built-in data type to properly deal with this.  Array of length two
> might be better fit, but I can see as many downsides with that too.
> 
> So, if anyone can give something clearly better for technical reasons,
> I'll be more than happy to take it, but as it currently stands, it
> seems we'll have to choose one among uglies and not everyone would be
> happy about the choice.  :-(

Quoting Christoph, from the previous exchange:

"The single large 128 bit scalar does not work. Having to define an
additional structure it also a bit clumsy. I think its best to get another
patchset out that also duplicates the first parameter and makes the percpu
variable specs conform to the other this_cpu ops."

I'm again probably missing something, but what is "clumsy" about defining a
structure like the following to ensure proper alignment of the target
pointer (instead of adding a runtime test) ?

struct cmpxchg_double {
#if __BYTE_ORDER == __LITTLE_ENDIAN
        unsigned long low, high;
#else
        unsigned long high, low;
#endif
} __attribute__((packed, aligned(2 * sizeof(unsigned long))));

(note: packed here along with "aligned" does _not_ generate ugly bytewise
read/write memory ops like "packed" alone. The use of "packed" is to let the
compiler down-align the structure to the value requested, instead of uselessly
aligning it on 32-byte if it chooses to.)

The prototype could then look like:

bool __this_cpu_generic_cmpxchg_double(pcp, oval_low, oval_high, nval_low, nval_high);

With:
  struct cmpxchg_double *pcp

I think Christoph's point is that he wants to alias this with a pointer. Well,
this can be done cleanly with:

union {
        struct cmpxchg_double casdbl;
        struct {
                void *ptr;
                unsigned long cpuid_tid;
        } t;
}

So by keeping distinct variables for the oval/nal arguments, we let the compiler
use registers (instead of the mandatory stack use that would be required if we
pass union or structures as oval/nval arguments), but we ensure proper alignment
(and drop the unneeded second pointer, as well as the runtime pointer alignment
checks) by passing one single pcp pointer of a fixed type with a known
alignment.

Thoughts ?

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
