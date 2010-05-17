Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab0EQQys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 12:54:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:36387 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab0EQQyr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 12:54:47 -0400
Subject: Re: [PATCH 1/1] fix-task-states-in-sched_switch-event.patch
From: Peter Zijlstra <peterz@infradead.org>
To: Carsten Emde <C.Emde@osadl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <4BF15F08.5050108@osadl.org>
References: <20100516221844.515632338@osadl.org>
	 <20100516222207.541520625@osadl.org> <1274098973.5605.4695.camel@twins>
	 <4BF15F08.5050108@osadl.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 17 May 2010 18:54:03 +0200
Message-ID: <1274115243.5605.5255.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 17:21 +0200, Carsten Emde wrote:

> > Since we all love vile macro magic, is the below any better?
> >
> > include/linux/task_states.h
> >
> > TASK_STATE(RUNNING, "R", "running")
> > TASK_STATE(INTERRUPTIBLE, "S", "sleeping")
> > ...
> Well, yes, this looks very nice and is perfectly readable and
> maintainable.
> 
> > enum {
> > #define TASK_STATE(tstate, tstate_c, tstate_s) __TASK_##tstate,
> > #include<linux/task_states.h>
> > #undef TASK_STATE
> > };
> >
> > enum {
> > #define TASK_STATE(tstate, tstate_c, tstate_s) \
> > 	TASK_##tstate = 1<<  __TASK_##tstate,
> > #include<linux/task_states.h>
> > #undef TASK_STATE
> > };
> >
> > const char *task_state_to_char =
> > #define TASK_STATE(tstate, tstate_c, tstate_s) tstate_c
> > #include<linux/task_states.h>
> > #undef TASK_STATE
> > ;
> >
> > const char *task_state_to_string[] = {
> > #define TASK_STATE(tstate, tstate_c, tstate_s) tstate_s,
> > #include<linux/task_states.h>
> > #undef TASK_STATE
> > };
> I find this section less convincing (although certainly
> indistinguishable from magic).
> 
> In addition, we need to take care of the various state name prefixes
> TASK, __TASK and EXIT and name clashes:
> TASK_RUNNING
> TASK_INTERRUPTIBLE
> TASK_UNINTERRUPTIBLE
> __TASK_STOPPED
> __TASK_TRACED
> EXIT_ZOMBIE
> EXIT_DEAD
> TASK_DEAD
> TASK_WAKEKILL
> TASK_WAKING

We could manually add:

#define EXIT_ZOMBIE TASK_ZOMBIE
#define EXIT_DEAD TASK_DEAD

But those two __TASK ones are unfortunate indeed.

> And we still need to maintain the defines in include/trace/events/
> sched.h:
> { 1, TASK_STATE_1 } , { 2, TASK_STATE_2 },
> { 4, TASK_STATE_4 }, { 8, TASK_STATE_8 },
> { 16, TASK_STATE_16 }, { 32, TASK_STATE_32 },
> { 64, TASK_STATE_64 }, { 128, TASK_STATE_128 },
> { 256, TASK_STATE_256 }
> ) : TASK_STATE_0,

#define TASK_STATE(tstate, tstate_c, tstate_s) \
	{ __TASK_##tstate, tstate_c },
#include <linux/task_state.h>
#undef TASK_STATE

Should get you mostly there I guess, trick would be making the user deal
with { 0, "R" }

> If we could use a general approach for all states, I would immediately
> go for your proposal. But since we anyway need to define the states
> individually, I would vote for the current version of the patch.
> 
> Or would you prefer to simply apply a minimal fix to correct the
> erroneous output of the sched_switch event and to leave the rest as an
> exercise for the future?

Dunno, I guess we can do with your version, just wanted to mention this
method.
