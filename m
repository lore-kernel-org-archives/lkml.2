Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab0EQMXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 08:23:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51829 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab0EQMXP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 08:23:15 -0400
Subject: Re: [PATCH 1/1] fix-task-states-in-sched_switch-event.patch
From: Peter Zijlstra <peterz@infradead.org>
To: Carsten Emde <C.Emde@osadl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20100516222207.541520625@osadl.org>
References: <20100516221844.515632338@osadl.org>
	 <20100516222207.541520625@osadl.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 17 May 2010 14:22:53 +0200
Message-ID: <1274098973.5605.4695.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 00:18 +0200, Carsten Emde wrote:
>  #define TASK_RUNNING           0
> +#define TASK_STATE_0           "R"
> +#define TASK_STATE_NAME_0      "running"
> +
>  #define TASK_INTERRUPTIBLE     1
> +#define TASK_STATE_1           "S"
> +#define TASK_STATE_NAME_1      "sleeping"
> +
>  #define TASK_UNINTERRUPTIBLE   2
> +#define TASK_STATE_2           "D"
> +#define TASK_STATE_NAME_2      "disk sleep"
> +
>  #define __TASK_STOPPED         4
> +#define TASK_STATE_4           "T"
> +#define TASK_STATE_NAME_4      "stopped"
> +
>  #define __TASK_TRACED          8
> +#define TASK_STATE_8           "t"
> +#define TASK_STATE_NAME_8      "tracing stop"
> +
>  /* in tsk->exit_state */
>  #define EXIT_ZOMBIE            16
> +#define TASK_STATE_16          "Z"
> +#define TASK_STATE_NAME_16     "zombie"
> +
>  #define EXIT_DEAD              32
> +#define TASK_STATE_32          "X"
> +#define TASK_STATE_NAME_32     "dead"
> +
>  /* in tsk->state again */
>  #define TASK_DEAD              64
> +#define TASK_STATE_64          "x"
> +#define TASK_STATE_NAME_64     "dead"
> +
>  #define TASK_WAKEKILL          128
> +#define TASK_STATE_128         "K"
> +#define TASK_STATE_NAME_128    "wakekill"
> +
>  #define TASK_WAKING            256
> +#define TASK_STATE_256         "W"
> +#define TASK_STATE_NAME_256    "waking"

Since we all love vile macro magic, is the below any better?

include/linux/task_states.h

TASK_STATE(RUNNING, "R", "running")
TASK_STATE(INTERRUPTIBLE, "S", "sleeping")
...

include/linux/sched.h

enum {
#define TASK_STATE(tstate, tstate_c, tstate_s) __TASK_##tstate,
#include <linux/task_states.h>
#undef TASK_STATE
};

enum {
#define TASK_STATE(tstate, tstate_c, tstate_s) \
	TASK_##tstate = 1 << __TASK_##tstate,
#include <linux/task_states.h>
#undef TASK_STATE
};

const char *task_state_to_char =
#define TASK_STATE(tstate, tstate_c, tstate_s) tstate_c
#include <linux/task_states.h>
#undef TASK_STATE
;

const char *task_state_to_string[] = {
#define TASK_STATE(tstate, tstate_c, tstate_s) tstate_s,
#include <linux/task_states.h>
#undef TASK_STATE
};


