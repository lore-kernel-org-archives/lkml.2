Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab0KIVQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:16:19 -0500
Received: from smtp-out.google.com ([216.239.44.51]:56374 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab0KIVQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:16:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=v6Zz+Xc04Hp80DaCuWTk1RAQQiJLhvl3lf1YNHEDbeNgtn3SOyGFsodzToEmEIzWaD
         UQSDptHyCe9mL+z1gyYQ==
Date: Tue, 9 Nov 2010 13:16:12 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Figo.zhang" <figo1802@gmail.com>
cc: lkml <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2]mm/oom-kill: direct hardware access processes should
 get bonus
In-Reply-To: <1289305468.10699.2.camel@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1011091307240.7730@chino.kir.corp.google.com>
References: <1288662213.10103.2.camel@localhost.localdomain> <1289305468.10699.2.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Nov 2010, Figo.zhang wrote:

>  
> the victim should not directly access hardware devices like Xorg server,
> because the hardware could be left in an unpredictable state, although 
> user-application can set /proc/pid/oom_score_adj to protect it. so i think
> those processes should get 3% bonus for protection.
> 

The logic here is wrong: if killing these tasks can leave hardware in an 
unpredictable state (and that state is presumably harmful), then they 
should be completely immune from oom killing since you're still leaving 
them exposed here to be killed.

So the question that needs to be answered is: why do these threads deserve 
to use 3% more memory (not >4%) than others without getting killed?  If 
there was some evidence that these threads have a certain quantity of 
memory they require as a fundamental attribute of CAP_SYS_RAWIO, then I 
have no objection, but that's going to be expressed in a memory quantity 
not a percentage as you have here.

The CAP_SYS_ADMIN heuristic has a background: it is used in the oom killer 
because we have used the same 3% in __vm_enough_memory() for a long time 
and we want consistency amongst the heuristics.  Adding additional bonuses 
with arbitrary values like 3% of memory for things like CAP_SYS_RAWIO 
makes the heuristic less predictable and moves us back toward the old 
heuristic which was almost entirely arbitrary.

Now before KOSAKI-san comes out and says the old heuristic considered 
CAP_SYS_RAWIO and the new one does not so it _must_ be a regression: the 
old heuristic also divided the badness score by 4 for that capability as a 
completely arbitrary value (just like 3% is here).  Other traits like 
runtime and nice levels were also removed from the heuristic.  What needs 
to be shown is that CAP_SYS_RAWIO requires additional memory just to run 
or we should neglect to free 3% of memory, which could be gigabytes, 
because it has this trait.
