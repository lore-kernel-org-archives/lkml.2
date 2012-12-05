Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab2LETgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 14:36:09 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:47691 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab2LETgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 14:36:07 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        "kexec\@lists.infradead.org" <kexec@lists.infradead.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <50BEFEBA.6070602@cn.fujitsu.com>
Date: Wed, 05 Dec 2012 11:35:58 -0800
In-Reply-To: <50BEFEBA.6070602@cn.fujitsu.com> (Zhang Yanfei's message of
	"Wed, 05 Dec 2012 15:58:50 +0800")
Message-ID: <87boe8qokh.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18FMIwCfN0mZGsj3VU8YsSz69ZWELbSObg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v10 0/2] x86: vmclear vmcss on all cpus when doing kdump if necessary
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang Yanfei <zhangyanfei@cn.fujitsu.com> writes:

> Currently, kdump just makes all the logical processors leave VMX operation by
> executing VMXOFF instruction, so any VMCSs active on the logical processors may
> be corrupted. But, sometimes, we need the VMCSs to debug guest images contained
> in the host vmcore. To prevent the corruption, we should VMCLEAR the VMCSs before
> executing the VMXOFF instruction.
>
> The patch set provides a way to VMCLEAR vmcss related to guests on all cpus before
> executing the VMXOFF when doing kdump. This is used to ensure the VMCSs in the
> vmcore updated and non-corrupted.

Skimming through it looks like the important things have been addressed.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>


> Changelog from v9 to v10:
> 1. add rcu protect to the callback function
>
> Changelog from v8 to v9:
> 1. KEXEC: use a callback function instead of a notifier.
> 2. KVM-INTEL: use a new vmclear function instead of just calling 
>    vmclear_local_loaded_vmcss to make sure we just do the core vmclear
>    operation in kdump.
>
> Changelog from v7 to v8:
> 1. KEXEC: regression for using name crash_notifier_list
>    and remove comments related to KVM
>    and just call function atomic_notifier_call_chain directly.
>
> Changelog from v6 to v7:
> 1. KVM-INTEL: in hardware_disable, we needn't disable the
>    vmclear, so remove it.
>
> Changelog from v5 to v6:
> 1. KEXEC: the atomic notifier list renamed:
>    crash_notifier_list --> vmclear_notifier_list
> 2. KVM-INTEL: provide empty functions if CONFIG_KEXEC is
>    not defined and remove unnecessary #ifdef's.
>
> Changelog from v4 to v5:
> 1. use an atomic notifier instead of function call, so
>    have all the vmclear codes in vmx.c.
>
> Changelog from v3 to v4:
> 1. add a new percpu variable vmclear_skipped to skip
>    vmclear in kdump in some conditions.
>
> Changelog from v2 to v3:
> 1. remove unnecessary conditions in function
>    cpu_emergency_clear_loaded_vmcss as Marcelo suggested.
>
> Changelog from v1 to v2:
> 1. remove the sysctl and clear VMCSs unconditionally.
>
> Zhang Yanfei (2):
>   x86/kexec: VMCLEAR VMCSs loaded on all cpus if necessary
>   KVM-INTEL: provide the vmclear function and a bitmap to support
>     VMCLEAR in kdump
>
>  arch/x86/include/asm/kexec.h |    2 +
>  arch/x86/kernel/crash.c      |   32 ++++++++++++++++++++
>  arch/x86/kvm/vmx.c           |   67 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 101 insertions(+), 0 deletions(-)
