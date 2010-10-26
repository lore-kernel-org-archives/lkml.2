Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530Ab0JZHZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 03:25:59 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36727 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758251Ab0JZHZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 03:25:56 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: pageexec@freemail.hu
Subject: Re: [resend][PATCH 4/4] oom: don't ignore rss in nascent mm
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Solar Designer <solar@openwall.com>, Eugene Teo <eteo@redhat.com>,
        Brad Spengler <spender@grsecurity.net>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
In-Reply-To: <4CC569DB.17734.314BBE7A@pageexec.freemail.hu>
References: <20101025122914.9173.A69D9226@jp.fujitsu.com> <4CC569DB.17734.314BBE7A@pageexec.freemail.hu>
Message-Id: <20101026155614.B7BC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 26 Oct 2010 16:25:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Thank you for reviewing.

> what happens when two (or more) threads in the same process call execve? the
> above set_exec_mm calls will race (de_thread doesn't happen until much later
> in execve) and overwrite each other's ->in_exec_mm which will still lead to
> problems since there will be at most one temporary mm accounted for in the
> oom killer.

patch 3/4 prevent this race :)
now, 3/4 move cred_guard_mutex into signal struct. and execve() take 
signal->cred_guard_mutex for protecting concurent execve race.


> [update: since i don't seem to have been cc'd on the other patch that
> serializes execve, the above point is moot ;)]

Ah, sorry. that's my mistake. I thought you've reviewed this one at
my last posting. 

can you please see 3/4? the URL is below.

http://www.gossamer-threads.com/lists/linux/kernel/1293297?do=post_view_threaded

> worse, even if each temporary mm was tracked separately there'd still be a
> race where the oom killer can get triggered with the culprit thread long
> gone (and reset ->in_exec_mm) and never to be found, so the oom killer would
> find someone else as guilty.

Sorry, I haven't got this point. can you please elaborate this worse scenario? 


> now all this leads me to suggest a simpler solution, at least for the first
> problem mentioned above (i don't know what to do with the second one yet as
> it seems to be a generic issue with the oom killer, probably it should verify
> the oom situation once again after it took the task_list lock).
> 
> [update: while the serialized execve solves the first problem, i still think
> that my idea is simpler and worth considering, so i leave it here even if for
> just documentation purposes ;)]
> 
> given that all the oom killer needs from the mm struct is either ->total_pages
> (in .35 and before, so be careful with the stable backport) or some ->rss_stat
> counters, wouldn't it be much easier to simply transfer the bprm->mm counters
> into current->mm for the duration of the execve (say, add them in get_arg_page
> and remove them when bprm->mm is mmput in the do_execve failure path, etc)? the
> transfer can be either to the existing counters or to new ones (obviously in
> the latter case the oom code needs a small change to take the new counters into
> account as well).

As I said at previous discussion, It is possible and one of option. and I've
made the patch of this way too at once. But, It is messy than current. because
pages in nascent mm are also swappable. then, a swapping-out of such page need
to update both mm->rss_stat and nascent_mm->rss_stat. IOW, we need to change 
VM core. But, actually, execve vs OOM race is very rarely event, then, I don't 
hope to add some new branch and complexity.

Note: before 2.6.35, oom_kill.c track amount of process virtual address space.
then changing get_arg_page() is enough. but on 2.6.36 or later, oom_kill.c track
amount of process rss. then we can't ignore swap in/out event. and changing
get_arg_page() is not enough. Or, Do you propse new OOM account 
mm->rss + nascent_mm->total_vm? this can be easily. but tricky more.

So, I think this is one of trade-off issue. If you have better patch rather
than me, I'm glad to accept your one and join to review it. However myself 
don't plan to take this approach.


Thanks.



