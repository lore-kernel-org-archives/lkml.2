Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374Ab2CMBnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 21:43:50 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:42206 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759363Ab2CMBnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 21:43:39 -0400
Message-ID: <4F5EA649.2060002@oss.ntt.co.jp>
Date: Tue, 13 Mar 2012 10:43:37 +0900
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
References: <CAE9FiQVPnO8-tuPoio0Wxv=8rjdm2tJbBk3+3ystueyYtZn9BA@mail.gmail.com> <20120216172735.GX9751@redhat.com> <CAE9FiQVhbAM9vjx-uFcuc0ndsUp0aez9_TsQHStje5G5iwYbag@mail.gmail.com> <20120216215603.GH9751@redhat.com> <m1y5s2ku36.fsf@fess.ebiederm.org> <m1fwe9bpk2.fsf@fess.ebiederm.org> <20120217195430.GO9751@redhat.com> <m1y5s07rn3.fsf@fess.ebiederm.org> <20120220151419.GU9751@redhat.com> <m1obss39a4.fsf@fess.ebiederm.org> <20120221135934.GF26998@redhat.com> <m1ipip6xe8.fsf@fess.ebiederm.org> <4F573E1C.2060909@oss.ntt.co.jp> <4F573E74.5040504@oss.ntt.co.jp> <m1eht31z8e.fsf@fess.ebiederm.org> <4F58495B.5080308@oss.ntt.co.jp> <m1r4x3yrsv.fsf@fess.ebiederm.org> <4F5A6D87.4050809@zytor.com> <4F5D8D0E.8060702@oss.ntt.co.jp> <4F5D8E63.60606@zytor.com> <4F5D943C.5020403@oss.ntt.co.jp> <4F5E431D.8010305@zytor.com>
In-Reply-To: <4F5E431D.8010305@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2012 03:40 AM, H. Peter Anvin wrote:

> On 03/11/2012 11:14 PM, Fernando Luis Vázquez Cao wrote:
>> The thing is that we want to avoid playing with hardware in the kdump
>> reboot patch when we can avoid it, the premise being that it cannot
>> be accessed without risking a lockup or worse (as the deadlock accessing
>> the I/O APIC showed). The kernel is crashing after all. What is more,
>> I forgot to mention that the long term goal is to leave the LAPIC
>> untouched too (we really want to keep the number of things we do in the
>> context of the crashing kernel to the bare minimum), so we would still
>> need to fix the early IDT.
>>
>> My patch set just installs a special handler for the NMI case so I think
>> it is pretty simple and self contained.
>>
>> Another reason to apply these patches is to be consistent with the rest
>> of the kernel. Spurious NMIs that would have been ignored after installing
>> the final IDT would cause the system to halt if they happen
>> to arrive while the early IDT is in place.
> I'm concerned that you're adding failure modes


This patch set just brings the early IDT in line with what we do after
switching to the final IDT, i.e. we ignore NMIs. The only difference is
that we do not honor panic*nmi and unknown_nmi_panic. As things
stand now the kernel will sometimes mysteriously hang. I really
think that independently of the kdump problem it would be nice
to be consistent in this regard.

> because you don't want to
> solve the real problem which is you need to block this at the source.

Indeed, I want to do both. Try to block NMIs at the source when
possible and install an IDT that ignores NMIs to have our backs
covered (avoid triple faults and lockups). As Eric mentioned
it is not clear that we can always identify and stop all the sources.


> It is way more than the IDT that has to work (at the very least, you
> need the GDT and a working stack) at all times in order for NMIs to be
> receivable.

Of course, and that is what the follow-up patch set does. It just needs
some more testing. The patches I sent make use of the early GDT and
it works as expected.

> That doesn't address what happens if you're getting an NMI
> storm either.

Well, the same applies to the final IDT. As I mentioned before
I think we should also try to stop things at the source when
it is safe (of course, first we need to identify all the sources).

- Fernando
