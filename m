Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab0HPNto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 09:49:44 -0400
Received: from depni.sinp.msu.ru ([213.131.7.21]:53681 "EHLO depni.sinp.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313Ab0HPNtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 09:49:43 -0400
From: Serge Belyshev <belyshev@depni.sinp.msu.ru>
To: Alexander Graf <agraf@suse.de>
Cc: Dieter Ries <mail@dieterries.net>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 23/42] KVM: Activate Virtualization On Demand
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
	<1258373983-8693-24-git-send-email-avi@redhat.com>
	<4BA1504A.3090801@dieterries.net>
	<808FF008-53B9-4271-904C-117A24ADF18C@suse.de>
	<20100317224002.GA5156@Localhorst.asterix.local>
	<59B2FA1C-035D-41BC-8359-65BDE8D541FE@suse.de>
	<20100318071131.GC24062@Localhorst.asterix.local>
	<4DCA075C-F95E-4FEB-BECA-15D43E1DC1AB@suse.de>
	<87ocddz4zy.fsf@depni.sinp.msu.ru>
	<122B6102-F892-4D2C-A85B-52F9BB0CB11E@suse.de>
Date: Mon, 16 Aug 2010 13:49:39 +0000
In-Reply-To: <122B6102-F892-4D2C-A85B-52F9BB0CB11E@suse.de> (Alexander Graf's
	message of "Mon, 16 Aug 2010 15:24:08 +0200")
Message-ID: <877hjq4qh8.fsf@depni.sinp.msu.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Graf <agraf@suse.de> writes:

> Hrm - try to use the following (probably whitespace broken and 100% untested) hacky patch:
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 56c9b6b..bde9ee3 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -429,9 +429,11 @@ static int svm_hardware_enable(void *garbage)
>         struct desc_struct *gdt;
>         int me = raw_smp_processor_id();
>  
> +#if 0
>         rdmsrl(MSR_EFER, efer);
>         if (efer & EFER_SVME)
>                 return -EBUSY;
> +#endif
>  

I tested a bit different hack keeping rdmsrl but removing the if() and
it works fine for me:

Index: linux/arch/x86/kvm/svm.c
===================================================================
--- linux.orig/arch/x86/kvm/svm.c
+++ linux/arch/x86/kvm/svm.c
@@ -429,8 +429,7 @@ static int svm_hardware_enable(void *gar
 	int me = raw_smp_processor_id();
 
 	rdmsrl(MSR_EFER, efer);
-	if (efer & EFER_SVME)
-		return -EBUSY;
+	printk(KERN_DEBUG "svm_hardware_enable: efer %x on %d\n", efer, me);
 
 	if (!has_svm()) {
 		printk(KERN_ERR "svm_hardware_enable: err EOPNOTSUPP on %d\n",

Here is an example of its output:

[231441.358111] svm_hardware_enable: efer 1d01 on 0
[231441.358117] svm_hardware_enable: efer d01 on 3
[231441.358124] svm_hardware_enable: efer d01 on 2
[231441.358135] svm_hardware_enable: efer d01 on 1
[231675.168967] svm_hardware_enable: efer d01 on 0
[231675.168972] svm_hardware_enable: efer d01 on 1
[231675.168983] svm_hardware_enable: efer d01 on 2
[231675.168995] svm_hardware_enable: efer d01 on 3


After reboot, the first kvm run always reports efer = 1d01 on the first cpu.
In all subsequent runs before reboot efer stays d01 on all cpus.
