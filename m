Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118Ab1DMTFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 15:05:05 -0400
Received: from mail.candelatech.com ([208.74.158.172]:41199 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757109Ab1DMTFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 15:05:02 -0400
Message-ID: <4DA5F3BA.3060404@candelatech.com>
Date: Wed, 13 Apr 2011 12:04:26 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: WARNING at libata-core.c:5015 in 2.6.39-rc3-wl+, then lockup.
References: <4DA5CF81.4070908@candelatech.com> <4DA5D5D8.8070301@candelatech.com>
In-Reply-To: <4DA5D5D8.8070301@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2011 09:56 AM, Ben Greear wrote:
> On 04/13/2011 09:29 AM, Ben Greear wrote:
>> This on an multi-core Atom based appliance. Using SSD for hard-drive.
>> Fedora 14 OS.
>>
>> 2.6.39-rc* has been very flaky for me on this system (haven't tried other
>> machines yet), and I'm pretty sure I saw similar bugs on earlier 39-rc
>> kernels though
>> they often crashed on other things as well...
>
> I found someone else reporting this bug against -rc1, and folks
> requested lspci -nn. It's included below. This is from a different
> boot, but appears to be the same bug. System didn't lock hard right away,
> but crashed shortly after I gathered this info.

And, same warning in latest linux-2.6 (no extra patches, from a few minutes ago).

System worked for a bit, then this splat:

[root@lec2010-ath9k-1 ~]# INFO: task readahead:259 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
readahead       D 00000002     0   259      1 0x00000000
  f4511cf8 00000046 21ede952 00000002 c0b17600 f466a940 c0b17600 c0b17600
  f466abb4 c0b17600 001a27c1 00000000 f457fb80 00000002 f466a940 f466a940
  f466a940 00000000 00000006 f4511ccc b25a0d89 f4511cd0 c045935d f45cff94
Call Trace:
  [<c045935d>] ? timekeeping_get_ns+0x16/0x52
  [<c045a58b>] ? ktime_get_ts+0x98/0xa2
  [<c07f2943>] io_schedule+0x72/0xab
  [<c0506949>] sleep_on_buffer+0xd/0x11
  [<c07f2e74>] __wait_on_bit_lock+0x39/0x75
  [<c050693c>] ? unmap_underlying_metadata+0x51/0x51
  [<c050693c>] ? unmap_underlying_metadata+0x51/0x51
  [<c07f2f50>] out_of_line_wait_on_bit_lock+0xa0/0xa8
  [<c0452114>] ? autoremove_wake_function+0x34/0x34
  [<c050720e>] __lock_buffer+0x24/0x27
  [<c054a8b3>] lock_buffer+0x33/0x36
  [<c054a9d6>] __ext4_get_inode_loc+0x120/0x34e
  [<c07f447a>] ? _raw_spin_unlock+0x22/0x25
  [<c04f864a>] ? iget_locked+0xdb/0x101
  [<c054bbd9>] ext4_iget+0x57/0x6a8
  [<c0552137>] ext4_lookup+0x66/0xb8
  [<c04ed4da>] d_alloc_and_lookup+0x3d/0x54
  [<c04eeadd>] walk_component+0x138/0x2b7
  [<c04ef1e8>] ? link_path_walk+0x8a/0x394
  [<c04eed59>] do_last+0xfd/0x502
  [<c04ef602>] path_openat+0x9b/0x28a
  [<c0463385>] ? lock_release_non_nested+0x86/0x1d8
  [<c04c1071>] ? might_fault+0x4c/0x86
  [<c04ef8bc>] do_filp_open+0x3d/0x62
  [<c07f447a>] ? _raw_spin_unlock+0x22/0x25
  [<c04f968d>] ? alloc_fd+0x137/0x144
  [<c04e3e29>] do_sys_open+0x59/0xd8
  [<c04e3ef4>] sys_open+0x23/0x2b
  [<c07fa3dc>] sysenter_do_call+0x12/0x38
1 lock held by readahead/259:
  #0:  (&sb->s_type->i_mutex_key#12){+.+.+.}, at: [<c04eeabc>] walk_component+0x117/0x2b7
INFO: task gnome-session:1522 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
gnome-session   D 00000000     0  1522   1342 0x00000000
  f206ddf0 00200046 00001bcf 00000000 c0b17600 f2054830 c0b17600 c0b17600
  f2054aa4 c0b17600 af6ef63b 0000000a 00000000 0000000a f2054830 f53935e8
  00000000 f206ddc0 c0461849 00200246 f2054830 f2054830 00000000 00000006
Call Trace:
  [<c0461849>] ? mark_lock+0x1e/0x1de
  [<c0461a50>] ? mark_held_locks+0x47/0x5f
  [<c07f3460>] ? __mutex_lock_common+0x1ca/0x2e8
  [<c0461cb6>] ? trace_hardirqs_on_caller+0x10e/0x12f
  [<c07f346e>] __mutex_lock_common+0x1d8/0x2e8
  [<c07f362b>] mutex_lock_nested+0x35/0x3d
  [<c04eeabc>] ? walk_component+0x117/0x2b7
  [<c04eeabc>] walk_component+0x117/0x2b7
  [<c04ef1e8>] ? link_path_walk+0x8a/0x394
  [<c04eed59>] do_last+0xfd/0x502
  [<c04ef602>] path_openat+0x9b/0x28a
  [<c0463385>] ? lock_release_non_nested+0x86/0x1d8
  [<c04c1071>] ? might_fault+0x4c/0x86
  [<c04ef8bc>] do_filp_open+0x3d/0x62
  [<c07f447a>] ? _raw_spin_unlock+0x22/0x25
  [<c04f968d>] ? alloc_fd+0x137/0x144
  [<c04e3e29>] do_sys_open+0x59/0xd8
  [<c04e3ef4>] sys_open+0x23/0x2b
  [<c07fa3dc>] sysenter_do_call+0x12/0x38
1 lock held by gnome-session/1522:
  #0:  (&sb->s_type->i_mutex_key#12){+.+.+.}, at: [<c04eeabc>] walk_component+0x117/0x2b7



Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

