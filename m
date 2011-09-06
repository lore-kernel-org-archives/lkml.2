Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab1IFFIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 01:08:43 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32885 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab1IFFIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 01:08:39 -0400
Date: Tue, 6 Sep 2011 14:08:31 +0900
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        oleg@redhat.com, arnd@arndb.de,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [BUG] CPU hotplug, freezer: Freezing of tasks failed after 20.00
 seconds
Message-ID: <20110906050831.GA16976@htj.dyndns.org>
References: <1313763382-12341-1-git-send-email-tj@kernel.org>
 <201108192300.55405.rjw@sisk.pl>
 <4E648DDA.8080605@linux.vnet.ibm.com>
 <20110905141512.GE9807@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110905141512.GE9807@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On Mon, Sep 05, 2011 at 11:15:12PM +0900, Tejun Heo wrote:
> >  Freezing of tasks failed after 20.01 seconds (2 tasks refusing to freeze, wq_busy=0):
> >  invert_cpu_stat D 0000000000000000  5304 20435  17329 0x00000084
> >   ffff8801f367bab8 0000000000000046 ffff8801f367bfd8 00000000001d3a00
> >   ffff8801f367a010 00000000001d3a00 00000000001d3a00 00000000001d3a00
> >   ffff8801f367bfd8 00000000001d3a00 ffff880414cc6840 ffff8801f36783c0
> >  Call Trace:
> >   [<ffffffff81532de5>] schedule_timeout+0x235/0x320
> >   [<ffffffff81532a0b>] wait_for_common+0x11b/0x170
> >   [<ffffffff81532b3d>] wait_for_completion+0x1d/0x20
> >   [<ffffffff81364486>] _request_firmware+0x156/0x2c0
> >   [<ffffffff81364686>] request_firmware+0x16/0x20
> >   [<ffffffffa01f0da0>] request_microcode_fw+0x70/0xf0 [microcode]
> >   [<ffffffffa01f0390>] microcode_init_cpu+0xc0/0x100 [microcode]
> >   [<ffffffffa01f14b4>] mc_cpu_callback+0x7c/0x11f [microcode]
> >   [<ffffffff815393a4>] notifier_call_chain+0x94/0xd0
> >   [<ffffffff8109770e>] __raw_notifier_call_chain+0xe/0x10
> >   [<ffffffff8106d000>] __cpu_notify+0x20/0x40
> >   [<ffffffff8152cf5b>] _cpu_up+0xc7/0x10e
> >   [<ffffffff8152d07b>] cpu_up+0xd9/0xec
> >   [<ffffffff8151e599>] store_online+0x99/0xd0
> >   [<ffffffff81355eb0>] sysdev_store+0x20/0x30
> >   [<ffffffff811f3096>] sysfs_write_file+0xe6/0x170
> >   [<ffffffff8117ee50>] vfs_write+0xd0/0x1a0
> >   [<ffffffff8117f024>] sys_write+0x54/0xa0
> >   [<ffffffff8153df02>] system_call_fastpath+0x16/0x1b
> 
> So, this task is trying to bring a CPU up, which triggers firmware
> helper to load microcode.  Firmware class currently sleeps
> non-interruptibly to wait for firmware load to complete, which is
> performed by another userland task.  Now, the PM freezer doesn't
> assume that there will be non-freezable wait dependencies among
> userland tasks.  It only knows two levels - userland and kernel tasks
> - and assumes that the former group may have non-freezable wait
> dependency on the latter but there's no such dependency among each
> group itself.  If there's such dependency, PM freezer may fail, which
> is what happened here.
> 
> ie. the firmware loader userland process got frozen first.
> invert_cpu_stat trying to bring up CPU was waiting for the firmware
> loader to finish in non-interruptible sleep, so the freezer couldn't
> proceed.

Hmmm... I went through the code again and usermodehelper_disable()
seems to be there to prevent deadlocks like this.  usermode helpers
are drained & plugged before freezing is tried.  Rafael, the above
shouldn't be happening, right?

Thanks.

-- 
tejun
