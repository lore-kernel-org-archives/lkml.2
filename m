Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab2D2MXi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 08:23:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348Ab2D2MXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 08:23:36 -0400
Message-ID: <4F9D32B4.8040002@redhat.com>
Date: Sun, 29 Apr 2012 15:23:16 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
CC: peterz@infradead.org, mingo@elte.hu, jeremy@goop.org, mtosatti@redhat.com,
        kvm@vger.kernel.org, x86@kernel.org, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [RFC PATCH v1 3/5] KVM: Add paravirt kvm_flush_tlb_others
References: <20120427161727.27082.43096.stgit@abhimanyu> <20120427162401.27082.59387.stgit@abhimanyu>
In-Reply-To: <20120427162401.27082.59387.stgit@abhimanyu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2012 07:24 PM, Nikunj A. Dadhania wrote:
> flush_tlb_others_ipi depends on lot of statics in tlb.c.  Replicated
> the flush_tlb_others_ipi as kvm_flush_tlb_others to further adapt to
> paravirtualization.
>
> Use the vcpu state information inside the kvm_flush_tlb_others to
> avoid sending ipi to pre-empted vcpus.
>
> * Do not send ipi's to offline vcpus and set flush_on_enter flag

get_user_pages_fast() depends on the IPI to hold off page table teardown
while they are locklessly walked with interrupts disabled.  If a vcpu
were to be preempted while in this critical section, another vcpu
tearing down page tables would go ahead and destroy them.  when the
preempted vcpu resumes it then touches the freed pages.

We could try to teach kvm and get_user_pages_fast() about this, but this
is intrusive.  Another option is to replace the cpu_relax() loop with
something that sleeps and is then woken up by the TLB IPI handler if needed.

> * For online vcpus: Wait for them to clear the flag
>
>

-- 
error compiling committee.c: too many arguments to function

