Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab1I2Mkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 08:40:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48562 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab1I2Mka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 08:40:30 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=jRhu4G1yBvdpZJKnbfUA:9 a=cb4raEPhQav7qsLoPIAA:7 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: Jump Label initialization
From: Steven Rostedt <rostedt@goodmis.org>
To: Jan Glauber <jang@linux.vnet.ibm.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Jason Baron <jbaron@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        David Daney <ddaney@caviumnetworks.com>,
        "David S. Miller" <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 29 Sep 2011 08:40:26 -0400
In-Reply-To: <1317297894.23938.9.camel@localhost.localdomain>
References: <4E83D49C.9080809@goop.org>
	 <1317297894.23938.9.camel@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317300028.4588.15.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-29 at 14:04 +0200, Jan Glauber wrote:
> On Wed, 2011-09-28 at 19:14 -0700, Jeremy Fitzhardinge wrote:
> > Hi all,
> > 
> > I'm trying to use the jump label machinery as part of the pv ticketlock
> > work I'm doing on x86.
> > 
> > The problem I'm having at the moment is that I do my spinlock setup in
> > smp_prepare_boot_cpu(), which happens before jump_label_init() gets
> > called, and so the latter goes and nops out all my enabled jump label key.
> > 
> > I'm experimenting at the moment with a patch to allow
> > jump_label_enable() to be called fairly early, and have that be
> > respected by jump_label_init().  I'm doing this by replacing
> > arch_jump_label_poke_text_early() with
> > arch_jump_label_transform_early(), which shares most of its code with
> > its non-early variant, except that it expects to run in a pre-SMP
> > environment.
> > 
> > Does this seem plausible? (I haven't tested it yet.)
> > 
> > The x86, mips and sparc patches are fairly simple; I forgot to look at
> > powerpc, and I didn't fully investigate s390.
> 
> s390 does not have the early() variant since it didn't need it. On
> pre-SMP we probably don't need stop_machine() so creating
> arch_jump_label_transform_early() by leaving out stop_machine()
> and patching the code directly should be fine.

Also note that stop_machine() may only be needed by a few archs (maybe
only x86).

x86 has a nasty condition if you change code that is being loaded in
another CPUs pipeline, it could cause a GPF. I've been playing with this
on PPC and this does not have that same bug. In fact Benjamin told me
that PPC is fine with modifying instructions on a running system.

I plan on removing the stop_machine() from ftrace for those boxes. I
already have patches made, just need to spiffy them up a bit.

-- Steve



