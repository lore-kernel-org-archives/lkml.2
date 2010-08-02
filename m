Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab0HBWow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 18:44:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39073 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754053Ab0HBWov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 18:44:51 -0400
Date: Mon, 2 Aug 2010 15:44:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: Kevin Cernekee <cernekee@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: Additional fix : (was [v2]printk: fix delayed messages from CPU
 hotplug events)
Message-Id: <20100802154434.5615bcf9.akpm@linux-foundation.org>
In-Reply-To: <EAF47CD23C76F840A9E7FCE10091EFAB02C5DB6D1F@dbde02.ent.ti.com>
References: <EAF47CD23C76F840A9E7FCE10091EFAB02C5DB6D1F@dbde02.ent.ti.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jun 2010 14:22:26 +0530
"Shilimkar, Santosh" <santosh.shilimkar@ti.com> wrote:

> Hi,
> 
> I have faced similar issue as what is being described in below with
> latest kernel.
> 
> ------------------------------------------------
> https://patchwork.kernel.org/patch/103347/
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
> 
> -----------------------------------------------
> 
> Above patch fixes only half of the problem. I mean the cpu online
> path prints are coming on the console.
> 
> But similar problem also exist if there are prints in the cpu offline
> path. I got that fixed by adding below patch on top of you patch.
>  
> diff --git a/kernel/printk.c b/kernel/printk.c
> index d370b74..f4d7352 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -982,6 +982,9 @@ static int __cpuinit console_cpu_notify(struct notifier_bloc
>         switch (action) {
>         case CPU_ONLINE:
>         case CPU_UP_CANCELED:
> +       case CPU_DEAD:
> +       case CPU_DYING:
> +       case CPU_DOWN_FAILED:
>                 if (try_acquire_console_sem() == 0)
>                         release_console_sem();
>         }

The patch lacked a suitable title.  I called it "console: flush log
messages for more cpu-hotplug events".

The patch lacks a Signed-off-by:.  Please send one.

The patch has its tabs replaced with spaces.  I fixed that.  Please
reconfigure your email client for next time.

The code which is being patch has changed.  It now does

                acquire_console_sem();
                release_console_sem();

so the code may no longer work - perhaps it now deadlocks (unlikely). 
Please retest?

Finally, I don't understand the patch :( Who is sending out CPU_DEAD,
CPU_DYING or CPU_DOWN_FAILED events during kernel boot?  I'd have
thought that those events simply aren't occurring, and that the patch
has no effect.  Confused - please explain further.
