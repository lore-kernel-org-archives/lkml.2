Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab0LBAsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 19:48:06 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58675 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab0LBAsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 19:48:05 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] do_exit(): Make sure we run with get_fs() == USER_DS.
Cc: kosaki.motohiro@jp.fujitsu.com, Nelson Elhage <nelhage@ksplice.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101201163001.fa185a50.akpm@linux-foundation.org>
References: <20101201115018.ABAE.A69D9226@jp.fujitsu.com> <20101201163001.fa185a50.akpm@linux-foundation.org>
Message-Id: <20101202094822.1576.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  2 Dec 2010 09:48:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > diff --git a/kernel/exit.c b/kernel/exit.c
> > > index 21aa7b3..68899b3 100644
> > > --- a/kernel/exit.c
> > > +++ b/kernel/exit.c
> > > @@ -914,6 +914,14 @@ NORET_TYPE void do_exit(long code)
> > >  	if (unlikely(!tsk->pid))
> > >  		panic("Attempted to kill the idle task!");
> > >  
> > > +	/*
> > > +	 * If do_exit is called because this processes oopsed, it's possible
> > > +	 * that get_fs() was left as KERNEL_DS, so reset it to USER_DS before
> > > +	 * continuing. This is relevant at least for clearing clear_child_tid in
> > > +	 * mm_release.
> > > +	 */
> > > +	set_fs(USER_DS);
> > 
> > "This is relevant" is no good explanation ;)
> > Please recognize this is tricky code and Please consider to write more 
> > careful and looooong comments.
> 
> I've seen worse comments.  And occasionally none at all :)
> 
> Is this better?
> 
> --- a/kernel/exit.c~do_exit-make-sure-we-run-with-get_fs-==-user_ds-fix
> +++ a/kernel/exit.c
> @@ -917,8 +917,9 @@ NORET_TYPE void do_exit(long code)
>  	/*
>  	 * If do_exit is called because this processes oopsed, it's possible
>  	 * that get_fs() was left as KERNEL_DS, so reset it to USER_DS before
> -	 * continuing. This is relevant at least for clearing clear_child_tid in
> -	 * mm_release.
> +	 * continuing. Amongst other possible reasons, this is to prevent
> +	 * mm_release()->clear_child_tid() from writing to a user-controlled
> +	 * kernel address.
>  	 */

Great!



