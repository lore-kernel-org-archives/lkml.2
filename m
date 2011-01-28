Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab1A1RlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 12:41:16 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61445 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061Ab1A1RlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 12:41:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=B84LDS2G9BUsuvFvw2a7yexaKqO7R7mNS3AaVdivNK6GDPXBbp0Ixt2xPHEqliBkVB
         HY4fE3UXomGWql7O7l9WwXj+GbskG6Fwz5Invrp3KZNQVICQboOa42lC4qKeIQHDKduj
         vfKzJnm0EXGB4n9J9NUXFFE9VdY1OActzkx4I=
Date: Fri, 28 Jan 2011 18:41:10 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Q: perf_event && task->ptrace_bps[]
Message-ID: <20110128174105.GA1761@nowhere>
References: <20101108145647.GA3426@redhat.com>
 <20110117203459.GA32700@redhat.com>
 <20110118184234.GA1808@nowhere>
 <20110119153746.GA32563@redhat.com>
 <20110119200536.GC1772@nowhere>
 <20110120172810.GA6809@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110120172810.GA6809@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 06:28:10PM +0100, Oleg Nesterov wrote:
> On 01/19, Frederic Weisbecker wrote:
> > OTOH I can drop
> > more of them for the no-running-breakpoint case from thread_struct
> > in a subsequent task.
> 
> Hmm. Can't understand what do you mean. Just curious, could you explain?

Indeed now that I read that, it was completely not understandable :)

So I meant that currently we have this:

task->thread->ptrace_bps[BP_NUM]

Where ptrace_bps is:

struct perf_event *ptrace_bps[BP_NUM];

And we populate that with pointers when needed. Now this is a waste
of space, I should better make it:

struct perf_event **ptrace_bps;

And only allocate the pointer space when needed.

 
> > Note the problem touches more archs than x86. Basically every
> > arch that use breakpoint use a similar scheme that must be fixed.
> 
> Yes. Perhaps we should try to unify some code... Say, can't we move
> ->ptrace_bps[] to task_struct?

It seems that every archs that currently implement breakpoints have
this linear mapping of registers, even when physically they are not
linear: ARM has a seperate register space for instruction and data
breakpoints for example.

So yeah it seems we can store that in task_struct. I may try that
in a subsequent patch.

> 
> > +void ptrace_put_breakpoints(struct task_struct *tsk)
> > +{
> > +	if (!atomic_dec_return(&tsk->ptrace_bp_refcnt))
> > +		flush_ptrace_hw_breakpoint(tsk);
> 
> (minor nit, atomic_dec_and_test() looks more natural)

Indeed, will change that.

Thanks!
