Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab0EQPYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 11:24:48 -0400
Received: from toro.web-alm.net ([62.245.132.31]:55151 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530Ab0EQPYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 11:24:46 -0400
Message-ID: <4BF15F08.5050108@osadl.org>
Date: Mon, 17 May 2010 17:21:44 +0200
From: Carsten Emde <C.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL) eG
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/1] fix-task-states-in-sched_switch-event.patch
References: <20100516221844.515632338@osadl.org>	 <20100516222207.541520625@osadl.org> <1274098973.5605.4695.camel@twins>
In-Reply-To: <1274098973.5605.4695.camel@twins>
Content-Type: multipart/mixed;
 boundary="------------010907070203060209030807"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010907070203060209030807
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Peter,

>>   #define TASK_RUNNING           0
>> +#define TASK_STATE_0           "R"
>> +#define TASK_STATE_NAME_0      "running"
>> +
>>   #define TASK_INTERRUPTIBLE     1
>> +#define TASK_STATE_1           "S"
>> +#define TASK_STATE_NAME_1      "sleeping"
>> +
>>   #define TASK_UNINTERRUPTIBLE   2
>> +#define TASK_STATE_2           "D"
>> +#define TASK_STATE_NAME_2      "disk sleep"
>> +
>>   #define __TASK_STOPPED         4
>> +#define TASK_STATE_4           "T"
>> +#define TASK_STATE_NAME_4      "stopped"
>> +
>>   #define __TASK_TRACED          8
>> +#define TASK_STATE_8           "t"
>> +#define TASK_STATE_NAME_8      "tracing stop"
>> +
>>   /* in tsk->exit_state */
>>   #define EXIT_ZOMBIE            16
>> +#define TASK_STATE_16          "Z"
>> +#define TASK_STATE_NAME_16     "zombie"
>> +
>>   #define EXIT_DEAD              32
>> +#define TASK_STATE_32          "X"
>> +#define TASK_STATE_NAME_32     "dead"
>> +
>>   /* in tsk->state again */
>>   #define TASK_DEAD              64
>> +#define TASK_STATE_64          "x"
>> +#define TASK_STATE_NAME_64     "dead"
>> +
>>   #define TASK_WAKEKILL          128
>> +#define TASK_STATE_128         "K"
>> +#define TASK_STATE_NAME_128    "wakekill"
>> +
>>   #define TASK_WAKING            256
>> +#define TASK_STATE_256         "W"
>> +#define TASK_STATE_NAME_256    "waking"
>
> Since we all love vile macro magic, is the below any better?
>
> include/linux/task_states.h
>
> TASK_STATE(RUNNING, "R", "running")
> TASK_STATE(INTERRUPTIBLE, "S", "sleeping")
> ...
Well, yes, this looks very nice and is perfectly readable and
maintainable.

> enum {
> #define TASK_STATE(tstate, tstate_c, tstate_s) __TASK_##tstate,
> #include<linux/task_states.h>
> #undef TASK_STATE
> };
>
> enum {
> #define TASK_STATE(tstate, tstate_c, tstate_s) \
> 	TASK_##tstate = 1<<  __TASK_##tstate,
> #include<linux/task_states.h>
> #undef TASK_STATE
> };
>
> const char *task_state_to_char =
> #define TASK_STATE(tstate, tstate_c, tstate_s) tstate_c
> #include<linux/task_states.h>
> #undef TASK_STATE
> ;
>
> const char *task_state_to_string[] = {
> #define TASK_STATE(tstate, tstate_c, tstate_s) tstate_s,
> #include<linux/task_states.h>
> #undef TASK_STATE
> };
I find this section less convincing (although certainly
indistinguishable from magic).

In addition, we need to take care of the various state name prefixes
TASK, __TASK and EXIT and name clashes:
TASK_RUNNING
TASK_INTERRUPTIBLE
TASK_UNINTERRUPTIBLE
__TASK_STOPPED
__TASK_TRACED
EXIT_ZOMBIE
EXIT_DEAD
TASK_DEAD
TASK_WAKEKILL
TASK_WAKING

And we still need to maintain the defines in include/trace/events/
sched.h:
{ 1, TASK_STATE_1 } , { 2, TASK_STATE_2 },
{ 4, TASK_STATE_4 }, { 8, TASK_STATE_8 },
{ 16, TASK_STATE_16 }, { 32, TASK_STATE_32 },
{ 64, TASK_STATE_64 }, { 128, TASK_STATE_128 },
{ 256, TASK_STATE_256 }
) : TASK_STATE_0,

If we could use a general approach for all states, I would immediately
go for your proposal. But since we anyway need to define the states
individually, I would vote for the current version of the patch.

Or would you prefer to simply apply a minimal fix to correct the
erroneous output of the sched_switch event and to leave the rest as an
exercise for the future?


	Carsten.

--------------010907070203060209030807
Content-Type: text/plain;
 name="fix-just-task-states-in-sched_switch-event.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="fix-just-task-states-in-sched_switch-event.patch"

LS0tCiBpbmNsdWRlL3RyYWNlL2V2ZW50cy9zY2hlZC5oIHwgICAgMiArLQogMSBmaWxlIGNo
YW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpJbmRleDogaGVhZC9pbmNs
dWRlL3RyYWNlL2V2ZW50cy9zY2hlZC5oCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGhlYWQub3JpZy9p
bmNsdWRlL3RyYWNlL2V2ZW50cy9zY2hlZC5oCisrKyBoZWFkL2luY2x1ZGUvdHJhY2UvZXZl
bnRzL3NjaGVkLmgKQEAgLTE1MSw3ICsxNTEsNyBAQCBUUkFDRV9FVkVOVChzY2hlZF9zd2l0
Y2gsCiAJCSAgX19wcmludF9mbGFncyhfX2VudHJ5LT5wcmV2X3N0YXRlLCAifCIsCiAJCQkJ
eyAxLCAiUyJ9ICwgeyAyLCAiRCIgfSwgeyA0LCAiVCIgfSwgeyA4LCAidCIgfSwKIAkJCQl7
IDE2LCAiWiIgfSwgeyAzMiwgIlgiIH0sIHsgNjQsICJ4IiB9LAotCQkJCXsgMTI4LCAiVyIg
fSkgOiAiUiIsCisJCQkJeyAxMjgsICJLIiB9LCB7IDI1NiwgIlciIH0pIDogIlIiLAogCQlf
X2VudHJ5LT5uZXh0X2NvbW0sIF9fZW50cnktPm5leHRfcGlkLCBfX2VudHJ5LT5uZXh0X3By
aW8pCiApOwogCg==
--------------010907070203060209030807--
