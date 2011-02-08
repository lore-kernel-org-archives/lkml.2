Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab1BHTYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 14:24:15 -0500
Received: from claw.goop.org ([74.207.240.146]:60973 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab1BHTYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 14:24:14 -0500
Message-ID: <4D51985B.7080003@goop.org>
Date: Tue, 08 Feb 2011 11:24:11 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@Oracle.Com>
CC: Yinghai Lu <yinghai@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>, Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH] x86/mm/init: respect memblock reserved regions when destroying
 mappings
References: <4D4E4E0D.2080806@zytor.com> <4D4EF553.6000000@kernel.org> <alpine.DEB.2.00.1102071524140.7277@kaball-desktop> <4D50343E.1020906@kernel.org> <alpine.DEB.2.00.1102071839060.7277@kaball-desktop> <4D504161.2060900@kernel.org> <4D506A85.9030802@goop.org> <4D50B4B5.4050505@kernel.org> <4D50CCFA.1040004@goop.org> <AANLkTi=koyyz8h1A3qWbp2F+N3kA46rJfHPSPN+Ms8hm@mail.gmail.com> <20110208145551.GA4606@dumpdata.com>
In-Reply-To: <20110208145551.GA4606@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2011 06:55 AM, Konrad Rzeszutek Wilk wrote:
>>>> could be used to skip clear highmap for xen path?
>>> Seems pretty ad-hoc.
>>>
>> then what is size for mfn-list after _end...
> 8 bytes * nr_pages. For 4GB, 2048 pages. For 32GB, 8192 pages. For 128GB,
> 32768 pages, and so on.
>> could be copied or move to BRK.
> The _brk size is determined during build-time. We don't know what the
> memory size will be during bootup time and would have to select the
> highest values (128MB) which is quite a large amount to be reserved
> in _brk area.

If the brk is guaranteed to be the last thing in the kernel, we could
remove the static allocation of brk space, and just make it dynamic, and
then use the dynamic end-of-brk instead of _end.

That would require mapping the brk space at runtime, which would require
a (conservative) runtime estimate of how much space we would end up
needing, I guess by adding together the static allocations and then
adding any dynamic ones we need.

For Xen, specifically, we could just extend brk to include all the stuff
the domain builder sticks after the kernel, so it would both be brk
allocated and left in-situ.

But I'm not sure if this would work in the native case - would there be
a guarantee that there's enough space after the kernel to fit any brk usage?

    J

