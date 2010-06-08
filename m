Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab0FHVAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 17:00:23 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:38833 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab0FHVAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 17:00:21 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: jacob pan <jacob.jun.pan@linux.intel.com>, Alan Cox <alan@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
References: <1275952044-27996-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<m1631ue5ho.fsf@fess.ebiederm.org>
	<20100607225010.342e2fab@jacob-laptop>
	<m1631tfh1i.fsf@fess.ebiederm.org> <4C0EA9BD.1090306@zytor.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 08 Jun 2010 13:59:30 -0700
In-Reply-To: <4C0EA9BD.1090306@zytor.com> (H. Peter Anvin's message of "Tue\, 08 Jun 2010 13\:36\:13 -0700")
Message-ID: <m1iq5tckb1.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: hpa@zytor.com, len.brown@intel.com, feng.tang@intel.com, mingo@elte.hu, linux-kernel@vger.kernel.org, arjan@linux.intel.com, alan@linux.intel.com, jacob.jun.pan@linux.intel.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH] x86/sfi: fix ioapic gsi range
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 06/08/2010 12:41 PM, Eric W. Biederman wrote:
>> 
>> At the ioapic and gsi level, and in your firmware interface reusing the
>> numbers is fine.
>> 
>> The issue is what acpi calls bus 0 irqs, and how drivers deal with
>> them.  We wind up having well know irqs:  irqs 3 and 4 for serial ports,
>> irq 7 for parallel ports. irqs 14, and 15 for ide.
>> 
>> A bunch of these hardware devices we can get if someone connects up a
>> lpc superio chip.
>> 
>> Even if sfi is never implemented on a platform where that kind of
>> hardware exists, the current sfi code is setup to coexist
>> simultaneously in the kernel with all of the infrastructure of other
>> platforms where those kinds of devices exist.  Which means there can
>> be drivers compiled into your kernel that make assumptions about special
>> properties of the irqs 0-15.
>> 
>> I have seen a lot of weird hard to track issues, because of a conflict in
>> assumptions over the ISA irqs.  It is easiest and safest just to let the
>> first 16 linux irq numbers be reserved for the legacy oddness, so code can
>> make assumptions and we don't have to worry about it.
>> 
>> As for the question about using legacy_pic to detect the absence of an irq
>> controller that Peter raised.  We can't do that because it should be possible
>> for an acpi system with all of the legacy hardware to exist without needing
>> to implement an i8259, or ever run in the historical interrupt delivery mode
>> of pcs.
>> 
>> With the current code you should get all of the remapping of the gsi's out
>> of the legacy irq space without needing to lift a finger, and if someone later
>> decides we need an irq override so we can have an isa irq present on a weird
>> embedded system on a chip the code will be able to handle that easily.
>> 
>
> OK, let me ask this, then: if we do that, and we hardcode this as 16
> magic IRQs indefinitely, does that mean we lose 16 IDT entries
> indefinitely as well?  We are already shy on interrupt vectors, and that
> would make me unhappy.

No.  There is no reason to loose 16 IDT entries indefinitely.  We may
need a boot time allocation when we see we have isa irqs, to replace
the static allocation that we have.  But for the most part we dynamically
idt entries aka vector numbers today, and there is no reason we can't
generalize that in the future.

Eric
