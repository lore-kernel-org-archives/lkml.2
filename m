Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423535Ab2LGRpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 12:45:55 -0500
Received: from smarthost03.mail.zen.net.uk ([212.23.1.3]:54635 "EHLO
	smarthost03.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423351Ab2LGRpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 12:45:54 -0500
Message-ID: <1354902347.8263.12.camel@linaro1.home>
Subject: Re: [PATCH] ARM: ftrace: Ensure code modifications are synchronised
 across all cpus
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Rabin Vincent <rabin@rab.in>,
        linux-kernel@vger.kernel.org
Date: Fri, 07 Dec 2012 17:45:47 +0000
In-Reply-To: <1354900436.17101.58.camel@gandalf.local.home>
References: <1354817466.30905.13.camel@linaro1.home>
	 <1354821581.17101.17.camel@gandalf.local.home>
	 <1354872138.3176.15.camel@computer5.home>
	 <1354888985.17101.41.camel@gandalf.local.home>
	 <1354892111.13000.50.camel@linaro1.home>
	 <1354894134.17101.44.camel@gandalf.local.home>
	 <20121207162346.GW14363@n2100.arm.linux.org.uk>
	 <1354898200.17101.50.camel@gandalf.local.home>
	 <20121207164530.GX14363@n2100.arm.linux.org.uk>
	 <1354900436.17101.58.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost03-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-07 at 12:13 -0500, Steven Rostedt wrote:
> I'll make my question more general:
> 
> If I have a nop, that is a size of a call (branch and link), which is
> near the beginning of a function and not part of any conditional, and I
> want to convert it into a call (branch and link), would adding a
> breakpoint to it, modifying it to the call, and then removing the
> breakpoint be possible? Of course it would require syncing in between
> steps, but my question is, if the above is possible on a thumb2 ARM
> processor?

I believe so. The details are (repeating your earlier explanation) ...

1. Replace first half of nop with 16bit 'breakpoint' instruction.

2. Sync.(cache flush to PoU + IPIs to make other cores invalidate the
icache for changed part of the nop instruction).

3. Replace second half of nop with second half of the call instruction.

4. Sync.

5. Replace the breakpoint with the first half of the call instruction.

6. Sync

And if any core execute the breakpoint instruction, then the handler
ensures execution continues at the instruction after the nop were trying
to replace.

However, wouldn't we need any of this breakpoint malarkey, why not just
just use a 16-bit branch instruction which branches over the second half
of the nop? :-)

-- 
Tixy

