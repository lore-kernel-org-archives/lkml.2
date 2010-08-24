Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab0HXDvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 23:51:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102Ab0HXDvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 23:51:21 -0400
Subject: Re: [PATCH] audit: speedup for syscalls when auditing is disabled
From: Eric Paris <eparis@redhat.com>
To: Anton Blanchard <anton@samba.org>
Cc: Michael Neuling <mikey@neuling.org>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <20100824021625.GA2425@kryten>
References: <29151.1282270393@neuling.org>
	 <1282586177.2681.43.camel@localhost.localdomain>
	 <20100824021625.GA2425@kryten>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Aug 2010 23:51:12 -0400
Message-ID: <1282621872.26616.420.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-24 at 12:16 +1000, Anton Blanchard wrote:
> Hi Eric,
> 
> > I don't think this works at all.  I don't see how syscall audit'ing can
> > work.  What if I have nothing in the AUDIT_FILTER_TASK list but I want
> > to audit all 'open(2)' syscalls?  This patch is going to leave the task
> > in the DISABLED state and we won't ever be able to match on the syscall
> > rules.
> 
> That's a good point. What if we went through and created an audit context
> for each thread at the point where we add a rule to the audit subsystem?
> 
> That would make the common case where no one touches audit go fast. It's
> only once you add a rule that you get the syscall entry/exit overhead of
> audit.
> 
> Anton

It might be viable but I certainly couldn't say.  I'm a bit scared of
allocating and attaching a struct audit_context to a running task as we
have no idea if that task is about to exit a syscall with an unfilled
out audit_context struct nor do I personally off the top of my head know
the task flag setting rules (especially when you want to set other
people's flags)

Maybe another approach would be to move audit_alloc() into the syscall
entry path rather than only at fork().

I think the best solution is going to be some better way of
setting/clearing TIF_SYSCALL_AUDIT. (notice the thing is never cleared,
ever, today)

-Eric

