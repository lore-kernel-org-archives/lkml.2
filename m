Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab2CLGOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 02:14:31 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:56619 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab2CLGOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 02:14:24 -0400
Message-ID: <4F5D943C.5020403@oss.ntt.co.jp>
Date: Mon, 12 Mar 2012 15:14:20 +0900
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
References: <CAE9FiQVPnO8-tuPoio0Wxv=8rjdm2tJbBk3+3ystueyYtZn9BA@mail.gmail.com> <20120216172735.GX9751@redhat.com> <CAE9FiQVhbAM9vjx-uFcuc0ndsUp0aez9_TsQHStje5G5iwYbag@mail.gmail.com> <20120216215603.GH9751@redhat.com> <m1y5s2ku36.fsf@fess.ebiederm.org> <m1fwe9bpk2.fsf@fess.ebiederm.org> <20120217195430.GO9751@redhat.com> <m1y5s07rn3.fsf@fess.ebiederm.org> <20120220151419.GU9751@redhat.com> <m1obss39a4.fsf@fess.ebiederm.org> <20120221135934.GF26998@redhat.com> <m1ipip6xe8.fsf@fess.ebiederm.org> <4F573E1C.2060909@oss.ntt.co.jp> <4F573E74.5040504@oss.ntt.co.jp> <m1eht31z8e.fsf@fess.ebiederm.org> <4F58495B.5080308@oss.ntt.co.jp> <m1r4x3yrsv.fsf@fess.ebiederm.org> <4F5A6D87.4050809@zytor.com> <4F5D8D0E.8060702@oss.ntt.co.jp> <4F5D8E63.60606@zytor.com>
In-Reply-To: <4F5D8E63.60606@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2012 02:49 PM, H. Peter Anvin wrote:

> On 03/11/2012 10:43 PM, Fernando Luis Vázquez Cao wrote:
>> To tackle this issue we can either stop the hardlockup detector
>> or disable the LAPIC (the NMIs needed by x86's hardlockup detector
>> are generated using performance counters in the LAPIC), leaving
>> the I/O APICs untouched. The second is simpler and I think it
>> is the approach Don took to fix this issue in RHEL kernels.
>>
>> Unfortunately, this is not enough, we are still exposed to external
>> NMIs not routed through the LAPIC. In other words, we have to make
>> sure that we always have and IDT that is able to handle NMIs without
>> seemingly random reboots and lockups. To achieve this goal we need
>> to fix machine_kexec() and the early IDT handlers. The current patch
>> set takes care of the latter.
> The only source of NMIs other than the LAPIC should be the system error
> which can be disabled through the RTC port, so I think your second
> paragraph here is way more mechanism than you need for very little gain.

The thing is that we want to avoid playing with hardware in the kdump
reboot patch when we can avoid it, the premise being that it cannot
be accessed without risking a lockup or worse (as the deadlock accessing
the I/O APIC showed). The kernel is crashing after all. What is more,
I forgot to mention that the long term goal is to leave the LAPIC
untouched too (we really want to keep the number of things we do in the
context of the crashing kernel to the bare minimum), so we would still
need to fix the early IDT.

My patch set just installs a special handler for the NMI case so I think
it is pretty simple and self contained.

Another reason to apply these patches is to be consistent with the rest
of the kernel. Spurious NMIs that would have been ignored after installing
the final IDT would cause the system to halt if they happen
to arrive while the early IDT is in place.

- Fernando

