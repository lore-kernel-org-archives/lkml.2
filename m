Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957Ab0FBUk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 16:40:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758646Ab0FBUkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 16:40:24 -0400
Date: Wed, 2 Jun 2010 22:38:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] oom: Make coredump interruptible
Message-ID: <20100602203827.GA29244@redhat.com>
References: <20100601093951.2430.A69D9226@jp.fujitsu.com> <20100601201843.GA20732@redhat.com> <20100602221805.F524.A69D9226@jp.fujitsu.com> <20100602154210.GA9622@redhat.com> <20100602172956.5A3E34A491@magilla.sf.frob.com> <20100602175325.GA16474@redhat.com> <20100602185812.4B5894A549@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602185812.4B5894A549@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02, Roland McGrath wrote:
>
> > when select_bad_process() finds the task P to kill it can participate
> > in the core dump (sleep in exit_mm), but we should somehow inform the
> > thread which actually dumps the core: P->mm->core_state->dumper.
>
> Perhaps it should simply do that: if you would choose P to oom-kill, and
> P->mm->core_state!=NULL, then choose P->mm->core_state->dumper instead.

... to set TIF_MEMDIE which should be checked in elf_core_dump().

Probably yes.

> > Well, we can use TIF_MEMDIE if we chose the right thread, I think.
> > But perhaps mm->flags |= MMF_OOM is better, it can have other user.
> > I dunno.
>
> This is all the quick hack before get around to just making core dumping
> fully-interruptible, no?  So we should go with whatever is the simplest
> change now.

Yes.

> Perhaps this belongs in another thread as you suggested.  But I wonder what
> we might get just from s/TASK_UNINTERRUPTIBLE/TASK_KILLABLE/ in exit_mm.

Oh. This needs more thinking. Definitely the task sleeping in exit_mm()
must not exit until core_state->dumper->thread returns from do_coredump().
If nothing else, the dumper can use its task_struct and it relies on
the stable core_thread->next list. And right now TASK_KILLABLE can't
work anyway, it is possible that fatal_signal_pending() is true.

But perhaps we can do something later. Assuming that do_coredump() is
interruptible, TASK_KILLABLE can make the difference only if the dumper
belongs to another thread-group.

Oleg.

