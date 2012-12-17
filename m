Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab2LQTgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 14:36:16 -0500
Received: from relay1.sgi.com ([192.48.179.29]:48805 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664Ab2LQTgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 14:36:14 -0500
Date: Mon, 17 Dec 2012 13:36:12 -0600
From: Russ Anderson <rja@sgi.com>
To: "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>
Cc: Sivaram Nair <sivaramn@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "shuox.liu@intel.com" <shuox.liu@intel.com>,
        "yanmin_zhang@intel.com" <yanmin_zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russ Anderson <rja@sgi.com>
Subject: [regression] cpuidle_get_cpu_driver livelocks idle system
Message-ID: <20121217193612.GA28600@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 3.7 kernel grinds to a halt on boot of a system with
2048 cpus.  NMI showed most of the cpus in
_raw_spin_lock in cpuidle_get_cpu_driver().  (backtrace below)

A quick look at cpuidle_get_cpu_driver() shows the hot lock.

In drivers/cpuidle/driver.c:
--------------------------------------------------------
/**
 * cpuidle_get_cpu_driver - return the driver tied with a cpu
 */
struct cpuidle_driver *cpuidle_get_cpu_driver(struct cpuidle_device *dev)
{
        struct cpuidle_driver *drv;

        if (!dev)
                return NULL;

        spin_lock(&cpuidle_driver_lock);
        drv = __cpuidle_get_cpu_driver(dev->cpu);
        spin_unlock(&cpuidle_driver_lock);

        return drv;
}
--------------------------------------------------------


This change was added in on Nov 14th, 2012.
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=bf4d1b5ddb78f86078ac6ae0415802d5f0c68f92

The patch says it adds support for cpus with different characteristics,
but adds a big global lock.  The comment claims "no impact for the other
platforms if the option is disabled", which leads me to believe the
spin_lock was added inadvertently.  CPU_IDLE_MULTIPLE_DRIVERS is off
in my config file.

linux$ grep CPU_IDLE_MULTIPLE_DRIVERS .config
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set

As more cpus become idle, more cpus fight over the lock until
the system livelocks on the crushing weight of idle.

The fix may be to move the spin_lock into __cpuidle_get_cpu_driver,
which has different versions for CONFIG_CPU_IDLE_MULTIPLE_DRIVERS,
to avoid impacting the disabled case, or get rid of the spin_lock
all together.


--------------------------------------------------------
== UV NMI process trace cpu 12: ==
CPU 12
Pid: 0, comm: swapper/12 Tainted: G           O 3.7.0.rja-sgi+ #38
RIP: 0010:[<ffffffff81614e45>]  [<ffffffff81614e45>] _raw_spin_lock+0x25/0x30
[...]
Call Trace:
 [<ffffffff814c891c>] cpuidle_get_cpu_driver+0x1c/0x30
 [<ffffffff814c871d>] cpuidle_idle_call+0x7d/0x1b0
 [<ffffffff8101d08d>] cpu_idle+0xdd/0x130
 [<ffffffff8160a3ea>] start_secondary+0xc6/0xcc
--------------------------------------------------------

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
