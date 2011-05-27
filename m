Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626Ab1E0XWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 19:22:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:34653 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757557Ab1E0XWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 19:22:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=XNF1m6xGyEspBVm/OIKcrbi8LoYFcuJAPq0Q3SGdGOfNtqUszeoLHKGMKwFdA/4flr
         519c4+TKz7aAhpP1BxvA==
Date: Fri, 27 May 2011 16:22:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trace: Set oom_score_adj to maximum for ring buffer
 allocating process
In-Reply-To: <1306519125-19301-1-git-send-email-vnagarnaik@google.com>
Message-ID: <alpine.DEB.2.00.1105271618470.9445@chino.kir.corp.google.com>
References: <1306439537-23706-1-git-send-email-vnagarnaik@google.com> <1306519125-19301-1-git-send-email-vnagarnaik@google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 May 2011, Vaibhav Nagarnaik wrote:

> The tracing ring buffer is allocated from kernel memory. While
> allocating the memory, if OOM happens, the allocating process might not
> be the one that gets killed, since the ring-buffer memory is not
> allocated as process memory. Thus random processes might get killed
> during the allocation.
> 
> This patch makes sure that the allocating process is considered the most
> likely oom-kill-able process while the allocating is going on. Thus if
> oom-killer is invoked because of ring-buffer allocation, it is easier
> for the ring buffer memory to be freed and save important system
> processes from being killed.
> 
> This patch also adds __GFP_NORETRY flag to the ring buffer allocation
> calls to make it fail more gracefully if the system will not be able to
> complete the allocation request.
> 
> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>

Still not sure this is what we want, I'm afraid.

I like the addition of __GFP_NORETRY, but I don't understand the use of 
test_set_oom_score_adj() here.  Why can't we use oom_killer_disable(), 
allocate with __GFP_NORETRY, and then do oom_killer_enable()?

This prevents other tasks from getting oom killed themselves if they have 
oom_score_adj of OOM_SCORE_ADJ_MAX and allows the write to fail with 
-ENOMEM rather then being oom killed out from under us.

So why is test_set_oom_score_adj() better?

The alternative would be to setup an oom notifier for the ring buffer and 
stop allocating prior to killing a task and return a size that was smaller 
than what the user requested.
