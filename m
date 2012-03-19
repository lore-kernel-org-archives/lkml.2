Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab2CSA60 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 20:58:26 -0400
Received: from mga14.intel.com ([143.182.124.37]:34102 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049Ab2CSA6Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 20:58:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="78960919"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: RE: [PATCH] Fix the race between smp_call_function and CPU booting
Thread-Topic: [PATCH] Fix the race between smp_call_function and CPU booting
Thread-Index: AQHNA1ocb15RzWBzFUygeaTQHM0/VZZwzvhA
Date: Mon, 19 Mar 2012 00:58:21 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A058AAE@SHSMSX101.ccr.corp.intel.com>
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
In-Reply-To: <1331891364.18960.221.camel@twins>
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



> -----Original Message-----
> From: Peter Zijlstra [mailto:peterz@infradead.org]
> Sent: Friday, March 16, 2012 5:49 PM
> To: Liu, Chuansheng
> Cc: linux-kernel@vger.kernel.org; Yanmin Zhang; tglx@linutronix.de
> Subject: RE: [PATCH] Fix the race between smp_call_function and CPU booting
> 
> On Fri, 2012-03-16 at 06:24 +0000, Liu, Chuansheng wrote:
> 
> > Based on your patch, I did a little modification, how do you think of that?
> 
> > --- a/kernel/cpu.c
> > +++ b/kernel/cpu.c
> > @@ -640,8 +640,10 @@ void set_cpu_present(unsigned int cpu, bool
> > present)
> >
> >  void set_cpu_online(unsigned int cpu, bool online)  {
> > -       if (online)
> > +       if (online) {
> >                 cpumask_set_cpu(cpu, to_cpumask(cpu_online_bits));
> > +               cpumask_set_cpu(cpu, to_cpumask(cpu_active_bits));
> > +       }
> >         else
> >                 cpumask_clear_cpu(cpu, to_cpumask(cpu_online_bits));
> > }
> 
> I'm thinking this lacks rationale. What was wrong, Why does this fix it.
> If you can't answer that stop tinkering and start thinking.
Your patch advance the setting active bit before online setting, that will cause
an warning error, I just move the setting active bit after setting online setting, it can fix
the warning error, and it can fix the race issue between smp_call_function and CPU booting.

I have tested it by some stress tests.

