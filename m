Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933584Ab0LUEbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 23:31:21 -0500
Received: from smtp-out.google.com ([74.125.121.67]:58710 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933461Ab0LUEbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 23:31:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=eccQc+pIRb4xeesFcSURLoE4tPjcJ+XNVvrH253bz+y67XltSuyd4jw8Zy5MlABtzd
         Zl3hrZl6/YB2O8MBgvOA==
MIME-Version: 1.0
In-Reply-To: <AANLkTimw_nvDEb4t1nOQFCtY8fx6fvg5Mmy+6vZw8mw1@mail.gmail.com>
References: <20101111100628.GA24728@localhost>
	<1289478978.2084.74.camel@laptop>
	<20101111124015.GA9706@localhost>
	<1289480656.2084.80.camel@laptop>
	<20101113084018.GA23098@localhost>
	<1289644224.2084.521.camel@laptop>
	<20101113120030.GA31517@localhost>
	<1289653078.2084.675.camel@laptop>
	<20101113131042.GA5522@localhost>
	<4CDEE314.6090107@kernel.org>
	<20101113235746.GA9458@localhost>
	<4CDF3DA1.2090806@kernel.org>
	<4D093ABB.4030206@zytor.com>
	<4D0943D5.1090404@kernel.org>
	<4D094703.7080701@zytor.com>
	<4D0AD464.2020408@kernel.org>
	<4D0AD486.9020704@kernel.org>
	<AANLkTin-LGig2RHHmvvy5H04jQRus_1mmS1Cr4KDWKsN@mail.gmail.com>
	<4D0BB9AD.90506@kernel.org>
	<AANLkTimw_nvDEb4t1nOQFCtY8fx6fvg5Mmy+6vZw8mw1@mail.gmail.com>
Date: Mon, 20 Dec 2010 20:31:16 -0800
Message-ID: <AANLkTi=VYooLbwWkTCSfQ38z=UO_kQZyQyKaw-5+kyYn@mail.gmail.com>
Subject: Re: [PATCH -v2 2/2] x86, acpi: Parse all SRAT cpu entries even have
 cpu num limitation
From: Venkatesh Pallipadi <venki@google.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nikanth Karthikesan <knikanth@suse.de>,
        David Rientjes <rientjes@google.com>,
        "Zheng, Shaohui" <shaohui.zheng@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, Nikhil Rao <ncrao@google.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 3:32 PM, Venkatesh Pallipadi <venki@google.com> wrote:
> On Fri, Dec 17, 2010 at 11:27 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On 12/17/2010 10:53 AM, Venkatesh Pallipadi wrote:
>>> linus git + these two patches still fails on my test system with the
>>> divide error. The failure dump is similar to what I reported here
>>> http://lkml.indiana.edu/hypermail//linux/kernel/1012.1/03641.html
>>>
>>> This patch description talk about new Intel systems. The test system I
>>> am seeing failure here is an ancient Intel (2 socket P4 HT) system.
>>> AFAICS, it does not even have an SRAT table (no "ACPI: SRAT" message
>>> in dmesg).
>>
>> that could be different cause.
>>
>> Do you have whole boot log with debug etc?
>>
>>
>
> This regression seems to be specific to fake numa configuration. Boots
> fine without "numa=fake=128M".
> Also, I see that the problem started between 2.6.36 and 2.6.37-rc1. I
> haven't done further bisect yet.
>

git bisect seems to narrow this down to the change below.

Thanks,
Venki

$ git bisect visualize
commit 50f2d7f682f9c0ed58191d0982fe77888d59d162
Author: Nikanth Karthikesan <knikanth@suse.de>
Date:   Thu Sep 30 17:34:10 2010 +0530

    x86, numa: Assign CPUs to nodes in round-robin manner on fake NUMA

    commit d9c2d5ac6af87b4491bff107113aaf16f6c2b2d9 "x86, numa: Use near(er)
    online node instead of roundrobin for NUMA" changed NUMA initialization on
    Intel to choose the nearest online node or first node.  Fake NUMA would be
    better of with round-robin initialization, instead of the all CPUS on
    first node.  Change the choice of first node, back to round-robin.

    For testing NUMA kernel behaviour without cpusets and NUMA aware
    applications, it would be better to have cpus in different nodes, rather
    than all in a single node.  With cpusets migration of tasks scenarios
    cannot not be tested.

    I guess having it round-robin shouldn't affect the use cases for all cpus
    on the first node.

    The code comments in arch/x86/mm/numa_64.c:759 indicate that this used to
    be the case, which was changed by commit d9c2d5ac6.  It changed from
    roundrobin to nearer or first node.  And I couldn't find any reason for
    this change in its changelog.

    Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
    Cc: David Rientjes <rientjes@google.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

$ git bisect log
# bad: [c8ddb2713c624f432fa5fe3c7ecffcdda46ea0d4] Linux 2.6.37-rc1
# good: [f6f94e2ab1b33f0082ac22d71f66385a60d8157f] Linux 2.6.36
git bisect start 'v2.6.37-rc1' 'v2.6.36'
# bad: [33081adf8b89d5a716d7e1c60171768d39795b39] Merge branch
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6
git bisect bad 33081adf8b89d5a716d7e1c60171768d39795b39
# bad: [02f36038c568111ad4fc433f6fa760ff5e38fab4] Merge branches
'softirq-for-linus', 'x86-debug-for-linus', 'x86-numa-for-linus',
'x86-quirks-for-linus', 'x86-setup-for-linus', 'x86-uv-for-linus' and
'x86-vm86-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect bad 02f36038c568111ad4fc433f6fa760ff5e38fab4
# good: [b5153163ed580e00c67bdfecb02b2e3843817b3e] Merge branch
'devel' of master.kernel.org:/home/rmk/linux-2.6-arm
git bisect good b5153163ed580e00c67bdfecb02b2e3843817b3e
# good: [91b745016c12d440386c40fb76ab69c8e08cbc06] Merge branch
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq
git bisect good 91b745016c12d440386c40fb76ab69c8e08cbc06
# good: [73ecf3a6e3f0206bf56a0fefe3b3eda042fb7034] Merge
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty-2.6
git bisect good 73ecf3a6e3f0206bf56a0fefe3b3eda042fb7034
# good: [b5b5c3ac5123dab047cfeff472053ab737052e9b] USB: xhci: Fix
compile error when CONFIG_PM=n
git bisect good b5b5c3ac5123dab047cfeff472053ab737052e9b
# good: [7f3883962870dd28b5f2322ac44a9d03640ef448] Merge branch
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin
git bisect good 7f3883962870dd28b5f2322ac44a9d03640ef448
# good: [b1f6a4f294088b3fcf9ae67915ca550a1ded2819] nilfs2: add
routines to redirect access to buffers of DAT file
git bisect good b1f6a4f294088b3fcf9ae67915ca550a1ded2819
# good: [6b81e14e645016597c81e71cd27ee5c57c3a3c36] nilfs2: eliminate
sparse warning - "context imbalance"
git bisect good 6b81e14e645016597c81e71cd27ee5c57c3a3c36
# good: [07bd8516a2f967aa67904c68ab97bb896a448b09] x86, asm: Restore
parentheses around one pushl_cfi argument
git bisect good 07bd8516a2f967aa67904c68ab97bb896a448b09
# good: [6c2754c28f2388a276fe21edde826f2113c8f60e] Revert "tty: Add a
new file /proc/tty/consoles"
git bisect good 6c2754c28f2388a276fe21edde826f2113c8f60e
# good: [892df7f81c31ce7f85778aa78094e8d1f19b8413] x86: HPET force
enable for CX700 / VIA Epia LT
git bisect good 892df7f81c31ce7f85778aa78094e8d1f19b8413
# good: [676cb02dc32adef13d9efb5ea52079e4ede1e3ec] softirqs: Make
wakeup_softirqd static
git bisect good 676cb02dc32adef13d9efb5ea52079e4ede1e3ec
# good: [6554287b1de0448f1e02e200d02b43914e997d15] x86, vm86: Fix
preemption bug for int1 debug and int3 breakpoint handlers.
git bisect good 6554287b1de0448f1e02e200d02b43914e997d15
# good: [b365a85c68161ea5db5476eb8845a91ceb1777ea] x86, UV: Use
allocated buffer in tlb_uv.c:tunables_read()
git bisect good b365a85c68161ea5db5476eb8845a91ceb1777ea
# good: [68f4d5a00adaab33b136fce2c72d5c377b39b0b0] x86, setup: Use
string copy operation to optimze copy in kernel compression
git bisect good 68f4d5a00adaab33b136fce2c72d5c377b39b0b0
# bad: [50f2d7f682f9c0ed58191d0982fe77888d59d162] x86, numa: Assign
CPUs to nodes in round-robin manner on fake NUMA
git bisect bad 50f2d7f682f9c0ed58191d0982fe77888d59d162
