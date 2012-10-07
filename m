Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab2JGPZr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 11:25:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:45942 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300Ab2JGPZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 11:25:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,547,1344236400"; 
   d="scan'208";a="201553875"
Message-ID: <50719EEC.7090302@zytor.com>
Date: Sun, 07 Oct 2012 23:25:32 +0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Seiji Aguchi <seiji.aguchi@hds.com>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "x86@kernel.org" <x86@kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [PATCH v4] trace,x86: add x86 irq vector tracepoints
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41385F33C@USINDEM103.corp.hds.com>   <50612729.2080307@zytor.com>   <A5ED84D3BB3A384992CBB9C77DEDA4D41386426D@USINDEM103.corp.hds.com>   <50650A7E.90807@zytor.com>   <A5ED84D3BB3A384992CBB9C77DEDA4D413869FD7@USINDEM103.corp.hds.com>  <1349446428.6755.56.camel@gandalf.local.home> <506F7849.2080805@zytor.com> <1349492261.6755.87.camel@gandalf.local.home>
In-Reply-To: <1349492261.6755.87.camel@gandalf.local.home>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2012 10:57 AM, Steven Rostedt wrote:
> 
> I didn't say anything magic, but a table of pointers that are very
> critical for the system running. Should we implement it with a single
> switch, like we discussed in San Diego to do with the system call table?
> 
> That is, have a "normal" table, and a "trace" table. The trace table
> points to functions that have tracepoints. The first enabler of tracing
> switches the table to use the tracepoints, and the last disabler
> switches it back?
> 

That is certainly a reasonable implementation option.  It is slightly
less usable than it is for system calls, though, because the vectors in
the IDTs are somewhat scrambled and so you can't just do an indirect
jump to the original vector content.  This does get messy because you
also want to preserve registers...

>>
>>> You are the maintainer and are responsible for the outcome of changes to
>>> the x86 arch, thus you do have final say. And if you think there's
>>> nothing to worry about with an IDT change then Seiji should implement
>>> it.
>>>
>>> I just want to point out some possible repercussions of doing it in a
>>> more complex way. As tracepoints use nops, and I may be pushing to even
>>> out-of-line the tracepoint unlikely part even more, I'm not sure the
>>> complexity is worth the amount of savings it would be against just
>>> adding the tracepoint in the code.
>>
>> The problem I'm seeing is the constant "oh, just a little bit more."  My
>> experience over the years is that there is always demand for "just one
>> more debug feature", each of which has negible cost, because they always
>> use the previous thing as a baseline... noone ever looks at the grand
>> total cost of the package (and by the time that happens, it is too late.)
> 
> Now I can turn this back at you ;-)  We can implement the simple "just
> add the tracepoints in the code" first, and then later implement the
> table swap version and we can say "hey! we just made the code faster!".

Can we?  My understanding how tracepoints are is that they export a
bunch of data structures via debugfs (a.k.a. sploitfs -- any system with
debugfs mounted really should be considered compromised from the start)
and that they are intimately tied to how they are implemented.

>>
>> tracepoints in particular are something I'm getting concerned about,
>> because they are one of those things that turn kernel internals into an
>> ABI, which means misdesigned tracepoints can actually make kernel
>> internal changes very hard to do.  The cost of those kinds of issues go
>> up over time as the strain between where we'd like the code to be vs.
>> where the code is increases.
> 
> Honestly, I'm extremely concerned about this too. In fact, I've bitched
> about this so many times in the past, but it just fell to deaf ears:
> 
> http://lwn.net/Articles/412685/
> http://lwn.net/Articles/415591/
> http://lwn.net/Articles/416665/
> http://lwn.net/Articles/416684/
> 

Slightly different complaint, but in the same general vein, yes.

	-hpa



