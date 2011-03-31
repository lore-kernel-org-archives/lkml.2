Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965133Ab1CaS6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:58:06 -0400
Received: from toro.web-alm.net ([62.245.132.31]:41013 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759123Ab1CaS6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:58:04 -0400
X-Greylist: delayed 1590 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Mar 2011 14:58:04 EDT
Message-ID: <4D94C666.3060206@osadl.org>
Date: Thu, 31 Mar 2011 20:22:30 +0200
From: Carsten Emde <C.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL)
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, Len Brown <lenb@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.hl>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Linux 2.6.33.8
References: <20110321204104.GA2702@kroah.com>
In-Reply-To: <20110321204104.GA2702@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

> I'm announcing the release of the 2.6.33.8 kernel.
>
> This is primarily for the use of those people who are stuck using the
> .33-rt kernel.  Anyone else who really wants to use the .33 kernel tree
> is welcome to use this one as well.
Thanks a lot for your work. It's highly appreciated.

While preparing 2.6.33.8/9 plus PREEMPT_RT patches for quality
assurance in our farm, I found that the "halt" command no longer
powers down the pretest machine (i7/Gulftown); this misbehavior occurs
with and without the PREEMPT_RT patches.

2.6.33.7:
# halt
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
sd 2:0:0:0: [sdb] Synchronizing SCSI cache
sd 2:0:0:0: [sdb] Stopping disk
The machine is powered down.

2.6.33.8:
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
sd 2:0:0:0: [sdb] Synchronizing SCSI cache
sd 2:0:0:0: [sdb] Stopping disk
ACPI: Preparing to enter system sleep state S5
Disabling non-boot CPUs ...
The machine is NOT powered down. Can be powered down only by pulling
the power plug or holding the on/off button for 5 seconds.

Bisecting from 2.6.33.7 to 2.6.33.8 revealed:
74a6e0fd8fc216cfa5edcde4bd356a8972cbc74c is the first bad commit
commit 74a6e0fd8fc216cfa5edcde4bd356a8972cbc74c
Author: H. Peter Anvin <hpa@linux.intel.com>
Date:   Fri Dec 10 23:57:04 2010 -0500

     x86, hotplug: Use mwait to offline a processor, fix the legacy case

     upstream ea53069231f9317062910d6e772cca4ce93de8c8
     x86, hotplug: Use mwait to offline a processor, fix the legacy case

     Here included also some small follow-on patches to the same code:

     upstream a68e5c94f7d3dd64fef34dd5d97e365cae4bb42a
     x86, hotplug: Move WBINVD back outside the play_dead loop

     upstream ce5f68246bf2385d6174856708d0b746dc378f20
     x86, hotplug: In the MWAIT case of play_dead, CLFLUSH the cache line

     https://bugzilla.kernel.org/show_bug.cgi?id=5471

     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
     Signed-off-by: Len Brown <len.brown@intel.com>
     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


With this patch
-	wbinvd_halt();
+	mwait_play_dead();	/* Only returns on failure */
applied, mwait_play_dead() is taken instead of wbinvd_halt(), and the
loop
while (1) {
         mb();
         wbinvd();
         __monitor(&current_thread_info()->flags, 0, 0);
         mb();
         __mwait(eax, 0);
}
never is left. Should native_play_dead() not have been called when
"halt" is executed?

After removing this patch, "halt" works as expected in the two kernel
versions with and without PREEMPT_RT - even after upgrading to 2.6.33.9.

Instead of the entire commit 74a6e0fd8fc216cfa5edcde4bd356a8972cbc74c,
it was also sufficient to apply the first contained upstream commit
ea53069231f9317062910d6e772cca4ce93de8c8 to reproduce the situation.

Thanks,
	Carsten.
