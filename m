Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab1BAK0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 05:26:24 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34565 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab1BAK0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 05:26:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XueBDchXnQiszARKwT1FFhehRzmnDIX+nddmlkd/d0wQi8YLxvEbhWI/oD/sPUyP8q
         /vgstwdR0fS9d4fVPo0OlwK+l6mROCYfCOkEglH6u6OU7riiz/8eBwUjnXi6TYvTdw35
         hA6ZhUpSGEldYP2hxOovnZ7RnLsV8Ff3VHVs4=
Date: Tue, 1 Feb 2011 11:26:18 +0100
From: Tejun Heo <tj@kernel.org>
To: Roland McGrath <roland@redhat.com>
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: [PATCH] ptrace: use safer wake up on ptrace_detach()
Message-ID: <20110201102618.GE14211@htj.dyndns.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
 <1296227324-25295-3-git-send-email-tj@kernel.org>
 <20110128184601.CBF7C180996@magilla.sf.frob.com>
 <20110131103855.GD7459@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110131103855.GD7459@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wake_up_process() call in ptrace_detach() is spurious and not
interlocked with the tracee state.  IOW, the tracee could be running
or sleeping in any place in the kernel by the time wake_up_process()
is called.  This can lead to the tracee waking up unexpectedly which
can be dangerous.

The wake_up is spurious and should be removed but for now reduce its
toxicity by only waking up if the tracee is in TRACED or STOPPED
state.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: stable@kernel.org
---
So, something like this.  Roland, Oleg, can you guys please ack this?
Also, should these ptrace patches be routed?  Shall I set up a git
tree?

Thank you.

 kernel/ptrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: work/kernel/ptrace.c
===================================================================
--- work.orig/kernel/ptrace.c
+++ work/kernel/ptrace.c
@@ -313,7 +313,7 @@ int ptrace_detach(struct task_struct *ch
 		child->exit_code = data;
 		dead = __ptrace_detach(current, child);
 		if (!child->exit_state)
-			wake_up_process(child);
+			wake_up_state(child, TASK_TRACED | TASK_STOPPED);
 	}
 	write_unlock_irq(&tasklist_lock);
 
