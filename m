Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106Ab2EUR2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 13:28:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758004Ab2EUR2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 13:28:36 -0400
Date: Mon, 21 May 2012 19:01:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, rusty@rustcorp.com.au,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tj@kernel.org, linux-kernel@vger.kernel.org
Subject: call_usermodehelper && check_hung_uninterruptible_tasks
Message-ID: <20120521170135.GA31803@redhat.com>
References: <4F6A93F5.1070202@panasas.com> <201203241028.IGJ09825.MtOVFHFJQSLOFO@I-love.SAKURA.ne.jp> <4F6D35F0.2020808@panasas.com> <20120323200028.fadf49f8.akpm@linux-foundation.org> <20120324145308.GA10023@redhat.com> <201205191121.BIF57837.FHFOtMOLJQSOFV@I-love.SAKURA.ne.jp> <4FB7170F.7070807@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB7170F.7070807@panasas.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(change subject, add lkml)

On 05/19, Boaz Harrosh wrote:
>
> On 05/19/2012 05:21 AM, Tetsuo Handa wrote:
>
> > By the way, when considering whether we want call_usermodehelper_timeout()
> > or not, maybe we also want to consider below hung check timer topic.
> >
> > I noticed that a task waiting for call_usermodehelper(UMH_WAIT_PROC) to return
> > is subjected to hung check timer. call_usermodehelper(UMH_WAIT_PROC) would
> > normally return within few seconds, but it can take longer than
> > hung_task_timeout_secs if the usermode helper is waiting for (e.g.) user's
> > input. Should hung check timer warn this situation?
> >
>
>
> The fix depends on if we want to enable usermodehelper to wait for user-input ?
> 	we will need to silence the hung check timer

tomoyo_load_policy() can use call_usermodehelper(UMH_WAIT_PROC | UMH_KILLABLE),
this should also silence the hung check.


But there is another problem, wait_for_completion/wait_for_completion_killable
are not freezer-friendly. Perhaps something like the patch below? Just in case,
it should silence check_hung_uninterruptible_tasks() as well.

Oleg.

--- x/kernel/kmod.c
+++ x/kernel/kmod.c
@@ -557,7 +557,9 @@ int call_usermodehelper_exec(struct subp
 		goto unlock;
 
 	if (wait & UMH_KILLABLE) {
+		freezer_do_not_count();
 		retval = wait_for_completion_killable(&done);
+		freezer_count();
 		if (!retval)
 			goto wait_done;
 
@@ -567,7 +569,9 @@ int call_usermodehelper_exec(struct subp
 		/* fallthrough, umh_complete() was already called */
 	}
 
+	freezer_do_not_count();
 	wait_for_completion(&done);
+	freezer_count();
 wait_done:
 	retval = sub_info->retval;
 out:

