Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab1HXKO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 06:14:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50727 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab1HXKO0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 06:14:26 -0400
MIME-Version: 1.0
In-Reply-To: <20110822161914.GA9399@redhat.com>
References: <48dnn9u5x3e4qoh8meht42xk.1313966177259@email.android.com>
	<4E527684.3020206@draigBrady.com>
	<20110822161914.GA9399@redhat.com>
Date: Wed, 24 Aug 2011 18:14:24 +0800
Message-ID: <CACV3sbJjDhzKq8YQEnrTQPVVw7YsZjLe45G5sWaMRBk3+Vxkcg@mail.gmail.com>
Subject: Re: [PATCH] coredump: fix pipe coredump when core limit is 0
From: Jovi Zhang <bookjovi@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: =?UTF-8?Q?P=C3=A1draig_Brady?= <P@draigbrady.com>,
        Neil Horman <nhorman@tuxdriver.com>, dhowells@redhat.com,
        roland@redhat.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/23 Oleg Nesterov <oleg@redhat.com>:
> On 08/22, Pádraig Brady wrote:
>>
>> On 08/21/2011 11:36 PM, Neil Horman wrote:
>> > Concur.  The comment should be changed
>> > Neil
>> >
>> > Oleg Nesterov <oleg@redhat.com> wrote:
>> >
>> >> On 08/21, Oleg Nesterov wrote:
>> >>>
>> >>> On 08/21, bookjovi@gmail.com wrote:
>> >>>>
>> >>>> For non-pipe case, limit 0 also means drop the coredump, so just put
>> >>>> the zero limit check at do_coredump function begining.
>> >>>
>> >>> Neil, what do you think? Should we change the code or the comment?
>> >>
>> >> Personally I think we should fix the comment. I think RLIMIT_CORE
>> >> doesn't apply in this case, limit == 1 check is very special. And
>> >> this is what linux always did, except between 725eae32 and 898b374a.
>>
>> Sorry for jumping in late here.
>> I would really like `ulimit -c 0` to completely disable core dumps,
>> including not running core_pattern, as I also mentioned here:
>> https://bugs.launchpad.net/ubuntu/+source/apport/+bug/62511
>> I noticed this in a script where ctrl-\ was taking a long
>> time to be registered as the core_pattern was run unconditionally.
>
> May be. As I said, I do not really know and personally I agree with
> everything. My only point was, this is not the bug, this is what we
> always did.
>
> This is up to Neil, I think.
>
> Oleg.
>
>
Well, so here have two questions.
1) That comments "but a limit of 0 skips the dump" definitely is wrong
right now, it don't match with reality.
2) In ispipe case, core limit 0 should skip the dump or not? this need
more discussion.
   from pipe coredump point of view, core limit is irrelevant, it
doesn't write to file system.
   from user point of view, there will be a lot of core files if we
let core limit 0 create core file, user might be boring.

I fix the comments part by below patch(thanks Oleg's comments), please
use attachment patch when merge.

>From dc7b02a1e0e413fb96d22f1d4ef4da98115cfb9d Mon Sep 17 00:00:00 2001
From: Jovi Zhang <bookjovi@gmail.com>
Date: Wed, 17 Aug 2011 15:34:29 +0800
Subject: [PATCH] coredump: fix wrong comments on core limits of pipe
coredump case

In commit 898b374a, core limits recursive check vaule changed from 0 to 1,
but the corresponding comments was not changed correctly.

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
---
 fs/exec.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 25dcbe5..ba493cc 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -2158,15 +2158,16 @@ void do_coredump(long signr, int exit_code,
struct pt_regs *regs)
 		}

 		if (cprm.limit == 1) {
-			/*
+			/* See umh_pipe_setup() which sets RLIMIT_CORE = 1.
+			 *
 			 * Normally core limits are irrelevant to pipes, since
 			 * we're not writing to the file system, but we use
-			 * cprm.limit of 1 here as a speacial value. Any
-			 * non-1 limit gets set to RLIM_INFINITY below, but
-			 * a limit of 0 skips the dump.  This is a consistent
-			 * way to catch recursive crashes.  We can still crash
-			 * if the core_pattern binary sets RLIM_CORE =  !1
-			 * but it runs as root, and can do lots of stupid things
+			 * cprm.limit of 1 here as a speacial value, this is a
+			 * consistent way to catch recursive crashes.
+			 * We can still crash if the core_pattern binary sets
+			 * RLIM_CORE = !1, but it runs as root, and can do
+			 * lots of stupid things.
+			 *
 			 * Note that we use task_tgid_vnr here to grab the pid
 			 * of the process group leader.  That way we get the
 			 * right pid if a thread in a multi-threaded
-- 
1.6.5.2
