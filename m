Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab0KGVkd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 16:40:33 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54337 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab0KGVka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 16:40:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ko5fxK0A2g2Xet926XhU9TQI7J0zEM/9B5an5SBM9qz8ePh/C6Mv8Nqc/TZWKXkmMN
         7UaUJu/M2rhGw1QW547CRvypBaJhdl+u2DPlJhb+u9Rf1wkX+M/ttSi7tT/FcGg5kmH7
         yD4py9sEa6xaJxaPCL4YmGGnPEL3ySO7BaOzg=
Date: Sun, 7 Nov 2010 22:40:27 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        linux-perf-users@vger.kernel.org
Subject: Re: perf tools miscellaneous questions
Message-ID: <20101107214025.GD11134@nowhere>
References: <fa.yHA7Aw03llqLWxPVYRnHvK5/dT8@ifi.uio.no> <fa.13KEqWk+Dk+jLLdFlAoZtQ2Vjuw@ifi.uio.no> <m2lj59sc7a.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2lj59sc7a.fsf@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 09:52:09AM +0100, Francis Moreau wrote:
> Frederic Weisbecker <fweisbec@gmail.com> writes:
> 
> > On Wed, Nov 03, 2010 at 08:28:59PM +0100, Francis Moreau wrote:
> >> Hello,
> >> 
> >> I'm trying to use perf-tools and also to learn some internals about
> >> them. So I prefer to ask all of them in one email.
> >> 
> >> The first one is about the list of pre-defined events given by
> >> perf-list. I couldn't find any documentations that describes these
> >> events so excuse me if the question is stupid.
> >
> >
> >
> > Sorry about that. We indeed need to improve a lot the documentation.
> > May be this particular part could come with the future sysfs exposure
> > of the events.
> >
> 
> No problem, but yes this part should be documented somewhere. And I
> think the syntax of event too, specially the modifier like 'u' or 'p'.



Ah that is documented in "man perf-list".



> 
> >> 
> >> What's the difference between 'cpu-clock' and 'task-clock' event ?
> >
> >
> > cpu-clock is based on the total time spent on the cpu. task-clock is
> > based only on the time spent on the profiled task, so that doesn't count
> > time spent on other tasks, it has a per thread granularity.
> 
> Ok, so 'cpu-clock' could have been named 'proc-clock' even though a task
> is a processus on Linux.



Well, this is a matter of opinion probably, I think cpu-clock defines
better its role.



> 
> [...]
> 
> >> The last question is about the source code annotation done by
> >> perf-report. I'm using it to locate the place in my code that generates
> >> the most data cache miss events. I can read this during a perf-report
> >> session:
> >> 
> >>    [...]
> >>     0.00 :           df215:       c3                      retq
> >>     0.00 :           df216:       66 2e 0f 1f 84 00 00    nopw   %cs:0x0(%rax,%rax,1)
> >>     0.00 :           df21d:       00 00 00
> >>    10.00 :           df220:       48 8b 75 00             mov    0x0(%rbp),%rsi
> >>    80.00 :           df224:       48 89 df                mov    %rbx,%rdi
> >>     0.00 :           df227:       41 ff d4                callq  *%r12
> >>     0.00 :           df22a:       85 c0                   test   %eax,%eax
> >>    [...]
> >> 
> >> If I read the output correctly, most of the dcache misses are coming from
> >> 'mov %rbx, %rdi', and AFAIK this intruction can't generate any dcache
> >> miss. What am I missing ?
> >
> >
> > Perhaps you need pebs to get the very precise location on your event.
> >
> > perf stat -e cache-misses:up,l1d-loads-misses:up true
> >
> >
> > I think the more you add 'p', the more precise it is.
> > Like:
> >
> > 	perf stat -e cache-misses:uppp,l1d-loads-misses:uppp true
> >
> > Not sure how much it will accept though :)
> 
> Well it doesn't want one actually:
> 
>   $ perf stat -v -e cache-misses:up true
>   Error: counter 0, sys_perf_event_open() syscall returned with -1 (No
>   space left on device)
>   No permission to collect stats.
>   Consider tweaking /proc/sys/kernel/perf_event_paranoid.
> 
> Where can I find a description of PEB ?


I have the same problem. But running perf record with this :p
works for me. Which is what we want: pebs is useful for sampling,
not counting-only.

Ah and that won't work if you don't run some intel CPU I think.
Check you have PEBS support in /proc/cpuinfo

