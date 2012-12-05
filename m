Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab2LEH5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 02:57:39 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:19726 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751585Ab2LEH5g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 02:57:36 -0500
X-IronPort-AV: E=Sophos;i="4.83,376,1352044800"; 
   d="scan'208";a="6337406"
Message-ID: <50BEFDF9.9080601@cn.fujitsu.com>
Date: Wed, 05 Dec 2012 15:55:37 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "x86@kernel.org" <x86@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 1/2] x86/kexec: VMCLEAR VMCSs loaded on all cpus if
 necessary
References: <50B43299.9030409@cn.fujitsu.com> <50B432CA.70804@cn.fujitsu.com> <87zk1t4lt4.fsf@xmission.com>
In-Reply-To: <87zk1t4lt4.fsf@xmission.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/05 15:56:55,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/05 15:56:56
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年12月05日 04:14, Eric W. Biederman 写道:
> Zhang Yanfei <zhangyanfei@cn.fujitsu.com> writes:
> 
>> This patch provides a way to VMCLEAR VMCSs related to guests
>> on all cpus before executing the VMXOFF when doing kdump. This
>> is used to ensure the VMCSs in the vmcore updated and
>> non-corrupted.
> 
> Apologies for the delay I have been travelling, and I wanted
> to at least read through the code.
> 
> Overall I think this is good but I have one nit, and I see one real
> problem with this code.
> 
>> +/*
>> + * This is used to VMCLEAR all VMCSs loaded on the
>> + * processor. And when loading kvm_intel module, the
>> + * callback function pointer will be assigned.
>> + */
>> +void (*crash_vmclear_loaded_vmcss)(void) = NULL;
>> +EXPORT_SYMBOL_GPL(crash_vmclear_loaded_vmcss);
>> +
>> +static inline void cpu_emergency_vmclear_loaded_vmcss(void)
>> +{
>> +	if (crash_vmclear_loaded_vmcss)
>> +		crash_vmclear_loaded_vmcss();
>> +}
> 
> The nit is the use of emergency instead of crash in the name.

ok, emergency -> crash

> 
> The problem is that this is potentially a NULL pointer dereference if
> kvm-intel is removed.  The easist fix would be in your second patch to
> just make it impossible to unload the kvm-intel module.  Otherwise
> there the deference of crash_vmclear_loaded_vmcss needs to be rcu
> protected, with a syncrhonize_rcu after the pointer is set to NULL in
> the unload path.

Ah, thanks for this comment.

I think I will use the rcu machanism to solve the problem.

> 
> Otherwise I have no objections to this code.

Thanks for your review. I will update the patch and resend it.

Thanks
Zhang Yanfei
