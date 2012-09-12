Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab2ILIPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 04:15:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab2ILIPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 04:15:45 -0400
Message-ID: <505044AC.80205@redhat.com>
Date: Wed, 12 Sep 2012 11:15:40 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: Re: [3.5.0 BUG] vmx_handle_exit: unexpected, valid vectoring info
 (0x80000b0e)
References: <20120912044037.GA23094@localhost>
In-Reply-To: <20120912044037.GA23094@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 07:40 AM, Fengguang Wu wrote:
> Hi,
> 
> 3 of my test boxes running v3.5 kernel become unaccessible and I find
> two of them kept emitting this dmesg:
> 
> vmx_handle_exit: unexpected, valid vectoring info (0x80000b0e) and exit reason is 0x31
> 
> The other one has froze and the above lines are the last dmesg.
> Any ideas?

First, that printk should be rate-limited.

Second, we should add EXIT_REASON_EPT_MISCONFIG (0x31) to 

	if ((vectoring_info & VECTORING_INFO_VALID_MASK) &&
			(exit_reason != EXIT_REASON_EXCEPTION_NMI &&
			exit_reason != EXIT_REASON_EPT_VIOLATION &&
			exit_reason != EXIT_REASON_TASK_SWITCH))
		printk(KERN_WARNING "%s: unexpected, valid vectoring info "
		       "(0x%x) and exit reason is 0x%x\n",
		       __func__, vectoring_info, exit_reason);

since it's easily caused by the guest.

Third, it's really unexpected.  It seems the guest was attempting to deliver a page fault exception (0x0e) but encountered an mmio page during delivery (in the IDT, TSS, stack, or page tables).  Is this reproducible?  If so it's easy to patch kvm to halt in that case and allow examining the guest via qemu.

Maybe we should do so regardless (return a KVM_EXIT_INTERNAL_ERROR).


-- 
error compiling committee.c: too many arguments to function
