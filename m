Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab2KFNsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 08:48:30 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56152 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab2KFNs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 08:48:29 -0500
Date: Tue, 6 Nov 2012 14:48:31 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Alex Shi <alex.shi@intel.com>
Cc: rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        suresh.b.siddha@intel.com, arjan@linux.intel.com,
        vincent.guittot@linaro.org, tglx@linutronix.de, andre.przywara@amd.com,
        rjw@sisk.pl, paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, cl@linux.com,
        pjt@google.com
Subject: Re: [RFC PATCH 1/3] sched: add sched_policy and it's sysfs interface
Message-ID: <20121106134831.GA969@kroah.com>
References: <1352207399-29497-1-git-send-email-alex.shi@intel.com>
 <1352207399-29497-2-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352207399-29497-2-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 09:09:57PM +0800, Alex Shi wrote:
> This patch add the power aware scheduler knob into sysfs:
> 
> $cat /sys/devices/system/cpu/sched_policy/available_sched_policy
> performance powersaving
> 
> $cat /sys/devices/system/cpu/sched_policy/current_sched_policy
> powersaving
> 
> The using sched policy is 'powersaving'. User can change the policy
> by commend 'echo':
>  echo performance > /sys/devices/system/cpu/current_sched_policy
> 
> Power aware scheduling will has different behavior according to
> different policy:
> 
> performance: the current scheduling behaviour, try to spread tasks
> 		on more CPU sockets or cores.
> powersaving: will shrink tasks into sched group until the group's
> 		nr_running is up to group_weight.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  Documentation/ABI/testing/sysfs-devices-system-cpu | 21 +++++++
>  drivers/base/cpu.c                                 |  2 +
>  include/linux/cpu.h                                |  2 +
>  kernel/sched/fair.c                                | 68 +++++++++++++++++++++-
>  kernel/sched/sched.h                               |  5 ++
>  5 files changed, 97 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
> index 6943133..1909d3e 100644
> --- a/Documentation/ABI/testing/sysfs-devices-system-cpu
> +++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
> @@ -53,6 +53,27 @@ Description:	Dynamic addition and removal of CPU's.  This is not hotplug
>  		the system.  Information writtento the file to remove CPU's
>  		is architecture specific.
>  
> +What:		/sys/devices/system/cpu/sched_policy/current_sched_policy
> +		/sys/devices/system/cpu/sched_policy/available_sched_policy
> +Date:		Oct 2012
> +Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
> +Description:	CFS scheduler policy showing and setting interface.
> +
> +		available_sched_policy shows there are 2 kinds of policy now:
> +		performance and powersaving.
> +		current_sched_policy shows current scheduler policy. And user
> +		can change the policy by writing it.
> +
> +		Policy decides that CFS scheduler how to distribute tasks onto
> +		which CPU unit when tasks number less than LCPU number in system
> +
> +		performance: try to spread tasks onto more CPU sockets,
> +		more CPU cores.
> +
> +		powersaving:     try to shrink tasks onto same core or same CPU
> +		until running task number beyond the LCPU number in the core
> +		or socket.
> +
>  What:		/sys/devices/system/cpu/cpu#/node
>  Date:		October 2009
>  Contact:	Linux memory management mailing list <linux-mm@kvack.org>
> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> index 6345294..5f6a573 100644
> --- a/drivers/base/cpu.c
> +++ b/drivers/base/cpu.c
> @@ -330,4 +330,6 @@ void __init cpu_dev_init(void)
>  		panic("Failed to register CPU subsystem");
>  
>  	cpu_dev_register_generic();
> +
> +	create_sysfs_sched_policy_group(cpu_subsys.dev_root);

Are you sure you didn't just race with userspace, creating the sysfs
files after the device was created and announced to userspace?

If so, you need to fix this :)

thanks,

greg k-h
