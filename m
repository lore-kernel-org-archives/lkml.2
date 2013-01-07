Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab3AGKrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 05:47:00 -0500
Received: from smtp.citrix.com ([66.165.176.89]:15697 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796Ab3AGKq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 05:46:59 -0500
X-IronPort-AV: E=Sophos;i="4.84,423,1355097600"; 
   d="scan'208";a="2860339"
Message-ID: <50EAA795.6030101@citrix.com>
Date: Mon, 7 Jan 2013 10:46:45 +0000
From: Andrew Cooper <andrew.cooper3@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121127 Icedove/10.0.11
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jan Beulich <JBeulich@suse.com>,
        "maxim.uvarov@oracle.com" <maxim.uvarov@oracle.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>
Subject: Re: [Xen-devel] [PATCH v3 00/11] xen: Initial kexec/kdump implementation
References: <1356574740-6806-1-git-send-email-daniel.kiper@oracle.com>  <50DBC856.6030208@zytor.com>  <791b4922-078f-4adc-b3f3-0651f2266147@email.android.com>  <50DC58C4.3000307@citrix.com> <874nj7qsor.fsf@xmission.com>  <50E41973.9050705@citrix.com>  <20130104142257.GC3346@host-192-168-1-59.local.net-space.pl>  <50E6F81D02000078000B3245@nat28.tlf.novell.com>  <20130104170751.GB3472@host-192-168-1-59.local.net-space.pl>  <20130104191146.GC6721@phenom.dumpdata.com> <1357554350.14291.134.camel@zakaz.uk.xensource.com>
In-Reply-To: <1357554350.14291.134.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/13 10:25, Ian Campbell wrote:
> On Fri, 2013-01-04 at 19:11 +0000, Konrad Rzeszutek Wilk wrote:
>> On Fri, Jan 04, 2013 at 06:07:51PM +0100, Daniel Kiper wrote:
>>> Because current KEXEC_CMD_kexec_load does not load kernel
>>> image and other things into Xen memory. It means that it
>>> should live somewhere in dom0 Linux kernel memory.
>> We could have a very simple hypercall which would have:
>>
>> struct fancy_new_hypercall {
>> 	xen_pfn_t payload; // IN
> This would have to be XEN_GUEST_HANDLE(something) since userspace cannot
> figure out what pfns back its memory. In any case since the hypervisor
> is going to want to copy the data into the crashkernel space a virtual
> address is convenient to have.
>
>> 	ssize_t len; // IN
>> #define DATA (1<<1)
>> #define DATA_EOF (1<<2)
>> #define DATA_KERNEL (1<<3)
>> #define DATA_RAMDISK (1<<4)
>> 	unsigned int flags; // IN
>> 	unsigned int status; // OUT
>> };
>>
>> which would in a loop just iterate over the payloads and
>> let the hypervisor stick it in the crashkernel space.
>>
>> This is all hand-waving of course. There probably would be a need
>> to figure out how much space you have in the reserved Xen's
>> 'crashkernel' memory region too.
> This is probably a mad idea but it's Monday morning and I'm sleep
> deprived so I'll throw it out there...
>
> What about adding DOMID_KEXEC (similar DOMID_IO etc)? This would allow
> dom0 to map the kexec memory space with the usual privcmd mmap
> hypercalls and build things in it directly.
>
> OK, I suspect this might not be practical for a variety of reasons (lack
> of a p2m for such domains so no way to find out the list of mfns, dom0
> userspace simply doesn't have sufficient context to write sensible
> things here, etc) but maybe someone has a better head on today...
>
> Ian.
>

Given that /sbin/kexec creates a binary blob in memory, surely the most 
simple thing is to get it to suitably mlock() the region and give a list 
of VAs to the hypervisor.

This way, Xen can properly take care of what it does with information 
and where.  For example, at the moment, allowing dom0 to choose where 
gets overwritten in the Xen crash area is a recipe for disaster if a 
crash occurs midway through loading/reloading the crash kernel.

~Andrew

