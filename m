Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab0JVAMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 20:12:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750774Ab0JVAMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 20:12:40 -0400
Date: Thu, 21 Oct 2010 17:12:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v2.6.36-rc7] init: don't call flush_scheduled_work()
 from do_initcalls()
Message-Id: <20101021171203.37d0d6d6.akpm@linux-foundation.org>
In-Reply-To: <4CB86F94.7080702@kernel.org>
References: <4CB86F94.7080702@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Oct 2010 17:13:24 +0200
Tejun Heo <tj@kernel.org> wrote:

> It's unclear what flush_scheduled_work() in do_initcalls() tries to
> achieve.  The call doesn't make much sense - there already are
> multiple system workqueues which aren't affected by
> flush_scheduled_wokr() and subsystems are free to create and use their
> own.  Ordering requirements are and should be expressed explicitly.
> 
> Drop the call to prepare for deprecation and removal of
> flush_scheduled_work().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
> If no one objects, I'll route this through wq tree.
> 
> Thank you.
> 
>  init/main.c |    3 ---
>  1 file changed, 3 deletions(-)
> 
> Index: work/init/main.c
> ===================================================================
> --- work.orig/init/main.c
> +++ work/init/main.c
> @@ -778,9 +778,6 @@ static void __init do_initcalls(void)
> 
>  	for (fn = __early_initcall_end; fn < __initcall_end; fn++)
>  		do_one_initcall(*fn);
> -
> -	/* Make sure there is no pending stuff from the initcall sequence */
> -	flush_scheduled_work();
>  }
> 

hm, that predates the initial 2002 BK tree.

If some initcall function leaves a work scheduled and doesn't flush it
then free_initmem() can come along and pull the rug out from under its
feet.  Then you will own both pieces :)

If you really don't like people sending you angry emails then I suppose
you could add some warning here if a scheduled work is pending, and
that the scheduled work's callback existed in init.text memory.  Which
would be a bit of a pain to implement.

Oh well.  The oops traces will make it fairly clear what happened.
