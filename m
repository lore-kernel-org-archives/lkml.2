Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab0IVMXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 08:23:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:48413 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab0IVMXE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 08:23:04 -0400
Subject: Re: [tip:perf/core] perf events: Clean up pid passing
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, will.deacon@arm.com, matthltc@us.ibm.com,
        mahesh@linux.vnet.ibm.com, rostedt@goodmis.org, tglx@linutronix.de,
        prasad@linux.vnet.ibm.com, greenrd@greenrd.org, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-38a81da2205f94e8a2a834b51a6b99c91fc7c2e8@git.kernel.org>
References: <a134e5e392ab0204961fd1a62c84a222bf5874a9.1284407763.git.matthltc@us.ibm.com>
	 <tip-38a81da2205f94e8a2a834b51a6b99c91fc7c2e8@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 22 Sep 2010 14:22:22 +0200
Message-ID: <1285158142.2275.898.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-15 at 10:03 +0000, tip-bot for Matt Helsley wrote:
> +++ b/kernel/hw_breakpoint.c
> @@ -433,8 +433,7 @@ register_user_hw_breakpoint(struct perf_event_attr *attr,
>                             perf_overflow_handler_t triggered,
>                             struct task_struct *tsk)
>  {
> -       return perf_event_create_kernel_counter(attr, -1, task_pid_vnr(tsk),
> -                                               triggered);
> +       return perf_event_create_kernel_counter(attr, -1, tsk, triggered);
>  }
>  EXPORT_SYMBOL_GPL(register_user_hw_breakpoint);
>   

That seems to have gotten lost somehow..

/usr/src/linux-2.6/kernel/hw_breakpoint.c: In function ‘register_user_hw_breakpoint’:
/usr/src/linux-2.6/kernel/hw_breakpoint.c:436: warning: passing argument 3 of ‘perf_event_create_kernel_counter’ makes pointer from integer without a cast
/usr/src/linux-2.6/include/linux/perf_event.h:909: note: expected ‘struct task_struct *’ but argument is of type ‘pid_t’

The below cures it

---
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 8f36c99..3b714e8 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -433,7 +433,7 @@ register_user_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered,
 			    struct task_struct *tsk)
 {
-	return perf_event_create_kernel_counter(attr, -1, task_pid_vnr(tsk), triggered);
+	return perf_event_create_kernel_counter(attr, -1, tsk, triggered);
 }
 EXPORT_SYMBOL_GPL(register_user_hw_breakpoint);
 

