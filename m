Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab2L0SDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 13:03:15 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:48448 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2L0SDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 13:03:13 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Daniel Kiper <daniel.kiper@oracle.com>,
        "jbeulich\@suse.com" <jbeulich@suse.com>,
        "konrad.wilk\@oracle.com" <konrad.wilk@oracle.com>,
        "maxim.uvarov\@oracle.com" <maxim.uvarov@oracle.com>,
        "mingo\@redhat.com" <mingo@redhat.com>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "vgoyal\@redhat.com" <vgoyal@redhat.com>,
        "x86\@kernel.org" <x86@kernel.org>,
        "kexec\@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization\@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "xen-devel\@lists.xensource.com" <xen-devel@lists.xensource.com>
References: <1356574740-6806-1-git-send-email-daniel.kiper@oracle.com>
	<50DBC856.6030208@zytor.com>
	<791b4922-078f-4adc-b3f3-0651f2266147@email.android.com>
	<50DC58C4.3000307@citrix.com>
Date: Thu, 27 Dec 2012 10:02:44 -0800
In-Reply-To: <50DC58C4.3000307@citrix.com> (Andrew Cooper's message of "Thu,
	27 Dec 2012 14:18:44 +0000")
Message-ID: <874nj7qsor.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/bd4hRjyplMNYJdnZ6JPiVKfj7go4hnuA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Cooper <andrew.cooper3@citrix.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3 00/11] xen: Initial kexec/kdump implementation
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Cooper <andrew.cooper3@citrix.com> writes:

> On 27/12/2012 07:53, Eric W. Biederman wrote:
>> The syscall ABI still has the wrong semantics.
>>
>> Aka totally unmaintainable and umergeable.
>>
>> The concept of domU support is also strange.  What does domU support even mean, when the dom0 support is loading a kernel to pick up Xen when Xen falls over.
>
> There are two requirements pulling at this patch series, but I agree
> that we need to clarify them.

It probably make sense to split them apart a little even.

> When dom0 loads a crash kernel, it is loading one for Xen to use.  As a
> dom0 crash causes a Xen crash, having dom0 set up a kdump kernel for
> itself is completely useless.  This ability is present in "classic Xen
> dom0" kernels, but the feature is currently missing in PVOPS.

> Many cloud customers and service providers want the ability for a VM
> administrator to be able to load a kdump/kexec kernel within a
> domain[1].  This allows the VM administrator to take more proactive
> steps to isolate the cause of a crash, the state of which is most likely
> discarded while tearing down the domain.  The result being that as far
> as Xen is concerned, the domain is still alive, while the kdump
> kernel/environment can work its usual magic.  I am not aware of any
> feature like this existing in the past.

Which makes domU support semantically just the normal kexec/kdump
support.  Got it.

The point of implementing domU is for those times when the hypervisor
admin and the kernel admin are different.

For domU support modifying or adding alternate versions of
machine_kexec.c and relocate_kernel.S to add paravirtualization support
make sense.

There is the practical argument that for implementation efficiency of
crash dumps it would be better if that support came from the hypervisor
or the hypervisor environment.  But this gets into the practical reality
that the hypervisor environment does not do that today.  Furthermore
kexec all by itself working in a paravirtualized environment under Xen
makes sense.

domU support is what Peter was worrying about for cleanliness, and
we need some x86 backend ops there, and generally to be careful.


For dom0 support we need to extend the kexec_load system call, and
get it right.

When we are done I expect both dom0 and domU support of kexec to work
in dom0.  I don't know if the normal kexec or kdump case will ever make
sense in dom0 but there is no reason for that case to be broken.

> ~Andrew
>
> [1] http://lists.xen.org/archives/html/xen-devel/2012-11/msg01274.html

Eric
