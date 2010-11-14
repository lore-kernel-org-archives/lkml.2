Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab0KNFHj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 00:07:39 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49963 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab0KNFHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 00:07:13 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v2]mm/oom-kill: direct hardware access processes should get bonus
Cc: kosaki.motohiro@jp.fujitsu.com, "Figo.zhang" <figo1802@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1011091307240.7730@chino.kir.corp.google.com>
References: <1289305468.10699.2.camel@localhost.localdomain> <alpine.DEB.2.00.1011091307240.7730@chino.kir.corp.google.com>
Message-Id: <20101112104140.DFFF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun, 14 Nov 2010 14:07:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > the victim should not directly access hardware devices like Xorg server,
> > because the hardware could be left in an unpredictable state, although 
> > user-application can set /proc/pid/oom_score_adj to protect it. so i think
> > those processes should get 3% bonus for protection.
> > 
> 
> The logic here is wrong: if killing these tasks can leave hardware in an 
> unpredictable state (and that state is presumably harmful), then they 
> should be completely immune from oom killing since you're still leaving 
> them exposed here to be killed.
> 
> So the question that needs to be answered is: why do these threads deserve 
> to use 3% more memory (not >4%) than others without getting killed?  If 
> there was some evidence that these threads have a certain quantity of 
> memory they require as a fundamental attribute of CAP_SYS_RAWIO, then I 
> have no objection, but that's going to be expressed in a memory quantity 
> not a percentage as you have here.

3% is choosed by you :-/


> The CAP_SYS_ADMIN heuristic has a background: it is used in the oom killer 
> because we have used the same 3% in __vm_enough_memory() for a long time 
> and we want consistency amongst the heuristics.  Adding additional bonuses 
> with arbitrary values like 3% of memory for things like CAP_SYS_RAWIO 
> makes the heuristic less predictable and moves us back toward the old 
> heuristic which was almost entirely arbitrary.

That's bogus. __vm_enough_memory() does track virtual adress space. oom-killer
doesn't. It's unrelated.


> Now before KOSAKI-san comes out and says the old heuristic considered 
> CAP_SYS_RAWIO and the new one does not so it _must_ be a regression: the 
> old heuristic also divided the badness score by 4 for that capability as a 
> completely arbitrary value (just like 3% is here).  Other traits like 
> runtime and nice levels were also removed from the heuristic.  What needs 
> to be shown is that CAP_SYS_RAWIO requires additional memory just to run 
> or we should neglect to free 3% of memory, which could be gigabytes, 
> because it has this trait.

Old background is very simple and cleaner. 

CAP_SYS_RESOURCE mean the process has a privilege of using more resource.
then, oom-killer gave it additonal bonus.

CAP_SYS_RAWIO mean the process has a direct hardware access privilege
(eg X.org, RDB). and then, killing it might makes system crash.


In another story, somebody doubt 4x bonus is good or not. but 3% has
the same problem.




