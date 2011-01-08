Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371Ab1AHQ7D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 11:59:03 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62643 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab1AHQ7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 11:59:00 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6220"; a="69755492"
Message-ID: <4D2897D1.3040609@codeaurora.org>
Date: Sat, 08 Jan 2011 08:58:57 -0800
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: tglx@linutronix.de
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: interrupt latency while resuming.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I am trying to address an issue of not handling a wakeup interrupt quick 
enough while resuming. It is an edge triggered interrupt with the 
IRQ_WAKEUP flag set. The interrupt controller implements lazy disabling 
of interrupts, IOW does not have a disable callback in the irq_chip.

So while going in to supend that interrupt is marked  IRQ_DISABLED in 
dpm_suspend_noirq().

On resume handle_edge_trigger is run right after 
arch_suspend_enable_irqs(). It finds the interrupt marked  IRQ_DISABLED 
and it sets the IRQ_PENDING flag and does not call the handler.

As the resume path unrolls, non boot cpus  are enabled, 
dpm_resume_noirq() is run. At that time it finds the IRQ_PENDING flag is 
set on this interrupt and the interrupt handler is run.

The problem is, this is very late for the interrupt to be run. Possibly 
because enable_nonboot_cpu takes a while or the resume_noirq callbacks 
take a long time etc.

I tried using IRQF_NO_SUSPEND for that interrupt and it seems the 
interrupt is handled as soon as arch_suspend_enable_irqs() is run.
However I suspect that with this the system will fail to abort suspend - 
The interrupt could trigger between dpm_suspend_noirq() and 
arch_suspend_disable_irqs() and since it wont be marked IRQF_PENDING the 
system goes to suspend never to be woken up again. (the check to abort 
suspend because of a pending interrupt is done in check_wakeup_irqs() in 
sysdev_suspend). I dont think IRQF_NO_SUSPEND was designed for wakeup 
interrupts. Please correct me if I am missing something here.

A solution that comes to mind is enabling such interrupts right before 
arch_suspend_enable_irqs() is run. In some more detail, mark these 
interrupts as IRQF_LOW_SUSPEND_LATENCY in their irq_desc->status and 
enable such interrupts before doing arch_suspend_enable_irqs(). That way 
when arch_suspend_enable_irqs() happens, the handler is run immediately.
We skip enabling such interrupts in resume_device_irqs() to avoid 
enabling them twice.

Will appreciate any other suggestions towards fixing the delay.

Abhijeet

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.










