Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700Ab2J3NX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 09:23:29 -0400
Received: from 5350504D.static.ziggozakelijk.nl ([83.80.80.77]:3859 "EHLO
	ns2.tasking.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137Ab2J3NX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 09:23:28 -0400
To: linux-kernel@vger.kernel.org
Date: Tue, 30 Oct 2012 14:23:25 +0100
From: Kees Bakker <spam@tasking.nl>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
Subject: Re: kernel BUG at fs/lockd/mon.c:150, was Re: [PATCH v2 3/3] lockd: create and ...
References: <20120918093612.2469.94393.stgit@localhost.localdomain> <20120918093612.2469.94393.stgit@localhost.localdomain> <20120918093723.2469.47300.stgit@localhost.localdomain> <20120918093723.2469.47300.stgit@localhost.localdomain> <508FD068.2000903@tasking.nl>
In-Reply-To: <508FD068.2000903@tasking.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
NNTP-Posting-Host: 172.17.1.96
Message-ID: <20d7.508fd4cd.ea5f1@altium.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-10-12 14:04, Kees Bakker wrote:
> On 18-09-12 11:37, Stanislav Kinsbursky wrote:
>> NSM RPC client can be required on NFSv3 umount, when child reaper is dying
>> (and destroying it's mount namespace). It means, that current nsproxy is set
>> to NULL already, but creation of RPC client requires UTS namespace for gaining
>> hostname string.
>>
>> This patch creates reference-counted per-net NSM client on first monitor
>> request and destroys it after last unmonitor request.
>>
>
> We're hitting the BUG_ON that was added in this patch. I've tried it with
> 3.6.3 and 3.6.4
>
> It happens almost immediate when I do apt-get update (the archive is on NFS).

And here is the oops message in case you need it.

------------[ cut here ]------------
kernel BUG at fs/lockd/mon.c:150!
ACPI: Invalid Power Resource to register!
invalid opcode: 0000 [#1] PREEMPT SMP
Modules linked in: vmthrottle
Pid: 18025, comm: apt-get Not tainted 3.6.4-x274+ #1 Dell Inc.                 OptiPlex 745                 /0RF703
EIP: 0060:[<c1232c63>] EFLAGS: 00010246 CPU: 1
EIP is at nsm_mon_unmon+0xa3/0xb0
EAX: e228dde8 EBX: 00000000 ECX: e228de2c EDX: 00000002
ESI: e446b989 EDI: e9073250 EBP: e228de18 ESP: e228dde0
  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 8005003b CR2: b762c000 CR3: 342da000 CR4: 00000770
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process apt-get (pid: 18025, ti=e228c000 task=da1e9e30 task.ti=e228c000)
Stack:
  da218500 e228ddfc e446b989 000186b5 00000003 00000010 e446b999 00000058
  c18470c2 e228dde8 e228de2c 00000000 e446b8f0 00000000 e228de40 c12330a5
  00000000 e51782e2 c1a88fb6 ff0a0004 ffffffff 00000001 e5178000 e9073250
Call Trace:
  [<c18470c2>] ? _raw_spin_unlock+0x12/0x30
  [<c12330a5>] nsm_monitor+0x65/0x120
  [<c122d1fc>] nlmclnt_lock+0x3c/0x260
  [<c122c778>] ? nlmclnt_setlockargs+0xd8/0x170
  [<c122d62c>] nlmclnt_proc+0x8c/0x130
  [<c11e1dfa>] nfs3_proc_lock+0x1a/0x20
  [<c11d0499>] do_setlk+0xc9/0xf0
  [<c11d0655>] nfs_lock+0xa5/0x1b0
  [<c113e123>] ? locks_alloc_lock+0x13/0x50
  [<c182e426>] ? __slab_free+0x26c/0x2d4
  [<c1100e5b>] ? do_sys_open+0x16b/0x1d0
  [<c11d05b0>] ? nfs_flock+0xf0/0xf0
  [<c113f120>] vfs_lock_file+0x20/0x50
  [<c113f210>] do_lock_file_wait+0x30/0xb0
  [<c12c923a>] ? __copy_from_user_ll+0x1a/0x30
  [<c113fe69>] fcntl_setlk64+0xd9/0x1c0
  [<c18470c2>] ? _raw_spin_unlock+0x12/0x30
  [<c1110516>] sys_fcntl64+0x76/0xb0
  [<c1847b9c>] sysenter_do_call+0x12/0x2c
Code: db 83 c4 30 89 d8 5b 5e 5d c3 8d b6 00 00 00 00 f6 05 00 84 cb c1 10 74 e8 89 44 24 04 c7 04 24 20 a2 a9 c1 e8 31 8c 5f 00 eb d6 <0f> 0b 8d 74 26 00 8d bc 27 00 00 00 00 55 89 e5 83 ec 0c 89 5d
EIP: [<c1232c63>] nsm_mon_unmon+0xa3/0xb0 SS:ESP 0068:e228dde0
---[ end trace 3316e005c1fbd275 ]---

-- 
Kees


