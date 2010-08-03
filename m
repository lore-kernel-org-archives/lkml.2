Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab0HCD0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 23:26:35 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:49434 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab0HCD0e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 23:26:34 -0400
To: Dave Airlie <airlied@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: oops in ioapic_write_entry
References: <AANLkTimeFuABgQHJzq38uJ-4gTQbfSRfQBb91P+NPwCS@mail.gmail.com>
	<AANLkTimqDPvTqOZiBgUn7t4JJhgQU4ShVTsCJEzV=8fR@mail.gmail.com>
	<AANLkTi=sNRwxmv8aKN_jo7tAx6SQ-AOFfAXJxcPnNZQp@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 02 Aug 2010 20:26:29 -0700
In-Reply-To: <AANLkTi=sNRwxmv8aKN_jo7tAx6SQ-AOFfAXJxcPnNZQp@mail.gmail.com> (Dave Airlie's message of "Tue\, 3 Aug 2010 09\:17\:16 +1000")
Message-ID: <m139uw1imy.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie <airlied@gmail.com> writes:

>>
>> the kernel is using mptable, and the  system have mcp55, so how come
>> with irq 35?
>> assume we should only have ioapic irq 0 - 23 ...
>>
>> Can you send out boot log with "debug apic=debug pci=routeirq" with
>> 2.6.32 and 2.6.35?
>
> Okay el6log is from a RHEL6 2.6.32 kernel, but it should give a good
> baseline, the 2.6.35 oops even earlier with all those options and is
> in the second attachment.

It appears we have a smoking gun:

For some reason setup_IO_APIC_IRQS thinks we at least 2 io_apics,
but we have only setup 1 io_apic.  Since io_apics need a kmap entry
accessing an apic that hasn't been setup will definitely give a
page fault.  It sounds like something is stomping nr_ioapics.

From: 2.6.35-debuglog
IOAPIC[0]: apic_id 8, version 17, address 0xfec00000, GSI 0-23
....
IOAPIC[1]: Set routing entry (0-16 -> 0x51 -> IRQ 16 Mode:1 Active:1)

Can we get your System.map of the failing kernel (so we can see what
is close to nr_ioapics), and could you add a print statement in
arch/x86/kernel/apic/io_apic:setup_IO_APIC_irqs to print nr_ioapics?

I would be surprised if drm changes could have affected this.

Eric

