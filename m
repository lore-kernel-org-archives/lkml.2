Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab1IUKYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 06:24:17 -0400
Received: from mail-ew0-f52.google.com ([209.85.215.52]:44644 "EHLO
	mail-ew0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab1IUKYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 06:24:16 -0400
MIME-Version: 1.0
In-Reply-To: <4E78C2CC.7080202@am.sony.com>
References: <4E77DADF.6020608@am.sony.com>
	<CAGn38=0kk1hxzMtZ9_P_kkyszE-4tXo28vNAYyYnQi=gRuJyBw@mail.gmail.com>
	<4E78C2CC.7080202@am.sony.com>
Date: Wed, 21 Sep 2011 18:24:13 +0800
Message-ID: <CAGn38=2oW4yisf6pbmrcbuBti1t9XBjD5u8i-5BRwnp8dU1Ysw@mail.gmail.com>
Subject: Re: kdb - can't set breakpoint by default on x86
From: Dongdong Deng <libfetion@gmail.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 12:43 AM, Tim Bird <tim.bird@am.sony.com> wrote:
> On 09/19/2011 07:38 PM, Dongdong Deng wrote:
>> On Tue, Sep 20, 2011 at 8:14 AM, Tim Bird <tim.bird@am.sony.com> wrote:
>>> I recently tried using KDB on a 3.0.1 kernel, on an x86 target, using
>>> a fairly-close-to-default kernel configuration.
>>>
>>> I found that I could not set a breakpoint.
>>> It sets inside KDB, but then fails to apply the breakpoint when
>>> resuming to user space:
>>>
>>>
>>> --------------------------------
>>> /proc # echo g >sysrq-trigger
>>> [2689816.806249] SysRq : DEBUG
>>>
>>> Entering kdb (current=0xc7661d40, pid 511) on processor 0 due to Keyboard Entry
>>>
>>> [0]kdb> bp sys_sync
>>> Instruction(i) BP #0 at 0xc111ce70 (sys_sync)
>>>    is enabled  addr at 00000000c111ce70, hardtype=0 installed=0
>>>
>>> [0]kdb> g
>>> _kdb_bp_install: failed to set breakpoint at 0xc111ce70
>>> /proc # sync
>>> /proc #
>>> --------------------------------
>>>
>>> I discovered that this was due to the text segment being marked
>>> read-only, by mark_rodata_ro() in arch/x86/mm/init_32.c
>>>
>>> This is controlled by CONFIG_DEBUG_RODATA.  With CONFIG_DEBUG_RODATA=y,
>>> I get the following message on startup:
>>>
>>> Write protecting the kernel read-only data: 6245
>>>
>>> Also, breakpoints don't work.
>>>
>>> Turning this off solves the problem, but seems counter-intuitive.
>>> CONFIG_DEBUG_RODATA depends on CONFIG_DEBUG_KERNEL.
>>>
>>> Should I:
>>> 1) turn off CONFIG_DEBUG_RODATA automatically when CONFIG_KGDB_KDB is set?
>>> or
>>> 2) make CONFIG_DEBUG_RODATA depend on !KGDB_KDB?
>>> or
>>> 3) something else more subtle?
>>
>>
>> The CONFIG_DEBUG_RODATA  is the nightmare for new user of kgdb/kdb,
>> Most of kgdb/kdb user meet this problem when they first time using
>> without reading manual.
>
> Thanks very much for the response!
>
> Ha ha. Oh the irony!  I just recently wrote up a detailed usage guide
> for KDB (see http://elinux.org/KDB), and even included information about
> CONFIG_DEBUG_RODATA that I copied from another document.

Ahah, Your kdb guide is very useful, thank for you create it to us. :-)

>
> But I didn't remember this in my own x86 testing.  This variable isn't
> used on ARM, where I've been doing most of my work.
>
> It turns out I should read my own documentation!!  :-)
>
>> but as the CONFIG_DEBUG_RODATA is an security feature, most of distro
>> enable it.(ex: ubuntu)
>> and the distro enable kgdb/kdb debugger too,
>>
>> if the KGDB/KDB mutual exclusion with CONFIG_DEBUG_RODATA,  the distro
>> just pick one...
>
>
> I see - that's a problem.  It's probably better to avoid messing
> with the CONFIG dependencies then.
>
>> BTW:  the kprobe have the same problem, it didn't handle with
>> CONFIG_DEBUG_RODATA too.
>
> In any event, CONFIG_DEBUG_RODATA is badly named, as it now covers both
> data and text (and it's not really related to DEBUG either).
>
> But, having said that, maybe just an addition to the debug message
> when failing to set the breakpoint would be useful?
> Something like:
>
> _kdb_bp_install: failed to set breakpoint at 0xc111ce70
> Maybe kernel or data segment is read-only?
> Please check that kernel is configured with CONFIG_DEBUG_RODATA=n
>
> I can whip up a patch for this, but does anyone have any better
> ideas?

I agree with you , it is a good solution to avoid the conflict of
CONFIG_DEBUG_RODATA and CONFIG_KGDB

and could help user to detect the problem.

For the realizing,
Maybe we add a debugger MACRO to control this debug message is good.

ex:
KGDB/KDB set_breakpoint_function()
{

set_bp_fail:

#ifdef CONFIG_DEBUG_RODATA
error message for warning CONFIG_DEBUG_RODATA options.
#endif

}

I CC to Jason for getting his's suggestion about above method. :-)


-- Dongdong
