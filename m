Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab1AMNHL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 08:07:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651Ab1AMNHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 08:07:04 -0500
Message-ID: <4D2EF8DC.9040301@redhat.com>
Date: Thu, 13 Jan 2011 15:06:36 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Christoph Lameter <cl@linux.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: BUG: sleeping function called from invalid context at mm/slub.c:793
References: <20110110105433.GA17881@shutemov.name> <alpine.DEB.2.00.1101101051260.12243@router.home> <20110110193117.GA20027@shutemov.name> <4D2C279D.5050309@redhat.com> <4D2C3115.9030301@redhat.com> <4D2EF717.8080604@siemens.com>
In-Reply-To: <4D2EF717.8080604@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2011 02:59 PM, Jan Kiszka wrote:
> >  @@ -5351,6 +5351,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
> >   	int r;
> >   	sigset_t sigsaved;
> >
> >  +	if (!tsk_used_math(current)&&  init_fpu(current))
> >  +		return -ENOMEM;
> >  +
>
> Could become a rainy day for the kvm-kmod maintainer:
>
> For compat support on kernels without init_fpu exported yet, can I
> trigger the same result by simply issuing an FPU instruction here so
> that do_device_not_available will perform the allocation? Not really
> nice, but it doesn't appear to me like there is any code path that would
> complain about in-kernel FPU usage (provided we don't need math
> emulation - which is quite likely).

That's a pessimization, since it forces the fpu to be switched.  If both 
qemu and the guest don't use the fpu, we can run a guest with some other 
task's fpu loaded.

Oh, but if it's after the check for !tsk_used_math(), it only triggers 
once, so that's okay.  I guess something like mov %%xmm0, %%xmm0 should 
do nicely.

-- 
error compiling committee.c: too many arguments to function

