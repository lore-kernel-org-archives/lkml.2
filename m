Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab1DCQTI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 12:19:08 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60762 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab1DCQTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 12:19:05 -0400
Date: Sun, 3 Apr 2011 21:48:56 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Len Brown <lenb@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Trinabh Gupta <trinabh@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, suresh.b.siddha@intel.com,
        benh@kernel.crashing.org, venki@google.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: cpuidle asymmetry (was Re: [RFC PATCH V4 5/5] cpuidle: cpuidle
 driver for apm)
Message-ID: <20110403161856.GB3376@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <4D89CA7D.8080108@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1103231623450.12911@x980>
 <4D8B550D.5000409@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1103250321480.32565@x980>
 <20110325180156.GC19214@dirshya.in.ibm.com>
 <alpine.LFD.2.02.1103302203490.1920@x980>
 <1301577536.4859.249.camel@twins>
 <alpine.LFD.2.02.1104010006210.2797@x980>
 <20110401081522.GA22339@in.ibm.com>
 <4D95E35F.2080707@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D95E35F.2080707@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 07:38:23AM -0700, Arjan van de Ven wrote:
> On 4/1/2011 1:15 AM, Dipankar Sarma wrote:
> >On Fri, Apr 01, 2011 at 12:09:25AM -0400, Len Brown wrote:
> >>>>Moorestown is already an example of an asymmetric system,
> >>>>since its deepest c-state is available on cpu0, but not on cpu1.
> >>>>So it needs different tables for each cpu.
> >>>wtf are these hardware guys smoking and how the heck are we supposed to
> >>>schedule on such a machine? Prefer to keep cpu1 busy while idling cpu0?
> >>they are smoking micro-amps:-)
> >>
> >>S0i3 on cpu0 can be entered only after cpu1 is already off-line,
> >>among other system hardware dependencies...
> >>
> >>So it makes no sense to export S0i3 as a c-state on cpu1.
> >>
> >>When cpu1 is online, the scheduler treats it as a normal SMP.
> >Isn't S0i3 a "system" state, as opposed to cpu state ?
> 
> it's misnamed. it's a C state to the OS.

I understand that it has been implemented as a C-state from this -
http://build.meego.com/package/view_file?file=linux-2.6.37-mrst-s0i3.patch&package=kernel-adaptation-mrst&project=home%3Adliu9&srcmd5=a0929a2863150f5c8454507d6cd8f09d

The key question is this -

+int mrst_check_state_availability(struct cpuidle_device *dev)  
+{  
+   int cpu = smp_processor_id();  
+ 
+   /*  
+    * If there is another CPU running, the GPU is active,  
+    * the PMU is uninitialized, or there is a still-unprocessed  
+    * PMU command, we cannot enter S0i3.  
+    */  
+   if (!pmu_reg || !cpumask_equal(cpu_online_mask, cpumask_of(cpu)) ||  
+       s0i3_pmu_command_pending)  
+       dev->states[5].flags |= CPUIDLE_FLAG_IGNORE;  
+   else  
+       dev->states[5].flags &= ~CPUIDLE_FLAG_IGNORE;  

Is this really asymetric ? Or is it that if the other
cpu(s) are in C6, the chip can enter S0i3 ? If that is the case,
then isn't this equivalent to all the cpus in the chip
entering S0i3 and thus symmetrical ? Also, if going to S0i3
relies on other cpus offlined, then we don't need to
worry about asymetry from the scheduler/cpuidle point of
view, no ?

Thanks
Dipankar
