Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab1BNRSP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 12:18:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44117 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab1BNRSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 12:18:14 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=4UV-9Kl2S54A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=zqWJBTdVaBfQQ7vYynMA:9 a=dCF-daiNY84QoE8z0rDIrI9N0mkA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
In-Reply-To: <1297702013.23343.51.camel@gandalf.stny.rr.com>
References: <cover.1294239591.git.jbaron@redhat.com>
	 <1297452328.5226.89.camel@laptop>
	 <BLU0-SMTP101B686C32E10BA346B15F896EF0@phx.gbl>
	 <1297460297.5226.99.camel@laptop> <1297536465.5226.108.camel@laptop>
	 <20110214155113.GA2840@redhat.com> <1297699024.2401.12.camel@twins>
	 <20110214160437.GB2840@redhat.com>
	 <BLU0-SMTP4069A1A89F06CDFF9B28F896D00@phx.gbl>
	 <1297700754.5226.110.camel@laptop>  <20110214162947.GA3449@redhat.com>
	 <1297701438.5226.113.camel@laptop>
	 <1297702013.23343.51.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 14 Feb 2011 12:18:12 -0500
Message-ID: <1297703892.23343.71.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-14 at 11:46 -0500, Steven Rostedt wrote:
> On Mon, 2011-02-14 at 17:37 +0100, Peter Zijlstra wrote:
> 
> > We could of course cheat implement our own version of atomic_read() in
> > order to avoid the whole header mess, but that's not pretty at all
> 
> Oh God please no! ;)
> 
> atomic_read() is implemented per arch.

Hmm, maybe this isn't so bad:

alpha:
#define atomic_read(v)          (*(volatile int *)&(v)->counter)

arm:
#define atomic_read(v)  (*(volatile int *)&(v)->counter)

avr32:
#define atomic_read(v)          (*(volatile int *)&(v)->counter)

blackfin:
#define atomic_read(v)  __raw_uncached_fetch_asm(&(v)->counter)

cris:
#define atomic_read(v) (*(volatile int *)&(v)->counter)

frv:
#define atomic_read(v)          (*(volatile int *)&(v)->counter)

h8300:
#define atomic_read(v)          (*(volatile int *)&(v)->counter)

ia64:
#define atomic_read(v)          (*(volatile int *)&(v)->counter)

m32r:
#define atomic_read(v)  (*(volatile int *)&(v)->counter)

m68k:
#define atomic_read(v)          (*(volatile int *)&(v)->counter)

microblaze: uses generic which is:


mips:
#define atomic_read(v)          (*(volatile int *)&(v)->counter)

mn10300:
#define atomic_read(v)  ((v)->counter)

parisc:
static __inline__ int atomic_read(const atomic_t *v)
{
        return (*(volatile int *)&(v)->counter);
}

powerpc:
static __inline__ int atomic_read(const atomic_t *v)
{
        int t;

        __asm__ __volatile__("lwz%U1%X1 %0,%1" : "=r"(t) : "m"(v->counter));

        return t;
}

which is still pretty much a volatile read


s390:
static inline int atomic_read(const atomic_t *v)
{
        barrier();
        return v->counter;
}

score:
uses generic

sh:
#define atomic_read(v)          (*(volatile int *)&(v)->counter)

sparc 32:
sparc 64:
#define atomic_read(v)          (*(volatile int *)&(v)->counter)


tile:
static inline int atomic_read(const atomic_t *v)
{
       return v->counter;
}

Hmm, nothing volatile at all?

x86:
static inline int atomic_read(const atomic_t *v)
{
        return (*(volatile int *)&(v)->counter);
}

xtensa:
#define atomic_read(v)          (*(volatile int *)&(v)->counter)

So all but a few have basically (as you said on IRC)
#define atomic_read(v) ACCESS_ONCE(v)

Those few are blackfin, s390, powerpc and tile.

s390 probably doesn't need that much of a big hammer with atomic_read()
(unless it uses it in its own arch that expects it to be such).

powerpc could probably be converted to just the volatile code as
everything else. Not sure why it did it that way. To be different?

tile just looks wrong, but wont be hurt with adding volatile to that.

blackfin, seems to be doing quite a lot. Not sure if it is required, but
that may need a bit of investigating to understand why it does the
raw_uncached thing.


Maybe we could move the atomic_read() out of atomic and make it a
standard inline for all (in kernel.h)?

-- Steve

