Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab0HPONM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 10:13:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46430 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981Ab0HPONK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 10:13:10 -0400
Subject: Re: [PATCH 23/42] KVM: Activate Virtualization On Demand
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <877hjq4qh8.fsf@depni.sinp.msu.ru>
Date: Mon, 16 Aug 2010 16:13:07 +0200
Cc: Dieter Ries <mail@dieterries.net>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <DE3C2C8A-BA4B-43A3-A40E-99302BECD0FF@suse.de>
References: <1258373983-8693-1-git-send-email-avi@redhat.com> <1258373983-8693-24-git-send-email-avi@redhat.com> <4BA1504A.3090801@dieterries.net> <808FF008-53B9-4271-904C-117A24ADF18C@suse.de> <20100317224002.GA5156@Localhorst.asterix.local> <59B2FA1C-035D-41BC-8359-65BDE8D541FE@suse.de> <20100318071131.GC24062@Localhorst.asterix.local> <4DCA075C-F95E-4FEB-BECA-15D43E1DC1AB@suse.de> <87ocddz4zy.fsf@depni.sinp.msu.ru> <122B6102-F892-4D2C-A85B-52F9BB0CB11E@suse.de> <877hjq4qh8.fsf@depni.sinp.msu.ru>
To: Serge Belyshev <belyshev@depni.sinp.msu.ru>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 16.08.2010, at 15:49, Serge Belyshev wrote:

> Alexander Graf <agraf@suse.de> writes:
> 
>> Hrm - try to use the following (probably whitespace broken and 100% untested) hacky patch:
>> 
>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>> index 56c9b6b..bde9ee3 100644
>> --- a/arch/x86/kvm/svm.c
>> +++ b/arch/x86/kvm/svm.c
>> @@ -429,9 +429,11 @@ static int svm_hardware_enable(void *garbage)
>>        struct desc_struct *gdt;
>>        int me = raw_smp_processor_id();
>> 
>> +#if 0
>>        rdmsrl(MSR_EFER, efer);
>>        if (efer & EFER_SVME)
>>                return -EBUSY;
>> +#endif
>> 
> 
> I tested a bit different hack keeping rdmsrl but removing the if() and
> it works fine for me:
> 
> Index: linux/arch/x86/kvm/svm.c
> ===================================================================
> --- linux.orig/arch/x86/kvm/svm.c
> +++ linux/arch/x86/kvm/svm.c
> @@ -429,8 +429,7 @@ static int svm_hardware_enable(void *gar
> 	int me = raw_smp_processor_id();
> 
> 	rdmsrl(MSR_EFER, efer);
> -	if (efer & EFER_SVME)
> -		return -EBUSY;
> +	printk(KERN_DEBUG "svm_hardware_enable: efer %x on %d\n", efer, me);

Ouch, yes. Thanks for not taking my patch ;). The efer read is of course still mandatory.

> 
> 	if (!has_svm()) {
> 		printk(KERN_ERR "svm_hardware_enable: err EOPNOTSUPP on %d\n",
> 
> Here is an example of its output:
> 
> [231441.358111] svm_hardware_enable: efer 1d01 on 0
> [231441.358117] svm_hardware_enable: efer d01 on 3
> [231441.358124] svm_hardware_enable: efer d01 on 2
> [231441.358135] svm_hardware_enable: efer d01 on 1
> [231675.168967] svm_hardware_enable: efer d01 on 0
> [231675.168972] svm_hardware_enable: efer d01 on 1
> [231675.168983] svm_hardware_enable: efer d01 on 2
> [231675.168995] svm_hardware_enable: efer d01 on 3
> 
> 
> After reboot, the first kvm run always reports efer = 1d01 on the first cpu.
> In all subsequent runs before reboot efer stays d01 on all cpus.

Happy broken BIOS fun. Oh well, I guess you can live with the patched version and normal end-users will just update their BIOSes.


Alex

