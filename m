Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab2KZBwE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 20:52:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:6969 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753501Ab2KZBwC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 20:52:02 -0500
X-IronPort-AV: E=Sophos;i="4.83,317,1352044800"; 
   d="scan'208";a="6272129"
Message-ID: <50B2CACD.2000103@cn.fujitsu.com>
Date: Mon, 26 Nov 2012 09:50:05 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v8 0/2] x86: vmclear vmcss on all cpus when doing kdump
 if necessary
References: <50ADE0C2.1000106@cn.fujitsu.com> <20121125142642.GC25516@redhat.com>
In-Reply-To: <20121125142642.GC25516@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/26 09:51:35,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/26 09:51:37
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年11月25日 22:26, Gleb Natapov 写道:
> On Thu, Nov 22, 2012 at 04:22:26PM +0800, Zhang Yanfei wrote:
>> Currently, kdump just makes all the logical processors leave VMX operation by
>> executing VMXOFF instruction, so any VMCSs active on the logical processors may
>> be corrupted. But, sometimes, we need the VMCSs to debug guest images contained
>> in the host vmcore. To prevent the corruption, we should VMCLEAR the VMCSs before
>> executing the VMXOFF instruction.
>>
>> The patch set provides a way to VMCLEAR vmcss related to guests on all cpus before
>> executing the VMXOFF when doing kdump. This is used to ensure the VMCSs in the
>> vmcore updated and non-corrupted.
>>
> Looks fine to me, but kexec part should get acks from exec maintainers.

Thanks. I will ask the exec maintainer.

> 
>> Changelog from v7 to v8:
>> 1. KEXEC: regression for using name crash_notifier_list
>>    and remove comments related to KVM
>>    and just call function atomic_notifier_call_chain directly.
>>
>> Changelog from v6 to v7:
>> 1. KVM-INTEL: in hardware_disable, we needn't disable the
>>    vmclear, so remove it.
>>
>> Changelog from v5 to v6:
>> 1. KEXEC: the atomic notifier list renamed:
>>    crash_notifier_list --> vmclear_notifier_list
>> 2. KVM-INTEL: provide empty functions if CONFIG_KEXEC is
>>    not defined and remove unnecessary #ifdef's.
>>
>> Changelog from v4 to v5:
>> 1. use an atomic notifier instead of function call, so
>>    have all the vmclear codes in vmx.c.
>>
>> Changelog from v3 to v4:
>> 1. add a new percpu variable vmclear_skipped to skip
>>    vmclear in kdump in some conditions.
>>
>> Changelog from v2 to v3:
>> 1. remove unnecessary conditions in function
>>    cpu_emergency_clear_loaded_vmcss as Marcelo suggested.
>>
>> Changelog from v1 to v2:
>> 1. remove the sysctl and clear VMCSs unconditionally.
>>
>> Zhang Yanfei (2):
>>   x86/kexec: add a new atomic notifier list for kdump
>>   KVM-INTEL: add a notifier and a bitmap to support VMCLEAR in kdump
>>
>>  arch/x86/include/asm/kexec.h |    2 +
>>  arch/x86/kernel/crash.c      |    9 +++++
>>  arch/x86/kvm/vmx.c           |   70 ++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 81 insertions(+), 0 deletions(-)
> 
> --
> 			Gleb.
> 

