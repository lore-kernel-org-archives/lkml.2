Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab2BPTe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 14:34:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174Ab2BPTe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 14:34:57 -0500
Message-ID: <4F3D5A59.20803@redhat.com>
Date: Thu, 16 Feb 2012 21:34:49 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Gleb Natapov <gleb@redhat.com>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@ozlabs.org>, qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com> <20120205093723.GQ23536@redhat.com>	<4F2E4F8B.8090504@redhat.com> <20120205095153.GA29265@redhat.com>	<4F2EAFF6.7030006@codemonkey.ws> <4F2F9E89.7090607@redhat.com>	<87vcnih5qt.fsf@rustcorp.com.au> <4F3BB59D.2020505@redhat.com>	<4F3C2AC5.80400@codemonkey.ws> <20120216085741.GB19771@redhat.com> <4F3D16BB.5060804@codemonkey.ws>
In-Reply-To: <4F3D16BB.5060804@codemonkey.ws>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2012 04:46 PM, Anthony Liguori wrote:
>> What will it buy us? Surely not speed. Entering a guest is not much
>> (if at all) faster than exiting to userspace and any non trivial
>> operation will require exit to userspace anyway,
>
>
> You can emulate the PIT/RTC entirely within the guest using kvmclock
> which doesn't require an additional exit to get the current time base.
>
> So instead of:
>
> 1) guest -> host kernel
> 2) host kernel -> userspace
> 3) implement logic using rdtscp via VDSO
> 4) userspace -> host kernel
> 5) host kernel -> guest
>
> You go:
>
> 1) guest -> host kernel
> 2) host kernel -> guest (with special CR3)
> 3) implement logic using rdtscp + kvmclock page
> 4) change CR3 within guest and RETI to VMEXIT source RIP
>
> Same basic concept as PS/2 emulation with SMM.

Interesting, but unimplementable in practice.  SMM requires a VMEXIT for
RSM, and anything non-SMM wants a virtual address mapping (and some RAM)
which you can't get without guest cooperation.  There are other
complications like an NMI interrupting hypervisor-provided code and
finding unexpected addresses on its stack (SMM at least blocks NMIs).

Tangentially related, Intel introduced a VMFUNC that allows you to
change the guest's physical memory map to a pre-set alternative provided
by the host, without a VMEXIT.  Seems similar to SMM but requires guest
cooperation.  I guess it's for unintrusive virus scanners and the like.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

