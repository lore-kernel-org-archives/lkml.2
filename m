Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760740Ab1D1Svd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 14:51:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64537 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab1D1Svc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 14:51:32 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=wom5GMh1gUkA:10 a=0i_OOtiXEx8A:10 a=Rj1_iGo3bfgA:10 a=8nJEP1OIZ-IA:10 a=eAWTIsOZi86Vnn5xZOjC/w==:17 a=cm27Pg_UAAAA:8 a=hBqU3vQJAAAA:8 a=meVymXHHAAAA:8 a=pm-Xp3uwzmuoAF5_Tz4A:9 a=qgl54K_mniezyl01c-gA:7 a=wPNLvfGTeEIA:10 a=zv9_9hqRWm8A:10 a=4gZ4WExUoD4A:10 a=jeBq3FmKZ4MA:10 a=eAWTIsOZi86Vnn5xZOjC/w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.154.172
Date: Thu, 28 Apr 2011 13:51:30 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Will Drewry <wad@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, eparis@redhat.com, agl@chromium.org,
        mingo@elte.hu, jmorris@namei.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Michal Marek <mmarek@suse.cz>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Slaby <jslaby@suse.cz>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/7] seccomp_filter: Enable ftrace-based system call
 filtering
Message-ID: <20110428185130.GA13071@hallyn.com>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
 <1303960136-14298-2-git-send-email-wad@chromium.org>
 <20110428165525.GB1927@hallyn.com>
 <1304010981.18763.192.camel@gandalf.stny.rr.com>
 <20110428173957.GA25940@hallyn.com>
 <BANLkTi=ukfidjHpKUr1vL67aQUFcNxXFeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=ukfidjHpKUr1vL67aQUFcNxXFeA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Will Drewry (wad@chromium.org):
> On Thu, Apr 28, 2011 at 12:39 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> > Quoting Steven Rostedt (rostedt@goodmis.org):
> >> On Thu, 2011-04-28 at 11:55 -0500, Serge E. Hallyn wrote:
> >> > I actually thought you were going to be more extreme about the seccomp
> >> > state than you are:  I thought you were going to tie a filter list to
> >> > seccomp state.  So adding or removing a filter would have required
> >> > duping the seccomp state, duping all the filters, making the change in
> >> > the copy, and then swapping the new state into place.  Slow in the
> >> > hopefully rare update case, but safe.
> 
> Hrm, I think I'm confused now!  This is exactly what I *thought* the
> code was doing.
> 
> At present, seccomp_state can be shared across predecessor/ancestor
> relationships using refcounting in fork.c  (get/put). However, the
> only way to change a given seccomp_state or its filters is either
> through the one-bit on_next_syscall change or through
> prctl_set_seccomp.  In prctl_set_seccomp, it does:
> state = (orig_state ? seccomp_state_dup(orig_state) :
>                               seccomp_state_new());
> operates on the new state and then rcu_assign_pointer()s it to the
> task.  I didn't intentionally provide any way to drop filters from an
> existing state object nor change the filtered syscalls on an in-use
> object.  That _dup call should hit the impromperly rcu_locked
> copy_all_filters returning duplicates of the original filters by
> reparsing the filter_string.
> 
> Did I accidentally provide a means to mutate a state object or filter
> list without dup()ing? :/

Ah - probably not, I probably misread your intent for the helpers.

So in that case you don't need to rcu-protect the filters at all
when copying.  You just need to inc the seccomp struct refcount
under rcu lock, to make sure it all stays put.  Drop rcu lock, take
your time copying, then when you dec the refcount the whole seccomp
struct either gets freed or not.

Excellent.

-serge
