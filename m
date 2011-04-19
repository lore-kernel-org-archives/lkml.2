Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab1DSNkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 09:40:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:38009 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab1DSNkE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 09:40:04 -0400
Subject: Re: [PATCH v3 2.6.39-rc1-tip 15/26] 15: uprobes: Handing int3 and
 singlestep exception.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110401143527.15455.32854.sendpatchset@localhost6.localdomain6>
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
	 <20110401143527.15455.32854.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 19 Apr 2011 15:39:19 +0200
Message-ID: <1303220359.8345.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-01 at 20:05 +0530, Srikar Dronamraju wrote:
> +               probept = uprobes_get_bkpt_addr(regs);
> +               down_read(&mm->mmap_sem);
> +               for (vma = mm->mmap; vma; vma = vma->vm_next) {
> +                       if (!valid_vma(vma))
> +                               continue;
> +                       if (probept < vma->vm_start || probept > vma->vm_end)
> +                               continue;
> +                       u = find_uprobe(vma->vm_file->f_mapping->host,
> +                                       probept - vma->vm_start);
> +                       break;
> +               }

Why the linear vma walk? Surely the find_vma() suffices since there can
only be one vma that matches a particular vaddr.

> +               up_read(&mm->mmap_sem); 
