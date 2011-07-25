Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab1GYCrD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 22:47:03 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:46286 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752272Ab1GYCq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 22:46:58 -0400
X-Sasl-enc: BalvqE6w0ETx/IQfd1qwZe7drTm9smQaXaUhnXa7hdla 1311562016
Subject: Re: [autofs] Lockdep splat in autofs with 2.6.39-rc2
From: Ian Kent <raven@themaw.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: autofs@linux.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20110421212537.GC24898@home.goodmis.org>
References: <20110407194403.GA29404@elliptictech.com>
	 <20110421212537.GC24898@home.goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jul 2011 10:46:51 +0800
Message-ID: <1311562011.3401.13.camel@perseus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 17:25 -0400, Steven Rostedt wrote:
> On Thu, Apr 07, 2011 at 03:44:03PM -0400, Nick Bowler wrote:
> > Just saw this on 2.6.39-rc2 after half a day or so of uptime.  I've
> > never seen it before today so it may be a regression from 2.6.38.
> > Nothing seems have failed as a result.  Please let me know if you
> > need any more info.
> >
> 
> Could you try this patch. I know it may be hard to reproduce, but the
> issue is that we are recursing down the locks in a tree/list and we changed a
> lock from being nested to being a parent. This patch tells lockdep about
> what we did.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Hi Steven,

It appears this is not included in current mainline yet so I'm guessing
it is still a problem.

Is this the correct way to handle the problem?
Do you want me to forward the patch to Al Viro for inclusion in his tree
and subsequent inclusion in mainline or would you like to do that?

Ian

> 
> 
> diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
> index 450f529..1feb68e 100644
> --- a/fs/autofs4/expire.c
> +++ b/fs/autofs4/expire.c
> @@ -124,6 +124,7 @@ start:
>  	/* Negative dentry - try next */
>  	if (!simple_positive(q)) {
>  		spin_unlock(&p->d_lock);
> +		lock_set_subclass(&q->d_lock.dep_map, 0, _RET_IP_);
>  		p = q;
>  		goto again;
>  	}
> @@ -186,6 +187,7 @@ again:
>  	/* Negative dentry - try next */
>  	if (!simple_positive(ret)) {
>  		spin_unlock(&p->d_lock);
> +		lock_set_subclass(&ret->d_lock.dep_map, 0, _RET_IP_);
>  		p = ret;
>  		goto again;
>  	}
> 
> _______________________________________________
> autofs mailing list
> autofs@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/autofs


