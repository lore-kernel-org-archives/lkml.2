Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab1AZKQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 05:16:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:47053 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab1AZKQm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 05:16:42 -0500
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 14/20] 14: uprobes: Handing int3
 and singlestep exception.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
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
In-Reply-To: <20110126085203.GG19725@linux.vnet.ibm.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
	 <20101216095957.23751.57040.sendpatchset@localhost6.localdomain6>
	 <1295963779.28776.1059.camel@laptop>
	 <20110126085203.GG19725@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 Jan 2011 11:17:11 +0100
Message-ID: <1296037031.28776.1146.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 14:22 +0530, Srikar Dronamraju wrote:
> * Peter Zijlstra <peterz@infradead.org> [2011-01-25 14:56:19]:
> 
> > On Thu, 2010-12-16 at 15:29 +0530, Srikar Dronamraju wrote:
> > > +               down_read(&mm->mmap_sem);
> > > +               for (vma = mm->mmap; vma; vma = vma->vm_next) {
> > > +                       if (!valid_vma(vma))
> > > +                               continue;
> > > +                       if (probept < vma->vm_start || probept > vma->vm_end)
> > > +                               continue;
> > > +                       u = find_uprobe(vma->vm_file->f_mapping->host,
> > > +                                       probept - vma->vm_start);
> > > +                       if (u)
> > > +                               break;
> > > +               }
> > > +               up_read(&mm->mmap_sem); 
> > 
> > One has to ask, what's wrong with find_vma() ?
> 
> Are you looking for something like this.
> 
>        down_read(&mm->mmap_sem);
> 	for (vma = find_vma(mm, probept); ; vma = vma->vm_next) {
> 	       if (!valid_vma(vma))
> 		       continue;
> 	       u = find_uprobe(vma->vm_file->f_mapping->host,
> 			       probept - vma->vm_start);
> 	       if (u)
> 		       break;
>        }
>        up_read(&mm->mmap_sem); 

How could you ever need to iterate here? There is only a single vma that
covers the probe point, if that doesn't find a uprobe, there isn't any.
