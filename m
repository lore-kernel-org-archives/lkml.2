Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab2BBRqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:46:46 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:44433 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab2BBRqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:46:44 -0500
Date: Thu, 2 Feb 2012 12:43:30 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, bp@amd64.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        lenb@kernel.org, xen-devel@lists.xensource.com
Subject: Re: WARN... Device 'cpu1' does not have a release() function, it is
 broken and must be fixed. when doing 'xl vcpu-set <guest_id> 1'
Message-ID: <20120202174330.GA9311@phenom.dumpdata.com>
References: <20120123180601.GA24553@phenom.dumpdata.com>
 <20120201222250.GA3854@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120201222250.GA3854@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090207.4F2ACBE6.0093,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 02:22:50PM -0800, Greg KH wrote:
> On Mon, Jan 23, 2012 at 01:06:01PM -0500, Konrad Rzeszutek Wilk wrote:
> > When I bring a CPU down in a guest (which should be the same as bringing a
> > CPU down using the ACPI framework), I get this:
> > 
> > [   14.484206] SMP alternatives: switching to UP code
> > [   14.514287] ------------[ cut here ]------------
> > [   14.514318] WARNING: at /home/konrad/linux-linus/drivers/base/core.c:194 device_release+0x82/0x90()
> > [   14.514354] Device 'cpu1' does not have a release() function, it is broken and must be fixed.
> > [   14.514386] Modules linked in: radeon fbcon tileblit font ttm bitblit softcursor drm_kms_helper xen_blkfront xen_netfront xen_fbfront fb_sys_fops sysimgblt sysfillrect syscopyarea xen_kbdfront xenfs xen_privcmd
> > [   14.514557] Pid: 22, comm: xenwatch Not tainted 3.3.0-rc1 #1
> > [   14.514586] Call Trace:
> > [   14.515094]  [<ffffffff810897fa>] warn_slowpath_common+0x7a/0xb0
> > [   14.515094]  [<ffffffff810898d1>] warn_slowpath_fmt+0x41/0x50
> > [   14.515094]  [<ffffffff813dea02>] device_release+0x82/0x90
> > [   14.515094]  [<ffffffff812dfb85>] kobject_release+0x45/0x90
> > [   14.515094]  [<ffffffff812dfa4c>] kobject_put+0x2c/0x60
> > [   14.515094]  [<ffffffff813de6a2>] put_device+0x12/0x20
> > [   14.515094]  [<ffffffff813df409>] device_unregister+0x19/0x20
> > [   14.515094]  [<ffffffff813e4edf>] unregister_cpu+0x4f/0x80
> > [   14.515094]  [<ffffffff81052c7c>] arch_unregister_cpu+0x1c/0x20
> > [   14.515094]  [<ffffffff8137f787>] handle_vcpu_hotplug_event+0xc7/0xd0
> > [   14.515094]  [<ffffffff8137b900>] xenwatch_thread+0xb0/0x180
> > [   14.515094]  [<ffffffff810ad3f0>] ? wake_up_bit+0x40/0x40
> > [   14.515094]  [<ffffffff8137b850>] ? split+0xf0/0xf0
> > [   14.515094]  [<ffffffff810acd16>] kthread+0x96/0xa0
> > [   14.515094]  [<ffffffff816151e4>] kernel_thread_helper+0x4/0x10
> > [   14.515094]  [<ffffffff8160cc80>] ? retint_restore_args+0x5/0x6
> > [   14.515094]  [<ffffffff816151e0>] ? gs_change+0x13/0x13
> > [   14.515094] ---[ end trace 8f70af51a2e2611f ]---
> > 
> > Looking at "commit e032d80774315869aa2285b217fdbbfed86c0b49
> > Author: Greg Kroah-Hartman <gregkh@suse.de>
> > Date:   Mon Jan 16 14:40:28 2012 -0800
> > 
> >     mce: fix warning messages about static struct mce_device
> > "
> > 
> > it looks like the corret fix is to make the 'cpu_devices' in
> > arch/x86/kernel/topology.c to be changed to be more dynamic
> > (or perhaps have an empty release function)?
> > 
> > Is anybody else hitting this with ACPI CPU hot-unplug? Or do I have
> > the privilige of being the first? Oh, I hadn't done a full bisection
> > but v3.2 does not have this.
> 
> Does the patch below solve the problem for you?

Hey Greg,

Indeed it does.

For the patch below, please put 'Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>'

Thanks!
> 
> thanks,
> 
> greg k-h
> 
> 
> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> index db87e78..23f2c4c 100644
> --- a/drivers/base/cpu.c
> +++ b/drivers/base/cpu.c
> @@ -208,6 +208,25 @@ static ssize_t print_cpus_offline(struct device *dev,
>  }
>  static DEVICE_ATTR(offline, 0444, print_cpus_offline, NULL);
>  
> +static void cpu_device_release(struct device *dev)
> +{
> +	/*
> +	 * This is an empty function to prevent the driver core from spitting a
> +	 * warning at us.  Yes, I know this is directly opposite of what the
> +	 * documentation for the driver core and kobjects say, and the author
> +	 * of this code has already been publically ridiculed for doing
> +	 * something as foolish as this.  However, at this point in time, it is
> +	 * the only way to handle the issue of statically allocated cpu
> +	 * devices.  The different architectures will have their cpu device
> +	 * code reworked to properly handle this in the near future, so this
> +	 * function will then be changed to correctly free up the memory held
> +	 * by the cpu device.
> +	 *
> +	 * Never copy this way of doing things, or you too will be made fun of
> +	 * on the linux-kerenl list, you have been warned.
> +	 */
> +}
> +
>  /*
>   * register_cpu - Setup a sysfs device for a CPU.
>   * @cpu - cpu->hotpluggable field set to 1 will generate a control file in
> @@ -223,6 +242,7 @@ int __cpuinit register_cpu(struct cpu *cpu, int num)
>  	cpu->node_id = cpu_to_node(num);
>  	cpu->dev.id = num;
>  	cpu->dev.bus = &cpu_subsys;
> +	cpu->dev.release = cpu_device_release;
>  	error = device_register(&cpu->dev);
>  	if (!error && cpu->hotpluggable)
>  		register_cpu_control(cpu);
