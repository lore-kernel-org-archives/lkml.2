Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab0LBAaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 19:30:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751475Ab0LBAaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 19:30:08 -0500
Date: Wed, 1 Dec 2010 16:30:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nelson Elhage <nelhage@ksplice.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] do_exit(): Make sure we run with get_fs() ==
 USER_DS.
Message-Id: <20101201163001.fa185a50.akpm@linux-foundation.org>
In-Reply-To: <20101201115018.ABAE.A69D9226@jp.fujitsu.com>
References: <20101130174947.5ccc3778.akpm@linux-foundation.org>
	<1291170456-22580-1-git-send-email-nelhage@ksplice.com>
	<20101201115018.ABAE.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  1 Dec 2010 11:50:32 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > If a user manages to trigger an oops with fs set to KERNEL_DS, fs is not
> > otherwise reset before do_exit(). do_exit may later (via mm_release in fork.c)
> > do a put_user to a user-controlled address, potentially allowing a user to
> > leverage an oops into a controlled write into kernel memory.
> > 
> > A more logical place to put this might be when we know an oops has occurred,
> > before we call do_exit(), but that would involve changing every architecture, in
> > multiple places. Let's just stick it in do_exit instead.
> > 
> > Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
> > ---
> >  kernel/exit.c |    8 ++++++++
> >  1 files changed, 8 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/exit.c b/kernel/exit.c
> > index 21aa7b3..68899b3 100644
> > --- a/kernel/exit.c
> > +++ b/kernel/exit.c
> > @@ -914,6 +914,14 @@ NORET_TYPE void do_exit(long code)
> >  	if (unlikely(!tsk->pid))
> >  		panic("Attempted to kill the idle task!");
> >  
> > +	/*
> > +	 * If do_exit is called because this processes oopsed, it's possible
> > +	 * that get_fs() was left as KERNEL_DS, so reset it to USER_DS before
> > +	 * continuing. This is relevant at least for clearing clear_child_tid in
> > +	 * mm_release.
> > +	 */
> > +	set_fs(USER_DS);
> 
> "This is relevant" is no good explanation ;)
> Please recognize this is tricky code and Please consider to write more 
> careful and looooong comments.

I've seen worse comments.  And occasionally none at all :)

Is this better?

--- a/kernel/exit.c~do_exit-make-sure-we-run-with-get_fs-==-user_ds-fix
+++ a/kernel/exit.c
@@ -917,8 +917,9 @@ NORET_TYPE void do_exit(long code)
 	/*
 	 * If do_exit is called because this processes oopsed, it's possible
 	 * that get_fs() was left as KERNEL_DS, so reset it to USER_DS before
-	 * continuing. This is relevant at least for clearing clear_child_tid in
-	 * mm_release.
+	 * continuing. Amongst other possible reasons, this is to prevent
+	 * mm_release()->clear_child_tid() from writing to a user-controlled
+	 * kernel address.
 	 */
 	set_fs(USER_DS);
 
_

