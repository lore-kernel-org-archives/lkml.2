Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab1COTvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 15:51:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:47858 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758536Ab1COTvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 15:51:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=aCAcUkHOradMt2FP7yhpQVJKbRJYDz9XeMtkNUDDu91D/YvyYnpdwkDONvIajA5L4K
         abYOXkqFbDeBKbH3Q8GQ==
Date: Tue, 15 Mar 2011 12:51:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrey Vagin <avagin@openvz.org>,
        Frantisek Hrbata <fhrbata@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 for 2.6.38] oom: oom_kill_process: don't set TIF_MEMDIE
 if !p->mm
In-Reply-To: <20110315191256.GB21640@redhat.com>
Message-ID: <alpine.DEB.2.00.1103151245020.558@chino.kir.corp.google.com>
References: <20110309151946.dea51cde.akpm@linux-foundation.org> <alpine.DEB.2.00.1103111142260.30699@chino.kir.corp.google.com> <20110312123413.GA18351@redhat.com> <20110312134341.GA27275@redhat.com> <AANLkTinHGSb2_jfkwx=Wjv96phzPCjBROfCTFCKi4Wey@mail.gmail.com>
 <20110313212726.GA24530@redhat.com> <20110314190419.GA21845@redhat.com> <20110314190446.GB21845@redhat.com> <AANLkTi=YnG7tYCSrCPTNSQANOkD2MkP0tMjbOyZbx4NG@mail.gmail.com> <alpine.DEB.2.00.1103141322390.31514@chino.kir.corp.google.com>
 <20110315191256.GB21640@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Mar 2011, Oleg Nesterov wrote:

> When I did this change I looked at 81236810226f71bd9ff77321c8e8276dae7efc61
> and the changelog says:
> 
> 	__oom_kill_task() is called to elevate the task's timeslice and give it
> 	access to memory reserves so that it may quickly exit.
> 
> 	This privilege is unnecessary, however, if the task has already detached
> 	its mm.
> 
> Now you are saing this is pointless.
> 

If you have the commit id, do a "git blame 8123681022", because I see a:

5081dde3 (Nick Piggin        2006-09-25 23:31:32 -0700 222)             if (!p->mm)
5081dde3 (Nick Piggin        2006-09-25 23:31:32 -0700 223)                     continue;

in select_bad_process() and it's also iterating over every thread:

a49335cc (Paul Jackson       2005-09-06 15:18:09 -0700 215)     do_each_thread(g, p) {

It's pointless since oom-skip-zombies-when-iterating-tasklist.patch in 
-mm reintroduced the filter for !p->mm in select_bad_process() which was 
still there when 81236810 was merged; it's a small optimization, though, 
to avoid races where the mm becomes detached between the process' 
selection in select_bad_process() and its kill in oom_kill_process().

> The problem is, we can't trust per-thread PF_EXITING checks. But I guess
> we will discuss this more anyway.
> 

My approach, as you saw with 
oom-avoid-deferring-oom-killer-if-exiting-task-is-being-traced.patch in 
-mm is to add exceptions to the oom killer when we can't trust that 
PF_EXITING will soon be exiting.  I think that's a much more long-term 
maintainable solution instead of inferring the status of a thread based on 
external circumstances (such as number of threads in the thread group) 
that could easily change out from under us and once again break the oom 
killer.
