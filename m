Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423399Ab2LFMmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 07:42:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423362Ab2LFMmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 07:42:08 -0500
Date: Thu, 6 Dec 2012 13:42:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Herton Krzesinski <herton.krzesinski@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: freezer: exec should clear PF_NOFREEZE along with PF_KTHREAD
Message-ID: <20121206124201.GA30705@redhat.com>
References: <50BF9CC2.7070705@canonical.com> <1354762294.17107.157.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354762294.17107.157.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(add lkml)

On 12/06, Ben Hutchings wrote:
>
> On Wed, 2012-12-05 at 14:13 -0500, Joseph Salisbury wrote:
>
> > Hi Oleg,
> >
> > A bug was opened against the Ubuntu kernel[0].  It was found that
> > reverting commit b40a79591ca918e7b91b0d9b6abd5d00f2e88c19 resolved this
> > bug, and allowed suspend/resume to work properly.
> >
> > I see that you are the author of this patch, so I wanted to run it by
> > you.  I was thinking of requesting a revert for 3.2 stable, but I wanted
> > to get your feedback first.
> >
> > Thanks,
> >
> > Joe
> >
> >
> > [0] https://bugs.launchpad.net/ubuntu/+source/v86d/+bug/1080530
>
> If I understand this rightly:
> 1. Suspend is aborted because the v86d usermodehelper cannot be frozen.
> 2. Before this fix, usermodehelpers could inherit PF_NOFREEZE (what
> could possibly go wrong with that?!), which is why this didn't
> previously happen.

Yes, try_to_freeze_tasks() ignores PF_NOFREEZE tasks

> 3. However, usermodehelpers are supposed to be disabled while the
> freezer is running.  Why is this one still running?

__usermodehelper_disable() doesn't try to kill/stop/whatever the already
spawned tasks...

The question is, why v86d refuses to freeze? It sleeps in TASK_INTERRUPTIBLE.


Oh... I seem to understand. This is 3.2 kernel, it also has PF_FREEZER_NOSIG.
which should be cleared along with PF_NOFREEZE.

This flag was removed upstream, but the older kernel need the fix. Could
you test the patch below?

Oleg.

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1084,7 +1084,7 @@ int flush_old_exec(struct linux_binprm *
 
 	set_fs(USER_DS);
 	current->flags &=
-		~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD | PF_NOFREEZE);
+		~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD | PF_NOFREEZE | PF_FREEZER_NOSIG);
 	flush_thread();
 	current->personality &= ~bprm->per_clear;
 

