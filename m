Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab1CNJOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 05:14:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55596 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab1CNJOF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 05:14:05 -0400
Subject: Re: [PATCH 1/3] futex: do not pagefault_disable in
 futex_atomic_cmpxchg_inatomic()
From: Peter Zijlstra <peterz@infradead.org>
To: Darren Hart <darren@dvhart.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Matt Turner <mattst88@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Michal Simek <monstr@monstr.eu>, Ralf Baechle <ralf@linux-mips.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTinmxcjRUj-JRtmO3JSAGWoiW+ec7JzTBpL32C=t@mail.gmail.com>
References: <20110307021127.GB31188@google.com>
	 <alpine.LFD.2.00.1103082114270.2787@localhost6.localdomain6>
	 <20110309112550.GA3050@google.com>
	 <alpine.LFD.2.00.1103101948540.2787@localhost6.localdomain6>
	 <20110311021654.GA26122@google.com> <20110311024731.GB26122@google.com>
	 <AANLkTinXxCMVozx-NKEVXJLNrB1V93VEAJ8FiHQHXY_=@mail.gmail.com>
	 <AANLkTinmxcjRUj-JRtmO3JSAGWoiW+ec7JzTBpL32C=t@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 14 Mar 2011 10:13:17 +0100
Message-ID: <1300093997.2203.51.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-03-13 at 17:55 -0700, Darren Hart wrote:
> I wondered about the preempt vs pagefault disable 

In current mainline they happen to be the same, but for -rt they're not.

Its also conceptually different, with preempt disable we dis-allow any
scheduling, which thus also precludes most fault handlers.

Disabling pagefault can be done without also disabling preemption (as is
done in -rt) and simply means that we'll never try to handle the fault
and fallback to the exception table or give up and segfault the kernel.

Its not dis-similar to the whole rcu_read_lock() vs preempt_disable()
stuff, for a while one implied the other.
