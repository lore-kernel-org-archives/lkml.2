Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab2HaDTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 23:19:19 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47230 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab2HaDTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 23:19:17 -0400
MIME-Version: 1.0
Date: Fri, 31 Aug 2012 11:19:17 +0800
Message-ID: <CAPrgqrpOBY09a4t2b0y2N=a9fgcezbMwrvF=9ZhaWDmOVeWaJA@mail.gmail.com>
Subject: [BUG REPORT] Wrong deaklock warning!
From: "Stanley.Miao" <stanleymiao@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, All,

I used two spinlocks in my code, and I enabled the following CONFIGs
for debugging.

CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_DEBUG_LOCKDEP=y

void abc_init(struct abc_dev *dev)
{
   spin_lock_init(&dev->locka);
   spin_lock_init(&dev->lockb);
}

void set_last_active_blk(struct abc_dev *dev)
{
   spin_lock(&dev->locka);
   spin_lock(&dev->lockb);
   /* do something */
   spin_unlock(&dev->lockb);
   spin_unlock(&dev->locka);
}

The code above works fine. No Warning.

Becaused of some reasons, I tried to encapsulate the spin_lock API.

typedef spinlock_t shannon_spinlock_t;
void abc_spin_lock_init(shannon_spinlock_t *lock)
{
         spin_lock_init((spinlock_t *)lock);
}

void abc_spin_lock(abc_spinlock_t *lock)
 {
         spin_lock((spinlock_t *)lock);
 }

void abc_spin_unlock(abc_spinlock_t *lock)
{
        spin_unlock((spinlock_t *)lock);
}

Then my code become:

void abc_init(struct abc_dev *dev)
{
   abc_spin_lock_init(&dev->locka);
   abc_spin_lock_init(&dev->lockb);
}

set_last_active_blk(struct abc_dev *dev)
{
   shannon_spin_lock(&dev->locka);
   shannon_spin_lock(&dev->lockb);
   /* do something */
   shannon_spin_unlock(&dev->lockb);
   shannon_spin_unlock(&dev->locka);
}

Then I got the following Warning:

[  538.987581] =============================================
[  538.988776] [ INFO: possible recursive locking detected ]
[  538.989594] 3.1.4+ #1085
[  538.989984] ---------------------------------------------
[  538.990801] fio/732 is trying to acquire lock:
[  538.991368]  (&((spinlock_t *)lock)->rlock){+.+...}, at:
[<ffffffff814b6d29>] abc_spin_lock+0xe/0x10
[  538.992341]
[  538.992341] but task is already holding lock:
[  538.992341]  (&((spinlock_t *)lock)->rlock){+.+...}, at:
[<ffffffff814b6d29>] abc_spin_lock+0xe/0x10
[  538.992341]
[  538.992341] other info that might help us debug this:
[  538.992341]  Possible unsafe locking scenario:
[  538.992341]
[  538.992341]        CPU0
[  538.992341]        ----
[  538.992341]   lock(&((spinlock_t *)lock)->rlock);
[  538.992341]   lock(&((spinlock_t *)lock)->rlock);
[  538.992341]
[  538.992341]  *** DEADLOCK ***
[  538.992341]
[  538.992341]  May be due to missing lock nesting notation
[  538.992341]
[  538.992341] 2 locks held by fio/732:
[  538.992341]  #0:  ((struct mutex *)lock){+.+.+.}, at:
[<ffffffff814b6c10>] abc_mutex_trylock+0xe/0x10
[  538.992341]  #1:  (&((spinlock_t *)lock)->rlock){+.+...}, at:
[<ffffffff814b6d29>] abc_spin_lock+0xe/0x10
[  538.992341]
[  538.992341] stack backtrace:
[  538.992341] Pid: 732, comm: fio Not tainted 3.1.4+ #1085
[  538.992341] Call Trace:
[  538.992341]  [<ffffffff8109b5f9>] __lock_acquire+0xff8/0x1864
[  538.992341]  [<ffffffff8110f085>] ? mempool_alloc_slab+0x15/0x17
[  538.992341]  [<ffffffff814b6d29>] ? abc_spin_lock+0xe/0x10
[  538.992341]  [<ffffffff8109c54f>] lock_acquire+0x101/0x12e
[  538.992341]  [<ffffffff814b6d29>] ? abc_spin_lock+0xe/0x10
[  538.992341]  [<ffffffff81856d59>] _raw_spin_lock+0x52/0x87
[  538.992341]  [<ffffffff814b6d29>] ? abc_spin_lock+0xe/0x10
[  538.992341]  [<ffffffff814b6d29>] abc_spin_lock+0xe/0x10
[  538.992341]  [<ffffffff814a95f7>] set_last_active_blk+0x74/0x141
[  538.992341]  [<ffffffff814abdcf>] move_to_next_chunk+0xab/0xef

Obviously this is wrong. There are two different spinlocks and it
won't cause deadlock. There is no warning if I don't encapsulate the
spinlock API.


Stanley
