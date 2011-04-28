Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751099Ab1D1BpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 21:45:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34353 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab1D1BpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 21:45:13 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] proc: fix pagemap_read() error case (was Re: [PATCH] proc: put check_mem_permission before __get_free_page in mem_read)
Cc: kosaki.motohiro@jp.fujitsu.com, bookjovi@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Stephen Wilson <wilsons@start.ca>,
        open list <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LSU.2.00.1104261321550.9533@sister.anvils>
References: <20110426145226.F383.A69D9226@jp.fujitsu.com> <alpine.LSU.2.00.1104261321550.9533@sister.anvils>
Message-Id: <20110428104658.D18C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Thu, 28 Apr 2011 10:45:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Great, thank you.  Though I see Steve has cleverly spotted another:
> yes, that should be worth looking into, but I've not studied it.
> 
> I confess that when I wrote yesterday, I thought there were a lot more
> such instances in fs/proc.  I thought /proc/pid/smaps was vulnerable,
> for example, but I cannot see that now: maybe I just confused it with
> /proc/pid/pagemap.
> 
> I was worrying about this a couple of months ago, when David had an
> OOM dump with OOM-killed threads failing to exit because they could
> not skb_alloc in proc_exit_connector()'s cn_netlink_send() - connector
> needs to allocate skb upfront (I'm being vague!), not when thread exits.
>
> But it was a mystery why memory was still unavailable at that late
> stage: my unsubstantiated suspicion was that something else was
> holding on to the mm-to-be-freed while trying to allocate memory.

Hi

Thank you for the explanation.

Today, I revisit get_task_mm() users. So, I found four suspect codes
for google usecase.

o CPUSET
  cpuset_change_nodemask() and cpuset_attach() call do_migrate_pages()
  under holding mm reference. That said, If you try to attach crazy large
  application, you can face the "OOM-killed threads failing to exit" issue.

o /proc/{pid}/cmdline and /proc/{pid}/environ
  proc_pid_cmdline() and environ_read() call get_user_pages() under holding
  mm reference. That said, If you run system monitor process and it periodically
  read the above interface, oom-kill can't gurantte to work.

So, I'll second that Linus said we should remove TIF_MEMDIE and PF_EXITING check
from select_bad_process(). Or at least, We have to make timeout and try to kill
next process if timeout is happen.

And, as Oleg said at past, maybe we have to make MMF_OOM_KILLED and page fault
should detect it.




