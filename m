Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014Ab1ESPCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 11:02:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34902 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932548Ab1ESPCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 11:02:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BCF5uDFdLty6ZMpRhAkQau14zAZA7C8eK69UnsMJEUJjkFcVo8FA7c5B+PLiFebrMq
         ik/fadiWFOBHw5v4UVqIHTsv6rxhjoUcDJu4dVzVWUr2pm1RbAE7w1y7VXlecrQxuUfX
         2g54x55WPNQVbrL5XUeQ6Pcg6iQTRvs/ObIAI=
Date: Thu, 19 May 2011 17:02:29 +0200
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Message-ID: <20110519150229.GK627@htj.dyndns.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <1305569849-10448-4-git-send-email-tj@kernel.org>
 <201105180240.56754.vda.linux@googlemail.com>
 <20110518095539.GU20624@htj.dyndns.org>
 <20110519141728.GJ627@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519141728.GJ627@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, again.

On Thu, May 19, 2011 at 04:17:28PM +0200, Tejun Heo wrote:
> On Wed, May 18, 2011 at 11:55:39AM +0200, Tejun Heo wrote:
> > I've been thinking about Jan's suggestion to make ATTACH and DETACH
> > not require tracee to trap.  We already have this for DETACH for cases
> > where the tracer is killed and it seems it wouldn't be too difficult
> > to make that happen for ATTACH either and for that to be truly useful
> > I suppose PTRACE_SETOPTIONS shouldn't require trapped state either.
> > Jan, would that be enough for the use cases you have on mind?
> 
> I've been trying this and clean DETACH requires the tracee to be
> trapped (or not running).  The arch detach hook, which BTW is not
> executed when the tracer is killed, modifies tracee state expecting it
> to be off-cpu.
> 
> But making SEIZE not trigger INTERRUPT and SETOPTIONS without
> requiring TRACED don't seem too difficult.  Jan, would that be enough?
> Oleg, what do you think?

Even the implementation is rather simple.  If SEIZE and INTERRUPT are
okay as implemented, the following should be fine too.

Thanks.

---
 kernel/ptrace.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

Index: work/kernel/ptrace.c
===================================================================
--- work.orig/kernel/ptrace.c
+++ work/kernel/ptrace.c
@@ -329,7 +329,7 @@ static int ptrace_attach(struct task_str
 
 	__ptrace_link(task, current);
 
-	/* SEIZE uses TRAP_STOP instead of SIGSTOP for initial trap */
+	/* SEIZE doesn't trap tracee on attach */
 	if (!seize)
 		send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
 
@@ -353,9 +353,6 @@ static int ptrace_attach(struct task_str
 	if (task_is_stopped(task)) {
 		task->jobctl |= JOBCTL_TRAP_STOP | JOBCTL_TRAPPING;
 		signal_wake_up(task, 1);
-	} else if (seize) {
-		task->jobctl |= JOBCTL_TRAP_STOP;
-		signal_wake_up(task, 0);
 	}
 
 	spin_unlock(&task->sighand->siglock);
@@ -907,6 +904,17 @@ static struct task_struct *ptrace_get_ta
 #define arch_ptrace_attach(child)	do { } while (0)
 #endif
 
+static bool ptrace_is_async_req(struct task_struct *child, int req)
+{
+	if (req == PTRACE_KILL)
+		return true;
+
+	if (!(child->ptrace & PT_SEIZED))
+		return false;
+
+	return req == PTRACE_SETOPTIONS || req == PTRACE_INTERRUPT;
+}
+
 /**
  * ptrace_put_task_struct - ptrace request processing done, put child
  * @child: child task struct to put
@@ -971,8 +979,7 @@ SYSCALL_DEFINE4(ptrace, long, request, l
 		goto out_put_task_struct;
 	}
 
-	ret = ptrace_check_attach(child, request == PTRACE_KILL ||
-				  request == PTRACE_INTERRUPT);
+	ret = ptrace_check_attach(child, ptrace_is_async_req(child, request));
 	if (ret < 0)
 		goto out_put_task_struct;
 
@@ -1114,8 +1121,7 @@ asmlinkage long compat_sys_ptrace(compat
 		goto out_put_task_struct;
 	}
 
-	ret = ptrace_check_attach(child, request == PTRACE_KILL ||
-				  request == PTRACE_INTERRUPT);
+	ret = ptrace_check_attach(child, ptrace_is_async_req(child, request));
 	if (!ret)
 		ret = compat_arch_ptrace(child, request, addr, data);
 
