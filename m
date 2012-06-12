Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab2FLW2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 18:28:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067Ab2FLW2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 18:28:00 -0400
Date: Tue, 12 Jun 2012 19:24:53 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
        gleb@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv6 5/8] kvm: eoi msi documentation
Message-ID: <20120612222453.GA1973@amt.cnet>
References: <cover.1338474301.git.mst@redhat.com>
 <ee4c8513394438ba534b515f5c82d5a37187c811.1338474301.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee4c8513394438ba534b515f5c82d5a37187c811.1338474301.git.mst@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 03, 2012 at 10:28:21AM +0300, Michael S. Tsirkin wrote:
> Document the new EOI MSR. Couldn't decide whether this change belongs
> conceptually on guest or host side, so a separate patch.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  Documentation/virtual/kvm/msr.txt |   32 ++++++++++++++++++++++++++++++++
>  1 files changed, 32 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/msr.txt b/Documentation/virtual/kvm/msr.txt
> index 96b41bd..f202a22 100644
> --- a/Documentation/virtual/kvm/msr.txt
> +++ b/Documentation/virtual/kvm/msr.txt
> @@ -223,3 +223,35 @@ MSR_KVM_STEAL_TIME: 0x4b564d03
>  		steal: the amount of time in which this vCPU did not run, in
>  		nanoseconds. Time during which the vcpu is idle, will not be
>  		reported as steal time.
> +
> +MSR_KVM_EOI_EN: 0x4b564d04
> +	data: Bit 0 is 1 when PV end of interrupt is enabled on the vcpu; 0
> +	when disabled.  When enabled, bits 63-1 hold 2-byte aligned physical address
> +	of a 2 byte memory area which must be in guest RAM and must be zeroed.
> +
> +	The first, least significant bit of 2 byte memory location will be
> +	written to by the hypervisor, typically at the time of interrupt
> +	injection.  Value of 1 means that guest can skip writing EOI to the apic
> +	(using MSR or MMIO write); instead, it is sufficient to signal
> +	EOI by clearing the bit in guest memory - this location will
> +	later be polled by the hypervisor.
> +	Value of 0 means that the EOI write is required.
> +
> +	It is always safe for the guest to ignore the optimization and perform
> +	the APIC EOI write anyway.
> +
> +	Hypervisor is guaranteed to only modify this least
> +	significant bit while in the current VCPU context, this means that
> +	guest does not need to use either lock prefix or memory ordering
> +	primitives to synchronise with the hypervisor.
> +
> +	However, hypervisor can set and clear this memory bit at any time:
> +	therefore to make sure hypervisor does not interrupt the
> +	guest and clear the least significant bit in the memory area
> +	in the window between guest testing it to detect
> +	whether it can skip EOI apic write and between guest
> +	clearing it to signal EOI to the hypervisor,
> +	guest must both read the least sgnificant bit in the memory area and

typo

> +	clear it using a single CPU instruction, such as test and clear, or
> +	compare and exchange.
> +
> -- 

