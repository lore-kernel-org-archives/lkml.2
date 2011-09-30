Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab1I3BFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 21:05:48 -0400
Received: from mout.perfora.net ([74.208.4.195]:62678 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755942Ab1I3BFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 21:05:46 -0400
Date: Thu, 29 Sep 2011 21:05:18 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Stephen Wilson <wilsons@start.ca>, Al Viro <viro@zeniv.linux.org.uk>,
        Johannes Weiner <jweiner@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: proc: hold cred_guard_mutex in check_mem_permission()
Message-ID: <20110930010518.GB9594@wicker.gateway.2wire.net>
References: <20110928202020.GA3164@redhat.com>
 <20110929071314.GA7734@wicker.gateway.2wire.net>
 <20110929114827.GA9279@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110929114827.GA9279@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:KoNOeJOwpgHW61Qlx+NsNNflWjBtF4O2bqK1OQEPF97
 gpeK1QUF6rY4QpWwItKFKVLNKixTxhYiCqaozNaPFHEnZ3YxuZ
 fjvui+hHQrfNHuX4c3sDzWak4bbB2g5yo9aJpPECf2A6clLCRu
 oNDseOjMl98HWiX1367Yyekyz3qYtoh4fMo12cCryEnzEjwGTP
 WNZep+KODvHriMmvbC60mWJb8v1KD2qMdffx59tJWK8AkWdxkY
 VRWHfr3ObGcagRkysPPyxBsMqoB3THMlpEOPg4cOyzrgVsdFvI
 w44WyEnJmJ2PTj0hCaamKL87FNclzTGIJ6KN0rUjhANJMeb6wG
 xkMFFpT606v4/d2RzuPQFF6BZbju6XcfdkmRdkT54R8upvT+k6
 XYU5HFCW4Sp9g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 01:48:27PM +0200, Oleg Nesterov wrote:
> > > Could you please explain? How can we race with exec?
> >
> > My understanding of the race is this:
> >
> > sequence during execve():
> >
> > 	1) cred_guard_mutex is taken in prepare_bprm_creds()
> > 	2) new mm is installed via exec_mmap()
> > 	3) new creds are pushed via install_exec_creds() which releases
> > 	   cred_guard_mutex
> >
> > so if we get_task_mm() and ptrace_may_access() between 2 and 3 we
> > obtain a reference to the new mm validated against old creds.
> >
> > Perhaps (the fairly old) commit 704b836c helps?
> 
> Yes, and that is why I sent 704b836c ;)
> 
> But, check_mem_permission() can't race with exec, that was my point.
> The task is stopped (it is TASK_TRACED), it can't run unless SIGKILL'ed.
> It can not change its mm/creds.

Ah, I see.  I misunderstood your question.  So, yes, the race as it
stands is fictional AFAIKT -- I did not recognize that the
ptrace_may_access() was effectively redundant when I first authored the
patch.

> > Checking ptrace_parent() against current was introduced in 0d094efeb,
> 
> not actually, this is very old check, probably since 2.4.0 at least.
> That patch only renames the helper we use.
> 
> > but the
> > commit message gives no clue as to why the check was added.
> 
> Only debugger can read/write the task's memory. May be we can relax
> this, perhaps we can only check ptrace_may_access(PTRACE_MODE_ATTACH).
> 
> But currently we require the caller should trace the target.

OK. 

> > If we are the tracer then that ptrace_may_access() check is redundant and the
> > whole race thing is a non-issue, right?
> 
> Yes.
> 
> > But perhaps the correct move is to
> > relax the restriction that current be the tracer.
> 
> Yes, I thought about this too. And in this case we do need the mutex.
> Although I don't think this really makes sense, I _think_ this all was
> created for debuggers. And, without ptrace_parent(), why do we need
> task_is_stopped_or_traced() check?

Thinking about this some more, I agree that this should remain only for
debuggers -- /proc/pid/mem is just a nicer interface to ptrace peek and
poke, nothing more.


> So I think we should simply remove ->cred_guard_mutex.

Yes, I think that is right, together with removing the
ptrace_may_access() check and updating that comment in
check_mem_permission().  I can put a patch together this weekend if
needed. 


Take care,

-- 
steve

