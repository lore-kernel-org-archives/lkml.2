Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253Ab0EUPMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 11:12:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37404 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758215Ab0EUPMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 11:12:51 -0400
Date: Fri, 21 May 2010 17:12:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 0/4] perf: Precise task / softirq / hardirq filtered
 stats/profiles
Message-ID: <20100521151230.GA20941@elte.hu>
References: <1274450715-23955-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274450715-23955-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3882]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Hi,
> 
> The new task and irq exclusion handling can let you 
> confine tracing and profiling to about everything you 
> want.

I fixed the subject line ;-)

'exclusion' is the ABI detail. The feature your patches 
implement are to allow 'softirq limited' or 'task-context 
limited' or 'hardirq profiling' - which is way cool.

One thing i'd like to see in this feature is for it to 
work on pure event counting - i.e. 'perf stat' as well.

This would allow some _very_ precise stats, without IRQ 
noise. For example, today we have this kind of noise
in instruction counting:


 $ for ((i=0;i<10;i++)); do perf stat -e instructions /bin/true 2>&1 | grep instructions; done
             217161  instructions             #      0,000 IPC  
             218591  instructions             #      0,000 IPC  
             223268  instructions             #      0,000 IPC  
             217112  instructions             #      0,000 IPC  
             219392  instructions             #      0,000 IPC  
             216801  instructions             #      0,000 IPC  
             217501  instructions             #      0,000 IPC  
             218565  instructions             #      0,000 IPC  
             218682  instructions             #      0,000 IPC  
             218523  instructions             #      0,000 IPC  

it it's all that bad at ~2% jitter, but many improvements 
we are working on in the kernel are much smaller than 1%.

If we extended your feature to perf stat, we might be able 
to get a lot more precise measurements in terms of kernel 
optimizations (and kernel bloat).

I'm really curious how accurate your scheme could become 
that way. From the above 'few thousands instructions' 
noise we might be able to get down to a 'hundreds of 
instructions' noise? If so then it would allow us to 
measure micro-optimizations in a radically more precise 
way.

Thanks,

	Ingo
