Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab0C3IHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 04:07:25 -0400
Received: from mail.gmx.net ([213.165.64.20]:38031 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751409Ab0C3IHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 04:07:21 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18oEbJGDRsoMVdXIB885gjExhGBKW8GhOa3Ekwqle
	NvgDHtSGNr7dej
Subject: Re: scheduler bug: process running since 5124095h
From: Mike Galbraith <efault@gmx.de>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: =?ISO-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4BB1989D.4050809@jp.fujitsu.com>
References: <4BADD408.8080609@gmail.com>  <4BAF1802.8070002@gmail.com>
	 <1269859960.6844.4.camel@marge.simson.net>
	 <4BB09736.5010009@jp.fujitsu.com>  <4BB1989D.4050809@jp.fujitsu.com>
Content-Type: text/plain
Date: Tue, 30 Mar 2010 10:07:15 +0200
Message-Id: <1269936435.6699.21.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-30 at 15:22 +0900, Hidetoshi Seto wrote:

> Quick report:
> 
> The reason why this commit have bisected is because it changed
> the type of time values from signed clock_t to unsigned cputime_t,
> so that the following if-block become to be always taken:
> 
>    > -       stime = nsec_to_clock_t(p->se.sum_exec_runtime) -
>    > -                       cputime_to_clock_t(task_utime(p));
>    > +       stime = nsecs_to_cputime(p->se.sum_exec_runtime) - task_utime(p);
>    > 
> >> >         if (stime >= 0)
>    > -               p->prev_stime = max(p->prev_stime, clock_t_to_cputime(stime));
>    > +               p->prev_stime = max(p->prev_stime, stime);
>    > 
>    >         return p->prev_stime;
> 
> >From strace of latancytop, it does write to /proc/<pid>/sched:
> 
>    5891  open("/proc/1/sched", O_RDWR)     = 5
>    5891  fstat(5, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
>    5891  mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
>     0x7fc6668f3000
>    5891  read(5, "init (1, #threads: 1)\n----------"..., 1024) = 776
>    5891  read(5, "", 1024)                 = 0
> >> 5891  write(5, "erase", 5)              = 5
>    5891  close(5)                          = 0
> 
> It results in:
> 
> [kernel/sched_debug.c]
> void proc_sched_set_task(struct task_struct *p)
> {
>  :
>         p->se.sum_exec_runtime                  = 0;
>         p->se.prev_sum_exec_runtime             = 0;
>         p->nvcsw                                = 0;
>         p->nivcsw                               = 0;
> }

Hm.  Dunno why that (evilness) exists.

> So soon some task will have great (in fact negative) stime.
> 
> There would be no doubt that this initialize in sched_debug.c
> will break monotonicity of sum_exec_runtime.  I confirmed that
> the issue is disappeared by comment-out of lines above.
> 
> Reverting the bisected commit is wrong solution, because it
> will bring another issue, i.e. lost of runtime, and u/stime
> seems to be frozen because these values restart from 0 so
> prev_* is used for a while.
> 
> How to fix?  Is this a bug of latencytop? Kernel?
> Please comment.

I looked at it in tip this morning (where task_stime doesn't exist), and
did the below to swat the underflow.  Seems ok, but I haven't yet
enabled CONFIG_LATENCYTOP.

diff --git a/kernel/sched.c b/kernel/sched.c
index 81575f1..cdf4fa4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3366,6 +3366,7 @@ void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	 * Compare with previous values, to keep monotonicity:
 	 */
 	p->prev_utime = max(p->prev_utime, utime);
+	rtime = max(rtime, p->prev_utime);
 	p->prev_stime = max(p->prev_stime, cputime_sub(rtime, p->prev_utime));
 
 	*ut = p->prev_utime;
@@ -3396,6 +3397,7 @@ void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 		utime = rtime;
 
 	sig->prev_utime = max(sig->prev_utime, utime);
+	rtime = max(rtime, sig->prev_utime);
 	sig->prev_stime = max(sig->prev_stime,
 			      cputime_sub(rtime, sig->prev_utime));
 


