Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab1JKXW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 19:22:56 -0400
Received: from smtp-out.google.com ([216.239.44.51]:28181 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab1JKXWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 19:22:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type;
	b=Tg9bbyrW5h9C8M5evbNFozHi4wO+yAkwjlZap5fdSEwde/oA2nXQsBBdyv2yeCa/+
	2pd0V58J+BUJc+G6Rv00Q==
Date: Tue, 11 Oct 2011 16:22:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Satoru Moriya <satoru.moriya@hds.com>, Con Kolivas <kernel@kolivas.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Satoru Moriya <smoriya@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, "lwoodman@redhat.com" <lwoodman@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, Hugh Dickins <hughd@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: RE: [PATCH -v2 -mm] add extra free kbytes tunable
In-Reply-To: <65795E11DBF1E645A09CEC7EAEE94B9CB516CBC4@USINDEVS02.corp.hds.com>
Message-ID: <alpine.DEB.2.00.1110111612120.5236@chino.kir.corp.google.com>
References: <20110901105208.3849a8ff@annuminas.surriel.com> <20110901100650.6d884589.rdunlap@xenotime.net> <20110901152650.7a63cb8b@annuminas.surriel.com> <alpine.DEB.2.00.1110072001070.13992@chino.kir.corp.google.com> <20111010153723.6397924f.akpm@linux-foundation.org>
 <65795E11DBF1E645A09CEC7EAEE94B9CB516CBC4@USINDEVS02.corp.hds.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Oct 2011, Satoru Moriya wrote:

> Actually page allocator decreases min watermark to 3/4 * min watermark
> for rt-task. But in our case some applications create a lot of
> processes and if all of them are rt-task, the amount of watermark
> bonus(1/4 * min watermark) is not enough.
> 

Right, if you can exhaust (1/4 * min_wmark) of memory quickly enough, 
you'll still have latency issues.

> If we can tune the amount of bonus, it may be fine. But that is
> almost all same as extra free kbytes.
> 

I don't know if your test case is the only thing that Rik is looking at, 
but if so, then that statement makes me believe that this patch is 
definitely in the wrong direction, so NACK on it until additional 
information is presented.  The reasoning is simple: if tuning the bonus 
given to rt-tasks in the page allocator itself would fix the issue, then 
we can certainly add logic specifically for rt-tasks that can reclaim more 
aggressively without needing any tunable from userspace (and _certainly_ 
not a global tunable that affects every application!).

> > Does there exist anything like a test case which demonstrates the need 
> > for this feature?
> 
> Unfortunately I don't have a real test case but just simple one.
> And in my simple test case, I can avoid direct reclaim if we set
> workload as rt-task.
> 
> The simple test case I used is following:
> http://marc.info/?l=linux-mm&m=131605773321672&w=2
> 

I tried proposing one of Con's patches from his BFS scheduler ("mm: adjust 
kswapd nice level for high priority page") about 1 1/2 years ago that I 
recall and believe may significantly help your test case.  The thread is 
at http://marc.info/?t=126743860700002.  (There's a lot of interesting 
things in Con's patchset that can be pulled into the VM, this isn't the 
only one.)

The patch wasn't merged back then because we wanted a test case that was 
specifically fixed by this issue, and it may be that we have just found 
one.  If you could try it out without any extra_free_kbytes, I think we 
may be able to help your situation.
