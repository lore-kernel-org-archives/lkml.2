Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab2BMQgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 11:36:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755282Ab2BMQgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 11:36:12 -0500
Date: Mon, 13 Feb 2012 11:35:46 -0500
From: Dave Jones <davej@redhat.com>
To: "N. Coesel" <nico@nctdev.nl>, linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Cpufreq shutdown patch (kernel 2.6.35.3)
Message-ID: <20120213163546.GA31316@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"N. Coesel" <nico@nctdev.nl>, linux-kernel@vger.kernel.org,
	Kay Sievers <kay.sievers@vrfy.org>
References: <CPSMTPM-CMT109lZGdO0011ecc5@CPSMTPM-CMT109.kpnxchange.com>
 <20120213162852.GA29947@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120213162852.GA29947@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 11:28:53AM -0500, Dave Jones wrote:
 > On Thu, Jan 19, 2012 at 10:18:10PM +0100, N. Coesel wrote:
 >  
 >  > I've found a problem in drivers/cpufreq/cpufreq.c. The driver does 
 >  > not execute the exit member of the low level driver when shutting 
 >  > down for a reboot (reset). This potentially leaves the power supply 
 >  > at a too low voltage to boot the system properly. The patch below 
 >  > adds a shutdown function which executes the exit member of the low 
 >  > level driver which allows a system to be properly prepared for a reset.
 > 
 > I'm curious what hardware you saw this problem on ?
 > 
 > I've just seen a report on an x86 system which looks like it might
 > be solved by this.
 > https://bugzilla.redhat.com/show_bug.cgi?id=789964
 > 
 >  > --- drivers/cpufreq/cpufreq.c.orig      2010-08-20 20:55:55.000000000 +0200
 >  > +++ drivers/cpufreq/cpufreq.c   2012-01-19 21:50:46.000000000 +0100
 >  > @@ -1431,11 +1431,34 @@ fail:
 >  >          return ret;
 >  >   }
 >  > 
 >  > +
 >  > +static int cpufreq_shutdown(struct sys_device *sysdev)
 >  > +{
 >  > +       struct cpufreq_policy *cpu_policy;
 >  > +       int cpu = sysdev->id;
 >  > +       int ret =0;
 >  > +
 >  > +       if (!cpu_online(cpu))
 >  > +               return 0;
 >  > +
 >  > +       cpu_policy = cpufreq_cpu_get(cpu);
 >  > +       if (!cpu_policy)
 >  > +               return -EINVAL;
 >  > +
 >  > +//     printk("cpufreq_shutdown %d \n", cpu);
 >  > +       if (cpufreq_driver->exit)
 >  > +               ret = cpufreq_driver->exit(cpu_policy);
 >  > +
 >  > +       return ret;
 >  > +}
 >  > +
 >  > +
 >  >   static struct sysdev_driver cpufreq_sysdev_driver = {
 >  >          .add            = cpufreq_add_dev,
 >  >          .remove         = cpufreq_remove_dev,
 >  >          .suspend        = cpufreq_suspend,
 >  >          .resume         = cpufreq_resume,
 >  > +       .shutdown = cpufreq_shutdown,
 >  >   };
 > 
 > I'll queue this up, with the whitespace fixed, and commented out line removed.

Except I can't of course, because we no longer have a sysdev driver
since 8a25a2fd126c621f44f3aeaef80d51f00fc11639
Kay, given the subsys_interface doesn't have a shutdown method, what should
this be doing ?

	Dave 
