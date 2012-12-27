Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab2L0OSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 09:18:52 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:43555 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab2L0OSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 09:18:50 -0500
X-IronPort-AV: E=Sophos;i="4.84,362,1355097600"; 
   d="scan'208";a="352340"
Message-ID: <50DC58C4.3000307@citrix.com>
Date: Thu, 27 Dec 2012 14:18:44 +0000
From: Andrew Cooper <andrew.cooper3@citrix.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Daniel Kiper <daniel.kiper@oracle.com>,
        "jbeulich@suse.com" <jbeulich@suse.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "maxim.uvarov@oracle.com" <maxim.uvarov@oracle.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH v3 00/11] xen: Initial kexec/kdump implementation
References: <1356574740-6806-1-git-send-email-daniel.kiper@oracle.com> <50DBC856.6030208@zytor.com> <791b4922-078f-4adc-b3f3-0651f2266147@email.android.com>
In-Reply-To: <791b4922-078f-4adc-b3f3-0651f2266147@email.android.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/12/2012 07:53, Eric W. Biederman wrote:
> The syscall ABI still has the wrong semantics.
>
> Aka totally unmaintainable and umergeable.
>
> The concept of domU support is also strange.  What does domU support even mean, when the dom0 support is loading a kernel to pick up Xen when Xen falls over.

There are two requirements pulling at this patch series, but I agree
that we need to clarify them.

When dom0 loads a crash kernel, it is loading one for Xen to use.  As a
dom0 crash causes a Xen crash, having dom0 set up a kdump kernel for
itself is completely useless.  This ability is present in "classic Xen
dom0" kernels, but the feature is currently missing in PVOPS.

Many cloud customers and service providers want the ability for a VM
administrator to be able to load a kdump/kexec kernel within a
domain[1].  This allows the VM administrator to take more proactive
steps to isolate the cause of a crash, the state of which is most likely
discarded while tearing down the domain.  The result being that as far
as Xen is concerned, the domain is still alive, while the kdump
kernel/environment can work its usual magic.  I am not aware of any
feature like this existing in the past.

~Andrew

[1] http://lists.xen.org/archives/html/xen-devel/2012-11/msg01274.html

>
> I expect a lot of decisions about what code can be shared and what code can't is going to be driven by the simple question what does the syscall mean.
>
> Sharing machine_kexec.c and relocate_kernel.S does not make much sense to me when what you are doing is effectively passing your arguments through to the Xen version of kexec.
>
> Either Xen has it's own version of those routines or I expect the Xen version of kexec is buggy.   I can't imagine what sharing that code would mean.  By the same token I can't any need to duplicate the code either.
>
> Furthermore since this is just passing data from one version of the syscall to another I expect you can share the majority of the code across all architectures that implement Xen.  The only part I can see being arch specific is the Xen syscall stub.
>
> With respect to the proposed semantics of silently giving the kexec system call different meaning when running under Xen,
> /sbin/kexec has to act somewhat differently when loading code into the Xen hypervisor so there is no point not making that explicit in the ABI.
>
> Eric
>

