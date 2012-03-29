Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760080Ab2C2UrC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 16:47:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933784Ab2C2Uqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 16:46:30 -0400
Date: Thu, 29 Mar 2012 16:46:28 -0400
From: Aristeu Rozanski Filho <arozansk@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg K H <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 00/14] Fix the EDAC API
Message-ID: <20120329204628.GQ22979@redhat.com>
References: <1333040821-6253-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333040821-6253-1-git-send-email-mchehab@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 02:06:47PM -0300, Mauro Carvalho Chehab wrote:
> The EDAC API is broken for any memory controller that doesn't use
> a DIMM rank as its primary unit.
> 
> That covers RAMBUS and FB-DIMM drivers, where it is impossible to
> track a single rank, as the hank is hidden by a buffer controller
> (AMB - Advanced Memory Buffer, in the case of FB-DIMM).
> 
> Also, newer Intel architectures (Nehalem and Sandy Bridge) brings
> advanced memory controllers, where the cachesize can be different
> than 128 bits, and up to 4 channels can be interlaced. The current
> EDAC API doesn't work for those.
> 
> So, all drivers that need that do some sort of tricks to lie to the
> EDAC core, in order for the memory to be somehow exposed. There are
> several cases where this is done wrong.
> 
> The only way to fix is to create a new ABI capable of exporting what
> the driver actually sees, and not some virtual information, produced
> by the driver just to make the EDAC core happy.
> 
> As requested by Greg, the first step is to convert the EDAC MC code
> to use struct device. That means that 3 drivers also need to be
> converted (amd64, i7core and mpc85xx_edac), as they create their own
> ABI's.
> 
> Those patches were compile-tested on all architectures.
> 
> It was also tested on all types of Memory Controllers with EDAC support
> I was able to find at Red Hat Labs:
> 	e752x_edac (a Xeon i3100 chipset)
> 	i3000_edac
> 	i3200_edac
> 	i5000_edac
> 	i5100_edac
> 	i5400_edac
> 	i7300_edac
> 	i7core_edac (Nehalem)
> 	sb_edac (Sandy Bridge E5)
> 	amd64_edac
> 	
> Several of them with multiple memory controllers (the amd64 hardware
> I used is the bigger one, in terms of MC, with 8 memory controllers).
> 
> There are 3 intended changes that are out of this series:
> 
> 	- ABI documentation. I'll write the ABI patch as soon as I
> merge this series at -next;
> 
> 	- New API UE/CE error counters. They're needed, but, as the
> discussions weren't finished, let's postpone it. I'll start work on
> it after the merge of this series.
> 
> 	- MCA error trace. Also, there wasn't any agreement yet.
> So, keep this out of this series, until we come to some conclusion.
> 
> Regards,
> Mauro
> 
> Mauro Carvalho Chehab (14):
>   edac: rewrite the sysfs code to use struct device
>   mpc85xx_edac: convert sysfs logic to use struct device
>   amd64_edac: convert sysfs logic to use struct device
>   i7core_edac: convert it to use struct device
>   edac: Get rid of the old kobj's from the edac mc code
>   edac: add a new per-dimm API and make the old per-virtual-rank API
>     obsolete
>   edac: add a sysfs node to report the maximum location for the system
>   edac: Add debufs nodes to allow doing fake error inject
>   edac: Create a per-Memory Controller bus
>   edac: Move grain/dtype/edac_type calculus to be out of channel loop
>   i82975x_edac: Test nr_pages earlier to save a few CPU cycles
>   i5100_edac: Fix a warning when compiled with 32 bits
>   i7300_edac: Get rid of some wrongly-solved rebase conflict
>   edac: Only expose csrows/channels on legacy API if they're populated
> 
>  drivers/edac/Kconfig          |    8 +
>  drivers/edac/amd64_edac.c     |   43 +-
>  drivers/edac/amd64_edac.h     |   29 +-
>  drivers/edac/amd64_edac_dbg.c |   89 ++--
>  drivers/edac/amd64_edac_inj.c |  128 +++--
>  drivers/edac/cpc925_edac.c    |   54 +-
>  drivers/edac/e752x_edac.c     |   31 +-
>  drivers/edac/e7xxx_edac.c     |   32 +-
>  drivers/edac/edac_mc.c        |   60 +-
>  drivers/edac/edac_mc_sysfs.c  | 1322 +++++++++++++++++++++--------------------
>  drivers/edac/edac_module.c    |   13 +-
>  drivers/edac/edac_module.h    |    9 +-
>  drivers/edac/i5000_edac.c     |    3 -
>  drivers/edac/i5100_edac.c     |    4 +-
>  drivers/edac/i7300_edac.c     |    3 -
>  drivers/edac/i7core_edac.c    |  336 +++++++----
>  drivers/edac/i82875p_edac.c   |    4 -
>  drivers/edac/i82975x_edac.c   |    9 +-
>  drivers/edac/mpc85xx_edac.c   |   93 ++--
>  include/linux/edac.h          |   69 +--
>  20 files changed, 1250 insertions(+), 1089 deletions(-)
Reviewed-by: Aristeu Rozanski <arozansk@redhat.com>

-- 
Aristeu

