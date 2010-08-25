Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab0HYVvD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 17:51:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751388Ab0HYVvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 17:51:00 -0400
Date: Wed, 25 Aug 2010 14:49:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Zhang, Wei-Jovi (NSN - CN/Hangzhou)" <wei-jovi.zhang@nsn.com>,
        mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]exit.c: support larger exit code
Message-Id: <20100825144954.233b6d3c.akpm@linux-foundation.org>
In-Reply-To: <20100806124456.GA9107@redhat.com>
References: <14414B36FFA0F1418CB707361EAA199A0194F7D2@CNBEEXC006.nsn-intra.net>
	<20100806124456.GA9107@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Aug 2010 14:44:56 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> On 08/06, Zhang, Wei-Jovi (NSN - CN/Hangzhou) wrote:
> >
> > Nowadays userspace application use systemcall exit/exit_group only
> > support one byte exit code.
> > In some cases this exit code range is too small for some "big
> > application"(like telecom software, 255 is not enough).
> >
> > So we can give some "big application" a chance to get larger exit code
> > from child process.
> > For other application don't want use larger exit code, they can use
> > marco WEXITSTATUS to get lower one byte exit code.
> >
> > #define WEXITSTATUS(status)   __WEXITSTATUS (__WAIT_INT (status))
> > --- stdlib.h
> > #define       __WEXITSTATUS(status)   (((status) & 0xff00) >> 8)
> > --- usrbits/waitstatus.h
> >
> >
> > diff --git a/kernel/exit.c b/kernel/exit.c
> > index ceffc67..8b13676 100644
> > --- a/kernel/exit.c
> > +++ b/kernel/exit.c
> > @@ -1045,7 +1045,7 @@ EXPORT_SYMBOL(complete_and_exit);
> >
> >  SYSCALL_DEFINE1(exit, int, error_code)
> >  {
> > -       do_exit((error_code&0xff)<<8);
> > +       do_exit(error_code << 8);
> >  }
> >
> >  /*
> > @@ -1086,7 +1086,7 @@ do_group_exit(int exit_code)
> >   */
> >  SYSCALL_DEFINE1(exit_group, int, error_code)
> >  {
> > -       do_group_exit((error_code & 0xff) << 8);
> > +       do_group_exit(error_code << 8);
> >         /* NOTREACHED */
> >         return 0;
> >  }
> 
> Hmm. Looking at this patch, I am wondering what was the reason for the
> current one-byte limitation.
> 
> I think the patch is fine. si_status, wo_stat are int too, so I do not
> see any possibility for truncation before reporting to user-space.
> 

There are back-compatibility issues.   If my crufty old child does

	exit(0xff01);

and my crufty old parent does

	if (exit_code == 1)

then I think the patch just broke my application.  The company which
wrote it no longer exists and I don't have source...

Is it worth this risk?


Also, the patch was missing a signed-off-by: and was in some complicated
html-in-mime format.
