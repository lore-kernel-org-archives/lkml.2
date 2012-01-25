Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab2AYM2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 07:28:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221Ab2AYM2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 07:28:37 -0500
Date: Wed, 25 Jan 2012 10:27:03 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Johannes Stezenbach <js@sig21.net>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-3.2.1 + KVM: TSC unstable on Core i5-2400S / H67
Message-ID: <20120125122702.GA30888@amt.cnet>
References: <20120124113608.GA16876@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124113608.GA16876@sig21.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 12:36:08PM +0100, Johannes Stezenbach wrote:
> Hi,
> 
> I just got the following in dmesg with linux-3.2.1:
> 
> [23379.612251] usb 2-1.2: new high-speed USB device number 6 using ehci_hcd
> [    0.006666] Marking TSC unstable due to KVM discovered backwards TSC
> [23421.511167] Switching to clocksource hpet
> 
> The mainboard is an Asus P8H67-V, BIOS 0806 10/26/2011 with Core i5-2400S.
> The kvm instance was running for a day already, and there was an overnight
> suspend-to-disk cycle in between, but the above happened ~1 hour after resume.
> (I don't think the usb message has anything to do with it, it's just
> the last message before the TSC message.)
> 
> Hm, checking /var/log/kern.* it seems this also happened with
> linux-3.1.* without me noticing.
> 
> Should I be worried?  I thought Core-i5 processors have a stable TSC?

It does.

Can you please apply the following patch, and report back when it
reproduces again.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9c912f0b..17d706d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2242,8 +2242,11 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		tsc_delta = !vcpu->arch.last_guest_tsc ? 0 :
 			     tsc - vcpu->arch.last_guest_tsc;
 
-		if (tsc_delta < 0)
+		if (tsc_delta < 0) {
+			printk(KERN_ERR "tsc = %llx last_guest_tsc = %llx\n",
+				tsc, vcpu->arch.last_guest_tsc);
 			mark_tsc_unstable("KVM discovered backwards TSC");
+		}
 		if (check_tsc_unstable()) {
 			kvm_x86_ops->adjust_tsc_offset(vcpu, -tsc_delta);
 			vcpu->arch.tsc_catchup = 1;

