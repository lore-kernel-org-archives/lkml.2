Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab2CBOx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 09:53:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522Ab2CBOx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 09:53:26 -0500
Message-ID: <4F50DECB.8030200@redhat.com>
Date: Fri, 02 Mar 2012 11:52:59 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 4/4] EDAC: Convert AMD EDAC pieces to use RAS printk buffer
References: <1330698314-9863-1-git-send-email-bp@amd64.org> <1330698314-9863-5-git-send-email-bp@amd64.org>
In-Reply-To: <1330698314-9863-5-git-send-email-bp@amd64.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 02-03-2012 11:25, Borislav Petkov escreveu:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> This is an initial version of the patch which converts MCE decoding
> facilities to use the RAS printk buffer. When there's no userspace agent
> running (i.e., /sys/devices/system/ras/agent == 0), we fall back to the
> default printk's into dmesg which is what we've been doing so far.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  drivers/edac/amd64_edac.c |    8 ++-
>  drivers/edac/edac_mc.c    |   42 ++++++---
>  drivers/edac/mce_amd.c    |  217 ++++++++++++++++++++++++---------------------
>  3 files changed, 149 insertions(+), 118 deletions(-)
> 
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index 08413377a43b..29e153c57e33 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -1,6 +1,7 @@
> -#include "amd64_edac.h"
>  #include <asm/amd_nb.h>
> +#include <asm/ras.h>
>  
> +#include "amd64_edac.h"
>  static struct edac_pci_ctl_info *amd64_ctl_pci;
>  
>  static int report_gart_errors;
> @@ -1901,7 +1902,10 @@ static void amd64_handle_ce(struct mem_ctl_info *mci, struct mce *m)
>  	sys_addr = get_error_address(m);
>  	syndrome = extract_syndrome(m->status);
>  
> -	amd64_mc_err(mci, "CE ERROR_ADDRESS= 0x%llx\n", sys_addr);
> +	if (ras_agent)
> +		ras_printk(PR_EMERG, "ERR_ADDR: 0x%llx", sys_addr);
> +	else
> +		amd64_mc_err(mci, "CE ERROR_ADDRESS= 0x%llx\n", sys_addr);
>  
>  	pvt->ops->map_sysaddr_to_csrow(mci, sys_addr, syndrome);
>  }
> diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
> index ca6c04d350ee..3b3db477b5d0 100644
> --- a/drivers/edac/edac_mc.c
> +++ b/drivers/edac/edac_mc.c
> @@ -30,8 +30,10 @@
>  #include <asm/uaccess.h>
>  #include <asm/page.h>
>  #include <asm/edac.h>
> +#include <asm/ras.h>
>  #include "edac_core.h"
>  #include "edac_module.h"
> +#include "mce_amd.h"
>  
>  /* lock to memory controller's control array */
>  static DEFINE_MUTEX(mem_ctls_mutex);
> @@ -701,14 +703,22 @@ void edac_mc_handle_ce(struct mem_ctl_info *mci,
>  		return;
>  	}
>  
> -	if (edac_mc_get_log_ce())
> -		/* FIXME - put in DIMM location */
> -		edac_mc_printk(mci, KERN_WARNING,
> -			"CE page 0x%lx, offset 0x%lx, grain %d, syndrome "
> -			"0x%lx, row %d, channel %d, label \"%s\": %s\n",
> -			page_frame_number, offset_in_page,
> -			mci->csrows[row].grain, syndrome, row, channel,
> -			mci->csrows[row].channels[channel].label, msg);
> +	if (edac_mc_get_log_ce()) {
> +		if (ras_agent)
> +			ras_printk(PR_CONT, ", row: %d, channel: %d\n",
> +				   row, channel);
> +		else
> +			/* FIXME - put in DIMM location */
> +			edac_mc_printk(mci, KERN_WARNING,
> +					"CE page 0x%lx, offset 0x%lx, grain %d,"
> +					" syndrome 0x%lx, row %d, channel %d,"
> +					" label \"%s\": %s\n",
> +					page_frame_number, offset_in_page,
> +					mci->csrows[row].grain, syndrome,
> +					row, channel,
> +					mci->csrows[row].channels[channel].label,
> +					msg);
> +	}


As I've commented already, This piece of the code is not ok, due
to several reasons:

	- the "ras_agent" helper functions is used only for amd64_edac. There's
no reason for use it elsewhere;

	- the code here is adding the location only for CE errors. The location
of the error is also pertinent for the other types of errors;

	- on my patches, this function disappears, being replaced by a single
function, that can be used to report all types of memory errors;

	- non MCA drivers should also generate tracepoints;

	- it is a way easier to add just one call to the tracepoint function here, than
to spread on all drivers.

As it is shown at:
	http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-edac.git;a=commitdiff_plain;h=4eb2a29419c1fefd76c8dbcd308b84a4b52faf4d

Once we made an agreement with regards to the tracepoint function, 
a change similar to what it was proposed there, e. g.:

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 37d2c97..2dca0e3 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -899,7 +899,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			  const int layer2,
 			  const char *msg,
 			  const char *other_detail,
-			  const void *mcelog)
+			  const void *arch_log)
 {
 	unsigned long remapped_page;
 	/* FIXME: too much for stack: move it to some pre-alocated area */
@@ -1033,8 +1047,17 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			"page 0x%lx offset 0x%lx grain %d\n",
 			page_frame_number, offset_in_page, grain);
 
+#ifdef CONFIG_X86
+	if (arch_log)
+		trace_mc_error_mce(type, mci->mc_idx, msg, label, location,
+				   detail, other_detail, arch_log);
+	else
+		trace_mc_error(type, mci->mc_idx, msg, label, location,
+			       detail, other_detail);
+#else
 	trace_mc_error(type, mci->mc_idx, msg, label, location,
 		       detail, other_detail);
+#endif
 
 	if (type == HW_EVENT_ERR_CORRECTED) {
 		if (edac_mc_get_log_ce())

is enough to generate traces for all existing drivers.

Regards,
Mauro
