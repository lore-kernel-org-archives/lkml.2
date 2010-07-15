Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab0GOADs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 20:03:48 -0400
Received: from mga14.intel.com ([143.182.124.37]:53305 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050Ab0GOADr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 20:03:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,204,1278313200"; 
   d="scan'208";a="300309923"
Subject: Re: tip/master broken with x2apic and kexec
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4C3E40EC.5060607@kernel.org>
References: <4C3BD6AA.3070908@kernel.org> <4C3CE210.2030902@zytor.com>
	 <4C3CF650.30905@kernel.org> <4C3E1FA0.9000107@kernel.org>
	 <4C3E2AE6.30406@kernel.org>  <4C3E40EC.5060607@kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 14 Jul 2010 17:03:09 -0700
Message-Id: <1279152189.2849.260.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-14 at 15:57 -0700, Yinghai Lu wrote:
> On 07/14/2010 02:23 PM, Yinghai Lu wrote:
> > On 07/14/2010 01:35 PM, Yinghai Lu wrote:
> >> On 07/13/2010 04:27 PM, Yinghai Lu wrote:
> >>> On 07/13/2010 03:00 PM, H. Peter Anvin wrote:
> >>>> On 07/12/2010 07:59 PM, Yinghai Lu wrote:
> >>>>> tip/master: 
> >>>>> system1: BIOS enabled x2apic, first kernel boot well, and when kexec second kernel will cause system instant reboot.
> >>>>>
> >>>>> system2: BIOS not enable x2apic, first kernel boot well and enable x2apic, and kexec second kernel well. but when kexec third kernel will case system instant reboot.
> >>>>>
> >>>>> linus' tree is ok.
> >>>>>
> >>>>> but for system2 if boot with nox2apic ,intr-remaping off, iommu off, the kexec loop test will pass.
> >>>>>
> >>>>> the problem looks start in recent two or three weeks.
> >>>>>
> >>>>> Any idea?
> >>>>>
> >>>>> bisecting will take a while, because the system post take a while everytime.
> >>>>>
> >>>>> Thanks
> >>>>>
> >>>>> Yinghai Lu
> >>>>
> >>>> OK, I found the bug... if you could test out the patch which will be
> >>>> sent out shortly I would very much appreciate it.
> >>>
> >>> not sure if your patch is the offending one now.
> >>>
> >>> kL: kernel from linus tree
> >>> kT1: kernel from tip
> >>> kT2: kernel from tip with reverting your patch
> >>>
> >>> BIOS-->kL ---> kL ---> kL....always working
> >>> BIOS-->kT1 ---> kT1 --->  kT1 : between second one and third one system reset instant...
> >>> BIOS-->kT2 ---> kT2 --->  kT2 : between second one and third one system reset instant...
> >>>
> >>> BIOS-->kL ---> kL ---> kL ---> then kT1 ---> kT1 .... always working
> >>> BIOS-->kL ---> kL ---> kL ---> then kT2 ---> kT2 .... always working
> >>>
> >>
> >> bisecting said:
> >>
> >>> git bisect good
> >> 58687acba59266735adb8ccd9b5b9aa2c7cd205b is the first bad commit
> >> commit 58687acba59266735adb8ccd9b5b9aa2c7cd205b
> >> Author: Don Zickus <dzickus@redhat.com>
> >> Date:   Fri May 7 17:11:44 2010 -0400
> >>
> >>     lockup_detector: Combine nmi_watchdog and softlockup detector
> >>     
> >>     The new nmi_watchdog (which uses the perf event subsystem) is very
> >>     similar in structure to the softlockup detector.  Using Ingo's
> >>     suggestion, I combined the two functionalities into one file:
> >>     kernel/watchdog.c.
> >>     
> >>     Now both the nmi_watchdog (or hardlockup detector) and softlockup
> >>     detector sit on top of the perf event subsystem, which is run every
> >>     60 seconds or so to see if there are any lockups.
> >>     
> >>     To detect hardlockups, cpus not responding to interrupts, I
> >>     implemented an hrtimer that runs 5 times for every perf event
> >>     overflow event.  If that stops counting on a cpu, then the cpu is
> >>     most likely in trouble.
> >>     
> >>     To detect softlockups, tasks not yielding to the scheduler, I used the
> >>     previous kthread idea that now gets kicked every time the hrtimer fires.
> >>     If the kthread isn't being scheduled neither is anyone else and the
> >>     warning is printed to the console.
> >>     
> >>     I tested this on x86_64 and both the softlockup and hardlockup paths
> >>     work.
> >>     
> > 
> > with
> > # CONFIG_LOCKUP_DETECTOR is not set
> > # CONFIG_HARDLOCKUP_DETECTOR is not set
> > 
> > kexec loop test could passed.
> > 
> > also that patch will break x2apic preenabled system 's kexec/kdump.
> 
> before the combining patch
> 
> CONFIG_DETECT_SOFTLOCKUP=y
> CONFIG_NMI_WATCHDOG=y
> 
> will have the same problem.
> 
> so the problem should come from NMI_WATCHDOG.

Yinghai, It looks like some timing issue wrt nmi handling/kexec and
perhaps not directly related to x2apic? Perhaps we should try with
x2apic disabled but with intr-remapping enabled etc to see if it changes
anything. Also do we know (like serial console log etc) how far ahead we
went in the kexec before we rebooted?

thanks,
suresh

