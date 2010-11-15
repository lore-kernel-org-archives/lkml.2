Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab0KOBYo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 20:24:44 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59202 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757223Ab0KOBYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 20:24:43 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v2]mm/oom-kill: direct hardware access processes should get bonus
Cc: kosaki.motohiro@jp.fujitsu.com, "Figo.zhang" <figo1802@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1011141322590.22262@chino.kir.corp.google.com>
References: <20101112104140.DFFF.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011141322590.22262@chino.kir.corp.google.com>
Message-Id: <20101115095446.BF00.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 15 Nov 2010 10:24:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 14 Nov 2010, KOSAKI Motohiro wrote:
> 
> > > So the question that needs to be answered is: why do these threads deserve 
> > > to use 3% more memory (not >4%) than others without getting killed?  If 
> > > there was some evidence that these threads have a certain quantity of 
> > > memory they require as a fundamental attribute of CAP_SYS_RAWIO, then I 
> > > have no objection, but that's going to be expressed in a memory quantity 
> > > not a percentage as you have here.
> > 
> > 3% is choosed by you :-/
> > 
> 
> No, 3% was chosen in __vm_enough_memory() for LSMs as the comment in the 
> oom killer shows:
> 
>         /*
>          * Root processes get 3% bonus, just like the __vm_enough_memory()
>          * implementation used by LSMs.
>          */
> 
> and is described in Documentation/filesystems/proc.txt.
> 
> I think in cases of heuristics like this where we obviously want to give 
> some bonus to CAP_SYS_ADMIN that there is consistency with other bonuses 
> given elsewhere in the kernel.

Keep comparision apple to apple. vm_enough_memory() account _virtual_ memory.
oom-killer try to free _physical_ memory. It's unrelated.


> 
> > Old background is very simple and cleaner. 
> > 
> 
> The old heuristic divided the arbitrary badness score by 4 with 
> CAP_SYS_RESOURCE.  The new heuristic doesn't consider it.
> 
> How is that more clean?
> 
> > CAP_SYS_RESOURCE mean the process has a privilege of using more resource.
> > then, oom-killer gave it additonal bonus.
> > 
> 
> As a side-effect of being given more resources to allocate, those 
> applications are relatively unbounded in terms of memory consumption to 
> other tasks.  Thus, it's possible that these applications are using a 
> massive amount of memory (say, 75%) and now with the proposed change a 
> task using 25% of memory would be killed instead.  This increases the 
> liklihood that the CAP_SYS_RESOURCE thread will have to be killed 
> eventually, anyway, and the goal is to kill as few tasks as possible to 
> free sufficient amount of memory.

You are talking two difference at once. 3% vs 4x and CAP_SYS_RESOURCE and
CAP_SYS_ADMIN.

Please keep comparing apple to apple.


> 
> Since threads having CAP_SYS_RESOURCE have full control over their 
> oom_score_adj, they can take the additional precautions to protect 
> themselves if necessary.  It doesn't need to be a part of the heuristic to 
> bias these tasks which will lead to the undesired result described above 
> by default rather than intentionally from userspace.
> 
> > CAP_SYS_RAWIO mean the process has a direct hardware access privilege
> > (eg X.org, RDB). and then, killing it might makes system crash.
> > 
> 
> Then you would want to explicitly filter these tasks from oom kill just as 
> OOM_SCORE_ADJ_MIN works rather than giving them a memory quantity bonus.

No. Why does userland recover your mistake?




