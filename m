Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831Ab2KNJQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 04:16:09 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63760 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932726Ab2KNJP1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 04:15:27 -0500
X-IronPort-AV: E=Sophos;i="4.83,249,1352044800"; 
   d="scan'208";a="6195591"
Message-ID: <50A360C7.2070904@cn.fujitsu.com>
Date: Wed, 14 Nov 2012 17:13:43 +0800
From: zhangyanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: "Hatayama, Daisuke" <d.hatayama@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH v3 2/2] KVM: make crash_clear_loaded_vmcss valid when
 loading kvm_intel module
References: <50909B55.2070901@cn.fujitsu.com> <50909C35.9080702@cn.fujitsu.com> <33710E6CAA200E4583255F4FB666C4E20AACCA2F@G01JPEXMBYT03> <50920EB8.3020400@cn.fujitsu.com> <20121113212203.GA26386@amt.cnet>
In-Reply-To: <20121113212203.GA26386@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/14 17:15:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/14 17:15:18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年11月14日 05:22, Marcelo Tosatti 写道:
> On Thu, Nov 01, 2012 at 01:55:04PM +0800, zhangyanfei wrote:
>> 于 2012年10月31日 17:01, Hatayama, Daisuke 写道:
>>>
>>>
>>>> -----Original Message-----
>>>> From: kexec-bounces@lists.infradead.org
>>>> [mailto:kexec-bounces@lists.infradead.org] On Behalf Of zhangyanfei
>>>> Sent: Wednesday, October 31, 2012 12:34 PM
>>>> To: x86@kernel.org; kexec@lists.infradead.org; Avi Kivity; Marcelo
>>>> Tosatti
>>>> Cc: linux-kernel@vger.kernel.org; kvm@vger.kernel.org
>>>> Subject: [PATCH v3 2/2] KVM: make crash_clear_loaded_vmcss valid when
>>>> loading kvm_intel module
>>>>
>>>> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
>>>
>>> [...]
>>>
>>>> @@ -7230,6 +7231,10 @@ static int __init vmx_init(void)
>>>>  	if (r)
>>>>  		goto out3;
>>>>
>>>> +#ifdef CONFIG_KEXEC
>>>> +	crash_clear_loaded_vmcss = vmclear_local_loaded_vmcss;
>>>> +#endif
>>>> +
>>>
>>> Assignment here cannot cover the case where NMI is initiated after VMX is on in kvm_init and before vmclear_local_loaded_vmcss is assigned, though rare but can happen.
>>>
>>
>> By saying "VMX is on in kvm init", you mean kvm_init enables the VMX feature in the logical processor?
>> No, only there is a vcpu to be created, kvm will enable the VMX feature.
>>
>> I think there is no difference with this assignment before or after kvm_init because the vmcs linked
>> list must be empty before vmx_init is finished.
> 
> The list is not initialized before hardware_enable(), though. Should
> move the assignment after that.
> 
> Also, it is possible that the loaded_vmcss_on_cpu list is being modified
> _while_ crash executes say via NMI, correct? If that is the case, better
> flag that the list is under manipulation so the vmclear can be skipped.
> 

Thanks for your comments.
In the new patchset, I didn't move the crash_clear_loaded_vmcss assignment.
I added a new percpu variable vmclear_skipped to indicate everything:
1. Before the loaded_vmcss_on_cpu list is initialized, vmclear_skipped is 1 and
   this means if the machine crashes and doing kdump, crash_clear_loaded_vmcss
   still will not be called.
2. If the loaded_vmcss_on_cpu list is under manipulation, vmclear_skipped is
   set to 1 and after the manipulation is finished, the variable is set to 0.
3. After all loaded vmcss are vmcleared, vmclear_skipped is set to 1. So we
   needn't repeat to vmclear loaded vmcss in kdump path.

Please refer to the new version of the patchset I sent. If you have any suggestions, that'll be helpful.

Thanks
Zhang

