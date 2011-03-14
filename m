Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab1CNUW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 16:22:26 -0400
Received: from smtp-out.google.com ([216.239.44.51]:16313 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab1CNUWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 16:22:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=ZC72x13Jkzm6GWjmaLl8BZ8CPzXH6dOkOUtYxFYhco5PIo/AMqf9sBoxD9j81qF103
         OLQIyKBGe0bcX6WjtaOQ==
Date: Mon, 14 Mar 2011 13:22:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>
cc: Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrey Vagin <avagin@openvz.org>,
        Frantisek Hrbata <fhrbata@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 for 2.6.38] oom: oom_kill_process: don't set TIF_MEMDIE
 if !p->mm
In-Reply-To: <20110314190446.GB21845@redhat.com>
Message-ID: <alpine.DEB.2.00.1103141314190.31514@chino.kir.corp.google.com>
References: <20110303100030.B936.A69D9226@jp.fujitsu.com> <20110308134233.GA26884@redhat.com> <alpine.DEB.2.00.1103081549530.27910@chino.kir.corp.google.com> <20110309151946.dea51cde.akpm@linux-foundation.org> <alpine.DEB.2.00.1103111142260.30699@chino.kir.corp.google.com>
 <20110312123413.GA18351@redhat.com> <20110312134341.GA27275@redhat.com> <AANLkTinHGSb2_jfkwx=Wjv96phzPCjBROfCTFCKi4Wey@mail.gmail.com> <20110313212726.GA24530@redhat.com> <20110314190419.GA21845@redhat.com> <20110314190446.GB21845@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011, Oleg Nesterov wrote:

> oom_kill_process() simply sets TIF_MEMDIE and returns if PF_EXITING.
> This is very wrong by many reasons. In particular, this thread can
> be the dead group leader. Check p->mm != NULL.
> 

This is true only for the oom_kill_allocating_task sysctl where it is 
required in all cases to kill current; current won't be triggering the oom 
killer if it's dead.

oom_kill_process() is called with the thread selected by 
select_bad_process() and that function will not return any thread if any 
eligible task is found to be PF_EXITING and is not current, or any 
eligible task is found to have TIF_MEMDIE.

In other words, for this conditional to be true in oom_kill_process(), 
then p must be current and so it cannot be the dead group leader as 
specified in your changelog unless PF_EXITING gets set between 
select_bad_process() and the oom_kill_process() call: we don't care about 
that since it's in the exit path and we therefore want to give it access 
to memory reserves to quickly exit anyway and the check for PF_EXITING in 
select_bad_process() prevents any infinite loop of that task getting 
constantly reselected if it's dead.

> Note: this is _not_ enough. Just a minimal fix.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
> 
>  mm/oom_kill.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- 38/mm/oom_kill.c~1_kill_fix_pf_exiting	2011-03-14 17:53:05.000000000 +0100
> +++ 38/mm/oom_kill.c	2011-03-14 18:51:49.000000000 +0100
> @@ -470,7 +470,7 @@ static int oom_kill_process(struct task_
>  	 * If the task is already exiting, don't alarm the sysadmin or kill
>  	 * its children or threads, just set TIF_MEMDIE so it can die quickly
>  	 */
> -	if (p->flags & PF_EXITING) {
> +	if (p->flags & PF_EXITING && p->mm) {
>  		set_tsk_thread_flag(p, TIF_MEMDIE);
>  		boost_dying_task_prio(p, mem);
>  		return 0;
> 
> 
