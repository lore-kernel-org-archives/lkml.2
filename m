Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245Ab1COSKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 14:10:33 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44867 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758100Ab1COSK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 14:10:29 -0400
Date: Tue, 15 Mar 2011 23:34:23 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2.6.38-rc8-tip 5/20] 5: Uprobes: register/unregister
 probes.
Message-ID: <20110315180423.GA10429@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
 <20110314133454.27435.81020.sendpatchset@localhost6.localdomain6>
 <alpine.LFD.2.00.1103151439400.2787@localhost6.localdomain6>
 <20110315171536.GA24254@linux.vnet.ibm.com>
 <1300211262.9910.295.camel@gandalf.stny.rr.com>
 <1300211411.2203.290.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1300211411.2203.290.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-03-15 18:50:11]:

> On Tue, 2011-03-15 at 13:47 -0400, Steven Rostedt wrote:
> > On Tue, 2011-03-15 at 22:45 +0530, Srikar Dronamraju wrote:
> > > > > +   }
> > > > > +   list_for_each_entry_safe(mm, tmpmm, &tmp_list, uprobes_list) {
> > > > > +           down_read(&mm->mmap_sem);
> > > > > +           if (!install_uprobe(mm, uprobe))
> > > > > +                   ret = 0;
> > > > 
> > > > Installing it once is success ?
> > > 
> > > This is a little tricky. My intention was to return success even if one
> > > install is successful. If we return error, then the caller can go
> > > ahead and free the consumer. Since we return success if there are
> > > currently no processes that have mapped this inode, I was tempted to
> > > return success on atleast one successful install.
> > 
> > What about an all or nothing approach. If one fails, remove all that
> > were installed, and give up.
> 
> That sounds like a much saner semantic and is what we generally do in
> the kernel.

One of the install_uprobe could be failing because the process was
almost exiting, something like there was no mm->owner. Also lets
assume that the first few install_uprobes go thro and the last
install_uprobe fails. There could be breakpoint hits corresponding to
the already installed uprobes that get displayed. i.e all
breakpoint hits from the first install_uprobe to the time we detect a
failed a install_uprobe and revert all inserted breakpoints will be
shown as being captured.

Also register_uprobe will only install probes for processes that are
actively and have mapped the inode.  However install_uprobe called from
uprobe_mmap which also registers the probe can fail. Now should we take
the same yardstick and remove all the probes corresponding to the
successful register_uprobe?
