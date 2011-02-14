Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab1BNR0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 12:26:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:60755 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab1BNR0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 12:26:23 -0500
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>,
        Chris Metcalf <cmetcalf@tilera.com>, dhowells <dhowells@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "heiko.carstens" <heiko.carstens@de.ibm.com>,
        benh <benh@kernel.crashing.org>
In-Reply-To: <1297703892.23343.71.camel@gandalf.stny.rr.com>
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
	 <1297703892.23343.71.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 18:27:27 +0100
Message-ID: <1297704447.5226.127.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-14 at 12:18 -0500, Steven Rostedt wrote:

> mn10300:
> #define atomic_read(v)  ((v)->counter)

> tile:
> static inline int atomic_read(const atomic_t *v)
> {
>        return v->counter;
> }

Yeah, I already send email to the respective maintainers telling them
they might want to fix this ;-)


> So all but a few have basically (as you said on IRC)
> #define atomic_read(v) ACCESS_ONCE(v)

ACCESS_ONCE(v->counter), but yeah :-)

> Those few are blackfin, s390, powerpc and tile.
> 
> s390 probably doesn't need that much of a big hammer with atomic_read()
> (unless it uses it in its own arch that expects it to be such).

Right, it could just do the volatile thing..

> powerpc could probably be converted to just the volatile code as
> everything else. Not sure why it did it that way. To be different?

Maybe that code was written before we all got inventive with the
volatile cast stuff..

> blackfin, seems to be doing quite a lot. Not sure if it is required, but
> that may need a bit of investigating to understand why it does the
> raw_uncached thing.

>From what I can tell its flushing its write cache, invalidating its
d-cache and then issue the read, something which is _way_ overboard.

> Maybe we could move the atomic_read() out of atomic and make it a
> standard inline for all (in kernel.h)?

Certainly looks like that might work..

