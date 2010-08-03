Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab0HCPZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 11:25:07 -0400
Received: from xenotime.net ([72.52.115.56]:34170 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932148Ab0HCPZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 11:25:04 -0400
Date: Tue, 3 Aug 2010 08:24:56 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: Additional fix : (was [v2]printk: fix delayed messages from CPU
 hotplug events)
Message-Id: <20100803082456.3b91e7a5.rdunlap@xenotime.net>
In-Reply-To: <EAF47CD23C76F840A9E7FCE10091EFAB02C641D8EC@dbde02.ent.ti.com>
References: <EAF47CD23C76F840A9E7FCE10091EFAB02C5DB6D1F@dbde02.ent.ti.com>
	<20100802154434.5615bcf9.akpm@linux-foundation.org>
	<EAF47CD23C76F840A9E7FCE10091EFAB02C641D8EC@dbde02.ent.ti.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Aug 2010 13:03:25 +0530 Shilimkar, Santosh wrote:

> -----------------------------------------------
> From b99271ce43cc82cda28447444004933d0f218ee3 Mon Sep 17 00:00:00 2001
> From: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Date: Tue, 3 Aug 2010 12:58:22 +0530
> Subject: [PATCH] console: flush delayed log messages from cpu-hotplug events
> 
> When a secondary CPU is being brought up, it is not uncommon for
> printk() to be invoked when cpu_online(smp_processor_id()) == 0.  The
> case that I witnessed personally was on MIPS:
> 
> http://lkml.org/lkml/2010/5/30/4
> 
> If (can_use_console() == 0), printk() will spool its output to log_buf
> and it will be visible in "dmesg", but that output will NOT be echoed to
> the console until somebody calls release_console_sem() from a CPU that
> is online.  Therefore, the boot time messages from the new CPU can get
> stuck in "limbo" for a long time, and might suddenly appear on the
> screen when a completely unrelated event (e.g. "eth0: link is down")
> occurs.
> 
> This patch modifies the console code so that any pending messages are
> automatically flushed out to the console whenever a CPU hotplug
> operation completes successfully or aborts.
> This is true even when CPU is getting hot-plugged out(offline) so
> need to add additional hotplug events.
> 
> The issue was seen on 2.6.34.
> 
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> ---
>  kernel/printk.c |   36 ++++++++++++++++++++++++++++++++++++
>  1 files changed, 36 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 444b770..a884d81 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -37,6 +37,8 @@
>  #include <linux/ratelimit.h>
>  #include <linux/kmsg_dump.h>
>  #include <linux/syslog.h>
> +#include <linux/cpu.h>
> +#include <linux/notifier.h>
>  
>  #include <asm/uaccess.h>
>  
> @@ -985,6 +987,40 @@ void resume_console(void)
>  }
>  
>  /**
> + * console_cpu_notify - print deferred console messages after CPU hotplug
> + *
> + * If printk() is called from a CPU that is not online yet, the messages
> + * will be spooled but will not show up on the console.  This function is
> + * called when a new CPU comes online and ensures that any such output
> + * gets printed.
> + */
> +static int __cpuinit console_cpu_notify(struct notifier_block *self,
> +	unsigned long action, void *hcpu)
> +{


kernel-doc notation should include function parameters also, please.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
