Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab0FAUm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:42:57 -0400
Received: from smtp-out.google.com ([74.125.121.35]:41594 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab0FAUm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:42:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ckmvyj3iXx0IAx1Vd1I5RH5MXMzmL4gLhUT0Q1WwFSPGPRPa4fMUlWlAy7lSPaucZ
	Ohud/IUHvZ3awe3v0MGNA==
Date: Tue, 1 Jun 2010 13:42:49 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 3/5] oom: introduce find_lock_task_mm() to fix !mm false
 positives
In-Reply-To: <20100531183539.1849.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1006011341380.13136@chino.kir.corp.google.com>
References: <20100531182526.1843.A69D9226@jp.fujitsu.com> <20100531183539.1849.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 May 2010, KOSAKI Motohiro wrote:

> From: Oleg Nesterov <oleg@redhat.com>
> Subject: [PATCH 3/5] oom: introduce find_lock_task_mm() to fix !mm false positives
> 
> Almost all ->mm == NUL checks in oom_kill.c are wrong.
> 
> The current code assumes that the task without ->mm has already
> released its memory and ignores the process. However this is not
> necessarily true when this process is multithreaded, other live
> sub-threads can use this ->mm.
> 
> - Remove the "if (!p->mm)" check in select_bad_process(), it is
>   just wrong.
> 
> - Add the new helper, find_lock_task_mm(), which finds the live
>   thread which uses the memory and takes task_lock() to pin ->mm
> 
> - change oom_badness() to use this helper instead of just checking
>   ->mm != NULL.
> 
> - As David pointed out, select_bad_process() must never choose the
>   task without ->mm, but no matter what badness() returns the
>   task can be chosen if nothing else has been found yet.
> 
> Note! This patch is not enough, we need more changes.
> 
> 	- badness() was fixed, but oom_kill_task() still ignores
> 	  the task without ->mm
> 
> This will be addressed later.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Cc: David Rientjes <rientjes@google.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [rebase
> latest -mm and remove some obsoleted description]

This is already pushed as part of my oom killer rewrite in patch 15/18 
"oom: introduce find_lock_task_mm to fix !mm false positives".
