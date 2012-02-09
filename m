Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004Ab2BIIdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 03:33:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41214 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab2BIIdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 03:33:36 -0500
Date: Thu, 9 Feb 2012 09:33:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org, jk@novozymes.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Memory issues with Opteron 6220
Message-ID: <20120209083315.GA19380@elte.hu>
References: <20120208143741.GB28486@otto.nzcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120208143741.GB28486@otto.nzcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Anders Ossowicki <aowi@novozymes.com> wrote:

> Hey,
> 
> We're seeing unexpected slowdowns and other memory issues with a new system.
> Enough to render it unusable. For example:
> 
> Error: open3: fork failed: Cannot allocate memory
> 
> at times where there's no real memory pressure:
>                    total       used       free     shared    buffers     cached
>       Mem:     132270720  131942388     328332          0     299768  103334420
>       -/+ buffers/cache:   28308200  103962520
>       Swap:      7811068      13760    7797308
>
> [...]

> The system is a Dell Poweredge R715, with two eight-core 
> Opteron 6220 processors and 128G of memory. We have several 
> similar systems, such as the one this should replace: R715, 
> 2x8 core Opteron 6140, 128G memory, and they do not exhibit 
> any similar symptoms.

130 MB of RAM visible to Linux isn't the expected bootup default 
indeed. Around 130 *GB* would be expected ...

> We have tried with 2.6.37, 2.6.38, 3.2.5 and 3.3-rc1 with no luck. The
> microcode updates from AMD have not helped either.

Nasty.

No smoking gun in the dmesg:

> dmesg is available at http://dev.exherbo.org/~arkanoid/atlas-dmesg-3.2.5.txt

[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000df679000 (usable)
[    0.000000]  BIOS-e820: 00000000df679000 - 00000000df68f000 (reserved)
[    0.000000]  BIOS-e820: 00000000df68f000 - 00000000df6ce000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000df6ce000 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fe000000 - 00000000fec90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec94000 - 00000000fecd0000 (reserved)
[    0.000000]  BIOS-e820: 00000000fecd4000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000201f000000 (usable)

that 0x201f000000 is slightly above 128 GB.

The lowlevel x86 RAM init code seems to be fine:

[    0.000000] last_pfn = 0x201f000 max_arch_pfn = 0x400000000

that 0x201f000 correctly points to slighly above 128 GB 
physical.

[    0.000000] init_memory_mapping: 0000000100000000-000000201f000000

that too shows that the lowlevel x86 platform memory init code 
still sees 128 GB.

it's spread out amongst 4 nodes, 32 GB each:

[    0.000000] Initmem setup node 0 0000000000000000-0000000820000000
[    0.000000]   NODE_DATA [000000081fffb000 - 000000081fffffff]
[    0.000000] Initmem setup node 1 0000000820000000-0000001020000000
[    0.000000]   NODE_DATA [000000101fffb000 - 000000101fffffff]
[    0.000000] Initmem setup node 2 0000001020000000-0000001820000000
[    0.000000]   NODE_DATA [000000181fffb000 - 000000181fffffff]
[    0.000000] Initmem setup node 3 0000001820000000-000000201f000000
[    0.000000]   NODE_DATA [000000201effa000 - 000000201effefff]

the NORMAL zone gets set up properly:

[    0.000000]   Normal   0x00100000 -> 0x0201f000

and each node zone got 32 GB of RAM:

[    0.000000]   Normal zone: 7354368 pages, LIFO batch:31
[    0.000000]   Normal zone: 8257536 pages, LIFO batch:31
[    0.000000]   Normal zone: 8257536 pages, LIFO batch:31
[    0.000000]   Normal zone: 8253504 pages, LIFO batch:31


and it's all visible in the end to the MM:

[    0.000000] Built 4 zonelists in Zone order, mobility grouping on.  Total pages: 33021506

that's still 125 GB. (cgroup_page appears to pick up 1GB of RAM 
btw.)

So where is the rest of RAM gone? How does /proc/meminfo look 
like?

Thanks,

	Ingo
