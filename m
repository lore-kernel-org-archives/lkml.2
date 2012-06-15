Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab2FOJ4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 05:56:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:39296 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032Ab2FOJ4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 05:56:06 -0400
Date: Fri, 15 Jun 2012 11:55:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gong <gong.chen@linux.intel.com>
cc: tony.luck@intel.com, borislav.petkov@amd.com, x86@kernel.org,
        peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tmp patch to fix hotplug issue in CMCI storm
In-Reply-To: <4FDADB74.3060701@linux.intel.com>
Message-ID: <alpine.LFD.2.02.1206151122140.3086@ionos>
References: <alpine.LFD.2.02.1206080940360.3086@ionos> <1339681786-8418-1-git-send-email-gong.chen@linux.intel.com> <alpine.LFD.2.02.1206141554290.3086@ionos> <4FDADB74.3060701@linux.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-65378916-1339754158=:3086"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-65378916-1339754158=:3086
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 15 Jun 2012, Chen Gong wrote:
> 于 2012/6/14 22:07, Thomas Gleixner 写道:
> > On Thu, 14 Jun 2012, Chen Gong wrote:
> > > this patch is based on tip tree and previous 5 patches.
> > 
> > You really don't need all this complexity to handle that. The main
> > thing is that you clear the storm state and adjust the storm counter
> > when the cpu goes offline (in case the state is ACTIVE).
> > 
> > When it comes online again then you can simply let it restart cmci. If
> > the storm on this cpu (or node) still exists then it will notice and
> > everything falls in place.
> 
> I ever tested some different scenarios, if storm on this cpu still
> exists, it triggers the CMCI and broadcast it on the sibling CPU,
> which means the counter *cmci_storm_on_cpus* will increase beyond
> the upper limit. E.g. on a 2 sockets SandyBridge-EP system (one socket
> has 8 cores and 16 threads), inject one error on one socket, you can
> watch *cmci_storm_on_cpus* = 16 becuase of CMCI broadcast, during
> this time, offline and online one CPU on this socket, firstly
> *cmci_storm_on_cpus* = 15 because of offline and ACTIVE status, and then
> *cmci_storm_on_cpus* = 31 in that CMCI is actived because of
> online.That's why I have to disable CMCI during whole online/offline
> until CMCI storm is subsided. Frankly, the logic is a little bit
> complex so that I write many comments to avoid I forget it after some
> time :-)

This does not make any sense at all.

What you are saying is that even if CPU0 run cmci_clear() the CMCI
raised on CPU1 will cause the CMCI vector to be triggered on CPU0.

So how does the whole storm machinery work in the following case:

CPU0   	    	      CPU1
cmci incoming	      cmci incoming
     storm detected   	   no storm detected yet
     cmci_clear()
     switch to poll
		      
		      cmci raised

So according to your explanation that would cause the cmci vector to
be broadcasted to CPU0 as well. Now that would cause the counter to
get a bogus increment, right ?

So instead of hacking insane crap into the code, we have simply to do
the obvious Right Thing:

Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce_intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -119,6 +119,9 @@ static bool cmci_storm_detect(void)
 	unsigned long ts = __this_cpu_read(cmci_time_stamp);
 	unsigned long now = jiffies;
 
+	if (__this_cpu_read(cmci_storm_state) != CMCI_STORM_NONE)
+		return true;
+
 	if (time_before_eq(now, ts + CMCI_STORM_INTERVAL)) {
 		cnt++;
 	} else {

That will prevent damage under all circumstances, cpu hotplug
included. 

But that's too simple and comprehensible I fear.

Thanks,

	tglx
--8323328-65378916-1339754158=:3086--
