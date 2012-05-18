Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967837Ab2ERVXB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 17:23:01 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:53406 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967547Ab2ERVW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 17:22:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sameer Nanda <snanda@chromium.org>
Subject: Re: [PATCH] power, trace: add tracing for device_resume
Date: Fri, 18 May 2012 23:27:53 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: rob@landley.net, len.brown@intel.com, pavel@ucw.cz,
        gregkh@linuxfoundation.org, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, jkosina@suse.cz, standby24x7@gmail.com,
        jj@chaosbits.net, paulmck@linux.vnet.ibm.com, josh@joshtriplett.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
References: <1337365643-29261-1-git-send-email-snanda@chromium.org>
In-Reply-To: <1337365643-29261-1-git-send-email-snanda@chromium.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201205182327.53409.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 18, 2012, Sameer Nanda wrote:
> Added event tracing for device_resume. This helps quickly pinpoint which
> devices take a long time to resume.

There is some code already for that in the PM core.  You have to boot the
kernel with initcall_debug in the command line to activate it.

Thanks,
Rafael


> Signed-off-by: Sameer Nanda <snanda@chromium.org>
> ---
>  Documentation/trace/events-power.txt |   20 +++++++++++
>  drivers/base/power/main.c            |   10 ++++++
>  include/trace/events/power.h         |   59 ++++++++++++++++++++++++++++++++++
>  3 files changed, 89 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/trace/events-power.txt b/Documentation/trace/events-power.txt
> index cf794af..dbfb7f0 100644
> --- a/Documentation/trace/events-power.txt
> +++ b/Documentation/trace/events-power.txt
> @@ -88,3 +88,23 @@ power_domain_target	"%s state=%lu cpu_id=%lu"
>  The first parameter gives the power domain name (e.g. "mpu_pwrdm").
>  The second parameter is the power domain target state.
>  
> +4. Device resume events
> +=======================
> +The device resume events are used for measuring the time taken to resume
> +devices.
> +
> +device_resume_in	"device=%s driver=%s"
> +device_resume_waited	"device=%s driver=%s time_delta=%lld"
> +device_resume_out	"device=%s driver=%s time_delta=%lld"
> +
> +The first parameter is the device that is being resumed.
> +
> +The second parameter is the driver associated with the device being resumed.
> +
> +The third parameter in device_resume_waited is the time delta from the entry
> +point of device_resume to the wait completion of parent device being resumed.
> +The unit for time_delta is us.
> +
> +The third parameter in device_resume_out is the time delta from the wait
> +completion of parent device being resumed to device_resume being completed.
> +The unit for time_delta is us.
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index b462c0e..3ed01cd 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -28,6 +28,7 @@
>  #include <linux/sched.h>
>  #include <linux/async.h>
>  #include <linux/suspend.h>
> +#include <trace/events/power.h>
>  
>  #include "../base.h"
>  #include "power.h"
> @@ -565,11 +566,19 @@ static int device_resume(struct device *dev, pm_message_t state, bool async)
>  	char *info = NULL;
>  	int error = 0;
>  	bool put = false;
> +	s64 in_time = ktime_to_us(ktime_get());
> +	s64 wait_done_time;
> +
> +	trace_device_resume_in(dev);
>  
>  	TRACE_DEVICE(dev);
>  	TRACE_RESUME(0);
>  
>  	dpm_wait(dev->parent, async);
> +
> +	wait_done_time = ktime_to_us(ktime_get());
> +	trace_device_resume_waited(dev, wait_done_time - in_time);
> +
>  	device_lock(dev);
>  
>  	/*
> @@ -638,6 +647,7 @@ static int device_resume(struct device *dev, pm_message_t state, bool async)
>  	if (put)
>  		pm_runtime_put_sync(dev);
>  
> +	trace_device_resume_out(dev, ktime_to_us(ktime_get()) - wait_done_time);
>  	return error;
>  }
>  
> diff --git a/include/trace/events/power.h b/include/trace/events/power.h
> index cae9a94..9601419 100644
> --- a/include/trace/events/power.h
> +++ b/include/trace/events/power.h
> @@ -4,6 +4,7 @@
>  #if !defined(_TRACE_POWER_H) || defined(TRACE_HEADER_MULTI_READ)
>  #define _TRACE_POWER_H
>  
> +#include <linux/device.h>
>  #include <linux/ktime.h>
>  #include <linux/tracepoint.h>
>  
> @@ -48,6 +49,64 @@ DEFINE_EVENT(cpu, cpu_frequency,
>  	TP_ARGS(frequency, cpu_id)
>  );
>  
> +#define get_driver_name(dev) dev->driver && dev->driver->name ? \
> +		dev->driver->name : ""
> +
> +TRACE_EVENT(device_resume_in,
> +
> +	TP_PROTO(struct device *dev),
> +
> +	TP_ARGS(dev),
> +
> +	TP_STRUCT__entry(
> +		__string(	device_name,	dev_name(dev)		)
> +		__string(	driver_name,	get_driver_name(dev)	)
> +	),
> +
> +	TP_fast_assign(
> +		__assign_str(device_name, dev_name(dev));
> +		__assign_str(driver_name, get_driver_name(dev));
> +	),
> +
> +	TP_printk("device=%s driver=%s", __get_str(device_name), __get_str(driver_name))
> +);
> +
> +DECLARE_EVENT_CLASS(device_resume_internal,
> +
> +	TP_PROTO(struct device *dev, s64 time_delta),
> +
> +	TP_ARGS(dev, time_delta),
> +
> +	TP_STRUCT__entry(
> +		__field(	s64,		time_delta		)
> +		__string(	device_name,	dev_name(dev)		)
> +		__string(	driver_name,	get_driver_name(dev)	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->time_delta = time_delta;
> +		__assign_str(device_name, dev_name(dev));
> +		__assign_str(driver_name, get_driver_name(dev));
> +	),
> +
> +	TP_printk("device=%s driver=%s time_delta=%lld", __get_str(device_name),
> +		  __get_str(driver_name), __entry->time_delta)
> +);
> +
> +DEFINE_EVENT(device_resume_internal, device_resume_waited,
> +
> +	TP_PROTO(struct device *dev, s64 time_delta),
> +
> +	TP_ARGS(dev, time_delta)
> +);
> +
> +DEFINE_EVENT(device_resume_internal, device_resume_out,
> +
> +	TP_PROTO(struct device *dev, s64 time_delta),
> +
> +	TP_ARGS(dev, time_delta)
> +);
> +
>  TRACE_EVENT(machine_suspend,
>  
>  	TP_PROTO(unsigned int state),
> 

