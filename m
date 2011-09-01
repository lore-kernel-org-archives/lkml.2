Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524Ab1IAPp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 11:45:26 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:54895 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439Ab1IAPpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 11:45:25 -0400
Date: Thu, 1 Sep 2011 11:45:03 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        jeremy@goop.org
Subject: Re: [PATCH v2] xen: x86_32: do not enable iterrupts when returning
 from exception in interrupt context
Message-ID: <20110901154503.GA7626@dumpdata.com>
References: <4E5EB794.7050909@goop.org>
 <1314877615-18280-1-git-send-email-imammedo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314877615-18280-1-git-send-email-imammedo@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090205.4E5FA88B.014A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 01:46:55PM +0200, Igor Mammedov wrote:
> If vmalloc page_fault happens inside of interrupt handler with interrupts
> disabled then on exit path from exception handler when there is no pending
> interrupts, the following code (arch/x86/xen/xen-asm_32.S:112):
> 
> 	cmpw $0x0001, XEN_vcpu_info_pending(%eax)
> 	sete XEN_vcpu_info_mask(%eax)
> 
> will enable interrupts even if they has been previously disabled according to
> eflags from the bounce frame (arch/x86/xen/xen-asm_32.S:99)
> 
> 	testb $X86_EFLAGS_IF>>8, 8+1+ESP_OFFSET(%esp)
> 	setz XEN_vcpu_info_mask(%eax)
> 
> Solution is in setting XEN_vcpu_info_mask only when it should be set
> according to
> 	cmpw $0x0001, XEN_vcpu_info_pending(%eax)
> but not clearing it if there isn't any pending events.
> 
> Reproducer for bug is attached to RHBZ 707552
> 
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>

Stuck it in the queue for 3.1 and stable. Thanks for finding this one!
