Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007Ab2CMCLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 22:11:52 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:43526 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825Ab2CMCLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 22:11:51 -0400
Message-ID: <4F5EACE5.8080202@oss.ntt.co.jp>
Date: Tue, 13 Mar 2012 11:11:49 +0900
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
References: <CAE9FiQVPnO8-tuPoio0Wxv=8rjdm2tJbBk3+3ystueyYtZn9BA@mail.gmail.com> <CAE9FiQVhbAM9vjx-uFcuc0ndsUp0aez9_TsQHStje5G5iwYbag@mail.gmail.com> <20120216215603.GH9751@redhat.com> <m1y5s2ku36.fsf@fess.ebiederm.org> <m1fwe9bpk2.fsf@fess.ebiederm.org> <20120217195430.GO9751@redhat.com> <m1y5s07rn3.fsf@fess.ebiederm.org> <20120220151419.GU9751@redhat.com> <m1obss39a4.fsf@fess.ebiederm.org> <20120221135934.GF26998@redhat.com> <m1ipip6xe8.fsf@fess.ebiederm.org> <4F573E1C.2060909@oss.ntt.co.jp> <4F573E74.5040504@oss.ntt.co.jp> <m1eht31z8e.fsf@fess.ebiederm.org> <4F58495B.5080308@oss.ntt.co.jp> <m1r4x3yrsv.fsf@fess.ebiederm.org> <4F5A6D87.4050809@zytor.com> <4F5D8D0E.8060702@oss.ntt.co.jp> <4F5D8E63.60606@zytor.com> <4F5D943C.5020403@oss.ntt.co.jp> <4F5E431D.8010305@zytor.com> <m1zkblmvw7.fsf@fess.ebiederm.org> <4F5E56EB.1090807@zytor.com> <4F5E59AC.7090708@zytor.com>
In-Reply-To: <4F5E59AC.7090708@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2012 05:16 AM, H. Peter Anvin wrote:
> On 03/12/2012 01:04 PM, H. Peter Anvin wrote:
>> On 03/12/2012 01:01 PM, Eric W. Biederman wrote:
>>> The basic problem is which source do we block this at?  How many
>>> sources are their?  And architecturally last I looked x86 no longer
>>> has a NMI disable EFI and similar systems want to get away without
>>> a CMOS legacy clock because designers so often get them wrong.
>>>
>> On all processors which have an LAPIC you can block all NMI sources at
>> the LAPIC.  I think it's safe to assume that if you don't have an LAPIC
>> -- an ancient system by now -- you have port 70h.
>>
> One thing: *disabling* the LAPIC will allow external NMIs coming in on
> LINT1 through, since the LAPIC in the disabled state tries to mimic the
> no-LAPIC configuration.  So I don't think you want to disable LAPIC as
> much as disable the interrupt vectors within.

Does this sound like a plan to get the ball rolling?:

1.- Merge Don's patch to disable the LAPIC in kdump reboot path (this
   fixes a real issue seen in the field, is a net win and certainly not a
   regression - indeed it makes the code simpler because the I/O
   APICs are left untouched).

2.- Merge my patch set to ignore early NMIs (this brings the behavior
   of the boot code in line with what we do in the rest of the kernel
   a we can avoid situations were a spurious NMI causes the kernel
   to halt). The early NMI handler is temporary and the final NMI
   handler installed shortly afterwards will take care of subsequent
   NMIs.

3.- Make sure that spurious NMIs (i.e. NMIs that for whatever reason
   could not be stopped at the source) received during the reboot
   path to the kdump kernel do not cause a triple fault or a system
   lockup. This is under testing.

4.- Identify all the NMI sources and keep them from reaching the CPU
   when it can be done in a race-free way.

Can we get 1 and 2 merged while we work on further improvements
(3 and 4)?

Thanks,
Fernando
