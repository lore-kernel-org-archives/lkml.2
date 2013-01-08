Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab3AHRpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 12:45:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756485Ab3AHRpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 12:45:43 -0500
Date: Tue, 8 Jan 2013 18:44:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] uprobes: Fix utask->xol_vaddr leak in pre_ssout()
Message-ID: <20130108174447.GA887@redhat.com>
References: <20121231175150.GA32066@redhat.com> <20121231175226.GA32108@redhat.com> <20130108121328.GH1325@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130108121328.GH1325@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08, Srikar Dronamraju wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2012-12-31 18:52:26]:
>
> > pre_ssout() should do xol_free_insn_slot() if arch_uprobe_pre_xol()
> > fails, otherwise nobody will free the allocated slot.
> >
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
> Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Thanks!

> (one nit below)
> ...
> > @@ -1316,7 +1317,13 @@ pre_ssout(struct uprobe *uprobe, struct pt_regs *regs, unsigned long bp_vaddr)
> >  	utask->xol_vaddr = xol_vaddr;
> >  	utask->vaddr = bp_vaddr;
> >
> > -	return arch_uprobe_pre_xol(&uprobe->arch, regs);
> > +	err = arch_uprobe_pre_xol(&uprobe->arch, regs);
> > +	if (unlikely(err)) {
> > +		xol_free_insn_slot(current);
> > +		return err;
> > +	}
> > +
> > +	return 0;
> >  }
>
> Nit: we could reduce a line or two with
>
> 	err = arch_uprobe_pre_xol(&uprobe->arch, regs);
> 	if (unlikely(err))
> 		xol_free_insn_slot(current);
>
> 	return err;

Yes, but this is also preparation for the next patch which adds more
code after arch_uprobe_pre_xol() == 0.

Oleg.

