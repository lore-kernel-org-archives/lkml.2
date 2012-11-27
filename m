Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827Ab2K0Bez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 20:34:55 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50028 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755680Ab2K0Bey convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 20:34:54 -0500
X-IronPort-AV: E=Sophos;i="4.83,325,1352044800"; 
   d="scan'208";a="6279806"
Message-ID: <50B41849.9040103@cn.fujitsu.com>
Date: Tue, 27 Nov 2012 09:32:57 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Gleb Natapov <gleb@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v8 1/2] x86/kexec: add a new atomic notifier list for
 kdump
References: <50ADE0C2.1000106@cn.fujitsu.com> <50ADE11A.401@cn.fujitsu.com> <87ip8sxuyh.fsf@xmission.com> <20121126172054.GF12969@redhat.com> <87fw3wuuoh.fsf@xmission.com> <20121126175327.GG12969@redhat.com> <87mwy4teh8.fsf@xmission.com>
In-Reply-To: <87mwy4teh8.fsf@xmission.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/27 09:34:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/27 09:34:27
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年11月27日 02:18, Eric W. Biederman 写道:
> Gleb Natapov <gleb@redhat.com> writes:
> 
>> On Mon, Nov 26, 2012 at 11:43:10AM -0600, Eric W. Biederman wrote:
>>> Gleb Natapov <gleb@redhat.com> writes:
>>>
>>>> On Mon, Nov 26, 2012 at 09:08:54AM -0600, Eric W. Biederman wrote:
>>>>> Zhang Yanfei <zhangyanfei@cn.fujitsu.com> writes:
>>>>>
>>>>>> This patch adds an atomic notifier list named crash_notifier_list.
>>>>>> Currently, when loading kvm-intel module, a notifier will be registered
>>>>>> in the list to enable vmcss loaded on all cpus to be VMCLEAR'd if
>>>>>> needed.
>>>>>
>>>>> crash_notifier_list ick gag please no.  Effectively this makes the kexec
>>>>> on panic code path undebuggable.
>>>>>
>>>>> Instead we need to use direct function calls to whatever you are doing.
>>>>>
>>>> The code walks linked list in kvm-intel module and calls vmclear on
>>>> whatever it finds there. Since the function have to resides in kvm-intel
>>>> module it cannot be called directly. Is callback pointer that is set
>>>> by kvm-intel more acceptable?
>>>
>>> Yes a specific callback function is more acceptable.  Looking a little
>>> deeper vmclear_local_loaded_vmcss is not particularly acceptable. It is
>>> doing a lot of work that is unnecessary to save the virtual registers
>>> on the kexec on panic path.
>>>
>> What work are you referring to in particular that may not be
>> acceptable?
> 
> The unnecessary work that I was see is all of the software state
> changing.  Unlinking things from linked lists flipping variables.
> None of that appears related to the fundamental issue saving cpu
> state.
> 
> Simply reusing a function that does more than what is strictly required
> makes me nervous.  What is the chance that the function will grow
> with maintenance and add constructs that are not safe in a kexec on
> panic situtation.

So in summary,

1. a specific callback function instead of a notifier?

2. Instead of calling vmclear_local_loaded_vmcss, the vmclear operation
   will just call the vmclear on every vmcss loaded on the cpu?

   like below:

   static void crash_vmclear_local_loaded_vmcss(void)
   {
        int cpu = raw_smp_processor_id();
        struct loaded_vmcs *v, *n;

        if (!crash_local_vmclear_enabled(cpu))
                return;

        list_for_each_entry_safe(v, n, &per_cpu(loaded_vmcss_on_cpu, cpu),
                                 loaded_vmcss_on_cpu_link)
                vmcs_clear(v->vmcs);
   }

   right?

Thanks
Zhang

> 
>>> In fact I wonder if it might not just be easier to call vmcs_clear to a
>>> fixed per cpu buffer.
>>>
>> There may be more than one vmcs loaded on a cpu, hence the list.
>>
>>> Performing list walking in interrupt context without locking in
>>> vmclear_local_loaded vmcss looks a bit scary.  Not that locking would
>>> make it any better, as locking would simply add one more way to deadlock
>>> the system.  Only an rcu list walk is at all safe.  A list walk that
>>> modifies the list as vmclear_local_loaded_vmcss does is definitely not safe.
>>>
>> The list vmclear_local_loaded walks is per cpu. Zhang's kvm patch
>> disables kexec callback while list is modified.
> 
> If the list is only modified on it's cpu and we are running on that cpu
> that does look like it will give the necessary protections.  It isn't
> particularly clear at first glance that is the case unfortunately.
> 
> Eric
> 

