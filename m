Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab0DBWzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 18:55:41 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:46191 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab0DBWzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 18:55:35 -0400
To: Chris Wright <chrisw@sous-sol.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>,
       Neil Horman <nhorman@tuxdriver.com>, Neil Horman <nhorman@redhat.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       hbabu@us.ibm.com, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 1/2] x86/amd-iommu: enable iommu before attaching devices
References: <20100331202745.GE13406@hmsreliant.think-freely.org>
	<20100401142902.GF24846@8bytes.org>
	<20100401144736.GA14069@shamino.rdu.redhat.com>
	<20100401155643.GG24846@8bytes.org>
	<20100401171149.GH13603@shamino.rdu.redhat.com>
	<20100401201433.GK24846@8bytes.org>
	<20100402000012.GA8930@hmsreliant.think-freely.org>
	<20100402003034.GX29241@sequoia.sous-sol.org>
	<20100402012353.GY29241@sequoia.sous-sol.org>
	<20100402155932.GA3516@redhat.com>
	<20100402223809.GB29241@sequoia.sous-sol.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 02 Apr 2010 15:55:25 -0700
In-Reply-To: <20100402223809.GB29241@sequoia.sous-sol.org> (Chris Wright's message of "Fri\, 2 Apr 2010 15\:38\:09 -0700")
Message-ID: <m1pr2hmplu.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: chrisw@sous-sol.org, iommu@lists.linux-foundation.org, hbabu@us.ibm.com, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, nhorman@redhat.com, nhorman@tuxdriver.com, joerg.roedel@amd.com, vgoyal@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright <chrisw@sous-sol.org> writes:

> * Vivek Goyal (vgoyal@redhat.com) wrote:
>> Following is just for my education purposes. Trying to understand better
>> the impact of in-flight DMAs. So IIUC, in kudmp context following seems to be
>> sequence of events.
>> 
>> 1. kernel crashes, we leave IOMMU enabled.
>
> No, we actually disable the IOMMU
>
> panic()
>   crash_exec()
>     machine_crash_shutdown()
>       native_machine_crash_shutdown()
>         x86_platform.iommu_shutdown() == amd_iommu_init.c::disable_iommus()

That call exists but is there any good reason for it?
Nothing should be on that can be reasonably done anywhere else.
This round of bug fixing and testing would be a good time to remove
that extraneous call.

>> 2. boot into capture kernel and we call enable_iommus(). This function
>>    first disables iommu, sets up new device table and enables iommus
>>    again.
>> 	a. So during this small window when iommu is disabled and we enable
>> 	   it back, any inflight DMA will passthrough possibly to an
>> 	   unintended physical address as translation is disabled and it
>> 	   can corrupt the kdump kenrel.
>
> Yes, should be possible.
>
>> 	b. Even after enabling the iommu, I guess we will continue to
>> 	   use cached DTE, and translation information to handle any
>> 	   in-flight DMA. The difference is that now iommus are enabled
>> 	   so any in-flight DMA should go to the address as intended in
>> 	   first kenrel and should not corrupt anything.
>
> Cached DTE only gets you domainID and pt root, so results depend upon
> other caches too.
>
>> 3. Once iommus are enabled again, we allocated and initilize protection
>>    domains. We attach devices to domains. In the process we flush the
>>    DTE, PDE and IO TLBs.
>
> Yes, but this is immediately after 2b above.  We can't send the invalidate
> commands until the iommu is enabled.
>
>> 	c. Looks like do_attach->set_dte_entry(), by default gives write
>> 	   permission (IW) to all the devices. I am assuming that at
>> 	   this point of time translation is enabled and possibly unity
>> 	   mapped.
>
> Unlikely to have full unity map, it's typically just for a range,
> and this is also typically for devices that have interaction w/ BIOS
> (typical examples are usb/SMM for keyboard and integrated graphics).
> And the mapping is to reserved memory areas (BIOS regions).  On my test
> box, for example, there are none of the BIOS specified ranges.
>
>>	   If that's the case, any in-flight DMA will not be
>> 	   allowed to happen at unity mapped address and this can possibly
>> 	   corrupt the kernel? 
>
> I don't understand what you mean there.
>
>> I understand this patch should fix the case when in second kernel a 
>> device is not doing DMA because of possibly cached DTE, and translation
>> information. But looks like in-flight DMA issues will still need a closer
>> look. But that is a separate issue and needs to be addressed in separate
>> set of patches.
>
> All of the in-flight DMA corrupts kdump kernel memory issues can exist
> w/out an IOMMU.  On the one hand, the IOMMU actually reduces the window
> of opportunity, but on the other it adds possible translation issue.

?
If disabling the IOMMU changes the destination in RAM of in-flight DMA
the issues are not at all the same.

> About the only thing we can do here is modify the crashing kernel to
> update the DTE to disable dma, invalidate, and leave IOMMU enabled.
> This is all in the context of crashing, so any further errors here mean
> we probably won't get to kdump kernel.

Why even touch the IOMMU?

> The kexec'd kernel will still need to defensively prepare things as it
> always does since it can't trust anything that came before it.


Yes.

Eric

