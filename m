Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750904Ab2KOWkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 17:40:36 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46731 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab2KOWke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 17:40:34 -0500
Date: Thu, 15 Nov 2012 14:40:30 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Constantine Shulyupin <const@MakeLinux.com>
Cc: linux-kernel@vger.kernel.org, celinux-dev@lists.celinuxforum.org,
        Ryan Mallon <rmallon@gmail.com>, Tim Bird <tim.bird@am.sony.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Selim TEMUR <selimtemur@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH v2] LDT - Linux Driver Template
Message-ID: <20121115224030.GA16377@kroah.com>
References: <1353007337-12791-1-git-send-email-const@MakeLinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353007337-12791-1-git-send-email-const@MakeLinux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 09:22:17PM +0200, Constantine Shulyupin wrote:
> From: Constantine Shulyupin <const@MakeLinux.com>
> 
> LDT is useful for Linux driver development beginners,
> hackers and as starting point for a new drivers.

Really?  I strongly doubt it.  The odds that a new driver needs to use a
misc device is quite low these days.  Normally you just start with a
driver for a device like the one you need to write and modify it from
there.  The days when people write char device drivers are pretty much
over now.

> The driver uses following Linux facilities: module, platform driver,
> file operations (read/write, mmap, ioctl, blocking and nonblocking mode, polling),
> kfifo, completion, interrupt, tasklet, work, kthread, timer, single misc device,
> Device Model, configfs, UART 0x3f8,
> HW loopback, SW loopback, ftracer.

That's a whole lot of different things all mushed together here.  If you
_really_ want to make something useful, you would do individual drivers
for each of these different things, not something all tied together in a
way that no one is ever going to use.

> --- /dev/null
> +++ b/samples/ldt/ldt.c
> @@ -0,0 +1,716 @@
> +/*
> + *	LDT - Linux Driver Template
> + *
> + *	Copyright (C) 2012 Constantine Shulyupin http://www.makelinux.net/
> + *
> + *	GPL License

GPLv1?  Cool, I haven't seen that for years and years.  Oh, and that's
not compatible with GPLv2, sorry.

In short, be explicit.

> + *	The driver demonstrates usage of following Linux facilities:
> + *
> + *	Linux kernel module
> + *	file_operations
> + *		read and write (UART)
> + *		blocking read and write
> + *		polling
> + *		mmap
> + *		ioctl
> + *	kfifo
> + *	completion
> + *	interrupt
> + *	tasklet
> + *	timer
> + *	work
> + *	kthread
> + *	simple single misc device file (miscdevice, misc_register)
> + *	multiple char device files (alloc_chrdev_region)

I thought you took this out.

> + *	debugfs
> + *	platform_driver and platform_device in another module
> + *	simple UART driver on port 0x3f8 with IRQ 4
> + *	Device Model

Really?  I thought this was gone too.  And it's not something that a
"normal" driver needs.

> + *	Power Management (dev_pm_ops)
> + *	Device Tree (of_device_id)

Again, that's a lot of non-related things all together in one piece,
making it hard to understand, and review, which does not lend itself to
being a good example for anything.

> +/*
> + *	ldt_received
> + *	Called from tasklet, which is fired from ISR or timer,
> + *	with data received from HW port
> + */
> +
> +static void ldt_received(char data)
> +{
> +	kfifo_in_spinlocked(&drvdata->in_fifo, &data,
> +			sizeof(data), &drvdata->fifo_lock);
> +	wake_up_interruptible(&drvdata->readable);
> +}

As others pointed out, if you are going to use function block comments,
use the correct kerneldoc style, don't invent your own, as I never want
to see this in any driver submitted for inclusion.

> +/*
> + *	work section
> + *
> + *	empty template function for deferred call in scheduler context
> + */
> +
> +static int ldt_work_counter;

Again, as others pointed out, you never want static data in a driver.

> +static void ldt_work_func(struct work_struct *work)
> +{
> +	ldt_work_counter++;
> +}

No locking?  Not good.

> +static int ldt_open(struct inode *inode, struct file *file)
> +{
> +	pr_debug("%s: from %s\n", __func__,current->comm);
> +	pr_debug("imajor=%d iminor=%d \n", imajor(inode), iminor(inode));
> +	pr_debug("f_flags & O_NONBLOCK=0x%X\n", file->f_flags & O_NONBLOCK);
> +	/* client related data can be allocated here and
> +	   stored in file->private_data */
> +	return 0;
> +}

What's with all of the pr_debug() calls?  Why?  Why pick only those
specific things out of the file structure?

Also, you didn't run this through checkpatch.pl, like was requested.

> +#define trace_ioctl(nr) pr_debug("ioctl=(%c%c %c #%i %i)\n", \
> +	(_IOC_READ & _IOC_DIR(nr)) ? 'r' : ' ', \
> +	(_IOC_WRITE & _IOC_DIR(nr)) ? 'w' : ' ', \
> +	_IOC_TYPE(nr), _IOC_NR(nr), _IOC_SIZE(nr))

That's just horrid :(

> +static DEFINE_MUTEX(ioctl_lock);

Why?

> +static long ldt_ioctl(struct file *f, unsigned int cmnd, unsigned long arg)

No, no new ioctls, don't even think about it, sorry.

> +static int ldt_cleanup(struct platform_device *pdev)
> +{
> +	struct ldt_data *drvdata = platform_get_drvdata(pdev);
> +	dev_dbg(&pdev->dev, "%s\n", __func__);

That's a tracing function, I thought you got rid of these?  Hint,
anything with __func__ in it should be removed.

> +	if (!IS_ERR_OR_NULL(debugfs))
> +		debugfs_remove(debugfs);

Why check this?

> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1779,10 +1779,10 @@ sub process {
>  		    $rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
>  		    !($line =~ /^\+\s*$logFunctions\s*\(\s*(?:(KERN_\S+\s*|[^"]*))?"[X\t]*"\s*(?:|,|\)\s*;)\s*$/ ||
>  		    $line =~ /^\+\s*"[^"]*"\s*(?:\s*|,|\)\s*;)\s*$/) &&
> -		    $length > 80)
> +		    $length > 90)

Heh, nice try, that's not going to happen.

>  		{
>  			WARN("LONG_LINE",
> -			     "line over 80 characters\n" . $herecurr);
> +			     "line ".$length." over 90 characters\n" . $herecurr);

What are you trying to do here?  Why are you touching this script at
all?

> --- /dev/null
> +++ b/tools/testing/ldt/ldt-test
> @@ -0,0 +1,142 @@
> +#!/bin/bash
> +
> +#
> +#	LDT - Linux Driver Template
> +#
> +#	Test script for driver samples/ldt/
> +#
> +#	Copyright (C) 2012 Constantine Shulyupin  http://www.makelinux.net/
> +#
> +#	Dual BSD/GPL License
> +#
> +
> +RED="\\033[0;31m"
> +NOCOLOR="\\033[0;39m"
> +GREEN="\\033[0;32m"
> +GRAY="\\033[0;37m"
> +
> +set -o errtrace
> +debugfs=`grep debugfs /proc/mounts | awk '{ print $2; }'`
> +tracing=$debugfs/tracing
> +
> +tracing()
> +{
> +	sudo sh -c "cd $tracing; $1" || true
> +}

sudo?  Why?


> +
> +tracing_start()
> +{
> +	tracing "echo :mod:ldt > set_ftrace_filter"
> +	tracing "echo function > current_tracer" # need for draw_functrace.py
> +	#tracing "echo function_graph > current_tracer"
> +	tracing "echo 1 > function_profile_enabled"
> +	# useful optional command:
> +	#tracing "echo XXX > set_ftrace_notrace"
> +	#sudo cat $tracing/current_tracer
> +	#sudo cat $tracing/set_ftrace_filter
> +	#sudo cat $tracing/function_profile_enabled
> +	# available_filter_functions
> +	# echo $$ > set_ftrace_pid
> +}

Is this really needed?

> +
> +tracing_stop()
> +{
> +	( echo Profiling data per CPU
> +	tracing "cat trace_stat/function*" )> trace_stat.log && echo trace_stat.log saved
> +	tracing "echo 0 > function_profile_enabled"
> +	sudo cp $tracing/trace ftrace.log && echo ftrace.log saved
> +	sudo dd iflag=nonblock if=$tracing/trace_pipe 2> /dev/null > trace_pipe.log || true && echo trace_pipe.log saved
> +	tracing "echo nop > current_tracer"
> +	#export PYTHONPATH=/usr/src/linux-headers-$(uname -r)/scripts/tracing/
> +	# draw_functrace.py needs function tracer
> +	python /usr/src/linux-headers-$(uname -r)/scripts/tracing/draw_functrace.py \
> +		< trace_pipe.log > functrace.log && echo functrace.log saved || true
> +}
> +
> +# sudo rmmod parport_pc parport  ppdev lp

Why commented out?

> +sudo dmesg -n 7
> +sudo rmmod ldt ldt_plat_dev 2> /dev/null
> +sudo dmesg -c > /dev/null
> +stty -F /dev/ttyS0 115200

Why did you just change my serial port line settings?

What is the goal of this script in the first place?

confused,

greg k-h
