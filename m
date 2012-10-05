Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab2JEB1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 21:27:36 -0400
Received: from mail.lemote.com ([222.92.8.141]:35090 "EHLO lemote.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755671Ab2JEB1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 21:27:34 -0400
X-Greylist: delayed 543 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Oct 2012 21:27:34 EDT
Message-ID: <2316.117.81.123.89.1349397314.squirrel@mail.lemote.com>
Date: Fri, 5 Oct 2012 08:35:14 +0800 (CST)
Subject: Re: Seems like "sched: Add missing call to calc_load_exit_idle()" 
     should be reverted in 3.5 branch
From: =?gb2312?Q?=B3=C2=BB=AA=B2=C5?= <chenhc@lemote.com>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Charles Wang" <muming.wq@taobao.com>,
        "Ingo Molnar" <mingo@kernel.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.11
MIME-Version: 1.0
Content-Type: text/plain;charset=gb2312
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My opinion: The original patch "sched/nohz: Rewrite and fix load-avg
computation -- again" is designed for 3.5-branch and calc_load_exit_idle()
is called directly in tick_nohz_idle_exit(). So, the patch can be fully
applied in 3.5 and doesn't need to fix (Add the missing call), but not
fully applied in 3.6 (because code splitted) and need to fix.



> On Thu, Oct 04, 2012 at 08:31:59PM +0200, Peter Zijlstra wrote:
>> On Thu, 2012-10-04 at 10:46 -0700, Greg Kroah-Hartman wrote:
>> > On Thu, Oct 04, 2012 at 12:11:01PM +0800, Huacai Chen wrote:
>> > > Hi, Greg
>> > >
>> > > I found that Linux-3.5.5 accept this commit "sched: Add missing call
>> > > to calc_load_exit_idle()" but I think this isn't needed. Because
>> > > "5167e8d5417b sched/nohz: Rewrite and fix load-avg computation --
>> > > again not fully applied" is true for 3.6 branch, but not for 3.5
>> > > branch.
>> >
>> > But 5167e8d5417b is in 3.5, so shouldn't this commit still be
>> necessary?
>> >
>> > > In 3.5 branch, calc_load_exit_idle() is already called in
>> > > tick_nohz_idle_exit(), it doesn't need to be called at
>> > > tick_nohz_update_jiffies() again. In 3.6 branch, some code of
>> > > tick_nohz_idle_exit() is splitted to tick_nohz_restart_sched_tick()
>> > > and calc_load_exit_idle() is missing by accident, so commit "sched:
>> > > Add missing call to calc_load_exit_idle()" is needed.
>> >
>> > So this really should be dropped from 3.5?  Charles, Peter, Ingo, any
>> > thoughts here?
>>
>> Bah, lots of code movement there recently.. let me try and untangle all
>> that afresh.. /me checks out v3.5.5.
>>
>> OK, assuming ->tick_stopped means what the label says, then we only want
>> to call calc_load_enter_idle() when it flips to 1 and
>> calc_load_exit_idle() when it flips back to 0, such that when an actual
>> tick happens its got correct state.
>>
>> Now the actual patch "5167e8d5417b sched/nohz: Rewrite and fix load-avg
>> computation -- again not fully applied" modifies
>> tick_nohz_restart_sched_tick() which doesn't appear to exist in v3.5.5
>> and the patch fobbed it into tick_nohz_update_jiffies() which is called
>> from interrupt entry when nohz-idle so that the interrupt (and possible
>> tailing softirq) see a valid jiffies count.
>>
>> However, since we don't restart the tick, we won't be sampling load muck
>> and calling calc_load_exit_idle() from there is bound to confuse state.
>>
>> I hope.. damn this code ;-)
>>
>> I can't find wtf went wrong either, the initial patch 5167e8d5417bf5c
>> contains both hunks, but in that case the fixup 749c8814f0 doesn't make
>> sense, not can I find anything in merge commits using:
>>
>>   git log -S calc_load_exit_idle kernel/time/tick-sched.c
>>
>> /me puzzled
>
> I'm puzzled as well.  Any ideas if I should do anything here or not?
>
> greg k-h
>


-- 
江苏中科梦兰电子科技有限公司

软件部 陈华才

E-mail: chenhc@lemote.com

Web: http://www.lemote.com/

Add: 江苏省常熟市虞山镇梦兰工业园

