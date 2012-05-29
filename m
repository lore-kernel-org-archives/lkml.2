Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab2E2XFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 19:05:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43442 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab2E2XFD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 19:05:03 -0400
Message-ID: <1338332687.26856.189.camel@twins>
Subject: Re: [PATCH 7/7] uprobes: kill uprobes_srcu/uprobe_srcu_id
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>
Date: Wed, 30 May 2012 01:04:47 +0200
In-Reply-To: <20120529193008.GG8057@redhat.com>
References: <20120529192721.GA8048@redhat.com>
	 <20120529193008.GG8057@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-29 at 21:30 +0200, Oleg Nesterov wrote:
> Kill the no longer needed uprobes_srcu/uprobe_srcu_id code.
> 
> It doesn't really work anyway. synchronize_srcu() can only synchronize
> with the code "inside" the srcu_read_lock/srcu_read_unlock section,
> while uprobe_pre_sstep_notifier() does srcu_read_lock() _after_ we
> already hit the breakpoint.
> 
> I guess this probably works "in practice". synchronize_srcu() is slow
> and it implies synchronize_sched(), and the probed task enters the non-
> preemptible section at the start of exception handler. Still this is not
> right at least in theory, and task->uprobe_srcu_id blows task_struct.

This kills the only user of srcu_read_{,un}lock_raw(), so I guess we
could also make:

  9ceae0e2
  101db7b4
  0c53dd8b

go away.. 
