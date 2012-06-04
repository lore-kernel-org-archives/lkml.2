Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761064Ab2FDWmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 18:42:09 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:56168 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179Ab2FDWmG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 18:42:06 -0400
MIME-Version: 1.0
In-Reply-To: <1337791532-15820-1-git-send-email-snanda@chromium.org>
References: <20120522202453.GA30723@kroah.com> <1337791532-15820-1-git-send-email-snanda@chromium.org>
From: Sameer Nanda <snanda@chromium.org>
Date: Mon, 4 Jun 2012 15:41:44 -0700
X-Google-Sender-Auth: 1perot4uh-BIq0QjiGNxSzvWGS4
Message-ID: <CANMivWbRM+VvJaAHjz0Tr0SpqN3-OFp7DpXhtiDssJMNRX+5YA@mail.gmail.com>
Subject: Re: [PATCH v2] power: add knob for printing device resume times
To: rob@landley.net, len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl,
        gregkh@linuxfoundation.org
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Sameer Nanda <snanda@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 9:45 AM, Sameer Nanda <snanda@chromium.org> wrote:
> Added a new knob called /sys/power/pm_print_times. Setting it to 1
> enables printing of time taken by devices to suspend and resume.
> Setting it to 0 disables this printing (unless overridden by
> initcall_debug kernel command line option).
>
> Signed-off-by: Sameer Nanda <snanda@chromium.org>
> cc: Greg KH <gregkh@linuxfoundation.org>
> cc: Rafael J. Wysocki <rjw@sisk.pl>
> cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  Documentation/ABI/testing/sysfs-power |   13 ++++++++++++
>  drivers/base/power/main.c             |    4 +-
>  drivers/base/power/power.h            |   11 ++++++++++
>  kernel/power/main.c                   |   34 +++++++++++++++++++++++++++++++++
>  4 files changed, 60 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/ABI/testing/sysfs-power b/Documentation/ABI/testing/sysfs-power
> index b464d12..79210d1 100644
> --- a/Documentation/ABI/testing/sysfs-power
> +++ b/Documentation/ABI/testing/sysfs-power
> @@ -172,3 +172,16 @@ Description:
>
>                Reading from this file will display the current value, which is
>                set to 1 MB by default.
> +
> +What:          /sys/power/pm_print_times
> +Date:          May 2012
> +Contact:       Sameer Nanda <snanda@chromium.org>
> +Description:
> +               The /sys/power/pm_print_times file allows user space to
> +               control whether the time taken by devices to suspend and
> +               resume is printed.  These prints are useful for hunting down
> +               devices that take too long to suspend or resume.
> +
> +               Writing a "1" enables this printing while writing a "0"
> +               disables it.  The default value is "0".  Reading from this file
> +               will display the current value.
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index b462c0e..ca8b2b5 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -166,7 +166,7 @@ static ktime_t initcall_debug_start(struct device *dev)
>  {
>        ktime_t calltime = ktime_set(0, 0);
>
> -       if (initcall_debug) {
> +       if (pm_print_times) {
>                pr_info("calling  %s+ @ %i, parent: %s\n",
>                        dev_name(dev), task_pid_nr(current),
>                        dev->parent ? dev_name(dev->parent) : "none");
> @@ -181,7 +181,7 @@ static void initcall_debug_report(struct device *dev, ktime_t calltime,
>  {
>        ktime_t delta, rettime;
>
> -       if (initcall_debug) {
> +       if (pm_print_times) {
>                rettime = ktime_get();
>                delta = ktime_sub(rettime, calltime);
>                pr_info("call %s+ returned %d after %Ld usecs\n", dev_name(dev),
> diff --git a/drivers/base/power/power.h b/drivers/base/power/power.h
> index eeb4bff..12c77b7 100644
> --- a/drivers/base/power/power.h
> +++ b/drivers/base/power/power.h
> @@ -85,3 +85,14 @@ static inline int pm_qos_sysfs_add(struct device *dev) { return 0; }
>  static inline void pm_qos_sysfs_remove(struct device *dev) {}
>
>  #endif
> +
> +#ifdef CONFIG_PM_DEBUG
> +
> +extern int pm_print_times_enabled;
> +#define pm_print_times (initcall_debug || pm_print_times_enabled)
> +
> +#else /* CONFIG_PM_DEBUG */
> +
> +#define pm_print_times initcall_debug
> +
> +#endif /* CONFIG_PM_DEBUG */
> diff --git a/kernel/power/main.c b/kernel/power/main.c
> index 1c12581..97eea04 100644
> --- a/kernel/power/main.c
> +++ b/kernel/power/main.c
> @@ -132,6 +132,39 @@ static ssize_t pm_test_store(struct kobject *kobj, struct kobj_attribute *attr,
>  }
>
>  power_attr(pm_test);
> +
> +/*
> + *     pm_print_times: print time taken by devices to suspend and resume.
> + *
> + *     show() returns whether printing of suspend and resume times is enabled.
> + *
> + *     store() accepts 0 or 1.  0 disables printing and 1 enables it.
> + */
> +int pm_print_times_enabled;
> +
> +static ssize_t pm_print_times_show(struct kobject *kobj,
> +                                  struct kobj_attribute *attr, char *buf)
> +{
> +       return sprintf(buf, "%d\n", pm_print_times_enabled);
> +}
> +
> +static ssize_t pm_print_times_store(struct kobject *kobj,
> +                                   struct kobj_attribute *attr,
> +                                   const char *buf, size_t n)
> +{
> +       unsigned long val;
> +
> +       if (kstrtoul(buf, 10, &val))
> +               return -EINVAL;
> +
> +       if (val > 1)
> +               return -EINVAL;
> +
> +       pm_print_times_enabled = val;
> +       return n;
> +}
> +
> +power_attr(pm_print_times);
>  #endif /* CONFIG_PM_DEBUG */
>
>  #ifdef CONFIG_DEBUG_FS
> @@ -411,6 +444,7 @@ static struct attribute * g[] = {
>        &wakeup_count_attr.attr,
>  #ifdef CONFIG_PM_DEBUG
>        &pm_test_attr.attr,
> +       &pm_print_times_attr.attr,
>  #endif
>  #endif
>        NULL,
> --
> 1.7.7.3
>

Greg KH, Rafael: any feedback on this patch?  Questions I can help
answer to help push this along?
