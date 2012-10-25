Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591Ab2JYHvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 03:51:43 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:54220 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756431Ab2JYHvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 03:51:40 -0400
Message-ID: <5088EF85.4080002@de.ibm.com>
Date: Thu, 25 Oct 2012 09:51:33 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>, Alexander Graf <agraf@suse.de>,
        Xiantao Zhang <xiantao.zhang@intel.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH 3/5] kvm: Directly account vtime to system on guest switch
References: <1351126313-17804-1-git-send-email-fweisbec@gmail.com> <1351126313-17804-4-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1351126313-17804-4-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12102507-0342-0000-0000-00000332EEBE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/10/12 02:51, Frederic Weisbecker wrote:
> Switching to or from guest context is done on ioctl context.
> So by the time we call kvm_guest_enter() or kvm_guest_exit()
> we know we are not running the idle task.
> 
> As a result, we can directly account the cputime using
> vtime_account_system_irqsafe().
> 
> There are two good reasons to do this:
> 
> * We avoid some useless checks on guest switch. It optimizes
> a bit this fast path.
> 
> * In the case of CONFIG_IRQ_TIME_ACCOUNTING, calling vtime_account()
> checks for irq time to account. This is pointless since we know
> we are not in an irq on guest switch. This is wasting cpu cycles
> for no good reason. vtime_account_system() OTOH is a no-op in
> this config option.
> 
> * s390 doesn't disable irqs in its implementation of vtime_account().
> If vtime_account() in kvm races with an irq, the pending time might
> be accounted twice. With vtime_account_system_irqsafe() we are protected.

We disable irqs before we call kvm_guest_enter/exit, see kvm-s390.c:


[...]
	if (!kvm_is_ucontrol(vcpu->kvm))
	        kvm_s390_deliver_pending_interrupts(vcpu);
	vcpu->arch.sie_block->icptcode = 0;
	local_irq_disable();
	kvm_guest_enter();
	local_irq_enable();
[...]

