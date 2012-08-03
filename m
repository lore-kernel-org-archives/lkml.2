Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab2HCNvj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 09:51:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284Ab2HCNve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 09:51:34 -0400
Date: Fri, 3 Aug 2012 15:47:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Arapov <anton@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        William Cohen <wcohen@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: Ignore unsupported instructions in uprobe_mmap
Message-ID: <20120803134758.GB2131@redhat.com>
References: <20120728163157.GA22719@redhat.com> <20120731064730.GB5087@linux.vnet.ibm.com> <20120731124805.GA485@redhat.com> <20120802100515.GC5782@linux.vnet.ibm.com> <20120802141757.GA5064@redhat.com> <20120802165452.GB4268@linux.vnet.ibm.com> <20120802175312.GB11933@redhat.com> <20120803012004.GA3565@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120803012004.GA3565@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03, Srikar Dronamraju wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2012-08-02 19:53:12]:
>
> > On 08/02, Srikar Dronamraju wrote:
> > >
> > > This is case where the uprobe_mmap() and uprobe_unregister() raced, and
> > > by the time install_breakpoint() was called by uprobe_mmap(), there were
> > > no consumers.
> >
> > Yes, exactly, and this case doesn't look 100% right too,
> >
> > > i.e there are no uprobe->consumers and the underlying
> > > instruction is still not a breakpoint instruction.
> >
> > Yes, but what if it _IS_ "int3" ?
>
> for int3, install_breakpoint returns -ENOTSUPP as install_breakpoint
> does an explicit check if the instruction is breakpoint instruction
> and x86 analyse_insn() also returns -ENOTSUPP.

install_breakpoint() checks ->consumers first and returns EEXIST.

OK. Suppose that the probed insn is int3, and nobody mmaps it.

	1. uprobe_register() succeeds

	2. uprobe_unregister() is called, it does consumer_del(),
	   but before it calls delete_uprobe()...

	3. uprobe_mmap() finds this uprobe and install_breakpoint()
	   returns -EEXIST.

We could fix this particular problem (and other similar), but I think
this is pointless. This all is broken. Please give me some time to try
to make a patch which removes this all.

> > Yet another reason to move arch_uprobe_analyze_insn/etc to _register.
> >
>
> I am for moving the stuff to _register that avoids us from looking at
> these cases.

Yes. Lets try to do this step-by-step, after we fix the pending/discussed
problems.

Oleg.

