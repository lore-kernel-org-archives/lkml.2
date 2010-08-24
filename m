Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab0HXF4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 01:56:09 -0400
Received: from ozlabs.org ([203.10.76.45]:46368 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab0HXF4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 01:56:08 -0400
From: Michael Neuling <mikey@neuling.org>
To: Eric Paris <eparis@redhat.com>
cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, anton@samba.org, sgrubb@redhat.com
Subject: Re: [PATCH] audit: speedup for syscalls when auditing is disabled
In-reply-to: <1282621410.26616.406.camel@localhost.localdomain>
References: <29151.1282270393@neuling.org> <1282586177.2681.43.camel@localhost.localdomain> <20887.1282615880@neuling.org> <1282621410.26616.406.camel@localhost.localdomain>
Comments: In-reply-to Eric Paris <eparis@redhat.com>
   message dated "Mon, 23 Aug 2010 23:43:30 -0400."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Tue, 24 Aug 2010 15:56:07 +1000
Message-ID: <5994.1282629367@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > I wonder if you could get much back, in terms of performance, by moving
> > > the
> > >          context->dummy = !audit_n_rules;
> > > line to the top and just returning if context->dummy == 1;
> > 
> > We get 668.09 cycles with this optimisation, so it comes down a bit, but
> > no where near if the auditing is disabled altogether.
> 
> Clean that patch up and send it.  Sounds like a win no matter what else
> we do.

ok...

audit: speedup audit_syscall_entry when there are zero rules

This creates a check at the start of audit_syscall_entry to see if there
are zero rules in the audit filter list.  If there are zero rules return
immediately.

This buys about ~10% on a null syscall on powerpc.

Signed-off-by: Michael Neuling <mikey@neuling.org>

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 1b31c13..bc0872b 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1579,6 +1579,9 @@ void audit_syscall_entry(int arch, int major,
 	if (unlikely(!context))
 		return;
 
+	context->dummy = !audit_n_rules;
+	if (context->dummy == 1)
+		return;
 	/*
 	 * This happens only on certain architectures that make system
 	 * calls in kernel_thread via the entry.S interface, instead of
@@ -1628,7 +1631,6 @@ void audit_syscall_entry(int arch, int major,
 	context->argv[3]    = a4;
 
 	state = context->state;
-	context->dummy = !audit_n_rules;
 	if (!context->dummy && state == AUDIT_BUILD_CONTEXT) {
 		context->prio = 0;
 		state = audit_filter_syscall(tsk, context, &audit_filter_list[AUDIT_FILTER_ENTRY]);

