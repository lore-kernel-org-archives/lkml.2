Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab2ADRMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 12:12:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62627 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756447Ab2ADRMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 12:12:33 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=0wm1LphaX4QA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=PvIzjc8avhGb6yaluUoA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1325697150.12696.29.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v8 3.2.0-rc5 1/9] uprobes: Install and remove
 breakpoints.
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 04 Jan 2012 12:12:30 -0500
In-Reply-To: <1325695916.2697.5.camel@twins>
References: <20111216122756.2085.95791.sendpatchset@srdronam.in.ibm.com>
	 <20111216122808.2085.76986.sendpatchset@srdronam.in.ibm.com>
	 <1325695916.2697.5.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-04 at 17:51 +0100, Peter Zijlstra wrote:

> > +               if (is_register)
> > +                       ret = install_breakpoint(mm, uprobe, vma, vi->vaddr);
> > +               else
> > +                       remove_breakpoint(mm, uprobe, vi->vaddr);
> > +
> > +               up_read(&mm->mmap_sem);
> > +               mmput(mm);
> > +               if (is_register) {
> > +                       if (ret && ret == -EEXIST)
> > +                               ret = 0;
> > +                       if (ret)
> > +                               break;
> > +               }
> 
> Since you init ret := 0 and remove_breakpoint doesn't change it, this
> conditional on is_register is superfluous.

True, but I would argue that this is easier to understand. That is, we
only break on a failed install_breakpoint (is_register is set). If I
looked at this code and saw:

	if (is_register)
		ret = install_breakpoint()
	else	
		remove_breakpoint()

	[...]

	if (ret && ret == -EEXIST)
		ret = 0;
	if (ret)
		break;

I would first think that there might be a bug. That is, we should have a
ret = remove_breakpoint().

Thus, I would say, either leave this as is and hope gcc is smart enough
to optimize out the if (is_register), or add the comment:

	/* ret will always be zero on remove_breakpoint */
	if (ret && ret == -EEXIST)
		ret = 0;
	if (ret)
		break;

-- Steve

> 
> > +       }
> > +       list_for_each_entry_safe(vi, tmpvi, &try_list, probe_list) {
> > +               list_del(&vi->probe_list);
> > +               kfree(vi);
> > +       }
> > +       return ret;
> > +} 


