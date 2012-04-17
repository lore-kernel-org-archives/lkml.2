Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab2DQHRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 03:17:43 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:48520 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab2DQHRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 03:17:42 -0400
Message-ID: <4F8D18FD.2040801@linux.vnet.ibm.com>
Date: Tue, 17 Apr 2012 12:47:17 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        X86 <x86@kernel.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Alexander Graf <agraf@suse.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Gleb Natapov <gleb@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Xen <xen-devel@lists.xensource.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC V5 3/6] kvm : Add unhalt msr to aid (live) migration
References: <20120323080503.14568.43092.sendpatchset@codeblue> <20120323080723.14568.23068.sendpatchset@codeblue> <20120412001517.GB32051@amt.cnet>
In-Reply-To: <20120412001517.GB32051@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12041707-8878-0000-0000-0000020EAEBB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2012 05:45 AM, Marcelo Tosatti wrote:
> On Fri, Mar 23, 2012 at 01:37:26PM +0530, Raghavendra K T wrote:
>> From: Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>
>>

[...]
>
> Unless there is a reason to use an MSR, should use a normal ioctl
> such as KVM_{GET,SET}_MP_STATE.
>
>

I agree with you. In the current implementation, since we are not doing
any communication between host/guest (on this flag), I too felt MSR is
an overkill for this.

IMO, patch like below should do the job, which I am planning to include
in next version of patch.
Let me know if you foresee any side-effects.

---
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index aa44292..5c81a66 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5691,7 +5691,9 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu 
*vcpu,
  int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
  				    struct kvm_mp_state *mp_state)
  {
-	mp_state->mp_state = vcpu->arch.mp_state;
+	mp_state->mp_state = (vcpu->arch.mp_state == KVM_MP_STATE_HALTED &&
+				vcpu->pv_unhalted)?
+				KVM_MP_STATE_RUNNABLE : vcpu->arch.mp_state;
  	return 0;
  }

