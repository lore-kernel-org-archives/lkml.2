Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760622Ab0JIWu2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 18:50:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59642 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756661Ab0JIWu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 18:50:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: James Hogan <james@albanarts.com>
Subject: Re: [PATCH 2/2] pm_trace: Add sysfs attr for rechecking dev hash.
Date: Sun, 10 Oct 2010 00:49:15 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-rjw+; KDE/4.4.4; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Randy Dunlap <rdunlap@xenotime.net>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        markgross <markgross@thegnar.org>
References: <201010092334.27808.james@albanarts.com> <201010092337.47821.james@albanarts.com>
In-Reply-To: <201010092337.47821.james@albanarts.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010100049.16054.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, October 10, 2010, James Hogan wrote:
> If the device which fails to resume is part of a loadable kernel module
> it won't be checked at startup against the magic number stored in the
> RTC.
> 
> Add a read-only sysfs attribute /sys/power/pm_trace_dev_hash which
> contains a list of newline separated devices (usually just the one)
> which currently match the last magic number. This allows the device
> which is failing to resume to be found after the modules are loaded
> again.
> 
> Signed-off-by: James Hogan <james@albanarts.com>
> ---
>  Documentation/power/s2ram.txt |    7 +++++++
>  drivers/base/power/trace.c    |   27 +++++++++++++++++++++++++++
>  include/linux/resume-trace.h  |    2 ++
>  kernel/power/main.c           |   18 ++++++++++++++++++
>  4 files changed, 54 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/power/s2ram.txt b/Documentation/power/s2ram.txt
> index 514b94f..3a2801a 100644
> --- a/Documentation/power/s2ram.txt
> +++ b/Documentation/power/s2ram.txt
> @@ -49,6 +49,13 @@ machine that doesn't boot) is:
>     device (lspci and /sys/devices/pci* is your friend), and see if you can
>     fix it, disable it, or trace into its resume function.
>  
> +   If no device matches the hash, it may be a device from a loadable kernel
> +   module that is not loaded until after the hash is checked. You can check
> +   the hash against the current devices again after more modules are loaded
> +   using sysfs:
> +
> +	cat /sys/power/pm_trace_dev_hash
> +

/sys/power/pm_trace_match perhaps?

How do we ensure it prints things that make sense when the last resume was
successful or the system hasn't suspended at all?

>  For example, the above happens to be the VGA device on my EVO, which I
>  used to run with "radeonfb" (it's an ATI Radeon mobility). It turns out
>  that "radeonfb" simply cannot resume that device - it tries to set the
> diff --git a/drivers/base/power/trace.c b/drivers/base/power/trace.c
> index 17e24e3..e0cdba1 100644
> --- a/drivers/base/power/trace.c
> +++ b/drivers/base/power/trace.c
> @@ -207,6 +207,33 @@ static int show_dev_hash(unsigned int value)
>  
>  static unsigned int hash_value_early_read;
>  
> +int snprint_trace_dev_hash(char *buf, size_t size)
> +{
> +	unsigned int value = hash_value_early_read / (USERHASH * FILEHASH);
> +	int ret = 0;
> +	struct list_head *entry;
> +
> +	device_pm_lock();
> +	entry = dpm_list.prev;
> +	while (size && entry != &dpm_list) {
> +		struct device *dev = to_device(entry);
> +		unsigned int hash = hash_string(DEVSEED, dev_name(dev),
> +						DEVHASH);
> +		if (hash == value) {
> +			int len = snprintf(buf, size, "%s\n",
> +					    dev_driver_string(dev));
> +			if (len > size)
> +				len = size;
> +			buf += len;
> +			ret += len;
> +			size -= len;

Don't we want to break; here and if so then why?

> +		}
> +		entry = entry->prev;
> +	}
> +	device_pm_unlock();
> +	return ret;
> +}
> +
>  static int early_resume_init(void)
>  {
>  	hash_value_early_read = read_magic_time();

Thanks,
Rafael
