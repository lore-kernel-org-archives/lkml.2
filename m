Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab1JDKdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 06:33:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755594Ab1JDKdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 06:33:15 -0400
Date: Tue, 4 Oct 2011 11:57:26 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, joerg.roedel@amd.com,
        mingo@elte.hu, a.p.zijlstra@chello.nl
Subject: Re: [PATCH 7/9] KVM, VMX: add support for switching of
 PERF_GLOBAL_CTRL
Message-ID: <20111004095726.GF30105@redhat.com>
References: <1317649795-18259-1-git-send-email-gleb@redhat.com>
 <1317649795-18259-8-git-send-email-gleb@redhat.com>
 <4E8AD293.8070905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8AD293.8070905@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 11:32:03AM +0200, Avi Kivity wrote:
> On 10/03/2011 03:49 PM, Gleb Natapov wrote:
> >Some cpus have special support for switching PERF_GLOBAL_CTRL msr.
> >Add logic to detect if such support exists and works properly and extend
> >msr switching code to use it if available. Also extend number of generic
> >msr switching entries to 8.
> >
> >
> >  static DECLARE_BITMAP(vmx_vpid_bitmap, VMX_NR_VPIDS);
> >  static DEFINE_SPINLOCK(vmx_vpid_lock);
> >@@ -1195,10 +1196,29 @@ static void clear_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr)
> >  {
> >  	unsigned i;
> >  	struct msr_autoload *m =&vmx->msr_autoload;
> >+	u32 entry_load, exit_load;
> >+	bool done = false;
> >
> >-	if (msr == MSR_EFER&&  cpu_has_load_ia32_efer) {
> >-		vmcs_clear_bits(VM_ENTRY_CONTROLS, VM_ENTRY_LOAD_IA32_EFER);
> >-		vmcs_clear_bits(VM_EXIT_CONTROLS, VM_EXIT_LOAD_IA32_EFER);
> >+	switch (msr) {
> >+	case MSR_EFER:
> >+		if (cpu_has_load_ia32_efer) {
> >+			entry_load = VM_ENTRY_LOAD_IA32_EFER;
> >+			exit_load = VM_EXIT_LOAD_IA32_EFER;
> >+			done = true;
> >+		}
> >+		break;
> >+	case MSR_CORE_PERF_GLOBAL_CTRL:
> >+		if (cpu_has_load_perf_global_ctrl) {
> >+			entry_load = VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
> >+			exit_load = VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
> >+			done = true;
> >+		}
> >+		break;
> >+	}
> >+
> >+	if (done) {
> >+		vmcs_clear_bits(VM_ENTRY_CONTROLS, entry_load);
> >+		vmcs_clear_bits(VM_EXIT_CONTROLS, exit_load);
> >  		return;
> >  	}
> >
> >
> 
> This is ugly.  How about
> 
>    if (msr == MSR_EFER && cpu_has_load_ia32_efer) {
>        clear_atomic_switch_msr_special(VM_ENTRY_LOAD_IA32_EFER,
> VM_EXIT_LOAD_IA32_EFER);
>        return;
>    }
> 
> avoids the fake 'done' variable.
> 
OK.

--
			Gleb.
