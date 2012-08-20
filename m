Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab2HTLvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 07:51:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34017 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab2HTLvL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 07:51:11 -0400
Message-ID: <1345463458.23018.37.camel@twins>
Subject: Re: lockdep trace from posix timers
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Date: Mon, 20 Aug 2012 13:50:58 +0200
In-Reply-To: <1345463081.23018.34.camel@twins>
References: <20120724203613.GA9637@redhat.com>
	 <1345140478.29668.54.camel@twins> <20120817151447.GA7918@redhat.com>
	 <1345446957.23018.14.camel@twins> <1345463081.23018.34.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-20 at 13:44 +0200, Peter Zijlstra wrote:
>  int
> +task_work_add(struct task_struct *task, struct callback_head *work, bool notify)
>  {
> +       struct callback_head **head = &task->task_works;
> +       struct callback_head *entry, *old_entry;
> +
> +       entry = &head;

My compiler just alerted me that: 

	entry = *head; 

works a lot better..

> +       for (;;) {
> +               if (entry == &dead)
> +                       return -ESRCH;
> +
> +               old_entry = entry;
> +               work->next = entry;
> +               entry = cmpxchg(head, old_entry, work);
> +               if (entry == old_entry)
> +                       break;
> +       }
>  
>         /* test_and_set_bit() implies mb(), see tracehook_notify_resume(). */
>         if (notify)
>                 set_notify_resume(task);
> +
>         return 0;
>  } 
