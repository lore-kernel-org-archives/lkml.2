Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab1FPJrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 05:47:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:39065 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448Ab1FPJrR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 05:47:17 -0400
Subject: Re: [PATCH v4 3.0-rc2-tip 4/22]  4: Uprobes: register/unregister
 probes.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110616041137.GG4952@linux.vnet.ibm.com>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
	 <20110607125900.28590.16071.sendpatchset@localhost6.localdomain6>
	 <1308159719.2171.57.camel@laptop>
	 <20110616041137.GG4952@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 16 Jun 2011 11:46:22 +0200
Message-ID: <1308217582.15315.94.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 09:41 +0530, Srikar Dronamraju wrote:
> * Peter Zijlstra <peterz@infradead.org> [2011-06-15 19:41:59]:
> 
> > On Tue, 2011-06-07 at 18:29 +0530, Srikar Dronamraju wrote:
> > > 1. Use mm->owner and walk thro the thread_group of mm->owner, siblings
> > > of mm->owner, siblings of parent of mm->owner.  This should be
> > > good list to traverse. Not sure if this is an exhaustive
> > > enough list that all tasks that have a mm set to this mm_struct are
> > > walked through. 
> > 
> > As per copy_process():
> > 
> > 	/*
> > 	 * Thread groups must share signals as well, and detached threads
> > 	 * can only be started up within the thread group.
> > 	 */
> > 	if ((clone_flags & CLONE_THREAD) && !(clone_flags & CLONE_SIGHAND))
> > 		return ERR_PTR(-EINVAL);
> > 
> > 	/*
> > 	 * Shared signal handlers imply shared VM. By way of the above,
> > 	 * thread groups also imply shared VM. Blocking this case allows
> > 	 * for various simplifications in other code.
> > 	 */
> > 	if ((clone_flags & CLONE_SIGHAND) && !(clone_flags & CLONE_VM))
> > 		return ERR_PTR(-EINVAL);
> > 
> > CLONE_THREAD implies CLONE_VM, but not the other way around, we
> > therefore would be able to CLONE_VM and not be part of the primary
> > owner's thread group.
> > 
> > This is of course all terribly sad..
> 
> Agree, 
> 
> If clone(CLONE_VM) were to be done by a thread_group leader, we can walk
> thro the siblings of parent of mm->owner.
> 
> However if clone(CLONE_VM) were to be done by non thread_group_leader
> thread, then we dont even seem to add it to the init_task. i.e I dont
> think we can refer to such a thread even when we walk thro
> do_each_thread(g,t) { .. } while_each_thread(g,t);
> 
> right?

No, we initialize p->group_leader = p; and only change that for
CLONE_THREAD, so a clone without CLONE_THREAD always results in a new
thread group leader, which are always added to the init_task list.

Or I'm now confused, which isn't at all impossible with that code ;-)
