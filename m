Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab0CQV5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 17:57:41 -0400
Received: from psi.thgersdorf.net ([188.40.92.130]:34947 "EHLO mail.psioc.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab0CQV5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 17:57:40 -0400
Message-ID: <4BA1504A.3090801@dieterries.net>
Date: Wed, 17 Mar 2010 22:57:30 +0100
From: Dieter Ries <mail@dieterries.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100308 Thunderbird/3.0.3
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Alexander Graf <agraf@suse.de>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Dieter Ries <mail@dieterries.net>
Subject: Re: [PATCH 23/42] KVM: Activate Virtualization On Demand
References: <1258373983-8693-1-git-send-email-avi@redhat.com> <1258373983-8693-24-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-24-git-send-email-avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.11.2009 13:19, schrieb Avi Kivity:
> From: Alexander Graf <agraf@suse.de>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index f54c4f9..59fe4d5 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -316,7 +316,7 @@ static void svm_hardware_disable(void *garbage)
>  	cpu_svm_disable();
>  }
>  
> -static void svm_hardware_enable(void *garbage)
> +static int svm_hardware_enable(void *garbage)
>  {
>  
>  	struct svm_cpu_data *svm_data;
> @@ -325,16 +325,20 @@ static void svm_hardware_enable(void *garbage)
>  	struct desc_struct *gdt;
>  	int me = raw_smp_processor_id();
>  
> +	rdmsrl(MSR_EFER, efer);
> +	if (efer & EFER_SVME)
> +		return -EBUSY;
> +

Hi,

This is breaking KVM on my Phenom II X4 955.

When I start kvm I get this on the terminal:

kvm_create_vm: Device or resource busy
Could not initialize KVM, will disable KVM support

And in dmesg:
[   67.980732] kvm: enabling virtualization on CPU0 failed


I commented out the if() and return, and I added 2 printk's there for
debugging, and now that's what I see in dmesg when I start kvm:

[ 3341.740112] efer is 3329
[ 3341.740113] efer is 3329
[ 3341.740117] efer is 3329
[ 3341.740119] EFER_SVME is 4096
[ 3341.740121] EFER_SVME is 4096
[ 3341.740124] EFER_SVME is 4096
[ 3341.740130] efer is 3329
[ 3341.740132] EFER_SVME is 4096

In hex the values are 0x1000 and 0x0d01

KVM has been working well on this machine before, and it still works
well after commenting that part out.

I am not sure what the value of this register is supposed to be, but are
you sure

if (efer & EFER_SVME)

is the right condition?



cu
Dieter
