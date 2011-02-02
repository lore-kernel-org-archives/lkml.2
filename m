Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab1BBTOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 14:14:54 -0500
Received: from smtp-out.google.com ([216.239.44.51]:49638 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab1BBTOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 14:14:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=kwkYujEAp3UayBwa4MkP45fdGfg7B6X8w3re76Ulc2aVHEmy+LnaImEL8m/lzKz0Ud
         7ety9WII3PtqygA58peA==
From: Ian Lance Taylor <iant@google.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Peter Maydell <peter.maydell@linaro.org>, gcc@gcc.gnu.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Subject: Re: ARM unaligned MMIO access with attribute((packed))
References: <201102021700.20683.arnd@arndb.de>
	<20110202163702.GA23240@n2100.arm.linux.org.uk>
	<201102021839.17223.arnd@arndb.de>
Date: Wed, 02 Feb 2011 11:14:45 -0800
In-Reply-To: <201102021839.17223.arnd@arndb.de> (Arnd Bergmann's message of
	"Wed, 2 Feb 2011 18:39:17 +0100")
Message-ID: <mcrpqrafdui.fsf@google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> On Wednesday 02 February 2011 17:37:02 Russell King - ARM Linux wrote:
>> We used to use inline assembly at one point, but that got chucked out.
>> The problem is that using asm() for this causes GCC to generate horrid
>> code.
>> 
>> 1. there's no way to tell GCC that the inline assembly is a load
>>    instruction and therefore it needs to schedule the following
>>    instructions appropriately.
>> 
>> 2. GCC will needlessly reload pointers from structures and other such
>>    behaviour because it can't be told clearly what the inline assembly
>>    is doing, so the inline asm needs to have a "memory" clobber.
>> 
>> 3. It seems to misses out using the pre-index addressing, prefering to
>>    create add/sub instructions prior to each inline assembly load/store.
>> 
>> 4. There are no (documented) constraints in GCC to allow you to represent
>>    the offset format for the half-word instructions.
>> 
>> Overall, it means greater register pressure, more instructions, larger
>> functions, greater instruction cache pressure, etc.
>
> Another solution would be to declare the readl function extern and define
> it out of line, but I assume that this would be at least as bad as an
> inline assembly for all the points you brought up, right?
>
> Would it be possible to add the proper constraints for defining readl
> in an efficient way to a future version of gcc? That wouldn't help us
> in the near future, but we could at some points use those in a number
> of places.

I think it would be quite difficult to implement item 1 above in a way
that was actually usable.  It would require some way to describe the
scheduling requirements of an asm.  But the details of scheduling are
backend specific.  Internally there are define_insn_reservation
structures which have names, but the names are processor specific which
is not what you want in source code (by processor specific I mean
specific to particular CPUs within a family).  There are define_cpu_unit
structures which also have names, but are again processor specific.
What you want here is some non-processor-specific way to describe the
characteristics of an instruction.  gcc does not have that today.

Even if somebody implemented all that, most inline asms are not a single
instructions and thus would find it difficult to take advantage of it.
I don't see this as paying off in the long run.

A more likely payoff would be to develop builtin functions for whatever
functionality is required that can not expressed in source code.

Item 2 above can be done.  It is possible to describe precisely which
areas of memory are clobbered.

Item 3 above seems impossible to me.  There is no way to combine
compiler generated instructions with user written inline asm such that
pre-index addressing can be used.  Perhaps I misunderstand.

Item 4 can be implemented; please consider opening a feature request in
bugzilla.

Ian
