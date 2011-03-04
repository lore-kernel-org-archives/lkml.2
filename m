Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760292Ab1CDXlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 18:41:51 -0500
Received: from smtp-out.google.com ([74.125.121.67]:41827 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759896Ab1CDXlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 18:41:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=F9ve8AM7NmwusQF9JidbHcYYKNeV7DmQaBXpjye5MzG7H4tlprEewZMPANLWRNiFzT
         sTXFEDJxjHPywxe1up/w==
Date: Fri, 4 Mar 2011 15:41:41 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrey Vagin <avagin@openvz.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH rh6] mm: skip zombie in OOM-killer
In-Reply-To: <1299274256-2122-1-git-send-email-avagin@openvz.org>
Message-ID: <alpine.DEB.2.00.1103041541040.7795@chino.kir.corp.google.com>
References: <1299274256-2122-1-git-send-email-avagin@openvz.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Mar 2011, Andrey Vagin wrote:

> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 7dcca55..2fc554e 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -311,7 +311,7 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
>  		 * blocked waiting for another task which itself is waiting
>  		 * for memory. Is there a better alternative?
>  		 */
> -		if (test_tsk_thread_flag(p, TIF_MEMDIE))
> +		if (test_tsk_thread_flag(p, TIF_MEMDIE) && p->mm)
>  			return ERR_PTR(-1UL);
>  
>  		/*

I think it would be better to just do

	if (!p->mm)
		continue;

after the check for oom_unkillable_task() because everything that follows 
this really depends on p->mm being non-NULL to actually do anything 
useful.
