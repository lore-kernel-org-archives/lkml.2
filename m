Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759037Ab1CaSib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:38:31 -0400
Received: from gateway11.websitewelcome.com ([69.56.144.11]:48495 "HELO
	gateway11.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759021Ab1CaSi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:38:29 -0400
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Mar 2011 14:38:29 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=basementcode.com;
	h=Received:MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Subject:Message-ID:X-Sender:User-Agent:X-Source:X-Source-Args:X-Source-Dir;
	b=CZZIqIH+S2HdnOq6mn+6QrGas1RsT3ZafONEAvDaRnWC842Mad9xomGojbFxjHulmPHtRfgQ83qs8r/gdo0ahhWv9qJkj/i9Y+m8My1LPx512y9JnALJIqdJU+rn5PuP;
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 31 Mar 2011 13:28:51 -0500
From: <chris@basementcode.com>
To: <linux-kernel@vger.kernel.org>
Subject: ARM SMP startup question (regarding =?UTF-8?Q?gic=5Fsecondary=5Fi?=
 =?UTF-8?Q?nit=29?=
Message-ID: <8e26cf04461fd0822f87d806dd7efae6@basementcode.com>
User-Agent: Roundcube Webmail/0.4.2
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator871.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - basementcode.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 I was looking at a some of the SMP code in the arm mach types. Inside 
 the platform_secondary_init function they all seem to follow the same 
 basic procedure:

   //secondary core code//
   gic_secondary_init(0);
   spin_lock(&boot_lock);
   spin_unlock(&boot_lock);

 I'm porting to a board myself, so I copied that structure to get 
 started. While the secondary processor is in the first bit of code, the 
 boot processor is here:

   //boot core code//
   spin_lock(&boot_lock);
   while (time_before(jiffies, timeout));
   /*
    * now the secondary core is starting up let it run its
    * calibrations, then wait for it to finish
    */
   spin_unlock(&boot_lock);

 which causes a deadlock because jiffies isn't being incremented, and 
 the boot cpu has a lock on boot_lock that the secondary processor needs 
 to sync with. Upon closer inspection gic_secondary_init uses the 
 following lines of code:

   /*
    * Deal with the banked PPI and SGI interrupts - disable all
    * PPI interrupts, ensure all SGI interrupts are enabled.
    */
   writel(0xffff0000, dist_base + GIC_DIST_ENABLE_CLEAR);
   writel(0x0000ffff, dist_base + GIC_DIST_ENABLE_SET);

 The timer for the scheduler seems to be attached via the GIC PPI 
 interrupts. I guess it makes sense that we don't need a scheduler while 
 a CPU is booting. The problem is that even ignoring platform (or should 
 I say mach?) specific code that uses jiffies as timer and timeout code, 
 core ARM files rely on it. For example, after disabling timer interrupts 
 the secondary core gets to the calibrate_delay function, which also has 
 the jiffy loops that never end. If I replace
   writel(0x0000ffff, dist_base + GIC_DIST_ENABLE_SET);
 with
   writel(0xffffffff, dist_base + GIC_DIST_ENABLE_SET);
 to avoid disabling the timer interrupts the system boots without any 
 problems, and both cpus work happily together.

 I should note that I am NOT yet using local timers.

 This is actually by first post to the LKML, I hope that I've asked the 
 right questions and made my points efficiently enough.

 I've read a few ARM related posts here, and I'm still not clear on what 
 is meant by "pointless churn". I understand that it means code is 
 constantly being changed with little to no effect on the kernel, but 
 what code are people refering to?

 Thanks,
 -Chris

