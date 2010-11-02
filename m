Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab0KBDK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 23:10:57 -0400
Received: from smtp-out.google.com ([74.125.121.35]:8704 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab0KBDKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 23:10:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=h+JmAs92FNHB9G4ywhwSGXTcH5HFMN+znlLgGjuf9Q4yAEXWBslMrxJqIGKF6RFeSi
         C9MRBN66d3PvYRsWvbeg==
Date: Mon, 1 Nov 2010 20:10:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Figo.zhang" <figo1802@gmail.com>
cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH]oom-kill: direct hardware access processes should get
 bonus
In-Reply-To: <1288662213.10103.2.camel@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1011012008160.9383@chino.kir.corp.google.com>
References: <1288662213.10103.2.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Nov 2010, Figo.zhang wrote:

> the victim should not directly access hardware devices like Xorg server,
> because the hardware could be left in an unpredictable state, although 
> user-application can set /proc/pid/oom_score_adj to protect it. so i think
> those processes should get 3% bonus for protection.
> 

Which applications are you referring to that cannot gracefully exit if 
killed?

> Signed-off-by: Figo.zhang <figo1802@gmail.com>
> ---
> mm/oom_kill.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 4029583..df6a9da 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -195,10 +195,12 @@ unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
>  	task_unlock(p);
>  
>  	/*
> -	 * Root processes get 3% bonus, just like the __vm_enough_memory()
> -	 * implementation used by LSMs.
> +	 * Root and direct hardware access processes get 3% bonus, just like the
> +	 * __vm_enough_memory() implementation used by LSMs.

LSM's have this bonus for CAP_SYS_ADMIN, but not for CAP_SYS_RAWIO, so 
this comment is incorrect.

>  	 */
> -	if (has_capability_noaudit(p, CAP_SYS_ADMIN))
> +	if (has_capability_noaudit(p, CAP_SYS_ADMIN) ||
> +	    has_capability_noaudit(p, CAP_SYS_RESOURCE) ||
> +	    has_capability_noaudit(p, CAP_SYS_RAWIO))
>  		points -= 30;
>  
>  	/*

CAP_SYS_RAWIO had a much more dramatic impact in the previous heuristic to 
such a point that it would often allow memory hogging tasks to elude the 
oom killer at the expense of innocent tasks.  I'm not sure this is the 
best way to go.
