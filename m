Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab0FCU0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 16:26:35 -0400
Received: from smtp-out.google.com ([74.125.121.35]:25354 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab0FCU0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 16:26:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ajKbxq/PnJLXk2xejDnWpMaCUfJB4D1J3KB6XLxclKr1I+uI3nS1kkKdYQnbFYaZI
	egLEJ1Okw1zy+6M0FcIWw==
Date: Thu, 3 Jun 2010 13:26:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 09/12] oom: remove PF_EXITING check completely
In-Reply-To: <20100603140008.GA3548@redhat.com>
Message-ID: <alpine.DEB.2.00.1006031313040.10856@chino.kir.corp.google.com>
References: <20100603135106.7247.A69D9226@jp.fujitsu.com> <20100603152436.7262.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1006022332320.22441@chino.kir.corp.google.com> <20100603140008.GA3548@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jun 2010, Oleg Nesterov wrote:

> On 06/02, David Rientjes wrote:
> >
> > On Thu, 3 Jun 2010, KOSAKI Motohiro wrote:
> >
> > > Currently, PF_EXITING check is completely broken. because 1) It only
> > > care main-thread and ignore sub-threads
> >
> > Then check the subthreads.
> >

Did you want to respond to this?

> > > 2) If user enable core-dump
> > > feature, it can makes deadlock because the task during coredump ignore
> > > SIGKILL.
> > >
> >
> > It may ignore SIGKILL, but does not ignore fatal_signal_pending() being
> > true
> 
> Wrong.
> 
> Unless the oom victim is exactly the thread which dumps the core,
> fatal_signal_pending() won't be true for the dumper. Even if the
> victim and the dumper are from the same group, this thread group
> already has SIGNAL_GROUP_EXIT. And if they do not belong to the
> same group, SIGKILL has even less effect.
> 

I'm guessing at the relevancy here because the changelog is extremely 
poorly worded (if I were Andrew I would have no idea how important this 
patch is based on the description other than the alarmist words of "... is 
completely broken)", but if we're concerned about the coredumper not being 
able to find adequate resources to allocate memory from, we can give it 
access to reserves specifically, we don't need to go killing additional 
tasks which may have their own coredumpers.

> Even if we chose the right thread we can race with
> clear_thread_flag(TIF_SIGPENDING), but fatal_signal_pending()
> checks signal_pending().
> 
> > which gives it access to memory reserves with my patchset
> 
> __get_user_pages() already checks fatal_signal_pending(), this
> is where the dumper allocates the memory (mostly).
> 
> And I am not sure I understand the "access to memory reserves",
> the dumper should just stop if oom-kill decides it should die,
> it can use a lot more memory if it doesn't stop.
> 

That's an alternative solution as well, but I'm disagreeing with the 
approach here because this enforces absolutely no guarantee that the next 
task to be oom killed will be the coredumper, its much more likely that 
we're just going to kill yet another task for the coredump.  That task may 
have a coredumper too.  Who knows.

> > Nacked-by: David Rientjes <rientjes@google.com>
> 
> Kosaki removes the code which only pretends to work, but it doesn't
> and leads to problems.
> 

LOL, this code doesn't pretend to work, we rely heavily on it and have for 
three years to prevent needless oom killing.  We use the oom killer 
constantly on every machine with memory isolation for enforcing a policy, 
as the memcg will as well as it becomes more popular.  Killing a job's 
task is a serious matter and we'd prefer to kill as few as possible to 
free memory.  That's the entire motivation behind having a badness() 
heuristic in the first place: so we don't kill tons of tasks to free 
enough memory.  Removing this check specifically will cause the oom killer 
to kill tasks when it is currently a no-op and will free memory and we 
have never had a problem with these so-called "deadlocks" that are being 
found only by code inspection.  So please care a little bit more about the 
ramifications of other people's use of Linux before you go and insist that 
certain code doesn't do a complete job in certain cases or it can 
introduce a deadlock in situations that are anything but from the real 
world must be removed entirely even though it has saved tons of our jobs 
over the course of the past three years.

> If you think we need this check, imho it is better to make the patch
> which adds the "right" code with the nice changelog explaining how
> this code works.
> 

I've got no objection to that, but until you find the right solution, 
please don't remove what works for people in practice.  Show me an oom 
deadlock as the result of this and the use of sane applications.  Nobody 
reports them because these are such ridiculous cornercases that are being 
addressed by sweeping and extreme code changes without other people's 
input being considered.

Since Google uses the oom killer to enforce memory isolation on every one 
of our machines, and we do it at a scale that is unparalleled to anybody 
else, I think you should consider this input.
