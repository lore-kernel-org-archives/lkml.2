Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab0KCVnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 17:43:22 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:64819 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab0KCVnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 17:43:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aqN8JdxKg32CQrFquLPC1krFwO0rQreD0YXjrb8kTKrI5T5CenqGA76iQVGDtS94ak
         GVh8cm2YIaGDehdHj6Gg1TTVtoKUEarOjTDDRWD/3MlUY0bqvzSZdbu189RCXIMgSImt
         ryszMzmHL5JE+f+XZw+3qS7Ci5S3BvkvbTdVo=
Date: Wed, 3 Nov 2010 22:43:13 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        linux-perf-users@vger.kernel.org
Subject: Re: perf tools miscellaneous questions
Message-ID: <20101103214308.GA5421@nowhere>
References: <m2eib2uryc.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2eib2uryc.fsf@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 08:28:59PM +0100, Francis Moreau wrote:
> Hello,
> 
> I'm trying to use perf-tools and also to learn some internals about
> them. So I prefer to ask all of them in one email.
> 
> The first one is about the list of pre-defined events given by
> perf-list. I couldn't find any documentations that describes these
> events so excuse me if the question is stupid.



Sorry about that. We indeed need to improve a lot the documentation.
May be this particular part could come with the future sysfs exposure
of the events.



> 
> What's the difference between 'cpu-clock' and 'task-clock' event ?


cpu-clock is based on the total time spent on the cpu. task-clock is
based only on the time spent on the profiled task, so that doesn't count
time spent on other tasks, it has a per thread granularity.

(I might be somehow wrong in my explanation).



> 
> What's exactly the 'cache-misses' event ? does it include both instructions
> _and_ data cache misses ? both L1 and L2 caches ?
> 
> I was expecting so but the following command makes me wondering:
> 
>   $ perf stat -e cache-misses:u,l1d-loads-misses:u true
>     Performance counter stats for 'true':
> 
>                 763  cache-misses            
>                 874  L1-dcache-load-misses   
> 
>         0.000916609  seconds time elapsed
> 
> Here cache-misses < L1-dcache-load-misses.



Dunno, will let others answer.



> The last question is about the source code annotation done by
> perf-report. I'm using it to locate the place in my code that generates
> the most data cache miss events. I can read this during a perf-report
> session:
> 
>    [...]
>     0.00 :           df215:       c3                      retq
>     0.00 :           df216:       66 2e 0f 1f 84 00 00    nopw   %cs:0x0(%rax,%rax,1)
>     0.00 :           df21d:       00 00 00
>    10.00 :           df220:       48 8b 75 00             mov    0x0(%rbp),%rsi
>    80.00 :           df224:       48 89 df                mov    %rbx,%rdi
>     0.00 :           df227:       41 ff d4                callq  *%r12
>     0.00 :           df22a:       85 c0                   test   %eax,%eax
>    [...]
> 
> If I read the output correctly, most of the dcache misses are coming from
> 'mov %rbx, %rdi', and AFAIK this intruction can't generate any dcache
> miss. What am I missing ?


Perhaps you need pebs to get the very precise location on your event.

perf stat -e cache-misses:up,l1d-loads-misses:up true


I think the more you add 'p', the more precise it is.
Like:

	perf stat -e cache-misses:uppp,l1d-loads-misses:uppp true

Not sure how much it will accept though :)

