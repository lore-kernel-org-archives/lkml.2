Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746Ab1DYRig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 13:38:36 -0400
Received: from mail.candelatech.com ([208.74.158.172]:55990 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758696Ab1DYRif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 13:38:35 -0400
Message-ID: <4DB5B199.6090606@candelatech.com>
Date: Mon, 25 Apr 2011 10:38:33 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Debugging hung tasks?
References: <4DB20AA9.4080801@candelatech.com> <20110422205545.19196ada.rdunlap@xenotime.net>
In-Reply-To: <20110422205545.19196ada.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2011 08:55 PM, Randy Dunlap wrote:
> On Fri, 22 Apr 2011 16:09:29 -0700 Ben Greear wrote:
>
>> I am testing lots of NFS traffic against an over-loaded and slow file server.
>>
>> I enabled the hung-task detection logic, and it's hitting after 180
>> seconds.
>>
>> First:  Is there any valid reason to have funky NFS cause a hung task?
>>
>> Second: Why doesn't the hung-task panic logic print the stack trace of
>>      the hung task?
>>      Is this an option that can be enabled?
>
> hung_task.c::check_hung_task() always calls sched_show_task() and
> optionally does the panic:
>
> 	if (sysctl_hung_task_panic)
> 		panic("hung_task: blocked tasks");
>
> sched.c::sched_show_task() calls show_stack(), which should be doing what
> you are asking for AFAICT.  What kernel version are you using?

Here's one of the panics, for instance (captured on serial console).

There is a lockdep splat in 2.6.36.4 early on, (known bug, but
not fixed since that kernel is EOL), so that is probably why there
is no locking info printed.  But, I was expecting a more useful stack
trace since it appears to be our user-space application (btserver)
that is hung.

Apr 22 15:57:38 localhost kernel: nfs: server 192.168.100.19 not responding, still trying
Apr 22 15:57:38 localhost kernel: nfs: server 192.168.100.19 OK
Kernel panic - not syncing: hung_task: blocked tasks
Pid: 58, comm: khungtaskd Not tainted 2.6.36.4+ #1
Apr 22 15:59:08 Call Trace:
localhost kernel [<ffffffff8140174a>] panic+0x96/0x1ae
: INFO: task bts [<ffffffff81093106>] watchdog+0x1b1/0x1f9
erver:15212 bloc [<ffffffff81092f55>] ? watchdog+0x0/0x1f9
ked for more tha [<ffffffff8105c774>] kthread+0x7d/0x85
n 180 seconds.
  [<ffffffff8100a8e4>] kernel_thread_helper+0x4/0x10
Apr 22 15:59:08  [<ffffffff81404a54>] ? restore_args+0x0/0x30
localhost kernel [<ffffffff8105c6f7>] ? kthread+0x0/0x85
: "echo 0 > /pro [<ffffffff8100a8e0>] ? kernel_thread_helper+0x0/0x10
c/sys/kernel/hunpanic occurred, switching back to text console
Rebooting in 10 seconds..^C

We're testing 2.6.38.4 now..haven't seen this problem again,
so maybe it's fixed anyway...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

