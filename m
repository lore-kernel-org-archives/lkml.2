Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab1AZI6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 03:58:46 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:33670 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab1AZI6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 03:58:45 -0500
Date: Wed, 26 Jan 2011 14:22:03 +0530
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
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 14/20] 14: uprobes: Handing int3
 and singlestep exception.
Message-ID: <20110126085203.GG19725@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
 <20101216095957.23751.57040.sendpatchset@localhost6.localdomain6>
 <1295963779.28776.1059.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1295963779.28776.1059.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-01-25 14:56:19]:

> On Thu, 2010-12-16 at 15:29 +0530, Srikar Dronamraju wrote:
> > +               down_read(&mm->mmap_sem);
> > +               for (vma = mm->mmap; vma; vma = vma->vm_next) {
> > +                       if (!valid_vma(vma))
> > +                               continue;
> > +                       if (probept < vma->vm_start || probept > vma->vm_end)
> > +                               continue;
> > +                       u = find_uprobe(vma->vm_file->f_mapping->host,
> > +                                       probept - vma->vm_start);
> > +                       if (u)
> > +                               break;
> > +               }
> > +               up_read(&mm->mmap_sem); 
> 
> One has to ask, what's wrong with find_vma() ?

Are you looking for something like this.

       down_read(&mm->mmap_sem);
	for (vma = find_vma(mm, probept); ; vma = vma->vm_next) {
	       if (!valid_vma(vma))
		       continue;
	       u = find_uprobe(vma->vm_file->f_mapping->host,
			       probept - vma->vm_start);
	       if (u)
		       break;
       }
       up_read(&mm->mmap_sem); 
