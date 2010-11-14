Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250Ab0KNV36 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 16:29:58 -0500
Received: from smtp-out.google.com ([74.125.121.35]:14823 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756969Ab0KNV34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 16:29:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=uhkgRbt5P9CIsQbBJRHplS9nRgK7qUOy6SMCBEG+ruOOyFv04ypDO6nIFdk/RdAQoC
         XwiGdqCGYF0lLl1ZmpwA==
Date: Sun, 14 Nov 2010 13:29:44 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: "Figo.zhang" <figo1802@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2]mm/oom-kill: direct hardware access processes should
 get bonus
In-Reply-To: <20101112104140.DFFF.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1011141322590.22262@chino.kir.corp.google.com>
References: <1289305468.10699.2.camel@localhost.localdomain> <alpine.DEB.2.00.1011091307240.7730@chino.kir.corp.google.com> <20101112104140.DFFF.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Nov 2010, KOSAKI Motohiro wrote:

> > So the question that needs to be answered is: why do these threads deserve 
> > to use 3% more memory (not >4%) than others without getting killed?  If 
> > there was some evidence that these threads have a certain quantity of 
> > memory they require as a fundamental attribute of CAP_SYS_RAWIO, then I 
> > have no objection, but that's going to be expressed in a memory quantity 
> > not a percentage as you have here.
> 
> 3% is choosed by you :-/
> 

No, 3% was chosen in __vm_enough_memory() for LSMs as the comment in the 
oom killer shows:

        /*
         * Root processes get 3% bonus, just like the __vm_enough_memory()
         * implementation used by LSMs.
         */

and is described in Documentation/filesystems/proc.txt.

I think in cases of heuristics like this where we obviously want to give 
some bonus to CAP_SYS_ADMIN that there is consistency with other bonuses 
given elsewhere in the kernel.

> Old background is very simple and cleaner. 
> 

The old heuristic divided the arbitrary badness score by 4 with 
CAP_SYS_RESOURCE.  The new heuristic doesn't consider it.

How is that more clean?

> CAP_SYS_RESOURCE mean the process has a privilege of using more resource.
> then, oom-killer gave it additonal bonus.
> 

As a side-effect of being given more resources to allocate, those 
applications are relatively unbounded in terms of memory consumption to 
other tasks.  Thus, it's possible that these applications are using a 
massive amount of memory (say, 75%) and now with the proposed change a 
task using 25% of memory would be killed instead.  This increases the 
liklihood that the CAP_SYS_RESOURCE thread will have to be killed 
eventually, anyway, and the goal is to kill as few tasks as possible to 
free sufficient amount of memory.

Since threads having CAP_SYS_RESOURCE have full control over their 
oom_score_adj, they can take the additional precautions to protect 
themselves if necessary.  It doesn't need to be a part of the heuristic to 
bias these tasks which will lead to the undesired result described above 
by default rather than intentionally from userspace.

> CAP_SYS_RAWIO mean the process has a direct hardware access privilege
> (eg X.org, RDB). and then, killing it might makes system crash.
> 

Then you would want to explicitly filter these tasks from oom kill just as 
OOM_SCORE_ADJ_MIN works rather than giving them a memory quantity bonus.
