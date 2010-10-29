Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609Ab0J2AEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 20:04:39 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30276 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758438Ab0J2AEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 20:04:34 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6150"; a="59663363"
Message-ID: <4CCA0F92.4070802@codeaurora.org>
Date: Thu, 28 Oct 2010 17:04:34 -0700
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm-owner@vger.kernel.org
Subject: Re: [RFC IRQ] genirq: fix handle_nested_irq for lazy disable
References: <1288144209-28086-1-git-send-email-adharmap@codeaurora.org> <alpine.LFD.2.00.1010270909590.3100@localhost6.localdomain6> <4CC9B167.8010401@codeaurora.org> <alpine.LFD.2.00.1010282050390.2692@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1010282050390.2692@localhost6.localdomain6>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Thu, 28 Oct 2010, Abhijeet Dharmapurikar wrote:
>> Thomas Gleixner wrote:
>>> Aside of that this wont work for edge triggered interrupts, as you'd
>>> loose the edge, so this needs more thought and a thorough look at the
>>> users of handle_nested_irq().
>> I didn't understand this though. This patch will mask the interrupt in the
>> controller even if it were edge. My interrupt controller latches
>> edges and wants a mask (or an ack) to be executed to deactivate the line
>> summary line. Do you mean that I should mark the interrupt IRQ_PENDING if it
>> were an edge before masking it? If not, can you please explain.
> 
> See handle_edge_irq().
> 
> An edge is a one time event. Once you mask/ack it, it's gone. So now
> when you unmask it won't reissue the interrupt on the hardware
> level. Level interrupts do, as the mask does not affect that.

handle_edge_irq() needs to handle nested invocations and so it checks if 
the irq is in progress and does the right masking/unmasking and calling 
the handler again.
But I think we will never be executing an interrupt within an interrupt 
in the threaded irq controller case. By that I mean the irq controller 
thread wont call handle_nested_irq on the same interrupt until the first 
execution finishes. We don't need to worry about nested calls to 
handle_nested_irq().
If this is right, simply marking the edge interrupt IRQF_PENDING before 
masking it will suffice IMO.
Please let me know if this is closer to what you were suggesting?

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index baa5c4a..2dd0228 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -419,6 +419,7 @@ void handle_nested_irq(unsigned int irq)
  {
         struct irq_desc *desc = irq_to_desc(irq);
         struct irqaction *action;
+       int mask_this_irq = 0;
         irqreturn_t action_ret;

         might_sleep();
@@ -428,8 +429,12 @@ void handle_nested_irq(unsigned int irq)
         kstat_incr_irqs_this_cpu(irq, desc);

         action = desc->action;
-       if (unlikely(!action || (desc->status & IRQ_DISABLED)))
+       if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
+               mask_this_irq = 1;
+               if (!(desc->status & IRQ_LEVEL))
+                       desc->status |= IRQ_PENDING;
                 goto out_unlock;
+       }

         desc->status |= IRQ_INPROGRESS;
         raw_spin_unlock_irq(&desc->lock);
@@ -443,6 +448,11 @@ void handle_nested_irq(unsigned int irq)

  out_unlock:
         raw_spin_unlock_irq(&desc->lock);
+       if (unlikely(mask_this_irq)) {
+               chip_bus_lock(desc);
+               mask_irq(irq);
+               chip_bus_sync_unlock(desc);
+       }
  }
  EXPORT_SYMBOL_GPL(handle_nested_irq);

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
