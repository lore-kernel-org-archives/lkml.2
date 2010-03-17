Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab0CQWCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 18:02:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:33206 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869Ab0CQWCp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 18:02:45 -0400
Subject: Re: [PATCH 23/42] KVM: Activate Virtualization On Demand
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4BA1504A.3090801@dieterries.net>
Date: Wed, 17 Mar 2010 23:02:40 +0100
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <808FF008-53B9-4271-904C-117A24ADF18C@suse.de>
References: <1258373983-8693-1-git-send-email-avi@redhat.com> <1258373983-8693-24-git-send-email-avi@redhat.com> <4BA1504A.3090801@dieterries.net>
To: Dieter Ries <mail@dieterries.net>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 17.03.2010, at 22:57, Dieter Ries wrote:

> Am 16.11.2009 13:19, schrieb Avi Kivity:
>> From: Alexander Graf <agraf@suse.de>
>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>> index f54c4f9..59fe4d5 100644
>> --- a/arch/x86/kvm/svm.c
>> +++ b/arch/x86/kvm/svm.c
>> @@ -316,7 +316,7 @@ static void svm_hardware_disable(void *garbage)
>> 	cpu_svm_disable();
>> }
>> 
>> -static void svm_hardware_enable(void *garbage)
>> +static int svm_hardware_enable(void *garbage)
>> {
>> 
>> 	struct svm_cpu_data *svm_data;
>> @@ -325,16 +325,20 @@ static void svm_hardware_enable(void *garbage)
>> 	struct desc_struct *gdt;
>> 	int me = raw_smp_processor_id();
>> 
>> +	rdmsrl(MSR_EFER, efer);
>> +	if (efer & EFER_SVME)
>> +		return -EBUSY;
>> +
> 
> Hi,
> 
> This is breaking KVM on my Phenom II X4 955.
> 
> When I start kvm I get this on the terminal:
> 
> kvm_create_vm: Device or resource busy
> Could not initialize KVM, will disable KVM support
> 
> And in dmesg:
> [   67.980732] kvm: enabling virtualization on CPU0 failed
> 
> 
> I commented out the if() and return, and I added 2 printk's there for
> debugging, and now that's what I see in dmesg when I start kvm:
> 
> [ 3341.740112] efer is 3329
> [ 3341.740113] efer is 3329
> [ 3341.740117] efer is 3329
> [ 3341.740119] EFER_SVME is 4096
> [ 3341.740121] EFER_SVME is 4096
> [ 3341.740124] EFER_SVME is 4096
> [ 3341.740130] efer is 3329
> [ 3341.740132] EFER_SVME is 4096
> 
> In hex the values are 0x1000 and 0x0d01
> 
> KVM has been working well on this machine before, and it still works
> well after commenting that part out.
> 
> I am not sure what the value of this register is supposed to be, but are
> you sure
> 
> if (efer & EFER_SVME)
> 
> is the right condition?

According to the printks you show above the & condition should never apply.

Are you 100% sure you don't have vmware, virtualbox, parallels, whatever running in parallel on that machine?


Alex