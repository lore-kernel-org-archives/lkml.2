Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697Ab0JUO6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:58:49 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63126 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab0JUO6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:58:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nWoQpCpT5pihgBY8woVENxueSuxI2017wMTj42odIGh1c7TvVO4FnkjlyKPmVMvigb
         83kOIb/2pZMUJ0q4rN6x2guV+0cIt4j2s7uGA/olCDn77r6mH+ACQ90D61FMPU+uGuKo
         gc6Ppkt/dQq/E0vmdff50u3VyPloWMDXFqY+s=
Subject: Re: [PATCH 1/6] Free up pf flag PF_KSOFTIRQD
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Yong Zhang <yong.zhang0@gmail.com>
In-Reply-To: <AANLkTi=QyTJ0vZ=U3Ts7bB-DGvtTuQ_M6k8igkKiv6EE@mail.gmail.com>
References: <1287614941-32325-1-git-send-email-venki@google.com>
	 <1287614941-32325-2-git-send-email-venki@google.com>
	 <1287638608.2545.98.camel@edumazet-laptop>
	 <AANLkTi=QyTJ0vZ=U3Ts7bB-DGvtTuQ_M6k8igkKiv6EE@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Oct 2010 16:58:41 +0200
Message-ID: <1287673121.6871.108.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 21 octobre 2010 à 07:36 -0700, Venkatesh Pallipadi a écrit :

> Yes. I thought about static inline part. The reason I did not make
> this static inline was because ksoftirqd was declared static in
> softirq.c and this function was getting called from sched.c.
> 

I believe you can remove the 'static' for this kind of thing.

> I did not know that this_cpu_read existed though. I guess I should be
> looking at using that elsewhere in the patchset too.
> 

Sure :)

> Also, part of the overhead you see below I think is coming from
> DEBUG_PREEMPT. That would be making every smp_processor_id() call more
> expensive. No?
> 

Right, but the point is the this_cpu_read() version doesnt have this
overhead, even if DEBUG_PREEMPT is on, at least on x86.

BTW, I lied somehow, because the way this_cpu_read() is handled,
following code :

	p == this_cpu_read(ksoftirqd);

generates :

mov     %gs:offset,%rax
cmp	%rdi,%rax

not :

cmp	%gs:offset,%rdi



