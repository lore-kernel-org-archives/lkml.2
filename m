Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab1FPMBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 08:01:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:33065 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962Ab1FPMBf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 08:01:35 -0400
Subject: Re: [PATCH v4 3.0-rc2-tip 7/22]  7: uprobes: mmap and fork hooks.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110616032645.GF4952@linux.vnet.ibm.com>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
	 <20110607125931.28590.12362.sendpatchset@localhost6.localdomain6>
	 <1308161486.2171.61.camel@laptop>
	 <20110616032645.GF4952@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 16 Jun 2011 14:00:26 +0200
Message-ID: <1308225626.13240.34.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 08:56 +0530, Srikar Dronamraju wrote: 
> * Peter Zijlstra <peterz@infradead.org> [2011-06-15 20:11:26]:
> 
> > On Tue, 2011-06-07 at 18:29 +0530, Srikar Dronamraju wrote:
> > > +       up_write(&mm->mmap_sem);
> > > +       mutex_lock(&uprobes_mutex);
> > > +       down_read(&mm->mmap_sem); 
> > 
> > egads, and all that without a comment explaining why you think that is
> > even remotely sane.
> > 
> > I'm not at all convinced, it would expose the mmap() even though you
> > could still decide to tear it down if this function were to fail, I bet
> > there's some funnies there.
> 
> The problem is with lock ordering.  register/unregister operations
> acquire uprobes_mutex (which serializes register unregister and the
> mmap_hook) and then holds mmap_sem for read before they insert a
> breakpoint.
> 
> But the mmap hook would be called with mmap_sem held for write. So
> acquiring uprobes_mutex can result in deadlock. Hence we release the
> mmap_sem, take the uprobes_mutex and then again hold the mmap_sem.

Sure, I saw why you wanted to do it, I'm just not quite convinced its
safe to do and something like this definitely wants a comment explaining
why its safe to drop mmap_sem.  

> After we re-acquire the mmap_sem, we do check if the vma is valid.

But you don't on the return path, and if !ret
mmap_region():unmap_and_free_vma will be touching vma again to remove
it.

> Do we have better solutions?

/me kicks the brain into gear and walks off to get a fresh cup of tea.

So the reason we take uprobes_mutex there is to avoid probes from going
away while you're installing them, right?

So we start by doing this add_to_temp_list() thing (horrid name), which
iterates the probes on this inode under uprobes_treelock and adds them
to a list.

Then we iterate the list, installing the probles.

How about we make the initial pass under uprobes_treelock take a
references on the probe, and then after install_breakpoint() succeeds we
again take uprobes_treelock and validate the uprobe still exists in the
tree and drop the extra reference, if not we simply remove the
breakpoint again and continue like it never existed.

That should avoid the need to take uprobes_mutex and not require
dropping mmap_sem, right?
