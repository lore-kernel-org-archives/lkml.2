Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab1H2Uy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 16:54:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684Ab1H2Uy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 16:54:28 -0400
Date: Mon, 29 Aug 2011 16:54:24 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, tytso@mit.edu,
        adilger.kernel@dilger.ca
Subject: Re: ext4 lockdep trace (3.1.0rc3)
Message-ID: <20110829205424.GA18208@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, tytso@mit.edu,
	adilger.kernel@dilger.ca
References: <20110826214930.GA21818@redhat.com>
 <20110829204830.GA18543@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110829204830.GA18543@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 04:48:30PM -0400, Dave Jones wrote:
 > On Fri, Aug 26, 2011 at 05:49:30PM -0400, Dave Jones wrote:
 >  > just hit this while building a kernel.  Laptop wedged for a few seconds
 >  > during the final link, and this was in the log when it unwedged.
 >  
 > I still see this in rc4, and can reproduce it reliably every time I build.
 > It only started happening in the last week.  I don't see any ext4 or vfs commits
 > within a few days of that, so I'm not sure why it only just begun
 > (I do daily builds, and the 26th was the first time I saw it appear)
 > 
 > Given the lack of obvious commits in that timeframe, I'm not sure a bisect is
 > going to be particularly fruitful. It might just be that my IO patterns changed ?

also a second variant with a different trace.

	Dave


 =======================================================
 [ INFO: possible circular locking dependency detected ]
 3.1.0-rc3+ #151
 -------------------------------------------------------
 gnome-settings-/2037 is trying to acquire lock:
  (&sb->s_type->i_mutex_key#14){+.+.+.}, at: [<ffffffff811cee83>] ext4_evict_inode+0x76/0x33c
 
 but task is already holding lock:
  (&mm->mmap_sem){++++++}, at: [<ffffffff8111ba13>] sys_munmap+0x3b/0x60
 
 which lock already depends on the new lock.
 
 
 the existing dependency chain (in reverse order) is:
 
 -> #1 (&mm->mmap_sem){++++++}:
        [<ffffffff81091251>] lock_acquire+0xf3/0x13e
        [<ffffffff8111499a>] might_fault+0x80/0xa3
        [<ffffffff811570ef>] filldir+0x6f/0xc7
        [<ffffffff811c5c3f>] call_filldir+0x96/0xc0
        [<ffffffff811c5f78>] ext4_readdir+0x1bd/0x548
        [<ffffffff81157344>] vfs_readdir+0x7b/0xb4
        [<ffffffff81157463>] sys_getdents+0x7e/0xd1
        [<ffffffff814f2342>] system_call_fastpath+0x16/0x1b
 
 -> #0 (&sb->s_type->i_mutex_key#14){+.+.+.}:
        [<ffffffff81090a71>] __lock_acquire+0xa2f/0xd0c
        [<ffffffff81091251>] lock_acquire+0xf3/0x13e
        [<ffffffff814ea40d>] __mutex_lock_common+0x65/0x44a
        [<ffffffff814ea8ed>] mutex_lock_nested+0x3b/0x40
        [<ffffffff811cee83>] ext4_evict_inode+0x76/0x33c
        [<ffffffff8115d2a5>] evict+0x98/0x152
        [<ffffffff8115d4f0>] iput+0x191/0x199
        [<ffffffff8115a0f2>] dentry_kill+0x123/0x145
        [<ffffffff8115a4fc>] dput+0xf2/0x102
        [<ffffffff8114948a>] fput+0x1d8/0x1f0
        [<ffffffff8111a6bd>] remove_vma+0x51/0x82
        [<ffffffff8111b8a0>] do_munmap+0x2f2/0x30b
        [<ffffffff8111ba21>] sys_munmap+0x49/0x60
        [<ffffffff814f2342>] system_call_fastpath+0x16/0x1b
 
 other info that might help us debug this:
 
  Possible unsafe locking scenario:
 
        CPU0                    CPU1
        ----                    ----
   lock(&mm->mmap_sem);
                                lock(&sb->s_type->i_mutex_key);
                                lock(&mm->mmap_sem);
   lock(&sb->s_type->i_mutex_key);
 
  *** DEADLOCK ***
 
 1 lock held by gnome-settings-/2037:
  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff8111ba13>] sys_munmap+0x3b/0x60
 
 stack backtrace:
 Pid: 2037, comm: gnome-settings- Not tainted 3.1.0-rc3+ #151
 Call Trace:
  [<ffffffff810811d1>] ? up+0x39/0x3e
  [<ffffffff814e1469>] print_circular_bug+0x1f8/0x209
  [<ffffffff81090a71>] __lock_acquire+0xa2f/0xd0c
  [<ffffffff810821ef>] ? local_clock+0x35/0x4c
  [<ffffffff8108fe4f>] ? mark_lock+0x2d/0x220
  [<ffffffff811cee83>] ? ext4_evict_inode+0x76/0x33c
  [<ffffffff81091251>] lock_acquire+0xf3/0x13e
  [<ffffffff811cee83>] ? ext4_evict_inode+0x76/0x33c
  [<ffffffff814ea3e5>] ? __mutex_lock_common+0x3d/0x44a
  [<ffffffff814ea8ed>] ? mutex_lock_nested+0x3b/0x40
  [<ffffffff811cee83>] ? ext4_evict_inode+0x76/0x33c
  [<ffffffff814ea40d>] __mutex_lock_common+0x65/0x44a
  [<ffffffff811cee83>] ? ext4_evict_inode+0x76/0x33c
  [<ffffffff810821ef>] ? local_clock+0x35/0x4c
  [<ffffffff8115d297>] ? evict+0x8a/0x152
  [<ffffffff8108d9ba>] ? put_lock_stats+0xe/0x29
  [<ffffffff8108e03e>] ? lock_release_holdtime.part.10+0x59/0x62
  [<ffffffff8115d297>] ? evict+0x8a/0x152
  [<ffffffff814ea8ed>] mutex_lock_nested+0x3b/0x40
  [<ffffffff811cee83>] ext4_evict_inode+0x76/0x33c
  [<ffffffff8115d2a5>] evict+0x98/0x152
  [<ffffffff8115d4f0>] iput+0x191/0x199
  [<ffffffff8115a0f2>] dentry_kill+0x123/0x145
  [<ffffffff8115a4fc>] dput+0xf2/0x102
  [<ffffffff8114948a>] fput+0x1d8/0x1f0
  [<ffffffff8111a6bd>] remove_vma+0x51/0x82
  [<ffffffff8111b8a0>] do_munmap+0x2f2/0x30b
  [<ffffffff8111ba21>] sys_munmap+0x49/0x60
  [<ffffffff814f2342>] system_call_fastpath+0x16/0x1b

