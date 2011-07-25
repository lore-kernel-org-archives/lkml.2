Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321Ab1GYM3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 08:29:53 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:58345 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab1GYM3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 08:29:46 -0400
Date: Mon, 25 Jul 2011 17:47:14 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3.0-rc2-tip 4/22]  4: Uprobes: register/unregister
 probes.
Message-ID: <20110725121714.GA17966@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
 <20110607125900.28590.16071.sendpatchset@localhost6.localdomain6>
 <20110724180713.GA24599@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110724180713.GA24599@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2011-07-24 20:07:13]:

> Hi Srikar,
> 
> I still hope some day I'll find the time to read the whole series ;)
> Trying to continue from where I have stopped, and it seems that this
> patch has a couple more problems.


Thanks for the review and I sincerely hope you find time and that too at
the earliest. 

> 
> On 06/07, Srikar Dronamraju wrote:
> >
> > A probe is specified by a file:offset.  While registering, a breakpoint
> > is inserted for the first consumer, On subsequent probes, the consumer
> > gets appended to the existing consumers. While unregistering a
> > breakpoint is removed if the consumer happens to be the last consumer.
> > All other unregisterations, the consumer is deleted from the list of
> > consumers.
> >
> > Probe specifications are maintained in a rb tree. A probe specification
> > is converted into a uprobe before store in a rb tree.  A uprobe can be
> > shared by many consumers.
> 
> register/unregister logic looks racy...
> 
> Supose that uprobe U has a single consumer C and register_uprobe()
> is called with the same inode/offset, while another thread does
> unregister(U,C).
> 
> 	- register() calls alloc_uprobe(), finds the entry in rb tree,
> 	  and increments U->ref. But this doesn't add the new consumer.
> 
> 	- uregister() does del_consumer(), and removes the single
> 	  consumer C.
> 
> 	  then it takes uprobes_mutex, sees uprobe->consumers == NULL
> 	  and calls delete_uprobe()->rb_erase()
> 
> 	- register() continues, takes uprobes_mutex, re-inserts the
> 	  breakpoints, finds the new consumer and succeeds.
> 
> 	  However, this uprobe is not in rb-tree, it was deleted
> 	  by unregister.
> 

Agree, 
I will move the alloc_uprobe under the mutex_lock.

On a side_note: As per the current discussions in this thread, I plan to
use inode->i_mutex so that we could serialize register/unregister if
they are for two different files.

> 
> 
> OTOH. Suppose we add the new uprobe. register()->alloc_uprobe() sets
> new_uprobe->ref == 2. If something goes wrong after that, register()
> does delete_uprobe() + put_uprobe(), new_uprobe->ref becomes 1 and
> we leak this uprobe.
> 

Agree:
yes I will add a put_uprobe() just after delete_uprobe() but just before
the goto.
sidenote: Even this code will change based on the discussions we had on
this topic. But I will ensure to make the appropriate changes are taken
care of.

-- 
Thanks and Regards
Srikar

> Oleg.
