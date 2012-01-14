Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541Ab2ANAgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 19:36:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55699 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab2ANAf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 19:35:59 -0500
Date: Fri, 13 Jan 2012 16:35:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Valdis.Kletnieks@vt.edu, Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel@vger.kernel.org,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: [PATCH] prctl: add PR_{SET,GET}_CHILD_SUBREAPER to allow simple
 process supervision
Message-Id: <20120113163558.a662e7c5.akpm@linux-foundation.org>
In-Reply-To: <20120109150701.GB1777@redhat.com>
References: <1325951797.860.10.camel@mop>
	<124669.1325952830@turing-police.cc.vt.edu>
	<20120109150701.GB1777@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jan 2012 16:07:01 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> > > +		/* find the first ancestor marked as child_subreaper */
> > > +		for (reaper = father->real_parent;
> > > +		     reaper != &init_task;
> > > +		     reaper = reaper->real_parent) {
> >
> > I admit being insufficiently caffienated - does this DTRT in a PID namespace? That
> > &init_task looks fishy to me...
> 
> Probably this needs a comment. Initially I was confused too.
> 
> Note that the code below checks same_thread_group(reaper, pid_ns->child_reaper),
> this is what we need to DTRT in a PID namespace. However we still need the
> check above, see http://marc.info/?l=linux-kernel&m=131385460420380

In light of Kay's haughty silence, I did this:

--- a/kernel/exit.c~prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix
+++ a/kernel/exit.c
@@ -724,7 +724,13 @@ static struct task_struct *find_new_reap
 	} else if (father->signal->has_child_subreaper) {
 		struct task_struct *reaper;
 
-		/* find the first ancestor marked as child_subreaper */
+		/*
+		 * Find the first ancestor marked as child_subreaper.
+		 * Note that the code below checks same_thread_group(reaper,
+		 * pid_ns->child_reaper).  This is what we need to DTRT in a
+		 * PID namespace. However we still need the check above, see
+		 * http://marc.info/?l=linux-kernel&m=131385460420380
+		 */
 		for (reaper = father->real_parent;
 		     reaper != &init_task;
 		     reaper = reaper->real_parent) {
_

I'm not a fan of URLs-in-comments, but that email was too gnarly to be
condensed into a sane comment.

