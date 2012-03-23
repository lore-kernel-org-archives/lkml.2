Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab2CWLcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 07:32:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:41872 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755685Ab2CWLcq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 07:32:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="80810715"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: RE: [PATCH] Fix the race between smp_call_function and CPU booting
Thread-Topic: [PATCH] Fix the race between smp_call_function and CPU booting
Thread-Index: AQHNCN9MKF1rJY3aXUun4qztc3puMZZ3vcqg
Date: Fri, 23 Mar 2012 11:32:43 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A05D65B@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A053BE8@SHSMSX101.ccr.corp.intel.com>
	 <1331546307.18960.26.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A054D70@SHSMSX101.ccr.corp.intel.com>
	 <1331654251.18960.78.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A0556FA@SHSMSX101.ccr.corp.intel.com>
	 <1331718197.18960.106.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A056F47@SHSMSX101.ccr.corp.intel.com>
	 <1331808391.18960.160.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05806B@SHSMSX101.ccr.corp.intel.com>
	 <1331891364.18960.221.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A058AAE@SHSMSX101.ccr.corp.intel.com>
	 <1332151397.18960.252.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05A6BF@SHSMSX101.ccr.corp.intel.com>
	 <1332245842.18960.413.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05B485@SHSMSX101.ccr.corp.intel.com>
	 <1332332739.18960.488.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05C092@SHSMSX101.ccr.corp.intel.com>
 <1332498333.16159.9.camel@twins>
In-Reply-To: <1332498333.16159.9.camel@twins>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In fact, I started two scripts running:
1/ One script:
echo 0 > /sys/devices/system/cpuX/online
echo 1 > /sys/devices/system/cpuX/online
Rerunning the above commands in loop

2/Another script:
echo 1 > /debug/smp_call_test
usleep 50000
Rerunning the above command in loop

This race issue can be easy to be reproduced in several minutes;
For simplify your test as mine(just two CPUs), you can set other non-booting CPUs as offline
at first and just leave one non-booting CPU.

> -----Original Message-----
> From: Peter Zijlstra [mailto:peterz@infradead.org]
> Sent: Friday, March 23, 2012 6:26 PM
> To: Liu, Chuansheng
> Cc: linux-kernel@vger.kernel.org; Yanmin Zhang; tglx@linutronix.de; Srivatsa S.
> Bhat
> Subject: RE: [PATCH] Fix the race between smp_call_function and CPU booting
> 
> On Thu, 2012-03-22 at 00:59 +0000, Liu, Chuansheng wrote:
> > Below is the complete test patch. Just run the simpl_loop_onoffline.sh
> > and simpl_loop_smpcalling.sh concurrently to reproduce the race.
> >
> What I did was:
> 
> for i in {2..23} ; do echo 0 > /sys/devices/system/cpu/cpu${i}/online ; done while
> usleep 50000 ; do echo 1 > /debug/smp_call_test ; done & while :; do echo $i >
> /sys/devices/system/cpu/cpu1/online ; let i^=1 ; done
> 
> and this has been running for well over 30 minutes.. is there anything else one
> needs to do?
> 

