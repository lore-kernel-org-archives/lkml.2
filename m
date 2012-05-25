Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab2EYLMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 07:12:51 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:60539 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351Ab2EYLMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 07:12:49 -0400
X-AuditID: b753bd60-9f483ba000000655-b1-4fbf692e15c4
X-AuditID: b753bd60-9f483ba000000655-b1-4fbf692e15c4
Message-ID: <4FBF6918.9010702@hitachi.com>
Date: Fri, 25 May 2012 20:12:24 +0900
From: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@mit.edu>, Ingo Molnar <mingo@elte.hu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Kevin Hilman <khilman@ti.com>,
        Prarit Bhargava <prarit@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tejun Heo <tj@kernel.org>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 0/4 V2] introduce: livedump
References: <20120525091207.10256.18614.stgit@t3500.sdl.hitachi.co.jp> <1337937942.9783.170.camel@laptop>
In-Reply-To: <1337937942.9783.170.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter

Thank you for quick reply.

Yes, I know that PF in NMI handling is dangerous, and so livedump doesn't
protect such pages that can be updated during NMI handling.
Such pages are listed in [3/4] as "sensitive pages".

Currently, I regard the following pages as sensitive pages in [3/4].
- Kernel/Exception/Interrupt stacks
- Page table structure
- All task_struct
- ".data" section of kernel
- All per_cpu areas

However, I can't assure these pages are enough to avoid PF in NMI handling.
Do you have any idea to enumerate sensitive pages correctly?

Thank you.


On 2012/05/25 18:25, Peter Zijlstra wrote:
> On Fri, 2012-05-25 at 18:12 +0900, YOSHIDA Masanori wrote:
>> Live Dump is based on Copy-on-write technique. Basically processing is
>> performed in the following order.
>> (1) Suspends processing of all CPUs.
>> (2) Makes pages (which you want to dump) read-only.
>> (3) Resumes all CPUs
>> (4) On page fault, dumps a page including a fault address.
>
> Suppose a PF is in progress when all this happens, you mark all RO, then
> an NMI happens, from the NMI context we'll generate another PF to update
> a vmap area, this will again PF because you mucked about and marked
> things RO.
>
> You're now at 3 PFs, which is instant reboot.
>
> I don't think this is going to work.
>

