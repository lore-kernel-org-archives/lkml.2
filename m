Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab2HUB6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 21:58:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:41405 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017Ab2HUB6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 21:58:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,799,1336374000"; 
   d="scan'208";a="207023299"
Date: Tue, 21 Aug 2012 09:58:41 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-fsdevel@vger.kernel.org
Subject: Re: BUG: NULL pointer dereference in shmem_evict_inode()
Message-ID: <20120821015841.GA12492@localhost>
References: <20120821010403.GA12018@localhost>
 <5032E021.2030400@linaro.org>
 <20120821013123.GA12104@localhost>
 <5032E85D.8020404@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5032E85D.8020404@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 06:46:05PM -0700, John Stultz wrote:
> On 08/20/2012 06:31 PM, Fengguang Wu wrote:
> >On Mon, Aug 20, 2012 at 06:10:57PM -0700, John Stultz wrote:
> >>On 08/20/2012 06:04 PM, Fengguang Wu wrote:
> >>>Hi John,
> >>>
> >>>The below oops happens in v3.5..v3.6-rc2 and it's bisected down to commit
> >>>2a8c0883c ("time: Move xtime_nsec adjustment underflow handling timekeeping_adjust").
> >>>
> >>>However linux-next is working fine. Do you have any fixes not yet sent to Linus?
> >>Yea, there's a fix pending in tip/timers/urgent
> >>(4e8b14526ca7fb046a81c94002c1c43b6fdf0e9b) to catch crazy values
> >>from settimeofday or the cmos clock that might overflow a ktime_t.
> >That's great!
> >
> >>Out of curiosity, how are you triggering/reproducing this?
> >I boot test lots of randconfig kernels in kvm, and this oops shows up
> >several times in one ranconfig and some of the test boxes. I find it
> >pretty hard to reproduce, but managed to bisect it down by counting
> >1000 good boots as bisect success and running dozens of KVM instances
> >in parallel in several test boxes to speed up the progress. Here is one step:
> 
> Oof.  That's an really impressive setup!

Thank you :)
 
> That said, if this happens only at boot up, and you don't have
> systems with crazy cmos values, I'm not sure I see how commit
> 4e8b14526ca7fb046a81c94002c1c43b6fdf0e9b might fix this.  So that's
> not very reassuring.

Sorry if my words mislead you, but the bug happens after booting the
user space. Look at the following dmesg mixed with userspace logs.
I noticed this when doing the bisects: the [    5.310905] suddenly
jumped to [ 2204.090146] in very short wall time.

        [    5.303661] device: 'input2': device_add
        [    5.304677] PM: Adding info for No Bus:input2
        [    5.305666] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
        [    5.307546] device: 'mouse0': device_add
        [    5.308452] PM: Adding info for No Bus:mouse0
        [    5.309505] driver: 'serio1': driver_bound: bound to device 'psmouse'
        [    5.310905] bus: 'serio': really_probe: bound device serio1 to driver psmouse
        modprobe: FATAL: Could not load /lib/modules/3.6.0-rc1/modules.dep: No such file or directory

        modprobe: FATAL: Could not load /lib/modules/3.6.0-rc1/modules.dep: No such file or directory

        modprobe: FATAL: Could not load /lib/modules/3.6.0-rc1/modules.dep: No such file or directory

        modprobe: FATAL: Could not load /lib/modules/3.6.0-rc1/modules.dep: No such file or directory

        [ 2204.090146] plymouthd (52) used greatest stack depth: 6324 bytes left
        modprobe: FATAL: Could not load /lib/modules/3.6.0-rc1/modules.dep: No such file or directory

        modprobe: FATAL: Could not load /lib/modules/3.6.0-rc1/modules.dep: No such file or directory

         * Asking all remaining processes to terminate...

        modprobe: FATAL: Could not load /lib/modules/3.6.0-rc1/modules.dep: No such file or directory

        modprobe: FATAL: Could not load /lib/modules/3.6.0-rc1/modules.dep: No such file or directory

        modprobe: FATAL: Could not load /lib/modules/3.6.0-rc1/modules.dep: No such file or directory

        modprobe: FATAL: Could not load /lib/modules/3.6.0-rc1/modules.dep: No such file or directory

        modprobe: FATAL: Could not load /lib/modules/3.6.0-rc1/modules.dep: No such file or directory

         * Killing all remaining processes...

        mount: unknown filesystem type 'devpts'
        mountall: mount /dev/pts [1267] terminated with status 32
        mountall: Filesystem could not be mounted: /dev/pts
        mountall: Skipping mounting /dev/pts since Plymouth is not available

        udevd[1346]: error creating signalfd

        udevd[1360]: error creating signalfd

         * Deactivating swap...
        [ 2220.929173] ip (1388) used greatest stack depth: 6132 bytes left
        udevd[1381]: error creating signalfd

        udevd[1397]: error creating signalfd

        [ 2221.089504] VFS: Busy inodes after unmount of tmpfs. Self-destruct in 5 seconds.  Have a nice day...
        [ 2221.091656] BUG: unable to handle kernel NULL pointer dereference at 0000000c                       
        [ 2221.093256] IP: [<810d2a2c>] shmem_free_inode+0x10/0x45
        [ 2221.093927] *pde = 00000000

> As a tangent, I think this sort of big-data style testing is a
> really great contribution, so thank you for setting up and doing all
> this work.

I'm glad you love it. Thanks!

Fengguang
