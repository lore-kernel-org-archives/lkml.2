Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab2CMXbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 19:31:45 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38096 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab2CMXbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 19:31:43 -0400
Date: Tue, 13 Mar 2012 16:31:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] edac: Add a sysfs node to test the EDAC error report
 facility
Message-ID: <20120313233138.GA31106@kroah.com>
References: <1331122101-28382-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331122101-28382-1-git-send-email-mchehab@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 09:08:21AM -0300, Mauro Carvalho Chehab wrote:
> Even on memory controllers that have memory injection, such functionality
> can be disabled by BIOS during bootstrap, and it may not be possible to
> enable it via BIOS setup.
> 
> So, as not all hardware supports error injection, add a mechanism to
> allow testing the edac driver and the core.
> 
> This feature is only enabled when EDAC_DEBUG is equal to Y, so there's no
> extra code for the production Kernels.

Then please move it to debugfs, where debugging stuff belongs.

At the least, you need to document all sysfs files in Documentation/ABI/

> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
> 
> NOTE: This patch should be applied after the series that add proper support for
> FB-DIMM, due to context changes.
> 
>  drivers/edac/edac_mc_sysfs.c |   62 ++++++++++++++++++++++++++++++++++++++++-
>  include/linux/edac.h         |    4 +++
>  2 files changed, 64 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
> index 870ccb0..f538f9e 100644
> --- a/drivers/edac/edac_mc_sysfs.c
> +++ b/drivers/edac/edac_mc_sysfs.c
> @@ -744,6 +744,42 @@ static ssize_t mci_size_mb_show(struct mem_ctl_info *mci, char *data,
>  	return sprintf(data, "%u\n", PAGES_TO_MiB(total_pages));
>  }
>  
> +#ifdef CONFIG_EDAC_DEBUG
> +static ssize_t edac_fake_inject_show(struct mem_ctl_info *mci,
> +				     char *data, void *priv)
> +{
> +	return sprintf(data,
> +		       "EDAC fake test engine. Writing to this node a value in the form of :\n"
> +		       "\t0:1:0\n"
> +		       "will call the EDAC core routine to produce a memory error for the given memory location (0, 1, 0).\n"
> +		       "The driver's error parsing logic won't be tested. This tool is useful only\n"
> +		       "if you're testing the EDAC core tracing facility, or if you're needing to test\n"
> +		       "some userspace application.\n");
> +}

Ick, no NEVER do this for a sysfs file, even for "debugging", that's
what debugfs is for, please move this file there, this isn't ok.

Again, sysfs is "one value per file".

thanks,

greg k-h
