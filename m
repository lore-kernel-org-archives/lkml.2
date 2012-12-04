Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab2LDUOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 15:14:33 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:46378 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab2LDUOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 15:14:30 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: "x86\@kernel.org" <x86@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>,
        "kexec\@lists.infradead.org" <kexec@lists.infradead.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <50B43299.9030409@cn.fujitsu.com> <50B432CA.70804@cn.fujitsu.com>
Date: Tue, 04 Dec 2012 12:14:15 -0800
In-Reply-To: <50B432CA.70804@cn.fujitsu.com> (Zhang Yanfei's message of "Tue,
	27 Nov 2012 11:26:02 +0800")
Message-ID: <87zk1t4lt4.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/5EBvJlll1rYVbFbz1h1y+Vl4Az6lWz64=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_12 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v9 1/2] x86/kexec: VMCLEAR VMCSs loaded on all cpus if necessary
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang Yanfei <zhangyanfei@cn.fujitsu.com> writes:

> This patch provides a way to VMCLEAR VMCSs related to guests
> on all cpus before executing the VMXOFF when doing kdump. This
> is used to ensure the VMCSs in the vmcore updated and
> non-corrupted.

Apologies for the delay I have been travelling, and I wanted
to at least read through the code.

Overall I think this is good but I have one nit, and I see one real
problem with this code.

> +/*
> + * This is used to VMCLEAR all VMCSs loaded on the
> + * processor. And when loading kvm_intel module, the
> + * callback function pointer will be assigned.
> + */
> +void (*crash_vmclear_loaded_vmcss)(void) = NULL;
> +EXPORT_SYMBOL_GPL(crash_vmclear_loaded_vmcss);
> +
> +static inline void cpu_emergency_vmclear_loaded_vmcss(void)
> +{
> +	if (crash_vmclear_loaded_vmcss)
> +		crash_vmclear_loaded_vmcss();
> +}

The nit is the use of emergency instead of crash in the name.

The problem is that this is potentially a NULL pointer dereference if
kvm-intel is removed.  The easist fix would be in your second patch to
just make it impossible to unload the kvm-intel module.  Otherwise
there the deference of crash_vmclear_loaded_vmcss needs to be rcu
protected, with a syncrhonize_rcu after the pointer is set to NULL in
the unload path.

Otherwise I have no objections to this code.

Eric
