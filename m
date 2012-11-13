Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab2KMVWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 16:22:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755567Ab2KMVWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 16:22:21 -0500
Date: Tue, 13 Nov 2012 19:22:03 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: zhangyanfei <zhangyanfei@cn.fujitsu.com>
Cc: "Hatayama, Daisuke" <d.hatayama@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH v3 2/2] KVM: make crash_clear_loaded_vmcss valid when
 loading kvm_intel module
Message-ID: <20121113212203.GA26386@amt.cnet>
References: <50909B55.2070901@cn.fujitsu.com>
 <50909C35.9080702@cn.fujitsu.com>
 <33710E6CAA200E4583255F4FB666C4E20AACCA2F@G01JPEXMBYT03>
 <50920EB8.3020400@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50920EB8.3020400@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 01:55:04PM +0800, zhangyanfei wrote:
> 于 2012年10月31日 17:01, Hatayama, Daisuke 写道:
> > 
> > 
> >> -----Original Message-----
> >> From: kexec-bounces@lists.infradead.org
> >> [mailto:kexec-bounces@lists.infradead.org] On Behalf Of zhangyanfei
> >> Sent: Wednesday, October 31, 2012 12:34 PM
> >> To: x86@kernel.org; kexec@lists.infradead.org; Avi Kivity; Marcelo
> >> Tosatti
> >> Cc: linux-kernel@vger.kernel.org; kvm@vger.kernel.org
> >> Subject: [PATCH v3 2/2] KVM: make crash_clear_loaded_vmcss valid when
> >> loading kvm_intel module
> >>
> >> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> > 
> > [...]
> > 
> >> @@ -7230,6 +7231,10 @@ static int __init vmx_init(void)
> >>  	if (r)
> >>  		goto out3;
> >>
> >> +#ifdef CONFIG_KEXEC
> >> +	crash_clear_loaded_vmcss = vmclear_local_loaded_vmcss;
> >> +#endif
> >> +
> > 
> > Assignment here cannot cover the case where NMI is initiated after VMX is on in kvm_init and before vmclear_local_loaded_vmcss is assigned, though rare but can happen.
> > 
> 
> By saying "VMX is on in kvm init", you mean kvm_init enables the VMX feature in the logical processor?
> No, only there is a vcpu to be created, kvm will enable the VMX feature.
> 
> I think there is no difference with this assignment before or after kvm_init because the vmcs linked
> list must be empty before vmx_init is finished.

The list is not initialized before hardware_enable(), though. Should
move the assignment after that.

Also, it is possible that the loaded_vmcss_on_cpu list is being modified
_while_ crash executes say via NMI, correct? If that is the case, better
flag that the list is under manipulation so the vmclear can be skipped.

> Thanks
> Zhang Yanfei
> 
> > What does happen if calling vmclear_local_loaded_vmcss before kvm_init? I think it no problem since the list is initially empty.
> > 
> >>  	vmx_disable_intercept_for_msr(MSR_FS_BASE, false);
> >>  	vmx_disable_intercept_for_msr(MSR_GS_BASE, false);
> >>  	vmx_disable_intercept_for_msr(MSR_KERNEL_GS_BASE, true);
> >> @@ -7265,6 +7270,10 @@ static void __exit vmx_exit(void)
> >>  	free_page((unsigned long)vmx_io_bitmap_b);
> >>  	free_page((unsigned long)vmx_io_bitmap_a);
> >>
> >> +#ifdef CONFIG_KEXEC
> >> +	crash_clear_loaded_vmcss = NULL;
> >> +#endif
> >> +
> >>  	kvm_exit();
> >>  }
> > 
> > Also, this is converse to the above.
> > 
> > Thanks.
> > HATAYAMA, Daisuke
> > 
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
