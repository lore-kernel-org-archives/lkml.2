Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab1CJVmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:42:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51817 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab1CJVmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:42:21 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=UwRGqXM3h7MA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=TNWvwwGL1HcNQAfk9GQA:9 a=qxsoN2vmQQYNqcYqv7EA:7 a=bSkleqk4zz9sqkeIbANPuj2imMUA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/2] jump label: update for .39
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: David Daney <ddaney@caviumnetworks.com>, Jason Baron <jbaron@redhat.com>,
        peterz@infradead.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
In-Reply-To: <BLU0-SMTP311155BEBE5F141636A6E596C80@phx.gbl>
References: <1299771504.15854.347.camel@gandalf.stny.rr.com>
	 <4D790A13.4060705@caviumnetworks.com>
	 <1299780241.15854.393.camel@gandalf.stny.rr.com>
	 <20110310182000.GB2906@redhat.com>
	 <1299782143.15854.402.camel@gandalf.stny.rr.com>
	 <4D791CAA.7090108@caviumnetworks.com>
	 <1299783236.15854.405.camel@gandalf.stny.rr.com>
	 <4D791F31.6040100@caviumnetworks.com>
	 <1299785143.15854.407.camel@gandalf.stny.rr.com>
	 <1299786329.15854.409.camel@gandalf.stny.rr.com>
	 <BLU0-SMTP311155BEBE5F141636A6E596C80@phx.gbl>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 10 Mar 2011 16:42:19 -0500
Message-ID: <1299793339.15854.430.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 16:22 -0500, Mathieu Desnoyers wrote:

> > Anyway, I think the best thing for now is to have Jason add
> > the .align(sizeof(long)) in the inline assembly for all locations and be
> > done with it.
> 
> You seem to be contradicting yourself here. I'm concerned about having
> "structures" of a size not power of two. Can we simply either

But we don't have structures. We have data that has been allocated in
assembly. Come to think of it, it may be best to keep these as 
".align 4".


> 
> - Add a padding element at the end
> or
> - use .align 4*sizeof(long) at the beginning
> 
> to make sure the linker won't put any holes when it puts objects 
> together ?
> 

The linker should be dumb and not trying to "optimize", because it has
no idea what the content is. If anything, it should try to compact
things as best as possible, with the exception of keeping things
naturally word aligned. If you added even ".align(4)" on a 64bit system,
the linker should be trying to keep everything packed.

If I get time, I could look at the linker code to see exactly what it
does, but adding holes into sections that are naturally word align seems
more like a bug in the linker than a problem that we need to deal with.

The only issue I could fathom, is if gcc added its own padding in a
section. That is, when it created the __jump_table section with one
element, it added another 4/8 bytes to make the section size a power of
two. Maybe that is a true issue, maybe not. It would seems stupid to do
so IMHO, because when you get to bigger numbers, the aligning a power of
2 can get much bigger. But perhaps it does it for small power of 2s?

-- Steve



