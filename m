Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab1AUWRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 17:17:15 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:36753 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219Ab1AUWRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 17:17:14 -0500
Message-ID: <4D3A05DC.4000208@free.fr>
Date: Fri, 21 Jan 2011 23:17:00 +0100
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.8.1.23) Gecko/20090823 SeaMonkey/1.1.18
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Lin Ming <ming.m.lin@intel.com>, Oliver Neukum <oneukum@suse.de>,
        rjw@sisk.pl, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Michal Marek <mmarek@suse.cz>, Yinghai Lu <yinghai@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Borislav Petkov <bp@alien8.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Siarhei Liakh <sliakh.lkml@gmail.com>,
        Xuxian Jiang <jiang@cs.ncsu.edu>, Dave Airlie <airlied@redhat.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] S3 resume on SandyBridge doesn't work with NX protection
 (5bd5a45)
References: <20110119173710.GA1331@suse.de> <20110119230602.6dd34fa3@mat-laptop> <20110120134734.GA7230@suse.de> <1295535954.4d384f524c8f0@imp.free.fr> <20110120155909.GA21782@suse.de> <4D38A697.3040308@free.fr> <4D38A836.5040003@zytor.com>
In-Reply-To: <4D38A836.5040003@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin a écrit :
> On 01/20/2011 01:18 PM, matthieu castet wrote:
>> PS :
>> x86 trampoline is a mess. There are many (wakeup, smpboot) and differ between 32 and 64 bit.
>> H. Peter Anvin, aren't you rewriting them ?
> 
> Yes, working on it, starting with the framework used to install them.
> 
> They can't all be unified; they are used for different purposes and have
> different requirements (for one thing, 32 vs 64 bits require different
> trampoline code), but the install framework patchset is almost done, and
> the recent change of keeping the 1:1 pagetable set around is also a
> dramatic cleanup.
Of course, but for example on x64, using smp trampoline to exit rm wakecode help
to merge code in one place.

Also the start of 32/64 bits trampoline (rm part) is really similar. The main difference is the verify_cpu
check, but can't it be called latter (when we switch to 64 bits ) ?

In the end we could have something like

wakeup_code:
(common rm 16 bit code)
call trampoline

trampoline:
(common rm 16 bit code)
call startup_32_vector (either startup_32_smp for 32 bits (exit trampoline) or startup_32 for 64 bit).

startup_32:
