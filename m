Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab2HBQzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 12:55:14 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60466 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478Ab2HBQzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 12:55:12 -0400
Date: Thu, 2 Aug 2012 22:24:52 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Arapov <anton@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        William Cohen <wcohen@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: Ignore unsupported instructions in uprobe_mmap
Message-ID: <20120802165452.GB4268@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120728163157.GA22719@redhat.com>
 <20120731064730.GB5087@linux.vnet.ibm.com>
 <20120731124805.GA485@redhat.com>
 <20120802100515.GC5782@linux.vnet.ibm.com>
 <20120802141757.GA5064@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120802141757.GA5064@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080216-7182-0000-0000-00000226E159
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-08-02 16:17:57]:

> Forgot to mention...
> 
> On 08/02, Srikar Dronamraju wrote:
> >
> > While at it, add a missing put_uprobe() in the path where uprobe_mmap()
> > races with uprobe_unregister().
> > ...
> > @@ -1051,8 +1051,10 @@ int uprobe_mmap(struct vm_area_struct *vma)
> >  			if (ret == -EEXIST) {
> >  				ret = 0;
> >
> > -				if (!is_swbp_at_addr(vma->vm_mm, vaddr))
> > +				if (!is_swbp_at_addr(vma->vm_mm, vaddr)) {
> > +					put_uprobe(uprobe);
> >  					continue;
> > +				}
> 
> Yes, this part looks correct.
> 
> In fact, I think this is not really correct anyway (wrt counter)
> but we are going to kill it.
> 
> 

Are you expecting the counter to be decreased/increased here?

This is case where the uprobe_mmap() and uprobe_unregister() raced, and
by the time install_breakpoint() was called by uprobe_mmap(), there were
no consumers.  i.e there are no uprobe->consumers and the underlying
instruction is still not a breakpoint instruction. 

Since we are refusing to add a breakpoint and that there is no
breakpoint, there is no need to increment/decrement the counter here.

Do let me know if I have missed something.

-- 
Thanks and Regards
Srikar

