Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181Ab2ERSiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 14:38:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33838 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933067Ab2ERSiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 14:38:02 -0400
Date: Fri, 18 May 2012 11:37:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sameer Nanda <snanda@chromium.org>
Cc: rob@landley.net, len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl,
        rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        jkosina@suse.cz, standby24x7@gmail.com, jj@chaosbits.net,
        paulmck@linux.vnet.ibm.com, josh@joshtriplett.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] power, trace: add tracing for device_resume
Message-ID: <20120518183756.GA3216@kroah.com>
References: <1337365643-29261-1-git-send-email-snanda@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337365643-29261-1-git-send-email-snanda@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 11:27:23AM -0700, Sameer Nanda wrote:
> Added event tracing for device_resume. This helps quickly pinpoint which
> devices take a long time to resume.
> 
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

Don't these TRACE_DEVICE() and TRACE_RESUME() calls already provide you
the same information you are wanting to determine above if you look at
the timestamps of the events?  Can you not do time processing in
userspace?

confused,

greg k-h
