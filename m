Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab0DEXbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 19:31:31 -0400
Received: from sous-sol.org ([216.99.217.87]:53837 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756727Ab0DEXbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 19:31:24 -0400
Date: Mon, 5 Apr 2010 16:29:12 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH V2 0/6][RFC] futex: FUTEX_LOCK with optional adaptive
	spinning
Message-ID: <20100405232912.GF29241@sequoia.sous-sol.org>
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com> <4BBA5305.7010002@redhat.com> <4BBA5C00.4090703@us.ibm.com> <4BBA6279.20802@redhat.com> <4BBA6F0B.2060008@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBA6F0B.2060008@us.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Darren Hart (dvhltc@us.ibm.com) wrote:
> Avi Kivity wrote:
>
>>>> An interesting (but perhaps difficult to achieve) optimization 
>>>> would be to spin in userspace.
>>>
>>> I couldn't think of a lightweight way to determine when the owner has 
>>> been scheduled out in userspace. Kernel assistance is required. You  
>>> could do this on the schedule() side of things, but I figured I'd get 
>>> some strong pushback if I tried to add a hook into descheduling that  
>>> flipped a bit in the futex value stating the owner was about to  
>>> deschedule(). Still, that might be something to explore.
>>
>> In the futex value it's hopeless (since a thread can hold many locks), 
>
> It can, but there is a futex value per lock. If the task_struct had a  
> list of held futex locks (as it does for pi futex locks) the  
> deschedule() path could walk that and mark the FUTEX_OWNER_SLEEPING bit.

You also have a notification scheme (preempt_notifiers will fire on
schedule out).  However, you'd have to register the notifiers from a
non-current context (i.e. on slow path acquire reaching out to lock owner
and registering notifier on lock owner's behalf, which would kind of
defeat the point AFAICT).

thanks,
-chris
