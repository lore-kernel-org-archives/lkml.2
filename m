Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab0JUOgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:36:54 -0400
Received: from smtp-out.google.com ([216.239.44.51]:16341 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab0JUOgw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:36:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cEqTJCmLa04L8OBWwB+80pYqp+cxcr0tIb6hTrYGyqMubcrHHigS6Qhwawfk67Y8FU
         gRVEdrartObUgIOJkRdg==
MIME-Version: 1.0
In-Reply-To: <1287638608.2545.98.camel@edumazet-laptop>
References: <1287614941-32325-1-git-send-email-venki@google.com>
	<1287614941-32325-2-git-send-email-venki@google.com>
	<1287638608.2545.98.camel@edumazet-laptop>
Date: Thu, 21 Oct 2010 07:36:49 -0700
Message-ID: <AANLkTi=QyTJ0vZ=U3Ts7bB-DGvtTuQ_M6k8igkKiv6EE@mail.gmail.com>
Subject: Re: [PATCH 1/6] Free up pf flag PF_KSOFTIRQD
From: Venkatesh Pallipadi <venki@google.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 10:23 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le mercredi 20 octobre 2010 à 15:48 -0700, Venkatesh Pallipadi a écrit :
>> +int is_ksoftirqd_context(void)
>> +{
>> +       return (current == __get_cpu_var(ksoftirqd));
>> +}
>
> "return (X == Y);" should be "return X == Y;"
>
> I believe this function should be inlined, and use this_cpu_read()
> You probably can pass 'current' as a pointer.
>
> static inline bool is_ksoftirq(struct task_struct *p)
> {
>        return p == this_cpu_read(ksoftirqd);
> }

Yes. I thought about static inline part. The reason I did not make
this static inline was because ksoftirqd was declared static in
softirq.c and this function was getting called from sched.c.

I did not know that this_cpu_read existed though. I guess I should be
looking at using that elsewhere in the patchset too.

Also, part of the overhead you see below I think is coming from
DEBUG_PREEMPT. That would be making every smp_processor_id() call more
expensive. No?

Thanks,
Venki

>
> Your version is a bit expensive :
>
> <is_ksoftirqd_context>:
>        55                      push   %rbp
>        48 89 e5                mov    %rsp,%rbp
>        48 83 ec 10             sub    $0x10,%rsp
>        48 89 1c 24             mov    %rbx,(%rsp)
>        4c 89 64 24 08          mov    %r12,0x8(%rsp)
>        48 c7 c3 40 03 01 00    mov    $0x10340,%rbx
>        e8 93 e5 24 00          callq  ffffffff812aeab0 <debug_smp_processor_id>
>        89 c0                   mov    %eax,%eax
>        48 8b 04 c5 a0 b8 b5    mov    -0x7e4a4760(,%rax,8),%rax
>        81
>        65 4c 8b 24 25 00 cc    mov    %gs:0xcc00,%r12
>        00 00
>        4c 39 24 18             cmp    %r12,(%rax,%rbx,1)
>        48 8b 1c 24             mov    (%rsp),%rbx
>        4c 8b 64 24 08          mov    0x8(%rsp),%r12
>        c9                      leaveq
>        0f 94 c0                sete   %al
>        0f b6 c0                movzbl %al,%eax
>        c3                      retq
>
> While alternate version :
>
>                                cmp    %gs:0x10340,%rdi
>
> (So it should be as fast as previous flag based test)
>
> Thanks
>
>
>
