Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030414Ab2HPSXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 14:23:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030366Ab2HPSW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 14:22:58 -0400
Date: Thu, 16 Aug 2012 18:56:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, James Morris <james.l.morris@oracle.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        John Johansen <john.johansen@canonical.com>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2] Yama: access task_struct->comm directly
Message-ID: <20120816165629.GA12599@redhat.com>
References: <20120815184155.GA3666@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120815184155.GA3666@www.outflux.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15, Kees Cook wrote:
>
> v2: update with newly added traceme report.

...

> @@ -319,12 +316,9 @@ static int yama_ptrace_traceme(struct task_struct *parent)
>  	}
>  
>  	if (rc) {
> -		char name[sizeof(current->comm)];
>  		printk_ratelimited(KERN_NOTICE
>  			"ptraceme of pid %d was attempted by: %s (pid %d)\n",
> -			current->pid,
> -			get_task_comm(name, parent),
> -			parent->pid);
> +			current->pid, parent->comm, parent->pid);

Hmm, yes. This change is even more important. This is called under
write_lock_irq(tasklist_lock), task_lock() can deadlock if we race
with another CPU doing task_lock()->interrupt->read_lock(tasklist).

Oleg.

