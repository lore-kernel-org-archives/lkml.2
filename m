Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab2CLFnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 01:43:53 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:55362 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab2CLFnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 01:43:46 -0400
Message-ID: <4F5D8D0E.8060702@oss.ntt.co.jp>
Date: Mon, 12 Mar 2012 14:43:42 +0900
From: =?UTF-8?B?RmVybmFuZG8gTHVpcyBWw6F6cXVleiBDYW8=?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Don Zickus <dzickus@redhat.com>, linux-tip-commits@vger.kernel.org,
        torvalds@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        mingo@elte.hu, Yinghai Lu <yinghai@kernel.org>,
        akpm@linux-foundation.org, vgoyal@redhat.com
Subject: Re: [PATCH 1/2] boot: ignore early NMIs
References: <CAE9FiQVPnO8-tuPoio0Wxv=8rjdm2tJbBk3+3ystueyYtZn9BA@mail.gmail.com> <20120216172735.GX9751@redhat.com> <CAE9FiQVhbAM9vjx-uFcuc0ndsUp0aez9_TsQHStje5G5iwYbag@mail.gmail.com> <20120216215603.GH9751@redhat.com> <m1y5s2ku36.fsf@fess.ebiederm.org> <m1fwe9bpk2.fsf@fess.ebiederm.org> <20120217195430.GO9751@redhat.com> <m1y5s07rn3.fsf@fess.ebiederm.org> <20120220151419.GU9751@redhat.com> <m1obss39a4.fsf@fess.ebiederm.org> <20120221135934.GF26998@redhat.com> <m1ipip6xe8.fsf@fess.ebiederm.org> <4F573E1C.2060909@oss.ntt.co.jp> <4F573E74.5040504@oss.ntt.co.jp> <m1eht31z8e.fsf@fess.ebiederm.org> <4F58495B.5080308@oss.ntt.co.jp> <m1r4x3yrsv.fsf@fess.ebiederm.org> <4F5A6D87.4050809@zytor.com>
In-Reply-To: <4F5A6D87.4050809@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2012 05:52 AM, H. Peter Anvin wrote:

> Is there a reason to not just simply block these NMIs during the kexec
> sequence?
Ok, some background:

In the reboot path to the kdump kernel we disable local interrupts
and the APICs in native_machine_crash_shutdown() and reset the IDT
in machine_kexec(), which leaves an in valid IDT installed.

However, disabling the I/O APIC involves taking a lock, which in
the event of a crash can is racy and can lead to a deadlock. To
solve this issue Don wrote a patch that left the I/O APICs and
the LAPIC of the crashing CPU untouched in the kdump reboot path,
but this seemed to cause mysterious reboots in some systems.
It turned out that an NMI coming from the perf based hardlockup
detector was causing the system to triple fault. If a NMI happens
to arrive in the window between the invalidation of the IDT in
machine_kexec() and the configuration of the final IDT we will be
in big trouble. In particular, the system will either triple fault
or halt, depending on whether the NMI arrived before or after
installing the early IDT.

To tackle this issue we can either stop the hardlockup detector
or disable the LAPIC (the NMIs needed by x86's hardlockup detector
are generated using performance counters in the LAPIC), leaving
the I/O APICs untouched. The second is simpler and I think it
is the approach Don took to fix this issue in RHEL kernels.

Unfortunately, this is not enough, we are still exposed to external
NMIs not routed through the LAPIC. In other words, we have to make
sure that we always have and IDT that is able to handle NMIs without
seemingly random reboots and lockups. To achieve this goal we need
to fix machine_kexec() and the early IDT handlers. The current patch
set takes care of the latter.

- Fernando

