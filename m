Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab3AJOUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 09:20:00 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:25101 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab3AJOT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 09:19:58 -0500
X-IronPort-AV: E=Sophos;i="4.84,444,1355097600"; 
   d="scan'208";a="3131100"
Message-ID: <50EECE0B.2080604@citrix.com>
Date: Thu, 10 Jan 2013 14:19:55 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Daniel Kiper <daniel.kiper@oracle.com>
CC: David Vrabel <david.vrabel@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "jbeulich@suse.com" <jbeulich@suse.com>,
        "maxim.uvarov@oracle.com" <maxim.uvarov@oracle.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>
Subject: Re: [Xen-devel] [PATCH v3 00/11] xen: Initial kexec/kdump implementation
References: <1356574740-6806-1-git-send-email-daniel.kiper@oracle.com>	<50DBC856.6030208@zytor.com>	<791b4922-078f-4adc-b3f3-0651f2266147@email.android.com>	<50DC58C4.3000307@citrix.com> <874nj7qsor.fsf@xmission.com>	<50E41973.9050705@citrix.com>	<20130104142257.GC3346@host-192-168-1-59.local.net-space.pl>	<50E6E974.5090805@citrix.com> <20130104170120.GA3472@host-192-168-1-59.local.net-space.pl>
In-Reply-To: <20130104170120.GA3472@host-192-168-1-59.local.net-space.pl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/13 17:01, Daniel Kiper wrote:
> On Fri, Jan 04, 2013 at 02:38:44PM +0000, David Vrabel wrote:
>> On 04/01/13 14:22, Daniel Kiper wrote:
>>> On Wed, Jan 02, 2013 at 11:26:43AM +0000, Andrew Cooper wrote:
>>>> On 27/12/12 18:02, Eric W. Biederman wrote:
>>>>> Andrew Cooper<andrew.cooper3@citrix.com>  writes:
>>>>>
>>>>>> On 27/12/2012 07:53, Eric W. Biederman wrote:
>>>>>>> The syscall ABI still has the wrong semantics.
>>>>>>>
>>>>>>> Aka totally unmaintainable and umergeable.
>>>>>>>
>>>>>>> The concept of domU support is also strange.  What does domU support even mean, when the dom0 support is loading a kernel to pick up Xen when Xen falls over.
>>>>>> There are two requirements pulling at this patch series, but I agree
>>>>>> that we need to clarify them.
>>>>> It probably make sense to split them apart a little even.
>>>>>
>>>>>
>>>>
>>>> Thinking about this split, there might be a way to simply it even more.
>>>>
>>>> /sbin/kexec can load the "Xen" crash kernel itself by issuing
>>>> hypercalls using /dev/xen/privcmd.  This would remove the need for
>>>> the dom0 kernel to distinguish between loading a crash kernel for
>>>> itself and loading a kernel for Xen.
>>>>
>>>> Or is this just a silly idea complicating the matter?
>>>
>>> This is impossible with current Xen kexec/kdump interface.
>>> It should be changed to do that. However, I suppose that
>>> Xen community would not be interested in such changes.
>>
>> I don't see why the hypercall ABI cannot be extended with new sub-ops
>> that do the right thing -- the existing ABI is a bit weird.
>>
>> I plan to start prototyping something shortly (hopefully next week) for
>> the Xen kexec case.
> 
> Wow... As I can this time Xen community is interested in...
> That is great. I agree that current kexec interface is not ideal.

I spent some more time looking at the existing interface and
implementation and it really is broken.

> David, I am happy to help in that process. However, if you wish I could
> carry it myself. Anyway, it looks that I should hold on with my
> Linux kexec/kdump patches.

I should be able to post some prototype patches for Xen in a few weeks.
 No guarantees though.

> My .5 cents:
>   - We should focus on KEXEC_CMD_kexec_load and KEXEC_CMD_kexec_unload;
>     probably we should introduce KEXEC_CMD_kexec_load2 and KEXEC_CMD_kexec_unload2;
>     load should __LOAD__ kernel image and other things into hypervisor memory;

Yes, but I don't see how we can easily support both ABIs easily.  I'd be
in favour of replacing the existing hypercalls and requiring updated
kexec tools in dom0 (this isn't that different to requiring the correct
libxc in dom0).

>     I suppose that allmost all things could be copied from linux/kernel/kexec.c,
>     linux/arch/x86/kernel/{machine_kexec_$(BITS).c,relocate_kernel_$(BITS).c};
>     I think that KEXEC_CMD_kexec should stay as is,

I don't think we want all the junk from Linux inside Xen -- we only want
to support the kdump case and do not have to handle returning from the
kexec image.

>   - Hmmm... Now I think that we should still use kexec syscall to load image
>     into Xen memory (with new KEXEC_CMD_kexec_load2) because it establishes
>     all things which are needed to call kdump if dom0 crashes; however,
>     I could be wrong...

I don't think we need the kexec syscall.  The kernel can unconditionally
do the crash hypercall, which will return if the kdump kernel isn't
loaded and the kernel can fall back to the regular non-kexec panic.

This will allow the kexec syscall to be used only for the domU kexec case.

>   - last but not least, we should think about support for PV guests
>     too.

I won't be looking at this.

To avoid confusion about the two largely orthogonal sorts of kexec how
about defining some terms.  I suggest:

Xen kexec: Xen executes the image in response to a Xen crash or a
hypercall from a privileged domain.

Guest kexec: The guest kernel executes the images within the domain in
response to a guest kernel crash or a system call.

David
