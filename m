Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab0FHUga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 16:36:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53046 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756396Ab0FHUg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 16:36:26 -0400
Message-ID: <4C0EA9BD.1090306@zytor.com>
Date: Tue, 08 Jun 2010 13:36:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: jacob pan <jacob.jun.pan@linux.intel.com>, Alan Cox <alan@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH] x86/sfi: fix ioapic gsi range
References: <1275952044-27996-1-git-send-email-jacob.jun.pan@linux.intel.com>	<m1631ue5ho.fsf@fess.ebiederm.org>	<20100607225010.342e2fab@jacob-laptop> <m1631tfh1i.fsf@fess.ebiederm.org>
In-Reply-To: <m1631tfh1i.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2010 12:41 PM, Eric W. Biederman wrote:
> 
> At the ioapic and gsi level, and in your firmware interface reusing the
> numbers is fine.
> 
> The issue is what acpi calls bus 0 irqs, and how drivers deal with
> them.  We wind up having well know irqs:  irqs 3 and 4 for serial ports,
> irq 7 for parallel ports. irqs 14, and 15 for ide.
> 
> A bunch of these hardware devices we can get if someone connects up a
> lpc superio chip.
> 
> Even if sfi is never implemented on a platform where that kind of
> hardware exists, the current sfi code is setup to coexist
> simultaneously in the kernel with all of the infrastructure of other
> platforms where those kinds of devices exist.  Which means there can
> be drivers compiled into your kernel that make assumptions about special
> properties of the irqs 0-15.
> 
> I have seen a lot of weird hard to track issues, because of a conflict in
> assumptions over the ISA irqs.  It is easiest and safest just to let the
> first 16 linux irq numbers be reserved for the legacy oddness, so code can
> make assumptions and we don't have to worry about it.
> 
> As for the question about using legacy_pic to detect the absence of an irq
> controller that Peter raised.  We can't do that because it should be possible
> for an acpi system with all of the legacy hardware to exist without needing
> to implement an i8259, or ever run in the historical interrupt delivery mode
> of pcs.
> 
> With the current code you should get all of the remapping of the gsi's out
> of the legacy irq space without needing to lift a finger, and if someone later
> decides we need an irq override so we can have an isa irq present on a weird
> embedded system on a chip the code will be able to handle that easily.
> 

OK, let me ask this, then: if we do that, and we hardcode this as 16
magic IRQs indefinitely, does that mean we lose 16 IDT entries
indefinitely as well?  We are already shy on interrupt vectors, and that
would make me unhappy.

	-hpa
