Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab1ALHRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 02:17:46 -0500
Received: from vms173013pub.verizon.net ([206.46.173.13]:42543 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884Ab1ALHRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 02:17:35 -0500
Date: Wed, 12 Jan 2011 02:17:18 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Thomas Renninger <trenn@suse.de>
Cc: linux-perf-users@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
        j-pihet@ti.com, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] acpi: processor->cpuidle: Only set cpuidle check_bm
 flag if pr->flags.bm_check is set
In-reply-to: <1294396190-23031-6-git-send-email-trenn@suse.de>
Message-id: <alpine.LFD.2.02.1101120159400.19140@x980>
References: <1294396190-23031-1-git-send-email-trenn@suse.de>
 <1294396190-23031-6-git-send-email-trenn@suse.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Jan 2011, Thomas Renninger wrote:

>  drivers/acpi/processor_idle.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index b28693e..82f74c9 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -1039,7 +1039,8 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
>  			snprintf(state->abbr, CPUIDLE_ABBR_LEN, "C3");
>  			state->flags |= CPUIDLE_FLAG_DEEP;
>  			state->flags |= CPUIDLE_FLAG_TIME_VALID;
> -			state->flags |= CPUIDLE_FLAG_CHECK_BM;
> +			if (pr->flags.bm_check)
> +				state->flags |= CPUIDLE_FLAG_CHECK_BM;
>  			state->enter = pr->flags.bm_check ?
>  					acpi_idle_enter_bm :
>  					acpi_idle_enter_simple;
> -- 

While it is logical, this patch is a NO-OP, since nobody
ever checks for state->flags |= CPUIDLE_FLAG_CHECK_BM --
not cpuidle, and not the platform driver.

ie. it would be better to delete use of this flag from this file.

This points out a problem w/ cpuidle, of course.
Who owns and defines state->flags -- cpuidle and its governors,
or the cpuidle drivers?

cpuidle and its governors look only at...
CPUIDLE_FLAG_TIME_VALID and CPUIDLE_FLAG_IGNORE

cpuidle sets, but never looks at, CPUIDLE_FLAG_POLL

only intel_idle uses CPUIDLE_FLAG_TLB_FLUSHED,
so it should probably define it.

only OMAP uses CPUIDLE_FLAG_CHECK_BM,
so it should define it (or create a flag
that actually says what they mean here)

CPUIDLE_FLAG_SHALLOW, CPUIDLE_FLAG_BALANCED, CPUIDLE_FLAG_DEEP
are set in various architectures, but never checked,
so they should be deleted.

thanks,
Len Brown, Intel Open Source Technology Center


