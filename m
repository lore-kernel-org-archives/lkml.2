Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab1CNUuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 16:50:18 -0400
Received: from smtp-out.google.com ([216.239.44.51]:26924 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab1CNUuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 16:50:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=p+M21XcbsvEVBEB6xQkqagmAYMVHXRxuDsEocDfgzImf5pRyMGBaWEFMNHYubhxDIN
         9G9jlBkCzfhKumal2djg==
Date: Mon, 14 Mar 2011 13:50:11 -0700 (PDT)
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
Subject: Re: [PATCH 2/3 for 2.6.38] oom: select_bad_process: ignore TIF_MEMDIE
 zombies
In-Reply-To: <20110314190508.GC21845@redhat.com>
Message-ID: <alpine.DEB.2.00.1103141344460.31514@chino.kir.corp.google.com>
References: <20110303100030.B936.A69D9226@jp.fujitsu.com> <20110308134233.GA26884@redhat.com> <alpine.DEB.2.00.1103081549530.27910@chino.kir.corp.google.com> <20110309151946.dea51cde.akpm@linux-foundation.org> <alpine.DEB.2.00.1103111142260.30699@chino.kir.corp.google.com>
 <20110312123413.GA18351@redhat.com> <20110312134341.GA27275@redhat.com> <AANLkTinHGSb2_jfkwx=Wjv96phzPCjBROfCTFCKi4Wey@mail.gmail.com> <20110313212726.GA24530@redhat.com> <20110314190419.GA21845@redhat.com> <20110314190508.GC21845@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011, Oleg Nesterov wrote:

> select_bad_process() assumes that a TIF_MEMDIE process should go away.
> But it can only go away it its parent does wait(). Change this check to
> ignore the TIF_MEMDIE zombies.
> 

The equivalent of this change would be to set TIF_MEMDIE for all threads 
in a thread group when choosing a process to kill; as we've already 
discussed in your first series of patches, that has the risk of fully 
depleting memory reserves and causing the kernel the deadlock.  We want to 
limit TIF_MEMDIE to an oom killed task or to current when it is responding 
to a SIGKILL or already in the exit path because we know it's exiting and 
without memory reserves it may never exit.

This patch is even more concerning, however, because select_bad_process() 
isn't even guaranteed to select a thread from the same thread group this 
time.

> Note: this is _not_ enough. Just a minimal fix.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
> 
>  mm/oom_kill.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- 38/mm/oom_kill.c~2_tif_memdie_zombie	2011-03-14 18:51:49.000000000 +0100
> +++ 38/mm/oom_kill.c	2011-03-14 18:52:39.000000000 +0100
> @@ -311,7 +311,8 @@ static struct task_struct *select_bad_pr
>  		 * blocked waiting for another task which itself is waiting
>  		 * for memory. Is there a better alternative?
>  		 */
> -		if (test_tsk_thread_flag(p, TIF_MEMDIE))
> +		if (test_tsk_thread_flag(p, TIF_MEMDIE) &&
> +		    !p->exit_state && thread_group_empty(p))
>  			return ERR_PTR(-1UL);
>  
>  		/*
> 
> 
