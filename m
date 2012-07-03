Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab2GCJ6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 05:58:30 -0400
Received: from mx2.parallels.com ([64.131.90.16]:37566 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab2GCJ62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 05:58:28 -0400
Message-ID: <4FF2C19D.4040608@parallels.com>
Date: Tue, 3 Jul 2012 13:55:41 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>, <jeremy@goop.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: __force_order usage on x86's CRn accesses
References: <4FF2D6AB020000780008D460@nat28.tlf.novell.com>
In-Reply-To: <4FF2D6AB020000780008D460@nat28.tlf.novell.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Pretty soon after the introduction of this via "x86: unify paravirt
> parts of system.h" Jeremy had posted a patch to correct the
> (reversed in direction of access) constraints using that auxiliary
> variable. What happened to that change? Was it dropped for a
> reason?

About the change itself, I don't know. Maybe Jeremy, who proposed it,
can give you a better answer.

> Furthermore, the addition of these constraints happened
> without any real explanation - the code comment that was added
> doesn't really help understand why "volatile" isn't sufficient here.

If my memory dont't fail me, I believe this is because gcc will feel
free to reorder a sequence of instructions that does not access memory.
Specially since it has no knowledge of what's in the inline assembly,
and what are its constraints. It only knows that it is an register
operation, and treats it like one.

Also, I believe what we are concerned with here is not arbitrary reorder
between that and other instructions, which we welcome, but reordering
between a read and a write to the same crX - specially of concern for
things doing read-modify-writes of control registers.

This is something I heavily looked at the time, but never again, so
confirmation from people with more knowledge on the compilers world can
be probably helpful here.

> 
> Next, I also saw it being suggested somewhere to replace the
> static definition of the variable (causing an instance to appear
> everywhere any of the referencing inline function being used)
> by an extern one. That also never got carried out, causing
> about two dozen pointless instances of this variable to be
> scattered around, likely consuming cache bandwidth here and
> there.

I indeed see no reason not to do it.

> Now, rather than exporting an auxiliary variable like this, how
> about using an existing, rarely referenced (at least in affected
> contexts) but already exported one instead?
> empty_zero_page, __supported_pte_mask, x86_platform, or
> high_memory might be candidates.

A similar technique is used to determine a safe address for access
somewhere in the scheduler IIRC,

> Finally (and this is because I lack the explanation why the
> artificial constraint is needed in the first place), why is it that
> clts() doesn't need one too?
> 

Because we're not using it to do read-modify-write of the control register.

But let me disclaim again that I might be wrong here...


