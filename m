Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab2GZPoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:44:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447Ab2GZPog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:44:36 -0400
Date: Thu, 26 Jul 2012 17:41:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: yama_ptrace_access_check(): possible recursive locking detected
Message-ID: <20120726154144.GA20964@redhat.com>
References: <20120726134748.GA20605@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120726134748.GA20605@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26, Fengguang Wu wrote:
>
> Here is a recursive lock possibility:
>
>         ptrace_may_access()
> =>        task_lock(task);
>             yama_ptrace_access_check()
>               get_task_comm()
> =>              task_lock(task);

I think yama_ptrace_access_check() can simply use ->comm

Oleg.

--- x/security/yama/yama_lsm.c
+++ x/security/yama/yama_lsm.c
@@ -279,12 +279,9 @@ static int yama_ptrace_access_check(stru
 	}
 
 	if (rc) {
-		char name[sizeof(current->comm)];
 		printk_ratelimited(KERN_NOTICE
 			"ptrace of pid %d was attempted by: %s (pid %d)\n",
-			child->pid,
-			get_task_comm(name, current),
-			current->pid);
+			child->pid, current->comm, current->pid);
 	}
 
 	return rc;

