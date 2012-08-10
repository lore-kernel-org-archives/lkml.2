Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760114Ab2HJC66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 22:58:58 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:48092 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab2HJC6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 22:58:55 -0400
Date: Thu, 9 Aug 2012 22:58:51 -0400
From: Palmer Cox <p@lmercox.com>
To: Thomas Renninger <trenn@suse.de>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] cpupower tools: Fix warning and a bug with the cpu
 package count
Message-ID: <20120810025851.GA4609@gmail.com>
References: <1344306288-12369-1-git-send-email-p@lmercox.com>
 <1344306288-12369-7-git-send-email-p@lmercox.com>
 <201208091207.36846.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208091207.36846.trenn@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 12:07:36PM +0200, Thomas Renninger wrote:
> On Tuesday 07 August 2012 04:24:48 Palmer Cox wrote:
> > The pkgs member of cpupower_topology is being used as the number of
> > cpu packages. As the comment in get_cpu_topology notes, the package ids
> > are not guaranteed to be contiguous. So, simply setting pkgs to the value
> > of the highest physical_package_id doesn't actually provide a count of
> > the number of cpu packages. Instead, calculate pkgs by setting it to
> > the number of distinct physical_packge_id values which is pretty easy
> > to do after the core_info structs are sorted. Calculating pkgs this
> > way also has the nice benefit of getting rid of a sign comparison warning
> > that GCC 4.6 was reporting.
> > ---
> >  tools/power/cpupower/utils/helpers/topology.c |   18 +++++++++++++-----
> >  1 file changed, 13 insertions(+), 5 deletions(-)
> > 
> > diff --git a/tools/power/cpupower/utils/helpers/topology.c b/tools/power/cpupower/utils/helpers/topology.c
> > index 4e2b583..fd3cc4d 100644
> > --- a/tools/power/cpupower/utils/helpers/topology.c
> > +++ b/tools/power/cpupower/utils/helpers/topology.c
> > @@ -64,7 +64,7 @@ static int __compare(const void *t1, const void *t2)
> >   */
> >  int get_cpu_topology(struct cpupower_topology *cpu_top)
> >  {
> > -	int cpu, cpus = sysconf(_SC_NPROCESSORS_CONF);
> > +	int cpu, last_pkg, cpus = sysconf(_SC_NPROCESSORS_CONF);
> >  
> >  	cpu_top->core_info = malloc(sizeof(struct cpuid_core_info) * cpus);
> >  	if (cpu_top->core_info == NULL)
> > @@ -78,20 +78,28 @@ int get_cpu_topology(struct cpupower_topology *cpu_top)
> >  			"physical_package_id",
> >  			&(cpu_top->core_info[cpu].pkg)) < 0)
> >  			return -1;
> > -		if ((int)cpu_top->core_info[cpu].pkg != -1 &&
> > -		    cpu_top->core_info[cpu].pkg > cpu_top->pkgs)
> > -			cpu_top->pkgs = cpu_top->core_info[cpu].pkg;
> >  		if(sysfs_topology_read_file(
> >  			cpu,
> >  			"core_id",
> >  			&(cpu_top->core_info[cpu].core)) < 0)
> >  			return -1;
> >  	}
> > -	cpu_top->pkgs++;
> >  
> >  	qsort(cpu_top->core_info, cpus, sizeof(struct cpuid_core_info),
> >  	      __compare);
> >  
> > +	/* Count the number of distinct pkgs values. This works
> > +	   becuase the primary sort of of the core_info structs was just
> becuase ... of of ... struct instead of structs

Oof. I'm not winning any grammar medals for this. Thanks for
noticing.
> 
> Otherwise the first 4 patches look like rather nice and straight forward
> cleanups/fixes.
> Feel free to add a Reviewed-by: Thomas Renninger <trenn@suse.de>

Will do. Thanks!
> 
> Let me have a closer look at patch 5 and 6. I had problems getting rid of
> the compiler warning, looks like you found an easy way to clean this up.
> I will be back and have time for this in the beginning of next week.

Thanks for the review! Let me know if there is anything in patches 5
and 6 that needs cleaning up and I'll be happy to do it. I only have
access to a laptop with a single package 2 core Centrino2 processor.
I tested each patch in the series on my laptop running a 64-bit 3.5
kernel to make sure that everything functioned. I'm no expert in the
exact expected output of the tool, but the only impact that I
believe these patches should have is the output of the number of cpu
packages. I tested this on my system which resulted in reporting
just a single cpu package as I expected, but I don't have access to
a system with multiple cpu packages to test on.

> 
> On which platforms (topology) did you test this?
> 
>    Thomas

-Palmer
