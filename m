Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab2HCJoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 05:44:22 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:38057 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab2HCJoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 05:44:21 -0400
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Vikram Pandita <vikram.pandita@ti.com>, gregkh@linuxfoundation.org,
        kay@vrfy.org
Cc: linux-kernel@vger.kernel.org, Vikram Pandita <vikram.pandita@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
Subject: Re: [PATCH v2] printk: add option to print cpu id
In-Reply-To: <1343985378-22330-1-git-send-email-vikram.pandita@ti.com>
References: <1343985378-22330-1-git-send-email-vikram.pandita@ti.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/24.0.95.1 (x86_64-unknown-linux-gnu)
Date: Fri, 03 Aug 2012 15:13:16 +0530
Message-ID: <87wr1g5n0r.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12080309-6102-0000-0000-000001FE00A1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2012 02:16:18 -0700, Vikram Pandita <vikram.pandita@ti.com> wrote:
> From: Vikram Pandita <vikram.pandita@ti.com>
> 
> Introduce config option to enable CPU id reporting for printk() calls.
> 
> Example logs with this option enabled look like:
>  [1] [    2.328613] usbcore: registered new interface driver libusual
>  [1] [    2.335418] usbcore: registered new interface driver usbtest
>  [1] [    2.342803] mousedev: PS/2 mouse device common for all mice
>  [0] [    2.352600] twl_rtc twl_rtc: Power up reset detected.
>  [0] [    2.359191] twl_rtc twl_rtc: Enabling TWL-RTC
>  [1] [    2.367797] twl_rtc twl_rtc: rtc core: registered twl_rtc as rtc0
>  [1] [    2.375274] i2c /dev entries driver
>  [1] [    2.382324] Driver for 1-wire Dallas network protocol.
> 
> Its sometimes very useful to have printk also print the CPU Identifier
> that executed the call. This has helped to debug various SMP issues on shipping
> products.
> 
> Known limitation is if the system gets preempted between function call and
> actual printk, the reported cpu-id might not be accurate. But most of the
> times its seen to give a good feel of how the N cpu's in the system are
> getting loaded.
> 
> Signed-off-by: Vikram Pandita <vikram.pandita@ti.com>
> Cc: Kay Sievers <kay@vrfy.org>
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
> ---
> v1: initial version - had wrong cpuid logging mechanism
> v2: fixed as per review comments from Kay Sievers
> 
>  kernel/printk.c   |   51 +++++++++++++++++++++++++++++++++++++++++----------
>  lib/Kconfig.debug |   13 +++++++++++++
>  2 files changed, 54 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 6a76ab9..64f4a1b 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -208,6 +208,7 @@ struct log {
>  	u8 facility;		/* syslog facility */
>  	u8 flags:5;		/* internal record flags */
>  	u8 level:3;		/* syslog level */
> +	u8 cpuid;		/* cpu invoking the log */
>  };

That would be sufficient for only 256 cpus. Is that what you intend?

There are systems which will have much higher numbers than this limit.

>  /*
> @@ -305,7 +306,8 @@ static u32 log_next(u32 idx)
>  static void log_store(int facility, int level,
>  		      enum log_flags flags, u64 ts_nsec,
>  		      const char *dict, u16 dict_len,
> -		      const char *text, u16 text_len)
> +		      const char *text, u16 text_len,
> +		      const u8 cpuid)
>  {
>  	struct log *msg;
>  	u32 size, pad_len;
> @@ -356,6 +358,7 @@ static void log_store(int facility, int level,
>  		msg->ts_nsec = local_clock();
>  	memset(log_dict(msg) + dict_len, 0, pad_len);
>  	msg->len = sizeof(struct log) + text_len + dict_len + pad_len;
> +	msg->cpuid = cpuid;
> 
>  	/* insert message */
>  	log_next_idx += msg->len;
> @@ -855,6 +858,25 @@ static size_t print_time(u64 ts, char *buf)
>  		       (unsigned long)ts, rem_nsec / 1000);
>  }
> 
> +#if defined(CONFIG_PRINTK_CPUID)
> +static bool printk_cpuid = 1;
> +#else
> +static bool printk_cpuid;
> +#endif
> +module_param_named(cpuid, printk_cpuid, bool, S_IRUGO | S_IWUSR);
> +
> +static size_t print_cpuid(u8 cpuid, char *buf)
> +{
> +
> +	if (!printk_cpuid)
> +		return 0;
> +
> +	if (!buf)
> +		return 4;
> +
Firstly, why this magic number?
Secondly, if buf is NULL, why should you increment?

> +	return sprintf(buf, "[%1d] ", cpuid);
> +}
> +
>  static size_t print_prefix(const struct log *msg, bool syslog, char *buf)
>  {
>  	size_t len = 0;

Regards
Nikunj

