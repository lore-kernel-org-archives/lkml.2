Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788Ab0DHO7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 10:59:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758725Ab0DHO7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 10:59:19 -0400
Date: Thu, 8 Apr 2010 07:55:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Will Deacon <will.deacon@arm.com>
cc: Jason Wessel <jason.wessel@windriver.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: RE: [PATCH 4/5] kgdb: Use atomic operators which use barriers
In-Reply-To: <000501cad70a$26ca7e10$745f7a30$@deacon@arm.com>
Message-ID: <alpine.LFD.2.00.1004080746330.3586@i5.linux-foundation.org>
References: <1270233145-29335-1-git-send-email-jason.wessel@windriver.com> <1270233145-29335-2-git-send-email-jason.wessel@windriver.com> <1270233145-29335-3-git-send-email-jason.wessel@windriver.com> <1270233145-29335-4-git-send-email-jason.wessel@windriver.com>
 <1270233145-29335-5-git-send-email-jason.wessel@windriver.com> <alpine.LFD.2.00.1004021205080.3634@i5.linux-foundation.org> <000501cad70a$26ca7e10$745f7a30$@deacon@arm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Apr 2010, Will Deacon wrote:
> 
> I simply used smp_mb() as a way to solve this ARM-specific problem. I think
> Russell objects to this largely because this problem affects a particular
> scenario of busy-wait loops and changing the definition of cpu_relax() adds
> barriers to code that doesn't necessarily require them.

How expensive is a smp_mb() on arm?

And by "expensive" I don't mean so much performance of the instruction 
itself (after all, we _are_ just busy-looping), but more about things like 
power and perhaps secondary effects (does it cause memory traffic, for 
example?).

Also, I have to say that _usually_ the problem with non-timely cache 
updates in not on the reading side, but on the writing side - ie the other 
CPU may be buffering writes indefinitely and the writes will go out only 
as a response to bus cycles or the write buffers filling up. In which case 
the reader can't really do much about it.

But your comment for the "smp_mb()" patch seems to imply that it's 
literally a matter of cache access priorities:

 "On the ARM11MPCore processor [where loads are prioritised over stores], 
  spinning in such a loop will prevent the write buffer from draining."

and in that case I would say that the correct thing _definitely_ is to 
make sure that the loop simply is never so tight that. Maybe you can do 
that without an smp_mb(), by just making whatever "cpu_relax()" does slow 
enough (something that stalls the pipeline or whatever?)

But if smp_mb() is cheap, then that sounds like the right solution.

			Linus
