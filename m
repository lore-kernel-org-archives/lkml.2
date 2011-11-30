Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab1K3UCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 15:02:38 -0500
Received: from hera.cwi.nl ([192.16.191.8]:63541 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801Ab1K3UCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 15:02:33 -0500
Message-ID: <4ED68BBF.8010608@cwi.nl>
Date: Wed, 30 Nov 2011 20:02:07 +0000
From: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Subject: Re: kmemleak: unreferenced object in copy_thread
References: <4ED3CE60.2060901@cwi.nl> <CAHkRjk69fwTy0+w4LyXeai5ekCirC1D5V7-Gkja6MbKqJ_-KFw@mail.gmail.com>
In-Reply-To: <CAHkRjk69fwTy0+w4LyXeai5ekCirC1D5V7-Gkja6MbKqJ_-KFw@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040208080807040503090501"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040208080807040503090501
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


On 11/30/2011 11:54 AM, Catalin Marinas wrote:
> I can't yet tell whether it's a false positive or not. Did the X
> server die? Is the process with pid 1415 still around? The leaked
> object looks like the thread stack (8K) and it should have been
> removed when the corresponding process was killed.
Hi Catalin,

Just got lucky and hit it again. This time it occurred without killing. 
Here's the splat:

unreferenced object 0xffff880003eda000 (size 8192):
   comm "Xorg", pid 1117, jiffies 4295143832 (age 34745.832s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 0f 00 00 00 0f 00 00 00  ................
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<ffffffff813feeb1>] kmemleak_alloc+0x21/0x50
     [<ffffffff8111086b>] kmem_cache_alloc_trace+0xdb/0x1d0
     [<ffffffff81001fbe>] copy_thread+0x1be/0x260
     [<ffffffff81044953>] copy_process+0xee3/0x1520
     [<ffffffff810450d6>] do_fork+0x116/0x350
     [<ffffffff8100a7d3>] sys_clone+0x23/0x30
     [<ffffffff8141c173>] stub_clone+0x13/0x20
     [<ffffffffffffffff>] 0xffffffffffffffff

The process 1117 is still alive. It is

root      1117  2.1  1.3 147484 28152 tty7     Ss+  09:55  13:02 
/usr/bin/X :0 vt7 -br -nolisten tcp -auth /var/run/xauth/A:0-Tdu4bb


Actually, there now are several splats of a second kind, relating to 
i915 gem buffers (attached). This type of splat has been reported before in
https://lkml.org/lkml/2011/10/4/15
although that thread seems to be a dead end. Maybe these warnings have a 
common source?

What would be a good next step?

With kind regards,

Wouter Koolen

--------------040208080807040503090501
Content-Type: text/plain;
 name="kmemleak"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="kmemleak"

unreferenced object 0xffff880078ce5290 (size 544):
  comm "Xorg", pid 1117, jiffies 4294897828 (age 36161.832s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff813feeb1>] kmemleak_alloc+0x21/0x50
    [<ffffffff8111043a>] kmem_cache_alloc+0xda/0x1f0
    [<ffffffff811ca238>] idr_pre_get+0x68/0x90
    [<ffffffff8127c97d>] drm_gem_handle_create+0x3d/0xf0
    [<ffffffff812b4976>] i915_gem_create+0x56/0x140
    [<ffffffff812b4a79>] i915_gem_create_ioctl+0x19/0x20
    [<ffffffff8127ad34>] drm_ioctl+0x404/0x4f0
    [<ffffffff8112e327>] do_vfs_ioctl+0x97/0x5f0
    [<ffffffff8112e8ca>] sys_ioctl+0x4a/0x80
    [<ffffffff8141bebb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880075179b70 (size 544):
  comm "Xorg", pid 1117, jiffies 4294897828 (age 36161.832s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 90 52 ce 78 00 88 ff ff  .........R.x....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff813feeb1>] kmemleak_alloc+0x21/0x50
    [<ffffffff8111043a>] kmem_cache_alloc+0xda/0x1f0
    [<ffffffff811ca238>] idr_pre_get+0x68/0x90
    [<ffffffff8127c97d>] drm_gem_handle_create+0x3d/0xf0
    [<ffffffff812b4976>] i915_gem_create+0x56/0x140
    [<ffffffff812b4a79>] i915_gem_create_ioctl+0x19/0x20
    [<ffffffff8127ad34>] drm_ioctl+0x404/0x4f0
    [<ffffffff8112e327>] do_vfs_ioctl+0x97/0x5f0
    [<ffffffff8112e8ca>] sys_ioctl+0x4a/0x80
    [<ffffffff8141bebb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880075179938 (size 544):
  comm "Xorg", pid 1117, jiffies 4294897828 (age 36161.832s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 70 9b 17 75 00 88 ff ff  ........p..u....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff813feeb1>] kmemleak_alloc+0x21/0x50
    [<ffffffff8111043a>] kmem_cache_alloc+0xda/0x1f0
    [<ffffffff811ca238>] idr_pre_get+0x68/0x90
    [<ffffffff8127c97d>] drm_gem_handle_create+0x3d/0xf0
    [<ffffffff812b4976>] i915_gem_create+0x56/0x140
    [<ffffffff812b4a79>] i915_gem_create_ioctl+0x19/0x20
    [<ffffffff8127ad34>] drm_ioctl+0x404/0x4f0
    [<ffffffff8112e327>] do_vfs_ioctl+0x97/0x5f0
    [<ffffffff8112e8ca>] sys_ioctl+0x4a/0x80
    [<ffffffff8141bebb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880075179700 (size 544):
  comm "Xorg", pid 1117, jiffies 4294897828 (age 36161.832s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 38 99 17 75 00 88 ff ff  ........8..u....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff813feeb1>] kmemleak_alloc+0x21/0x50
    [<ffffffff8111043a>] kmem_cache_alloc+0xda/0x1f0
    [<ffffffff811ca238>] idr_pre_get+0x68/0x90
    [<ffffffff8127c97d>] drm_gem_handle_create+0x3d/0xf0
    [<ffffffff812b4976>] i915_gem_create+0x56/0x140
    [<ffffffff812b4a79>] i915_gem_create_ioctl+0x19/0x20
    [<ffffffff8127ad34>] drm_ioctl+0x404/0x4f0
    [<ffffffff8112e327>] do_vfs_ioctl+0x97/0x5f0
    [<ffffffff8112e8ca>] sys_ioctl+0x4a/0x80
    [<ffffffff8141bebb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800751794c8 (size 544):
  comm "Xorg", pid 1117, jiffies 4294897828 (age 36161.836s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 97 17 75 00 88 ff ff  ...........u....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff813feeb1>] kmemleak_alloc+0x21/0x50
    [<ffffffff8111043a>] kmem_cache_alloc+0xda/0x1f0
    [<ffffffff811ca238>] idr_pre_get+0x68/0x90
    [<ffffffff8127c97d>] drm_gem_handle_create+0x3d/0xf0
    [<ffffffff812b4976>] i915_gem_create+0x56/0x140
    [<ffffffff812b4a79>] i915_gem_create_ioctl+0x19/0x20
    [<ffffffff8127ad34>] drm_ioctl+0x404/0x4f0
    [<ffffffff8112e327>] do_vfs_ioctl+0x97/0x5f0
    [<ffffffff8112e8ca>] sys_ioctl+0x4a/0x80
    [<ffffffff8141bebb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880075179290 (size 544):
  comm "Xorg", pid 1117, jiffies 4294897828 (age 36161.836s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c8 94 17 75 00 88 ff ff  ...........u....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff813feeb1>] kmemleak_alloc+0x21/0x50
    [<ffffffff8111043a>] kmem_cache_alloc+0xda/0x1f0
    [<ffffffff811ca238>] idr_pre_get+0x68/0x90
    [<ffffffff8127c97d>] drm_gem_handle_create+0x3d/0xf0
    [<ffffffff812b4976>] i915_gem_create+0x56/0x140
    [<ffffffff812b4a79>] i915_gem_create_ioctl+0x19/0x20
    [<ffffffff8127ad34>] drm_ioctl+0x404/0x4f0
    [<ffffffff8112e327>] do_vfs_ioctl+0x97/0x5f0
    [<ffffffff8112e8ca>] sys_ioctl+0x4a/0x80
    [<ffffffff8141bebb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880075179058 (size 544):
  comm "Xorg", pid 1117, jiffies 4294897828 (age 36161.836s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 90 92 17 75 00 88 ff ff  ...........u....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff813feeb1>] kmemleak_alloc+0x21/0x50
    [<ffffffff8111043a>] kmem_cache_alloc+0xda/0x1f0
    [<ffffffff811ca238>] idr_pre_get+0x68/0x90
    [<ffffffff8127c97d>] drm_gem_handle_create+0x3d/0xf0
    [<ffffffff812b4976>] i915_gem_create+0x56/0x140
    [<ffffffff812b4a79>] i915_gem_create_ioctl+0x19/0x20
    [<ffffffff8127ad34>] drm_ioctl+0x404/0x4f0
    [<ffffffff8112e327>] do_vfs_ioctl+0x97/0x5f0
    [<ffffffff8112e8ca>] sys_ioctl+0x4a/0x80
    [<ffffffff8141bebb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880079d2cda8 (size 544):
  comm "Xorg", pid 1117, jiffies 4294897828 (age 36161.836s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 58 90 17 75 00 88 ff ff  ........X..u....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff813feeb1>] kmemleak_alloc+0x21/0x50
    [<ffffffff8111043a>] kmem_cache_alloc+0xda/0x1f0
    [<ffffffff811ca238>] idr_pre_get+0x68/0x90
    [<ffffffff8127c97d>] drm_gem_handle_create+0x3d/0xf0
    [<ffffffff812b4976>] i915_gem_create+0x56/0x140
    [<ffffffff812b4a79>] i915_gem_create_ioctl+0x19/0x20
    [<ffffffff8127ad34>] drm_ioctl+0x404/0x4f0
    [<ffffffff8112e327>] do_vfs_ioctl+0x97/0x5f0
    [<ffffffff8112e8ca>] sys_ioctl+0x4a/0x80
    [<ffffffff8141bebb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880079d2cb70 (size 544):
  comm "Xorg", pid 1117, jiffies 4294897828 (age 36161.840s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 a8 cd d2 79 00 88 ff ff  ...........y....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff813feeb1>] kmemleak_alloc+0x21/0x50
    [<ffffffff8111043a>] kmem_cache_alloc+0xda/0x1f0
    [<ffffffff811ca238>] idr_pre_get+0x68/0x90
    [<ffffffff8127c97d>] drm_gem_handle_create+0x3d/0xf0
    [<ffffffff812b4976>] i915_gem_create+0x56/0x140
    [<ffffffff812b4a79>] i915_gem_create_ioctl+0x19/0x20
    [<ffffffff8127ad34>] drm_ioctl+0x404/0x4f0
    [<ffffffff8112e327>] do_vfs_ioctl+0x97/0x5f0
    [<ffffffff8112e8ca>] sys_ioctl+0x4a/0x80
    [<ffffffff8141bebb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880003eda000 (size 8192):
  comm "Xorg", pid 1117, jiffies 4295143832 (age 35177.892s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 0f 00 00 00 0f 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff813feeb1>] kmemleak_alloc+0x21/0x50
    [<ffffffff8111086b>] kmem_cache_alloc_trace+0xdb/0x1d0
    [<ffffffff81001fbe>] copy_thread+0x1be/0x260
    [<ffffffff81044953>] copy_process+0xee3/0x1520
    [<ffffffff810450d6>] do_fork+0x116/0x350
    [<ffffffff8100a7d3>] sys_clone+0x23/0x30
    [<ffffffff8141c173>] stub_clone+0x13/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88007d0bfb70 (size 544):
  comm "Xorg", pid 1117, jiffies 4295215414 (age 34891.572s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 70 cb d2 79 00 88 ff ff  ........p..y....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff813feeb1>] kmemleak_alloc+0x21/0x50
    [<ffffffff8111043a>] kmem_cache_alloc+0xda/0x1f0
    [<ffffffff811ca238>] idr_pre_get+0x68/0x90
    [<ffffffff8127c97d>] drm_gem_handle_create+0x3d/0xf0
    [<ffffffff812b4976>] i915_gem_create+0x56/0x140
    [<ffffffff812b4a79>] i915_gem_create_ioctl+0x19/0x20
    [<ffffffff8127ad34>] drm_ioctl+0x404/0x4f0
    [<ffffffff8112e327>] do_vfs_ioctl+0x97/0x5f0
    [<ffffffff8112e8ca>] sys_ioctl+0x4a/0x80
    [<ffffffff8141bebb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88000a771700 (size 544):
  comm "Xorg", pid 1117, jiffies 4298477934 (age 21841.552s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 70 fb 0b 7d 00 88 ff ff  ........p..}....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff813feeb1>] kmemleak_alloc+0x21/0x50
    [<ffffffff8111043a>] kmem_cache_alloc+0xda/0x1f0
    [<ffffffff811ca238>] idr_pre_get+0x68/0x90
    [<ffffffff8127c97d>] drm_gem_handle_create+0x3d/0xf0
    [<ffffffff812b4976>] i915_gem_create+0x56/0x140
    [<ffffffff812b4a79>] i915_gem_create_ioctl+0x19/0x20
    [<ffffffff8127ad34>] drm_ioctl+0x404/0x4f0
    [<ffffffff8112e327>] do_vfs_ioctl+0x97/0x5f0
    [<ffffffff8112e8ca>] sys_ioctl+0x4a/0x80
    [<ffffffff8141bebb>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff

--------------040208080807040503090501--
