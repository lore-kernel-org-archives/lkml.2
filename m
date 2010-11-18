Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760671Ab0KRVsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:48:31 -0500
Received: from bluebox.CS.Princeton.EDU ([128.112.136.38]:56299 "EHLO
	bluebox.CS.Princeton.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205Ab0KRVsa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:48:30 -0500
X-Greylist: delayed 848 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Nov 2010 16:48:30 EST
Subject: Re: [stable] Boot failure with 2.6.27.46 on Xeon E5620 (Westmere EP)
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=utf-8
From: =?utf-8?Q?=22S=2E=C3=87a=C4=9Flar_Onur=22?= 
	<caglar@CS.Princeton.EDU>
In-Reply-To: <20100526132357.GA26728@youquan-linux.bj.intel.com>
Date: Thu, 18 Nov 2010 16:24:40 -0500
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Greg KH <greg@kroah.com>,
        "stable@kernel.org" <stable@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Song, Youquan" <youquan.song@intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <E934EC71-FD1D-4750-818F-DDEBA2F68B4D@CS.Princeton.EDU>
References: <000954C6-B4AC-4FD8-BA3B-C3B199C7607F@CS.Princeton.EDU> <20100525155307.GA7453@kroah.com> <620C3556-2708-4704-90F3-37DDEF1A404E@CS.Princeton.EDU> <20100525205123.GA14993@kroah.com> <1274833451.2892.574.camel@sbs-t61.sc.intel.com> <DD6ACA75-527D-406D-971B-64F042E0ED26@CS.Princeton.EDU> <20100526132357.GA26728@youquan-linux.bj.intel.com>
To: Youquan Song <youquan.song@linux.intel.com>
X-Mailer: Apple Mail (2.1082)
X-Proofpoint-Virus-Version: vendor=nai engine=5400 definitions=6171 signatures=648885
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Youquan & Greg,


On May 26, 2010, at 9:23 AM, Youquan Song wrote:

>>> I can't think of any known issues in 2.6.27 that can lead to this kind
>>> of boot failure on WSM-EP. Caglar, It will be nice if you can do git
>>> bisect between working and non-working kernels.
>> 
>> Sure, I'll try to boot those with plain 2.6.27 to see but please note that it's going to be little time consuming. For each one I have to create a custom boot image for them to download and test (a.k.a. don't expect to hear from me soon :))
> 
> Hi Caglar,
> 
> What's the microcode version? Get by "dmesg | grep microcode" if you
> success boot other version of kernel.
> Can you try to disable C-state(C6) in BIOS before your boot 2.6.27?

First of all I'm really sorry that it took really long time to reply this mail as I was waiting Dell to send a loaner machine to us. This morning I've got the hardware and following patch solved the boot problem that I was observing, Greg could you consider adding that to 2.6.27-stable tree?

commit a0bf284bfedd6dc95bbee7ebf5ccf3b5f753a008
Author: Len Brown <len.brown@intel.com>
Date:   Fri May 15 01:29:31 2009 -0400

    ACPI: Idle C-states disabled by max_cstate should not disable the TSC
    
    Processor idle power states C2 and C3 stop the TSC on many machines.
    Linux recognizes this situation and marks the TSC as unstable:
    
    Marking TSC unstable due to TSC halts in idle
    
    But if those same machines are booted with "processor.max_cstate=1",
    then there is no need to validate C2 and C3, and no need to
    disable the TSC, which can be reliably used as a clocksource.
    
    Signed-off-by: Len Brown <len.brown@intel.com>
    Acked-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index e39a40a..e65476f 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -582,7 +582,7 @@ static int acpi_processor_power_verify(struct acpi_processor *pr)
 
        pr->power.timer_broadcast_on_state = INT_MAX;
 
-       for (i = 1; i < ACPI_PROCESSOR_MAX_POWER; i++) {
+       for (i = 1; i < ACPI_PROCESSOR_MAX_POWER && i <= max_cstate; i++) {
                struct acpi_processor_cx *cx = &pr->power.states[i];
 
                switch (cx->type) {


> Thanks
> -Youquan


Best,
--
S.Çağlar Onur <caglar@cs.princeton.edu>

