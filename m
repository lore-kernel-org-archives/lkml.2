Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab0JJMss (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 08:48:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155Ab0JJMsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 08:48:47 -0400
Message-ID: <4CB1B5EF.7040207@redhat.com>
Date: Sun, 10 Oct 2010 14:47:43 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v6 06/12] Add PV MSR to enable asynchronous page faults
 delivery.
References: <1286207794-16120-1-git-send-email-gleb@redhat.com> <1286207794-16120-7-git-send-email-gleb@redhat.com> <4CADC01E.3060409@redhat.com> <20101007175329.GF2397@redhat.com>
In-Reply-To: <20101007175329.GF2397@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/07/2010 07:53 PM, Gleb Natapov wrote:
> On Thu, Oct 07, 2010 at 02:42:06PM +0200, Avi Kivity wrote:
> >   On 10/04/2010 05:56 PM, Gleb Natapov wrote:
> >  >Guest enables async PF vcpu functionality using this MSR.
> >  >
> >  >   			return NON_PRESENT;
> >  >+
> >  >+MSR_KVM_ASYNC_PF_EN: 0x4b564d02
> >  >+	data: Bits 63-6 hold 64-byte aligned physical address of a 32bit memory
> >
> >  Given that it must be aligned anyway, we can require it to be a
> >  64-byte region and also require that the guest zero it before
> >  writing the MSR.  That will give us a little more flexibility in the
> >  future.
> >
> No code change needed, so OK.

The guest needs to allocate a 64-byte per-cpu entry instead of a 4-byte 
entry.

> >
> >  >+		return 0;
> >  >+	}
> >  >+
> >  >+	if (kvm_gfn_to_hva_cache_init(vcpu->kvm,&vcpu->arch.apf.data, gpa))
> >  >+		return 1;
> >
> >  Note: we need to handle the memory being removed from underneath
> >  kvm_gfn_to_hve_cache().  Given that, we can just make
> >  kvm_gfn_to_hva_cache_init() return void.  "success" means nothing
> >  when future changes can invalidate it.
> >
> I want to catch guest doing stupid things. If guest give us non-existent
> address I want wrmsr to #GP.

Ok.

> >  >+
> >  >+	kvm_async_pf_wakeup_all(vcpu);
> >
> >  Why is this needed?  If all apfs are flushed at disable time, what
> >  do we need to wake up?
> For migration. Destination will rewrite msr and all processes will be
> waked up.

Ok. What happens to apf completions that happen after all vcpus are stopped?

> >
> >  Need to list the MSR for save/restore/reset.
> >
> >
> This patch adds it to msrs_to_save, no?

Yes, missed it somehow.

-- 
error compiling committee.c: too many arguments to function

