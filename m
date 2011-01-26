Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab1AZPKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 10:10:14 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:52099 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab1AZPKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 10:10:12 -0500
Date: Wed, 26 Jan 2011 20:29:55 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 8/20]  8: uprobes: mmap and fork
 hooks.
Message-ID: <20110126145955.GJ19725@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
 <20101216095848.23751.73144.sendpatchset@localhost6.localdomain6>
 <1295957739.28776.717.camel@laptop>
 <20110126090346.GH19725@linux.vnet.ibm.com>
 <1296037239.28776.1149.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1296037239.28776.1149.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-01-26 11:20:39]:

> On Wed, 2011-01-26 at 14:33 +0530, Srikar Dronamraju wrote:
> > 
> > 
> > I actually dont like to release the write_lock and then reacquire it.
> > write_opcode, which is called thro install_uprobe, i.e to insert the
> > actual breakpoint instruction takes a read lock on the mmap_sem.
> > Hence uprobe_mmap gets called in context with write lock on mmap_sem
> > held, I had to release it before calling install_uprobe. 
> 
> Ah, right, so that's going to give you a head-ache ;-)
> 
> The moment you release this mmap_sem, the map you're going to install
> the probe point in can go away.
> 
> The only way to make this work seems to start by holding the mmap_sem
> for writing and make a breakpoint install function that assumes its
> taken and doesn't try to acquire it again.
> 


Yes, this can be done.
I would have to do something like this in register_uprobe().

list_for_each_entry_safe(mm, tmpmm, &tmp_list, uprobes_list) {
		down_read(&mm->map_sem);
                if (!install_uprobe(mm, uprobe))
                        ret = 0;
		up_read(&mm->map_sem);
                list_del(&mm->uprobes_list);
                mmput(mm);
}

Agree that this is much better than what we have now.
