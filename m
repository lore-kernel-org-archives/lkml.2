Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab0EQQ5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 12:57:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54879 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353Ab0EQQ5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 12:57:04 -0400
Date: Mon, 17 May 2010 18:56:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
Message-ID: <20100517165658.GB5947@basil.fritz.box>
References: <87tyq9mqrz.fsf@basil.nowhere.org> <a3572531-ca89-4959-b190-bcb9309a0193@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3572531-ca89-4959-b190-bcb9309a0193@default>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 08:23:59AM -0700, Dan Magenheimer wrote:
> will read this long thread and also be convinced never to use
> rdtsc, the problem is there is a high and increasing chance that
> any given systems programmer will write code that uses rdtsc and,
> in all of his/her test machines will NEVER see a problem.  But,

It would be probably a good idea to document all this
somewhere central, agreed.

In fact I remember wanting to write such a paper once. Possibly
even with some title borrowing from Swift. It seems it never happened :)
 
> > From: Andi Kleen [mailto:andi@firstfloor.org]
> > 32bit doesn't have a fast ring 3 gtod() today but that could be also
> > fixed.
> 
> That might have helped, because the enterprise app I mentioned
> earlier was 32-bit... but I'll bet the genie is out of the
> bottle now and the app has already shipped using rdtsc.

Well the enterprise will have to live with wrong timing now and then
(or perhaps totally broken timing on some system) then.

> > From: Andi Kleen [mailto:andi@firstfloor.org]
> > It seems to me you're bordering on violating Steinberg's rule
> > of system programming here :-)
> 
> <Embarrassed to not know this rule, Dan goes off and googles
> but fails to find any good matches before his TSC goes bad>

Sorry it's Steinbach's rule. Never test for an error condition
you don't know how to handle.

> 
> > From: Andi Kleen [mailto:andi@firstfloor.org]
> > First the single instruction is typically quite slow. Then
> > to really get monotonous time you need a barrier anyways.
> 
> Agreed, I've measured 30-ish and 60-ish cycles on a
> couple of machines.

It can be worse.

Also for correct behaviour you need the barrier on many systems.
And some other workarounds.

> 
> I think vsyscall is an excellent idea and I'm very much in
> favor of continuing to improve it and encouraging people
> to use it.  But until it either "always" "just works" in "all"

On 64bit it should just work, although it could be made somewhat
(but not dramatically) faster.

On older kernels vsyscall got a bad name because it was not always
as clever as it could be to chose when to use TSC and when not,
but that is long fixed. It worked in any case, just was slower[1]

[1] That is some specific TSC misbehaviours were only fixed in later
kernels, but it's very unlikely that any other RDTSC user got
that right either.


> > From: Andi Kleen [mailto:andi@firstfloor.org]
> > I don't think that's true. There are various large systems with
> > non synchronized TSC and I haven't heard of any unique cache coherency
> > problems on that.
> 
> Here I was referring to clock skew/drift, not the "fixed offset"
> problem.  I'm far from an expert in PLL's etc, but I think if
> the clock signal is delayed far enough to cause TSC to skew
> significantly, eventually some critical cache coherency protocol
> is eventually going to miss a beat and screw up and corrupt data.

Generally small systems run on the same clock (and any drift
you see has other reasons), but large systems built out of multiple
boards run on different clocks and the interconnect
does appropiate timing between the different domains for itself.

The interconnects also have checksums and other error checking
and recovery mechanisms and tend to do something appropiate when there
is a transmission problem. It does not usually lead to data corruption.

> I believe (and this is strictly a personal opinion based on my
> view of human psychology) that adding more obscure interfaces and
> more obscure options is a losing battle.

It sounds like you're arguing against your own patch here.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
