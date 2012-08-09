Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab2HIKI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 06:08:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46406 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab2HIKIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 06:08:24 -0400
From: Thomas Renninger <trenn@suse.de>
To: Palmer Cox <p@lmercox.com>
Subject: Re: [PATCH 6/6] cpupower tools: Fix warning and a bug with the cpu package count
Date: Thu, 9 Aug 2012 12:07:36 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34.10-0.4-desktop; KDE/4.4.4; x86_64; ; )
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-kernel@vger.kernel.org
References: <1344306288-12369-1-git-send-email-p@lmercox.com> <1344306288-12369-7-git-send-email-p@lmercox.com>
In-Reply-To: <1344306288-12369-7-git-send-email-p@lmercox.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201208091207.36846.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 August 2012 04:24:48 Palmer Cox wrote:
> The pkgs member of cpupower_topology is being used as the number of
> cpu packages. As the comment in get_cpu_topology notes, the package ids
> are not guaranteed to be contiguous. So, simply setting pkgs to the value
> of the highest physical_package_id doesn't actually provide a count of
> the number of cpu packages. Instead, calculate pkgs by setting it to
> the number of distinct physical_packge_id values which is pretty easy
> to do after the core_info structs are sorted. Calculating pkgs this
> way also has the nice benefit of getting rid of a sign comparison warning
> that GCC 4.6 was reporting.
> ---
>  tools/power/cpupower/utils/helpers/topology.c |   18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/power/cpupower/utils/helpers/topology.c b/tools/power/cpupower/utils/helpers/topology.c
> index 4e2b583..fd3cc4d 100644
> --- a/tools/power/cpupower/utils/helpers/topology.c
> +++ b/tools/power/cpupower/utils/helpers/topology.c
> @@ -64,7 +64,7 @@ static int __compare(const void *t1, const void *t2)
>   */
>  int get_cpu_topology(struct cpupower_topology *cpu_top)
>  {
> -	int cpu, cpus = sysconf(_SC_NPROCESSORS_CONF);
> +	int cpu, last_pkg, cpus = sysconf(_SC_NPROCESSORS_CONF);
>  
>  	cpu_top->core_info = malloc(sizeof(struct cpuid_core_info) * cpus);
>  	if (cpu_top->core_info == NULL)
> @@ -78,20 +78,28 @@ int get_cpu_topology(struct cpupower_topology *cpu_top)
>  			"physical_package_id",
>  			&(cpu_top->core_info[cpu].pkg)) < 0)
>  			return -1;
> -		if ((int)cpu_top->core_info[cpu].pkg != -1 &&
> -		    cpu_top->core_info[cpu].pkg > cpu_top->pkgs)
> -			cpu_top->pkgs = cpu_top->core_info[cpu].pkg;
>  		if(sysfs_topology_read_file(
>  			cpu,
>  			"core_id",
>  			&(cpu_top->core_info[cpu].core)) < 0)
>  			return -1;
>  	}
> -	cpu_top->pkgs++;
>  
>  	qsort(cpu_top->core_info, cpus, sizeof(struct cpuid_core_info),
>  	      __compare);
>  
> +	/* Count the number of distinct pkgs values. This works
> +	   becuase the primary sort of of the core_info structs was just
becuase ... of of ... struct instead of structs

Otherwise the first 4 patches look like rather nice and straight forward
cleanups/fixes.
Feel free to add a Reviewed-by: Thomas Renninger <trenn@suse.de>

Let me have a closer look at patch 5 and 6. I had problems getting rid of
the compiler warning, looks like you found an easy way to clean this up.
I will be back and have time for this in the beginning of next week.

On which platforms (topology) did you test this?

   Thomas
