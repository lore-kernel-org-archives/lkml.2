Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356Ab0DAQjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:39:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758336Ab0DAQj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:39:28 -0400
Date: Thu, 1 Apr 2010 18:36:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Patch] workqueue: move lockdep annotations up to
	destroy_workqueue()
Message-ID: <20100401163642.GA19551@redhat.com>
References: <20100331105534.5601.50813.sendpatchset@localhost.localdomain> <20100331112559.GA17747@redhat.com> <4BB408AF.4080908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB408AF.4080908@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01, Cong Wang wrote:
>
>> I must have missed something, but it seems to me this patch tries to
>> supress the valid warning.
>>
>> Could you please clarify?
>
> Sure, below is the whole warning. Please teach me how this is valid.

Oh, I can never understand the output from lockdep, it is much more
clever than me ;)

But at first glance,

> Mar 31 16:15:02 dhcp-66-70-5 kernel: -> #2 (rtnl_mutex){+.+.+.}:
> Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffff810a6bc1>] validate_chain+0x1019/0x1540
> Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffff810a7e75>] __lock_acquire+0xd8d/0xe55
> Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffff810aa3a4>] lock_acquire+0x160/0x1af
> Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffff815523f8>] mutex_lock_nested+0x64/0x4e9
> Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffff8147af16>] rtnl_lock+0x1e/0x27
> Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffffa0836779>] bond_mii_monitor+0x39f/0x74b [bonding]
> Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffff8108654f>] worker_thread+0x2da/0x46c
> Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffff8108b1ea>] kthread+0xdd/0xec
> Mar 31 16:15:02 dhcp-66-70-5 kernel:        [<ffffffff81004894>] kernel_thread_helper+0x4/0x10

OK, so work->func() takes rtnl_mutex.

This means it is not safe to do flush_workqueue() or destroy_workqueue()
under rtnl_lock(). This is known fact.

> Mar 31 16:15:03 dhcp-66-70-5 kernel: -> #0 ((bond_dev->name)){+.+...}:
> Mar 31 16:15:03 dhcp-66-70-5 kernel:        [<ffffffff810a6696>] validate_chain+0xaee/0x1540
> Mar 31 16:15:03 dhcp-66-70-5 kernel:        [<ffffffff810a7e75>] __lock_acquire+0xd8d/0xe55
> Mar 31 16:15:03 dhcp-66-70-5 kernel:        [<ffffffff810aa3a4>] lock_acquire+0x160/0x1af
> Mar 31 16:15:03 dhcp-66-70-5 kernel:        [<ffffffff81085278>] cleanup_workqueue_thread+0x59/0x10b
> Mar 31 16:15:03 dhcp-66-70-5 kernel:        [<ffffffff81085428>] destroy_workqueue+0x9c/0x107
> Mar 31 16:15:03 dhcp-66-70-5 kernel:        [<ffffffffa0839d32>] bond_uninit+0x524/0x58a [bonding]
> Mar 31 16:15:03 dhcp-66-70-5 kernel:        [<ffffffff8146967b>] rollback_registered_many+0x205/0x2e3
> Mar 31 16:15:03 dhcp-66-70-5 kernel:        [<ffffffff81469783>] unregister_netdevice_many+0x2a/0x75
> Mar 31 16:15:03 dhcp-66-70-5 kernel:        [<ffffffff8147ada3>] __rtnl_kill_links+0x8b/0x9d
> Mar 31 16:15:03 dhcp-66-70-5 kernel:        [<ffffffff8147adea>] __rtnl_link_unregister+0x35/0x72
> Mar 31 16:15:03 dhcp-66-70-5 kernel:        [<ffffffff8147b293>] rtnl_link_unregister+0x2c/0x43

However, rtnl_link_unregister() takes rtnl_mutex and then bond_uninit()
does cleanup_workqueue_thread().

So, looks like this warning is valid, this path can deadlock if
destroy_workqueue() is called when bond->mii_work is queued.


Lockdep decided to blaim cpu_add_remove_lock in this chain.

Oleg.

