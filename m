Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab2ILIZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 04:25:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:12241 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab2ILIZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 04:25:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,408,1344236400"; 
   d="scan'208";a="221091401"
Date: Wed, 12 Sep 2012 16:25:17 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: Re: [3.5.0 BUG] vmx_handle_exit: unexpected, valid vectoring info
 (0x80000b0e)
Message-ID: <20120912082517.GA27847@localhost>
References: <20120912044037.GA23094@localhost>
 <505044AC.80205@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505044AC.80205@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 11:15:40AM +0300, Avi Kivity wrote:
> On 09/12/2012 07:40 AM, Fengguang Wu wrote:
> > Hi,
> > 
> > 3 of my test boxes running v3.5 kernel become unaccessible and I find
> > two of them kept emitting this dmesg:
> > 
> > vmx_handle_exit: unexpected, valid vectoring info (0x80000b0e) and exit reason is 0x31
> > 
> > The other one has froze and the above lines are the last dmesg.
> > Any ideas?
> 
> First, that printk should be rate-limited.
> 
> Second, we should add EXIT_REASON_EPT_MISCONFIG (0x31) to 
> 
> 	if ((vectoring_info & VECTORING_INFO_VALID_MASK) &&
> 			(exit_reason != EXIT_REASON_EXCEPTION_NMI &&
> 			exit_reason != EXIT_REASON_EPT_VIOLATION &&
> 			exit_reason != EXIT_REASON_TASK_SWITCH))
> 		printk(KERN_WARNING "%s: unexpected, valid vectoring info "
> 		       "(0x%x) and exit reason is 0x%x\n",
> 		       __func__, vectoring_info, exit_reason);
> 
> since it's easily caused by the guest.
> 
> Third, it's really unexpected.  It seems the guest was attempting to deliver a page fault exception (0x0e) but encountered an mmio page during delivery (in the IDT, TSS, stack, or page tables).  Is this reproducible?  If so it's easy to patch kvm to halt in that case and allow examining the guest via qemu.

It's the first time I see such errors.  For now I've upgraded the host
kernel to 3.6-rc5.  Let's check whether it will happen again.

> Maybe we should do so regardless (return a KVM_EXIT_INTERNAL_ERROR).

I can test your changes either way.

Thanks,
Fengguang
