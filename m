Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab0GAE2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 00:28:16 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44000 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab0GAE2O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 00:28:14 -0400
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
To: Kevin Cernekee <cernekee@gmail.com>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Date: Thu, 1 Jul 2010 09:57:52 +0530
Subject: RE: Additional fix : (was [v2]printk: fix delayed messages from CPU
 hotplug events)
Thread-Topic: Additional fix : (was [v2]printk: fix delayed messages from
 CPU hotplug events)
Thread-Index: AcsXaGXicqa8+43jSDSUdKePtrVn0ABbO0yA
Message-ID: <EAF47CD23C76F840A9E7FCE10091EFAB02C5E41803@dbde02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding linux-pm@lists.linux-foundation.org)

> -----Original Message-----
> From: Shilimkar, Santosh
> Sent: Tuesday, June 29, 2010 2:22 PM
> To: 'Kevin Cernekee'
> Cc: linux-kernel@vger.kernel.org; Russell King - ARM Linux
> Subject: Additional fix : (was [v2]printk: fix delayed messages from CPU
> hotplug events)
> 
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
> @@ -982,6 +982,9 @@ static int __cpuinit console_cpu_notify(struct
> notifier_bloc
>         switch (action) {
>         case CPU_ONLINE:
>         case CPU_UP_CANCELED:
> +       case CPU_DEAD:
> +       case CPU_DYING:
> +       case CPU_DOWN_FAILED:
>                 if (try_acquire_console_sem() == 0)
>                         release_console_sem();
>         }
> 
> 
> 
> Regards
> Santosh
