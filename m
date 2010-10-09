Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059Ab0JIBF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 21:05:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab0JIBF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 21:05:28 -0400
Date: Fri, 8 Oct 2010 21:37:08 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Avi Kivity <avi@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dean Nelson <dnelson@redhat.com>
Subject: Re: [PATCH 2/2] kvm, MCE, Send SRAR SIGBUS directly
Message-ID: <20101009003708.GA18859@amt.cnet>
References: <1286526255.7768.96.camel@yhuang-dev>
 <20101008202501.GA2291@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008202501.GA2291@amt.cnet>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 05:25:01PM -0300, Marcelo Tosatti wrote:
> On Fri, Oct 08, 2010 at 04:24:15PM +0800, Huang Ying wrote:
> > Originally, SRAR SIGBUS is sent to QEMU-KVM via touching the poisoned
> > page. But commit 96054569190bdec375fe824e48ca1f4e3b53dd36 prevents the
> > signal from being sent. So now the signal is sent via
> > force_sig_info_fault directly.
> > 
> > Reported-by: Dean Nelson <dnelson@redhat.com>
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > ---
> >  arch/x86/include/asm/signal.h |    3 +++
> >  arch/x86/kvm/mmu.c            |   15 +++------------
> >  arch/x86/mm/fault.c           |    6 +++---
> >  3 files changed, 9 insertions(+), 15 deletions(-)
> > 
> >  static int kvm_handle_bad_page(struct kvm *kvm, gfn_t gfn, pfn_t pfn)
> >  {
> >  	kvm_release_pfn_clean(pfn);
> >  	if (is_hwpoison_pfn(pfn)) {
> > -		kvm_send_hwpoison_signal(kvm, gfn);
> > +		force_sig_info_fault(SIGBUS, BUS_MCEERR_AR,
> > +				     gfn_to_hva(kvm, gfn), current);
> >  		return 0;
> >  	} else if (is_fault_pfn(pfn))
> >  		return -EFAULT;
> 
> Better fill siginfo and use force_sig_info, which is already exported.

Thats wrong, its not exported. But there is no need to force delivery,
so i've changed it to use send_sig_info.

Applied the other patches, thanks.

