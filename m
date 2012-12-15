Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326Ab2LOGlI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 01:41:08 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:59966 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2LOGlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 01:41:06 -0500
Message-ID: <1355553634.4731.13.camel@marge.simpson.net>
Subject: Re: [RFC PATCH v2 3/6] sched: pack small tasks
From: Mike Galbraith <bitbucket@online.de>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Alex Shi <alex.shi@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, linux@arm.linux.org.uk,
        pjt@google.com, santosh.shilimkar@ti.com, Morten.Rasmussen@arm.com,
        chander.kashyap@linaro.org, cmetcalf@tilera.com, tony.luck@intel.com,
        preeti@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, viresh.kumar@linaro.org
Date: Sat, 15 Dec 2012 07:40:34 +0100
In-Reply-To: <CAKfTPtDw6Tk6oVut5REBsbCoHD3JE0ajHKp=aYhwx0j9NiTKGQ@mail.gmail.com>
References: <1355319092-30980-1-git-send-email-vincent.guittot@linaro.org>
	 <1355319092-30980-4-git-send-email-vincent.guittot@linaro.org>
	 <50C93AC1.1060202@intel.com>
	 <CAKfTPtB9iz1ePsS+juQVRhuWREYB1duGWRJT7ya8XBXPhC-mkw@mail.gmail.com>
	 <50C9E552.1010600@intel.com> <1355460356.5777.12.camel@marge.simpson.net>
	 <50CAC905.9070100@intel.com> <1355471146.7641.13.camel@marge.simpson.net>
	 <CAKfTPtDw6Tk6oVut5REBsbCoHD3JE0ajHKp=aYhwx0j9NiTKGQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:Kv9uEI9l59B6pzhMm0N2DLvbtM3diCx6jCCvYmQSsyd
 2tI7tZ9ERvBrNKTbZhDsi2F2o9Ilod+nZp1NveAsgMf5zDJE/x
 BJrWzu9+sl7njfmDS/wBdlEyvv4KaFP5Wg0BCVTLreOgKewM9w
 FMuyLyK2JLOWyHeNMXChf668CspVMzWzmb86/HsDzcpw0MbqPD
 UskTkGrZX5M739ZkFMeJpbVSzpFe6+K9RuLmtO6OMziDei5rS2
 aX+wXvaSK0fDn49QLD7l9LWFsF1OAzt/OC+hlOr5ck7Tmpfs3M
 eLaguUZlqwyZdhpI324vXxUnhjNVyvi9+7ex2WepDCjvK82eB4
 +48jFMNkPG6JFQXctXubI3nJg2B7qbxIuqf2jqToDXQLOTyrxW
 Mx0nqw5+0fL/g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-14 at 11:43 +0100, Vincent Guittot wrote: 
> On 14 December 2012 08:45, Mike Galbraith <bitbucket@online.de> wrote:
> > On Fri, 2012-12-14 at 14:36 +0800, Alex Shi wrote:
> >> On 12/14/2012 12:45 PM, Mike Galbraith wrote:
> >> >> > Do you have further ideas for buddy cpu on such example?
> >> >>> > >
> >> >>> > > Which kind of sched_domain configuration have you for such system ?
> >> >>> > > and how many sched_domain level have you ?
> >> >> >
> >> >> > it is general X86 domain configuration. with 4 levels,
> >> >> > sibling/core/cpu/numa.
> >> > CPU is a bug that slipped into domain degeneration.  You should have
> >> > SIBLING/MC/NUMA (chasing that down is on todo).
> >>
> >> Maybe.
> >> the CPU/NUMA is different on domain flags, CPU has SD_PREFER_SIBLING.
> >
> > What I noticed during (an unrelated) bisection on a 40 core box was
> > domains going from so..
> >
> > 3.4.0-bisect (virgin)
> > [    5.056214] CPU0 attaching sched-domain:
> > [    5.065009]  domain 0: span 0,32 level SIBLING
> > [    5.075011]   groups: 0 (cpu_power = 589) 32 (cpu_power = 589)
> > [    5.088381]   domain 1: span 0,4,8,12,16,20,24,28,32,36,40,44,48,52,56,60,64,68,72,76 level MC
> > [    5.107669]    groups: 0,32 (cpu_power = 1178)  4,36 (cpu_power = 1178)  8,40 (cpu_power = 1178) 12,44 (cpu_power = 1178)
> >                          16,48 (cpu_power = 1177) 20,52 (cpu_power = 1178) 24,56 (cpu_power = 1177) 28,60 (cpu_power = 1177)
> >                          64,72 (cpu_power = 1176) 68,76 (cpu_power = 1176)
> > [    5.162115]    domain 2: span 0-79 level NODE
> > [    5.171927]     groups: 0,4,8,12,16,20,24,28,32,36,40,44,48,52,56,60,64,68,72,76 (cpu_power = 11773)
> >                            1,5,9,13,17,21,25,29,33,37,41,45,49,53,57,61,65,69,73,77 (cpu_power = 11772)
> >                            2,6,10,14,18,22,26,30,34,38,42,46,50,54,58,62,66,70,74,78 (cpu_power = 11773)
> >                            3,7,11,15,19,23,27,31,35,39,43,47,51,55,59,63,67,71,75,79 (cpu_power = 11770)
> >
> > ..to so, which looks a little bent.  CPU and MC have identical spans, so
> > CPU should have gone away, as it used to do.
> >
> > 3.6.0-bisect (virgin)
> > [    3.978338] CPU0 attaching sched-domain:
> > [    3.987125]  domain 0: span 0,32 level SIBLING
> > [    3.997125]   groups: 0 (cpu_power = 588) 32 (cpu_power = 589)
> > [    4.010477]   domain 1: span 0,4,8,12,16,20,24,28,32,36,40,44,48,52,56,60,64,68,72,76 level MC
> > [    4.029748]    groups: 0,32 (cpu_power = 1177)  4,36 (cpu_power = 1177)  8,40 (cpu_power = 1178) 12,44 (cpu_power = 1178)
> >                          16,48 (cpu_power = 1178) 20,52 (cpu_power = 1178) 24,56 (cpu_power = 1178) 28,60 (cpu_power = 1178)
> >                          64,72 (cpu_power = 1178) 68,76 (cpu_power = 1177)
> > [    4.084143]    domain 2: span 0,4,8,12,16,20,24,28,32,36,40,44,48,52,56,60,64,68,72,76 level CPU
> > [    4.103796]     groups: 0,4,8,12,16,20,24,28,32,36,40,44,48,52,56,60,64,68,72,76 (cpu_power = 11777)
> > [    4.124373]     domain 3: span 0-79 level NUMA
> > [    4.134369]      groups: 0,4,8,12,16,20,24,28,32,36,40,44,48,52,56,60,64,68,72,76 (cpu_power = 11777)
> >                             1,5,9,13,17,21,25,29,33,37,41,45,49,53,57,61,65,69,73,77 (cpu_power = 11778)
> >                             2,6,10,14,18,22,26,30,34,38,42,46,50,54,58,62,66,70,74 ,78 (cpu_power = 11778)
> >                             3,7,11,15,19,23,27,31,35,39,43,47,51,55,59,63,67,71,75,79 (cpu_power = 11780)
> >
> 
> Thanks. that's an interesting example of a numa topology
> 
> For your sched_domain difference,
> On 3.4, SD_PREFER_SIBLING was set for both MC and CPU level thanks to
> sd_balance_for_mc_power and  sd_balance_for_package_power
> On 3.6, SD_PREFER_SIBLING is only set for CPU level and this flag
> difference with MC level prevents the destruction of CPU sched_domain
> during the degeneration
> 
> We may need to set SD_PREFER_SIBLING for MC level

Ah, that explains oddity. (todo--).

Hm, seems changing flags should trigger a rebuild. (todo++,drat).

-Mike

