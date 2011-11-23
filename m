Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab1KWMNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 07:13:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36360 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab1KWMNN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 07:13:13 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.SOC.1.00.1111231311490.15939@math.ut.ee>
References: <alpine.SOC.1.00.1111231311490.15939@math.ut.ee>
Date: Wed, 23 Nov 2011 20:13:12 +0800
Message-ID: <CAM_iQpVWgY-EusMP9+J2ZGmO0E-LYkE=n95szt8PpnQXephndA@mail.gmail.com>
Subject: Re: 3.2.0-rc2+git: possible recursive locking detected in process
 memory freeing
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 7:12 PM, Meelis Roos <mroos@linux.ee> wrote:
> This is 3.2.0-rc2-00143-ga767835 kernel on Sun Fire V100 (64-bit sparc).
> It gives the locking warning on bootup but seems to work fine otherwise
> (apt-get dist-upgrade saw no problems). It did not happen on a very
> similar Netra X1 but the kernel conf might have been different there
> (have not verified).
[...]
> [   90.626091] =============================================
> [   90.697052] [ INFO: possible recursive locking detected ]
> [   90.768027] 3.2.0-rc2-00143-ga767835 #8
> [   90.818411] ---------------------------------------------
> [   90.889387] 000resolvconf/921 is trying to acquire lock:
> [   90.959210]  (&(&parent->list_lock)->rlock){..-...}, at: [<000000000070a8ec>] cache_flusharray+0x14/0xc8
> [   91.083911]
> [   91.083917] but task is already holding lock:
> [   91.160578]  (&(&parent->list_lock)->rlock){..-...}, at: [<000000000070a8ec>] cache_flusharray+0x14/0xc8
> [   91.285283]
> [   91.285289] other info that might help us debug this:
> [   91.371092]  Possible unsafe locking scenario:
> [   91.371102]
> [   91.448908]        CPU0
> [   91.480915]        ----
> [   91.512918]   lock(&(&parent->list_lock)->rlock);
> [   91.574632]   lock(&(&parent->list_lock)->rlock);
> [   91.636353]
> [   91.636359]  *** DEADLOCK ***
> [   91.636367]
> [   91.714182]  May be due to missing lock nesting notation
> [   91.714193]
> [   91.803440] 1 lock held by 000resolvconf/921:
> [   91.860594]  #0:  (&(&parent->list_lock)->rlock){..-...}, at: [<000000000070a8ec>] cache_flusharray+0x14/0xc8
> [   91.990909]
> [   91.990916] stack backtrace:
> [   92.048140] Call Trace:
> [   92.080167]  [0000000000487c0c] __lock_acquire+0xfec/0x1d00
> [   92.153419]  [0000000000488e2c] lock_acquire+0x4c/0x80
> [   92.220959]  [000000000070f51c] _raw_spin_lock+0x1c/0x40
> [   92.290780]  [000000000070a8ec] cache_flusharray+0x14/0xc8
> [   92.362897]  [00000000004ccaa8] kmem_cache_free+0x88/0xa0
> [   92.433859]  [00000000004ccb04] slab_destroy+0x44/0x80
> [   92.501397]  [00000000004ccc8c] free_block+0x14c/0x180
> [   92.568937]  [000000000070a958] cache_flusharray+0x80/0xc8
> [   92.641048]  [00000000004ccaa8] kmem_cache_free+0x88/0xa0
> [   92.712021]  [00000000004b80d0] free_pgd_range+0x1f0/0x320
> [   92.784126]  [00000000004b828c] free_pgtables+0x8c/0xc0
> [   92.852813]  [00000000004bf2cc] exit_mmap+0xac/0x140
> [   92.918065]  [000000000045464c] mmput+0x2c/0x100
> [   92.978745]  [0000000000458958] exit_mm+0xf8/0x160
> [   93.041710]  [000000000045a790] do_exit+0xf0/0x7c0
> [   93.104679]  [000000000045b088] do_group_exit+0x28/0xc0

Seems we have a recursive call chain...

__cache_free()
-> cache_flusharray()
  -> free_block()
    -> slab_destroy()
      -> kmem_cache_free()
        -> __cache_free()

Cc Pekka.
