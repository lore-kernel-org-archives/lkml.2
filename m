Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab2EMP40 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 11:56:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753495Ab2EMP4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 11:56:25 -0400
Date: Sun, 13 May 2012 18:56:23 +0300
From: Gleb Natapov <gleb@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: kvm@vger.kernel.org, Rob Landley <rob@landley.net>,
        Glauber Costa <glommer@redhat.com>, Rik van Riel <riel@redhat.com>,
        Avi Kivity <avi@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: eoi msi documentation
Message-ID: <20120513155622.GG15230@redhat.com>
References: <20120513151321.GA25721@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120513151321.GA25721@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2012 at 06:13:22PM +0300, Michael S. Tsirkin wrote:
> Document the new EOI MSR.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> This documents my PV EOI patchset and applies on top.
> Will make it part of the patchset on the next respin.
> 
>  Documentation/virtual/kvm/msr.txt |   56 +++++++++++++++++++++++++++++++++++++
>  1 files changed, 56 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/msr.txt b/Documentation/virtual/kvm/msr.txt
> index 5031780..bdbd337 100644
> --- a/Documentation/virtual/kvm/msr.txt
> +++ b/Documentation/virtual/kvm/msr.txt
> @@ -219,3 +219,59 @@ MSR_KVM_STEAL_TIME: 0x4b564d03
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
> +	clear it using a single CPU instruction, such as test and clear, or
> +	compare and exchange.
> +
Looks good, but everything below this is here by mistake. Are You still
going to resend host side patch to address my other comment?

> +the page referred to by the page fault is not
> +	present. Value 2 means that the page is now available. Disabling
> +	interrupt inhibits APFs. Guest must not enable interrupt
> +	before the reason is read, or it may be overwritten by another
> +	APF. Since APF uses the same exception vector as regular page
> +	fault guest must reset the reason to 0 before it does
> +	something that can generate normal page fault.  If during page
> +	fault APF reason is 0 it means that this is regular page
> +	fault.
> +
> +	During delivery of type 1 APF cr2 contains a token that will
> +	be used to notify a guest when missing page becomes
> +	available. When page becomes available type 2 APF is sent with
> +	cr2 set to the token associated with the page. There is special
> +	kind of token 0xffffffff which tells vcpu that it should wake
> +	up all processes waiting for APFs and no individual type 2 APFs
> +	will be sent.
> +
> +	If APF is disabled while there are outstanding APFs, they will
> +	not be delivered.
> +
> +	Currently type 2 APF will be always delivered on the same vcpu as
> +	type 1 was, but guest should not rely on that.
> +
> -- 
> MST

--
			Gleb.
