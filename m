Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab0HXPR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:17:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277Ab0HXPRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:17:54 -0400
Subject: Re: [PATCH] audit: speedup for syscalls when auditing is disabled
From: Eric Paris <eparis@redhat.com>
To: Miloslav Trmac <mitr@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, anton@samba.org,
        Al Viro <viro@zeniv.linux.org.uk>, Michael Neuling <mikey@neuling.org>
In-Reply-To: <1147049992.1241541282662896620.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
References: <1147049992.1241541282662896620.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 11:17:44 -0400
Message-ID: <1282663064.13142.113.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-24 at 11:14 -0400, Miloslav Trmac wrote:
> ----- "Eric Paris" <eparis@redhat.com> wrote:
> > Add a new spot in the assembly which will call a function which will
> > check if audit_n_rules > 0 and if so will set TIF_SYSCALL_AUDIT and if
> > not will clear TIF_SYSCALL_AUDIT?  It might make things slightly worse
> > on systems which explictly disable audit and the flag would always be
> > clear on every task (like you did with the explicit rule) but I'm
> > guessing might be a win on systems with no rules which are wasting time
> > on the audit slow path.....
> Is "audit_n_rules" a specific enough trigger?  Right now, even if
> there are no rules configured at all, audit_log_start() while
> processing a syscall will mark that syscall for auditing, and all
> collected information about the syscall will be logged at syscall
> exit.
> 
> Would the suggested change break this behavior?

That's correct, if there are 0 rules we still collect information while
knowing that it will get thrown away at the end (since obviously no rule
is going to switch the state from 'build' to 'on')

The only real loss is that a syscall in progress when a rule is loaded
would get audited today and wouldn't get audited with my new proposal.
I don't see that as an unacceptable race.....

-Eric

