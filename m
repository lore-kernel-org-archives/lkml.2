Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab2HBQzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 12:55:11 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60149 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392Ab2HBQzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 12:55:03 -0400
Date: Thu, 2 Aug 2012 22:12:25 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Arapov <anton@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        William Cohen <wcohen@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: Ignore unsupported instructions in uprobe_mmap
Message-ID: <20120802164225.GA4268@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120728163157.GA22719@redhat.com>
 <20120731064730.GB5087@linux.vnet.ibm.com>
 <20120731124805.GA485@redhat.com>
 <20120802100515.GC5782@linux.vnet.ibm.com>
 <20120802135313.GA4334@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120802135313.GA4334@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080216-5930-0000-0000-00000A789634
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > uprobe_mmap()->install_breakpoint() can fail if the probed insn is not
> > supported
> 
> But there are other reasons why it can fail,
> 
> > However failing mmap_region()/do_fork() because of a probe on an
> > unsupported instruction is wrong.
> 
> Srikar, I strongly, absolutely disagree. Please correct me, but..
> 
> Do you realize how much uprobes hooks in mmap_region/dup_mmap are broken?
> 
> (cough, can't resist, vma_adjust()->uprobe_mmap() is not right too, but
>  this is another story).
> 
> OK, lets start with dup_mmap:
> 
> 		// retval == 0
> 
> 		if (file && uprobe_mmap(tmp))
> 			goto out;
> 
> 	out:
> 		up_write(&mm->mmap_sem);
> 		flush_tlb_mm(oldmm);
> 		up_write(&oldmm->mmap_sem);
> 		return retval;
> 
> Given that retval == 0, what do you think dup_mmap() returns if
> uprobe_mmap() fails? And note that we didn't copy all vmas.
> OK, at least this can't crash (afaics), and easy to fix.
> 
> 
> But mmap_region() is worse, much worse. It simply can _not_ fail
> after uprobe_mmap (of course, I am not saying this is unfixable)
> without the crash. And note that the crash is "delayed". And btw,
> like dup_mmap(), mmap_region() doesn't return the error too.

Oh, thats really a bad mistake from my side. I apologize.

> 
> Srikar, I strongly believe this horror must not exist. Either
> we should teach mmap_region() and dup_mmap() (and vma_adjust!)
> to fail correctly, or we should ignore the error code.
> 
> It is that simple, isn't it?
> 

Right.

> Whatever you do with uprobe_mmap(), even if you change it to always
> return 0, the code in mmap_region() is absolutely, absolutely broken.
> 

But uprobe_mmap() still needs to walk thro the probe list and 
insert the other probes. Currently we just ignore the remaining probes
and that has to be fixed within uprobe_mmap.

> Do you agree?
> 
> And once again. I agree, in the long term we should reconsider
> this change. But we need a simple fix for now/stable.
> 

Agree.

> > Hence change uprobe_mmap() to ignore unsupported instructions.
> 
> OK. Now suppose that mmap_region()-> uprobe_mmap() fails because
> the caller is SIGKILL'ed (so __get_user_pages fails). Given that
> mmap_region() can't handle the error correctly, the kernel can
> crash.
> 

How about having your fix + my patch to fix the uprobe_mmap()?

-- 
Thanks and Regards
Srikar

