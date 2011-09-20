Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab1ITQnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 12:43:32 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:1643
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751103Ab1ITQnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 12:43:31 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zzbb2dK9371K1432N98dKzz1202hzz8275bh8275dhz2fh668h839h93fh)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4E78C2CC.7080202@am.sony.com>
Date: Tue, 20 Sep 2011 09:43:56 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Dongdong Deng <libfetion@gmail.com>
CC: "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: kdb - can't set breakpoint by default on x86
References: <4E77DADF.6020608@am.sony.com>  <CAGn38=0kk1hxzMtZ9_P_kkyszE-4tXo28vNAYyYnQi=gRuJyBw@mail.gmail.com>
In-Reply-To: <CAGn38=0kk1hxzMtZ9_P_kkyszE-4tXo28vNAYyYnQi=gRuJyBw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2011 07:38 PM, Dongdong Deng wrote:
> On Tue, Sep 20, 2011 at 8:14 AM, Tim Bird <tim.bird@am.sony.com> wrote:
>> I recently tried using KDB on a 3.0.1 kernel, on an x86 target, using
>> a fairly-close-to-default kernel configuration.
>>
>> I found that I could not set a breakpoint.
>> It sets inside KDB, but then fails to apply the breakpoint when
>> resuming to user space:
>>
>>
>> --------------------------------
>> /proc # echo g >sysrq-trigger
>> [2689816.806249] SysRq : DEBUG
>>
>> Entering kdb (current=0xc7661d40, pid 511) on processor 0 due to Keyboard Entry
>>
>> [0]kdb> bp sys_sync
>> Instruction(i) BP #0 at 0xc111ce70 (sys_sync)
>>    is enabled  addr at 00000000c111ce70, hardtype=0 installed=0
>>
>> [0]kdb> g
>> _kdb_bp_install: failed to set breakpoint at 0xc111ce70
>> /proc # sync
>> /proc #
>> --------------------------------
>>
>> I discovered that this was due to the text segment being marked
>> read-only, by mark_rodata_ro() in arch/x86/mm/init_32.c
>>
>> This is controlled by CONFIG_DEBUG_RODATA.  With CONFIG_DEBUG_RODATA=y,
>> I get the following message on startup:
>>
>> Write protecting the kernel read-only data: 6245
>>
>> Also, breakpoints don't work.
>>
>> Turning this off solves the problem, but seems counter-intuitive.
>> CONFIG_DEBUG_RODATA depends on CONFIG_DEBUG_KERNEL.
>>
>> Should I:
>> 1) turn off CONFIG_DEBUG_RODATA automatically when CONFIG_KGDB_KDB is set?
>> or
>> 2) make CONFIG_DEBUG_RODATA depend on !KGDB_KDB?
>> or
>> 3) something else more subtle?
> 
> 
> The CONFIG_DEBUG_RODATA  is the nightmare for new user of kgdb/kdb,
> Most of kgdb/kdb user meet this problem when they first time using
> without reading manual.

Thanks very much for the response!

Ha ha. Oh the irony!  I just recently wrote up a detailed usage guide
for KDB (see http://elinux.org/KDB), and even included information about
CONFIG_DEBUG_RODATA that I copied from another document.

But I didn't remember this in my own x86 testing.  This variable isn't
used on ARM, where I've been doing most of my work.

It turns out I should read my own documentation!!  :-)

> but as the CONFIG_DEBUG_RODATA is an security feature, most of distro
> enable it.(ex: ubuntu)
> and the distro enable kgdb/kdb debugger too,
> 
> if the KGDB/KDB mutual exclusion with CONFIG_DEBUG_RODATA,  the distro
> just pick one...


I see - that's a problem.  It's probably better to avoid messing
with the CONFIG dependencies then.

> BTW:  the kprobe have the same problem, it didn't handle with
> CONFIG_DEBUG_RODATA too.

In any event, CONFIG_DEBUG_RODATA is badly named, as it now covers both
data and text (and it's not really related to DEBUG either).

But, having said that, maybe just an addition to the debug message
when failing to set the breakpoint would be useful?
Something like:

_kdb_bp_install: failed to set breakpoint at 0xc111ce70
Maybe kernel or data segment is read-only?
Please check that kernel is configured with CONFIG_DEBUG_RODATA=n

I can whip up a patch for this, but does anyone have any better
ideas?
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

