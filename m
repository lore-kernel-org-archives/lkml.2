Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab2JFJwa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 05:52:30 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:54998 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab2JFJw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 05:52:29 -0400
Date: Sat, 6 Oct 2012 15:22:58 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] uprobes: Fix uprobe_copy_insn() race with itself
Message-ID: <20121006095258.GD9145@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120930194119.GA11278@redhat.com>
 <20120930194224.GA11347@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120930194224.GA11347@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12100609-5518-0000-0000-00000830518D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-09-30 21:42:24]:

> install_breakpoint() is called under mm->mmap_sem, this protects
> set_swbp() but not uprobe_copy_insn(). Two or more different tasks
> can call install_breakpoint()->uprobe_copy_insn() at the same time,
> this leads to numerous problems if UPROBE_COPY_INSN is not set.
> 
> Just for example, the second copy_insn() can corrupt the already
> analyzed/fixuped uprobe->arch.insn and race with handle_swbp().
> 
> This patch simply adds uprobe->copy_mutex to serialize this code.
> We could probably reuse ->consumer_rwsem, but this would mean that
> consumer->handler() can not use mm->mmap_sem, not good.
> 
> Note: this is another temporary ugly hack until we move this logic
> into uprobe_register().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Given that we copy just for the first install, and register not being  a
performance path, Can we use a single mutex instead of a per-uprobe
mutex.

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

