Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab0JFKu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 06:50:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771Ab0JFKu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 06:50:27 -0400
Message-ID: <4CAC5459.3060004@redhat.com>
Date: Wed, 06 Oct 2010 12:50:01 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, hpa@zytor.com, riel@redhat.com,
        cl@linux-foundation.org
Subject: Re: [PATCH v6 02/12] Halt vcpu if page it tries to access is swapped
 out.
References: <1286207794-16120-1-git-send-email-gleb@redhat.com> <1286207794-16120-3-git-send-email-gleb@redhat.com> <20101005145916.GA28955@amt.cnet>
In-Reply-To: <20101005145916.GA28955@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/05/2010 04:59 PM, Marcelo Tosatti wrote:
> On Mon, Oct 04, 2010 at 05:56:24PM +0200, Gleb Natapov wrote:
> >  If a guest accesses swapped out memory do not swap it in from vcpu thread
> >  context. Schedule work to do swapping and put vcpu into halted state
> >  instead.
> >
> >  Interrupts will still be delivered to the guest and if interrupt will
> >  cause reschedule guest will continue to run another task.
> >
> >  Signed-off-by: Gleb Natapov<gleb@redhat.com>
> >  ---
> >   arch/x86/include/asm/kvm_host.h |   17 +++
> >   arch/x86/kvm/Kconfig            |    1 +
> >   arch/x86/kvm/Makefile           |    1 +
> >   arch/x86/kvm/mmu.c              |   51 +++++++++-
> >   arch/x86/kvm/paging_tmpl.h      |    4 +-
> >   arch/x86/kvm/x86.c              |  109 +++++++++++++++++++-
> >   include/linux/kvm_host.h        |   31 ++++++
> >   include/trace/events/kvm.h      |   88 ++++++++++++++++
> >   virt/kvm/Kconfig                |    3 +
> >   virt/kvm/async_pf.c             |  220 +++++++++++++++++++++++++++++++++++++++
> >   virt/kvm/async_pf.h             |   36 +++++++
> >   virt/kvm/kvm_main.c             |   57 ++++++++--
> >   12 files changed, 603 insertions(+), 15 deletions(-)
> >   create mode 100644 virt/kvm/async_pf.c
> >   create mode 100644 virt/kvm/async_pf.h
> >
>
> >  +	async_pf_cache = NULL;
> >  +}
> >  +
> >  +void kvm_async_pf_vcpu_init(struct kvm_vcpu *vcpu)
> >  +{
> >  +	INIT_LIST_HEAD(&vcpu->async_pf.done);
> >  +	INIT_LIST_HEAD(&vcpu->async_pf.queue);
> >  +	spin_lock_init(&vcpu->async_pf.lock);
> >  +}
> >  +
> >  +static void async_pf_execute(struct work_struct *work)
> >  +{
> >  +	struct page *page;
> >  +	struct kvm_async_pf *apf =
> >  +		container_of(work, struct kvm_async_pf, work);
> >  +	struct mm_struct *mm = apf->mm;
> >  +	struct kvm_vcpu *vcpu = apf->vcpu;
> >  +	unsigned long addr = apf->addr;
> >  +	gva_t gva = apf->gva;
> >  +
> >  +	might_sleep();
> >  +
> >  +	use_mm(mm);
> >  +	down_read(&mm->mmap_sem);
> >  +	get_user_pages(current, mm, addr, 1, 1, 0,&page, NULL);
> >  +	up_read(&mm->mmap_sem);
> >  +	unuse_mm(mm);
> >  +
> >  +	spin_lock(&vcpu->async_pf.lock);
> >  +	list_add_tail(&apf->link,&vcpu->async_pf.done);
> >  +	apf->page = page;
> >  +	spin_unlock(&vcpu->async_pf.lock);
>
> This can fail, and apf->page become NULL.

Does it even become NULL?  On error, get_user_pages() won't update the 
pages argument, so page becomes garbage here.

-- 
error compiling committee.c: too many arguments to function

