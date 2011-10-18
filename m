Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab1JRVH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 17:07:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64417 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab1JRVH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 17:07:57 -0400
X-Authority-Analysis: v=1.1 cv=cRnbtTsVO6wWDdOYuq0VmyuiiLG/FStMSb4CWlTvuS0= c=1 sm=0 a=FyDICSIpE5IA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=FzyTmyQx500x1eZmhIMA:9 a=SccET_7KKY2lUYcTvTgA:7 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH] jump_label_inc may return before the code is patched
From: Steven Rostedt <rostedt@goodmis.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20111018175551.GH17571@redhat.com>
References: <20111018175551.GH17571@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Oct 2011 17:06:25 -0400
Message-ID: <1318971986.3712.18.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-18 at 19:55 +0200, Gleb Natapov wrote:
> If cpu A calls jump_label_inc() just after atomic_add_return() is
> called by cpu B, atomic_inc_not_zero() will return value greater then
> zero and jump_label_inc() will return to a caller before jump_label_update()
> finishes its job on cpu B.

OK, I see what you are saying. There's a race here that jump_label_inc
may return before jump labels are actually activated. I have no issue
with this change. This guarantees that jump labels will be active on
return of jump_label_inc().

I'm assuming that jump_label_update() does memory barries, as it does
modify code, and would be itself a synchronization point.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> 
> Signed-off-by: Gleb Natapov <gleb@redhat.com>
> diff --git a/kernel/jump_label.c b/kernel/jump_label.c
> index a8ce450..e6f1f24 100644
> --- a/kernel/jump_label.c
> +++ b/kernel/jump_label.c
> @@ -66,8 +66,9 @@ void jump_label_inc(struct jump_label_key *key)
>  		return;
>  
>  	jump_label_lock();
> -	if (atomic_add_return(1, &key->enabled) == 1)
> +	if (atomic_read(&key->enabled) == 0)
>  		jump_label_update(key, JUMP_LABEL_ENABLE);
> +	atomic_inc(&key->enabled);
>  	jump_label_unlock();
>  }
>  
> --
> 			Gleb.


