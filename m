Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab2A0F0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 00:26:20 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:48580 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab2A0F0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 00:26:19 -0500
Message-ID: <4F223571.8090300@linux.vnet.ibm.com>
Date: Fri, 27 Jan 2012 10:56:09 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@infradead.org, robert.richter@amd.com, ming.m.lin@intel.com,
        andi@firstfloor.org, asharma@fb.com, ravitillo@lbl.gov,
        vweaver1@eecs.utk.edu
Subject: Re: [PATCH 04/13] perf_events: sync branch stack sampling with X86
 precise_sampling (v3)
References: <1326127761-2723-1-git-send-email-eranian@google.com> <1326127761-2723-5-git-send-email-eranian@google.com>
In-Reply-To: <1326127761-2723-5-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12012619-5140-0000-0000-000000A840C5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 January 2012 10:19 PM, Stephane Eranian wrote:
> If precise sampling is enabled on Intel X86, then perf_event uses PEBS.
> To correct for the off-by-one error of PEBS, perf_event uses LBR when
> precise_sample > 1.
> 
> On Intel X86 PERF_SAMPLE_BRANCH_STACK is implemented using LBR,
> therefore both features must be coordinated as they may not
> configure LBR the same way.
> 
> For PEBS, LBR needs to capture all branches at all priv levels.
> This patch sets this up.
> 
> The configuration of PERF_SAMPLE_BRANCH_STACK may not be compatible
> in which case an error must be returned.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
  Reviewed   by: Anshuman Khandual<khandual@linux.vnet.ibm.com>
> ---
>  arch/x86/kernel/cpu/perf_event.c |   22 ++++++++++++++++++++++
>  1 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 3779313..710ec93 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -356,6 +356,7 @@ int x86_setup_perfctr(struct perf_event *event)
>  int x86_pmu_hw_config(struct perf_event *event)
>  {
>  	if (event->attr.precise_ip) {
> +		u64 *br_type, br_sel;
>  		int precise = 0;
> 
>  		/* Support for constant skid */
> @@ -369,6 +370,27 @@ int x86_pmu_hw_config(struct perf_event *event)
> 
>  		if (event->attr.precise_ip > precise)
>  			return -EOPNOTSUPP;
> +		/*
> +		 * check that PEBS LBR correction does not conflict with
> +		 * whatever the user is asking with attr->branch_sample_type
> +		 */
> +		if (event->attr.precise_ip > 1) {
> +
> +			br_type = &event->attr.branch_sample_type;
> +
> +			if (has_branch_stack(event)) {
> +				br_sel = *br_type & PERF_SAMPLE_BRANCH_ANY;
> +				if (br_sel != PERF_SAMPLE_BRANCH_ANY)
> +					return -EOPNOTSUPP;
> +			} else {
> +				/*
> +				 * For PEBS fixups, we capture all
> +				 * the branches at all priv levels
> +				 */
> +				*br_type = PERF_SAMPLE_BRANCH_ANY
> +					 | PERF_SAMPLE_BRANCH_PLM_ALL;
> +			}
> +		}
>  	}
> 
>  	/*


-- 
Linux Technology Centre
IBM Systems and Technology Group
Bangalore India

