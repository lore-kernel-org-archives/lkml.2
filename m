Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab1LNJht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 04:37:49 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63736 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab1LNJhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 04:37:48 -0500
MIME-Version: 1.0
In-Reply-To: <BC00F5384FCFC9499AF06F92E8B78A9E287D8A556C@shsmsx502.ccr.corp.intel.com>
References: <CAB9v_DFOm8eDwR5YsqLfUEtr0ku2Zp=NCOaEjkSmxJFcpQ9nPA@mail.gmail.com>
 <BC00F5384FCFC9499AF06F92E8B78A9E287D8A556C@shsmsx502.ccr.corp.intel.com>
From: Alexey Zaytsev <alexey.zaytsev@nexenta.com>
Date: Wed, 14 Dec 2011 12:37:26 +0300
X-Google-Sender-Auth: QHR88ZNKMQFeEpS2yka6AqauC4M
Message-ID: <CAB9v_DFs_Rz04+waeBpVoJsLX+Ao7vQ4EtH2TJsX6jHZewWLQA@mail.gmail.com>
Subject: Re: [Regression, bisected] a3e06bbe8445f57eb949e6474c5a9b30f24d2057:
 KVM: emulate lapic tsc deadline timer for guest"
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
        "Garrett D'Amore" <garrett@nexenta.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 10:13, Liu, Jinsong <jinsong.liu@intel.com> wrote:
> Alexey Zaytsev wrote:
>> Hi.
>>
>> After a recent change, qemu --enable-kvm (both 0.15.92 and 1.0) fails
>> to boot illumos. The OS gets stuck pretty late in the boot process,
>> without any hints from the guest. MDB (the illumos kenrnel debugger)
>> failed to clarify the situation at once, the kernel seems to be stuck
>> idling. I've bisected the problem to commit
>> a3e06bbe8445f57eb949e6474c5a9b30f24d2057. Please let me know if you
>> need me to collect any debug information or test any patches.
>
> Alexey,
>
> Does illumos use tsc deadline timer? and do you run it at Intel platform?
>
> If yes, would you please help me to collect debug information by add some printk points at kvm tsc deadline timer logic? currently I totally have no clue to figure out what the issue root from :)
> and, would you please check illumos tsc deadline timer logic by confirm whether illumos
> 1). Enumerate tsc deadline timer capability by CPUID;
> 2). Enable tsc deadline timer mode by lapic MMIO;
> 3). Start tsc deadline timer by WRMSR;

I think, here's what's going on. We get into
kvm_get_lapic_tscdeadline_msr/kvm_set_lapic_tscdeadline_msr, but qemu
does not use the KVM_CREATE_IRQCHIP ioctl, so we are running without
vcpu->arch.apic and the functions do nothing. And the Linux guest just
handles broken tsc a lot  better, so it survives. Both guests seem to
work fine with qemu-kvm, which uses the ioctl.

>
> Thanks,
> Jinsong
