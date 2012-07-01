Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab2GAK4o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 06:56:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755334Ab2GAK4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 06:56:42 -0400
Date: Sun, 1 Jul 2012 13:56:44 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        x86@kernel.org
Subject: Re: linux-next: Tree for June 29 (kvm)
Message-ID: <20120701105643.GA4782@redhat.com>
References: <20120629175341.22a9eccd30d9c085bfd92c1d@canb.auug.org.au>
 <4FEDEE6A.7020608@xenotime.net>
 <4FF01B59.1010600@redhat.com>
 <20120701094430.GB4642@redhat.com>
 <4FF01D41.5070600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF01D41.5070600@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2012 at 12:49:53PM +0300, Avi Kivity wrote:
> On 07/01/2012 12:44 PM, Michael S. Tsirkin wrote:
> > On Sun, Jul 01, 2012 at 12:41:45PM +0300, Avi Kivity wrote:
> >> On 06/29/2012 09:05 PM, Randy Dunlap wrote:
> >> > On 06/29/2012 12:53 AM, Stephen Rothwell wrote:
> >> > 
> >> >> Hi all,
> >> >> 
> >> >> Changes since 20120628:
> >> > 
> >> > 
> >> > 
> >> > on i386:
> >> > 
> >> > arch/x86/built-in.o: In function `kvm_guest_apic_eoi_write':
> >> > kvm.c:(.text+0x3561f): undefined reference to `apic'
> >> > 
> >> > 
> >> > Full randconfig file is attached.
> >> 
> >> Michael, please disable pveoi if built with no apic.
> > 
> > Will do.
> > How do I tweak config to test this? Any hints?
> 
> See the original mail, there's a .config there.

This https://lkml.org/lkml/2012/6/29/40 ?
I don't see a .config there.

> Basically, i386 UP with
> IOAPIC disabled.

The following patch fixes this in another way:
making sure that anyone looking at apicdrivers
gets an empty list. Thoughts?


Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index eaff479..e48547b 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -417,7 +417,12 @@ extern struct apic *apic;
 	__aligned(sizeof(struct apic *))				\
 	__section(.apicdrivers) = { &sym1, &sym2 }
 
+#ifdef CONFIG_X86_LOCAL_APIC
 extern struct apic *__apicdrivers[], *__apicdrivers_end[];
+#else
+#define __apicdrivers ((struct apic **)NULL)
+#define __apicdrivers_end ((struct apic **)NULL)
+#endif
 
 /*
  * APIC functionality to boot other CPUs - only used on SMP:

> -- 
> error compiling committee.c: too many arguments to function
> 
