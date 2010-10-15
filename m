Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585Ab0JOU4J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:56:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:60538 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932453Ab0JOU4I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:56:08 -0400
Subject: Re: [PATCH 4/9] jump label: Fix deadlock b/w jump_label_mutex vs.
 text_mutex
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jason Baron <jbaron@redhat.com>
In-Reply-To: <20101015201036.691801067@goodmis.org>
References: <20101015200949.134732894@goodmis.org>
	 <20101015201036.691801067@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Oct 2010 22:55:34 +0200
Message-ID: <1287176134.1998.113.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 16:09 -0400, Steven Rostedt wrote:
> +void jump_label_lock(void)
> +{
> +       mutex_lock(&jump_label_mutex);
> +}
> +

> +++ b/kernel/kprobes.c
> @@ -1145,13 +1145,16 @@ int __kprobes register_kprobe(struct kprobe *p)
>                 return ret;
>  
>         preempt_disable();
> +       jump_label_lock();

How exactly does that work?

>         if (!kernel_text_address((unsigned long) p->addr) ||
>             in_kprobes_functions((unsigned long) p->addr) ||
>             ftrace_text_reserved(p->addr, p->addr) ||
>             jump_label_text_reserved(p->addr, p->addr)) {
>                 preempt_enable();
> +               jump_label_unlock();
>                 return -EINVAL;
>         }
> +       jump_label_unlock(); 
