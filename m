Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab2JQGnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 02:43:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:34533 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab2JQGnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 02:43:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,597,1344236400"; 
   d="scan'208";a="157109913"
Date: Wed, 17 Oct 2012 14:43:19 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [3.5.0 BUG] vmx_handle_exit: unexpected, valid vectoring info
 (0x80000b0e)
Message-ID: <20121017064319.GA17754@localhost>
References: <20120912044037.GA23094@localhost>
 <505044AC.80205@redhat.com>
 <5052C732.7060508@linux.vnet.ibm.com>
 <507E4F8E.7000103@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507E4F8E.7000103@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 02:26:22PM +0800, Xiao Guangrong wrote:
> On 09/14/2012 01:57 PM, Xiao Guangrong wrote:
> > On 09/12/2012 04:15 PM, Avi Kivity wrote:
> >> On 09/12/2012 07:40 AM, Fengguang Wu wrote:
> >>> Hi,
> >>>
> >>> 3 of my test boxes running v3.5 kernel become unaccessible and I find
> >>> two of them kept emitting this dmesg:
> >>>
> >>> vmx_handle_exit: unexpected, valid vectoring info (0x80000b0e) and exit reason is 0x31
> >>>
> >>> The other one has froze and the above lines are the last dmesg.
> >>> Any ideas?
> >>
> >> First, that printk should be rate-limited.
> >>
> >> Second, we should add EXIT_REASON_EPT_MISCONFIG (0x31) to 
> >>
> >> 	if ((vectoring_info & VECTORING_INFO_VALID_MASK) &&
> >> 			(exit_reason != EXIT_REASON_EXCEPTION_NMI &&
> >> 			exit_reason != EXIT_REASON_EPT_VIOLATION &&
> >> 			exit_reason != EXIT_REASON_TASK_SWITCH))
> >> 		printk(KERN_WARNING "%s: unexpected, valid vectoring info "
> >> 		       "(0x%x) and exit reason is 0x%x\n",
> >> 		       __func__, vectoring_info, exit_reason);
> >>
> >> since it's easily caused by the guest.
> > 
> > Yes, i will do these.
> > 
> >>
> >> Third, it's really unexpected.  It seems the guest was attempting to deliver a page fault exception (0x0e) but encountered an mmio page during delivery (in the IDT, TSS, stack, or page tables).  Is this reproducible?  If so it's easy to patch kvm to halt in that case and allow examining the guest via qemu.
> >>
> > 
> > Have no idea yet why the box was frozen under this case, will try to write a test case,
> > hope it can help me to find the reason out.
> > 
> 
> Still did not know why linux kernel triggered it. I have posted
> a patchset to report an internal error for this case, hoping
> Fengguang can reproduce it after the patchset and Qemu's dump
> can help us to find the reason out.
> 
> I will keep working on it.

Thanks! Shall I run some patched kernel, or just 3.6.0?

Another problem I sometimes run into is, dmesg no longer works in the
test boxes that run lots of KVMs. It aborts with an error message:

dmesg: klogctl failed: Bad address

Thanks,
Fengguang
