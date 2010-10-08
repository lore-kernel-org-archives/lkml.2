Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab0JHHzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 03:55:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988Ab0JHHzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 03:55:14 -0400
Date: Fri, 8 Oct 2010 09:54:14 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v6 07/12] Add async PF initialization to PV guest.
Message-ID: <20101008075414.GB8354@redhat.com>
References: <1286207794-16120-1-git-send-email-gleb@redhat.com>
 <1286207794-16120-8-git-send-email-gleb@redhat.com>
 <4CADC229.9040402@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CADC229.9040402@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 02:50:49PM +0200, Avi Kivity wrote:
>  On 10/04/2010 05:56 PM, Gleb Natapov wrote:
> >Enable async PF in a guest if async PF capability is discovered.
> >
> >
> >+void __cpuinit kvm_guest_cpu_init(void)
> >+{
> >+	if (!kvm_para_available())
> >+		return;
> >+
> >+	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF)&&  kvmapf) {
> >+		u64 pa = __pa(&__get_cpu_var(apf_reason));
> >+
> >+		if (native_write_msr_safe(MSR_KVM_ASYNC_PF_EN,
> >+					  pa | KVM_ASYNC_PF_ENABLED, pa>>  32))
> 
> native_ versions of processor accessors shouldn't be used generally.
> 
> Also, the MSR isn't documented to fail on valid input, so you can
> use a normal wrmsrl() here.
> 
Kernel will oops on wrong write then. OK, why not.

> >+			return;
> >+		__get_cpu_var(apf_reason).enabled = 1;
> >+		printk(KERN_INFO"KVM setup async PF for cpu %d\n",
> >+		       smp_processor_id());
> >+	}
> >+}
> >+
> >
> >+static int kvm_pv_reboot_notify(struct notifier_block *nb,
> >+				unsigned long code, void *unused)
> >+{
> >+	if (code == SYS_RESTART)
> >+		on_each_cpu(kvm_pv_disable_apf, NULL, 1);
> >+	return NOTIFY_DONE;
> >+}
> >+
> >+static struct notifier_block kvm_pv_reboot_nb = {
> >+	.notifier_call = kvm_pv_reboot_notify,
> >+};
> 
> Does this handle kexec?
> 
Yes.

> >+
> >+static void kvm_guest_cpu_notify(void *dummy)
> >+{
> >+	if (!dummy)
> >+		kvm_guest_cpu_init();
> >+	else
> >+		kvm_pv_disable_apf(NULL);
> >+}
> 
> Why are you making decisions based on a dummy input?
> 
> The whole thing looks strange.  Use two functions?
> 
What is so strange? Type of notification is passed as a parameter.
The code that does this is just under the function. I can rename
dummy to something else. Or make it two functions.

--
			Gleb.
