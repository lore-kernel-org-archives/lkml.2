Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619Ab0G3NcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 09:32:10 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:36018 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753351Ab0G3NcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 09:32:07 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18IVnByjjoInoPDI703HsE26bkTSr0gsnGbNtlQCT
	CvrfPQEvRkz8Ju
Subject: Re: [PATCH 0/6] [RFC] Large weight differential leads to
 inefficient load balancing
From: Mike Galbraith <efault@gmx.de>
To: Nikhil Rao <ncrao@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>,
        Ken Chen <kenchen@google.com>, Paul Turner <pjt@google.com>
In-Reply-To: <1280467146-32218-1-git-send-email-ncrao@google.com>
References: <1280467146-32218-1-git-send-email-ncrao@google.com>
Content-Type: text/plain
Date: Fri, 30 Jul 2010 15:32:19 +0200
Message-Id: <1280496739.10435.10.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-29 at 22:19 -0700, Nikhil Rao wrote:
> Hi all,
> 
> We have observed that a large weight differential between tasks on a runqueue
> leads to sub-optimal machine utilization and poor load balancing. For example,
> if you have lots of SCHED_IDLE tasks (sufficient number to keep the machine 100%
> busy) and a few SCHED_NORMAL soaker tasks, we see that the machine has
> significant idle time.
> 
> The data below highlights this problem. The test machine is a 4 socket quad-core
> box (16 cpus). These experiemnts were done with v2.6.25-rc6. We spawn 16
> SCHED_IDLE soaker threads (one per-cpu) to completely fill up the machine. CPU
> utilization numbers gathered from mpstat for 10s are:
> 
> 03:30:24 PM  CPU   %user   %nice    %sys %iowait    %irq   %soft  %steal   %idle    intr/s
> 03:30:25 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  16234.65
> 03:30:26 PM  all   99.88    0.06    0.06    0.00    0.00    0.00    0.00    0.00  16374.00
> 03:30:27 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  16392.00
> 03:30:28 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  16612.12
> 03:30:29 PM  all   99.88    0.00    0.12    0.00    0.00    0.00    0.00    0.00  16375.00
> 03:30:30 PM  all   99.94    0.06    0.00    0.00    0.00    0.00    0.00    0.00  16440.00
> 03:30:31 PM  all   99.81    0.00    0.19    0.00    0.00    0.00    0.00    0.00  16237.62
> 03:30:32 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  16360.00
> 03:30:33 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  16405.00
> 03:30:34 PM  all   99.38    0.06    0.50    0.00    0.00    0.00    0.00    0.06  18881.82
> Average:     all   99.86    0.02    0.12    0.00    0.00    0.00    0.00    0.01  16628.20
> 
> We then spawn one SCHED_NORMAL while-1 task (the absolute number does not matter
> so long as we introduce some large weight differential).
> 
> 03:40:57 PM  CPU   %user   %nice    %sys %iowait    %irq   %soft  %steal   %idle    intr/s
> 03:40:58 PM  all   83.06    0.00    0.06    0.00    0.00    0.00    0.00   16.88  14555.00
> 03:40:59 PM  all   78.25    0.00    0.06    0.00    0.00    0.00    0.00   21.69  14527.00
> 03:41:00 PM  all   82.71    0.06    0.06    0.00    0.00    0.00    0.00   17.17  14879.00
> 03:41:01 PM  all   87.34    0.00    0.06    0.00    0.00    0.00    0.00   12.59  15466.00
> 03:41:02 PM  all   80.80    0.06    0.19    0.00    0.00    0.00    0.00   18.95  14584.00
> 03:41:03 PM  all   82.90    0.00    0.06    0.00    0.00    0.00    0.00   17.04  14570.00
> 03:41:04 PM  all   79.45    0.00    0.06    0.00    0.00    0.00    0.00   20.49  14536.00
> 03:41:05 PM  all   86.48    0.00    0.07    0.00    0.00    0.00    0.00   13.46  14577.00
> 03:41:06 PM  all   76.73    0.06    0.06    0.00    0.00    0.06    0.00   23.10  14594.00
> 03:41:07 PM  all   86.48    0.00    0.07    0.00    0.00    0.00    0.00   13.45  14703.03
> Average:     all   82.31    0.02    0.08    0.00    0.00    0.01    0.00   17.59  14699.10

What happens with s/SCHED_IDLE/nice 19?

	-Mike

