Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab0EFXLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 19:11:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40501 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab0EFXLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 19:11:53 -0400
X-Authority-Analysis: v=1.1 cv=nrqrmdtKPnrEe5McJVoaEKFzY/lexCxOe+Stj/aSkNs= c=1 sm=0 a=djxfJSnEeKsA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=D_SbEOMbAAAA:8 a=Fo1mPARr0NQq209HrtYA:9 a=rG1XxmlFaORVz8MdAekrUCem8M0A:4 a=PUjeQqilurYA:10 a=7KbvKZvEaC0A:10 a=McTXtk4zgLY5TZo5:21 a=C9KeNykoS7ppy5jN:21 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 1/1] fix-taskstates-in-sched_switch-trace.patch
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Carsten Emde <C.Emde@osadl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100311122822.678489605@osadl.org>
References: <20100311122454.585724424@osadl.org>
	 <20100311122822.678489605@osadl.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 06 May 2010 19:11:50 -0400
Message-ID: <1273187510.22438.67.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just notice that this patch was never applied.

Anyone against applying it?

-- Steve


On Thu, 2010-03-11 at 13:24 +0100, Carsten Emde wrote:
> plain text document attachment
> (fix-taskstates-in-sched_switch-trace.patch)
> The sched_switch trace event displays erroneous character codes of task
> states, after a new task state was added in the scheduler code but
> omitted to add in the trace event code.
> 
> Define character codes of task states individually. In addition, define
> task state descriptions needed in /proc at the same place. This will
> help to keep the task state bits, characters and descriptions in sync
> should they ever need to be changed again.
> 
> Signed-off-by: Carsten Emde <C.Emde@osadl.org>
> 
> Index: head/include/trace/events/sched.h
> ===================================================================
> --- head.orig/include/trace/events/sched.h
> +++ head/include/trace/events/sched.h
> @@ -161,11 +161,17 @@ TRACE_EVENT(sched_switch,
>  		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
>  		__entry->prev_state ?
>  		  __print_flags(__entry->prev_state, "|",
> -				{ 1, "S"} , { 2, "D" }, { 4, "T" }, { 8, "t" },
> -				{ 16, "Z" }, { 32, "X" }, { 64, "x" },
> -				{ 128, "W" }) : "R",
> +			{ 1, TASK_STATE_1} , { 2, TASK_STATE_2 },
> +			{ 4, TASK_STATE_4 }, { 8, TASK_STATE_8 },
> +			{ 16, TASK_STATE_16 }, { 32, TASK_STATE_32 },
> +			{ 64, TASK_STATE_64 }, { 128, TASK_STATE_128 },
> +			{ 256, TASK_STATE_256 }
> +			) : TASK_STATE_0,
>  		__entry->next_comm, __entry->next_pid, __entry->next_prio)
>  );
> +#if TASK_STATE_MAX != 512
> +#error "Please add new task state array in __print_flags() above."
> +#endif
>  
>  /*
>   * Tracepoint for a task being migrated:
> Index: head/include/linux/sched.h
> ===================================================================
> --- head.orig/include/linux/sched.h
> +++ head/include/linux/sched.h
> @@ -172,7 +172,9 @@ print_cfs_rq(struct seq_file *m, int cpu
>  
>  /*
>   * Task state bitmask. NOTE! These bits are also
> - * encoded in fs/proc/array.c: get_task_state().
> + * used in fs/proc/array.c: get_task_state() and
> + * in include/trace/events/sched.h in the
> + * sched_switch trace event.
>   *
>   * We have two separate sets of flags: task->state
>   * is about runnability, while task->exit_state are
> @@ -181,20 +183,52 @@ print_cfs_rq(struct seq_file *m, int cpu
>   * mistake.
>   */
>  #define TASK_RUNNING		0
> +#define TASK_STATE_0		"R"
> +#define DESCR_TASK_STATE_0	"running"
> +
>  #define TASK_INTERRUPTIBLE	1
> +#define TASK_STATE_1		"S"
> +#define DESCR_TASK_STATE_1	"sleeping"
> +
>  #define TASK_UNINTERRUPTIBLE	2
> +#define TASK_STATE_2		"D"
> +#define DESCR_TASK_STATE_2	"disk sleep"
> +
>  #define __TASK_STOPPED		4
> +#define TASK_STATE_4		"T"
> +#define DESCR_TASK_STATE_4	"stopped"
> +
>  #define __TASK_TRACED		8
> +#define TASK_STATE_8		"t"
> +#define DESCR_TASK_STATE_8	"tracing stop"
> +
>  /* in tsk->exit_state */
>  #define EXIT_ZOMBIE		16
> +#define TASK_STATE_16		"Z"
> +#define DESCR_TASK_STATE_16	"zombie"
> +
>  #define EXIT_DEAD		32
> +#define TASK_STATE_32		"X"
> +#define DESCR_TASK_STATE_32	"dead"
> +
>  /* in tsk->state again */
>  #define TASK_DEAD		64
> +#define TASK_STATE_64		"x"
> +#define DESCR_TASK_STATE_64	"dead"
> +
>  #define TASK_WAKEKILL		128
> +#define TASK_STATE_128		"K"
> +#define DESCR_TASK_STATE_128	"wakekill"
> +
>  #define TASK_WAKING		256
> +#define TASK_STATE_256		"W"
> +#define DESCR_TASK_STATE_256	"waking"
> +
>  #define TASK_STATE_MAX		512
>  
> -#define TASK_STATE_TO_CHAR_STR "RSDTtZXxKW"
> +#define TASK_STATE_TO_CHAR_STR \
> +  TASK_STATE_0 TASK_STATE_1 TASK_STATE_2 TASK_STATE_4 TASK_STATE_8 \
> +  TASK_STATE_16 TASK_STATE_32 TASK_STATE_64 TASK_STATE_128 TASK_STATE_256
>  
>  extern char ___assert_task_state[1 - 2*!!(
>  		sizeof(TASK_STATE_TO_CHAR_STR)-1 != ilog2(TASK_STATE_MAX)+1)];
> Index: head/fs/proc/array.c
> ===================================================================
> --- head.orig/fs/proc/array.c
> +++ head/fs/proc/array.c
> @@ -129,21 +129,22 @@ static inline void task_name(struct seq_
>  
>  /*
>   * The task state array is a strange "bitmap" of
> - * reasons to sleep. Thus "running" is zero, and
> - * you can test for combinations of others with
> + * reasons to sleep. Thus, the first element is zero,
> + * and you can test for combinations of others with
>   * simple bit tests.
>   */
> +#define TASK_STATE_X(num) TASK_STATE_##num " (" DESCR_TASK_STATE_##num ")"
>  static const char *task_state_array[] = {
> -	"R (running)",		/*   0 */
> -	"S (sleeping)",		/*   1 */
> -	"D (disk sleep)",	/*   2 */
> -	"T (stopped)",		/*   4 */
> -	"t (tracing stop)",	/*   8 */
> -	"Z (zombie)",		/*  16 */
> -	"X (dead)",		/*  32 */
> -	"x (dead)",		/*  64 */
> -	"K (wakekill)",		/* 128 */
> -	"W (waking)",		/* 256 */
> +	TASK_STATE_X(0),
> +	TASK_STATE_X(1),
> +	TASK_STATE_X(2),
> +	TASK_STATE_X(4),
> +	TASK_STATE_X(8),
> +	TASK_STATE_X(16),
> +	TASK_STATE_X(32),
> +	TASK_STATE_X(64),
> +	TASK_STATE_X(128),
> +	TASK_STATE_X(256)
>  };
>  
>  static inline const char *get_task_state(struct task_struct *tsk)
> 


