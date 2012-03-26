Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab2CZKvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 06:51:18 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:46901 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222Ab2CZKvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 06:51:17 -0400
X-AuditID: b753bd60-9658fba000007b1b-94-4f704a233334
X-AuditID: b753bd60-9658fba000007b1b-94-4f704a233334
Message-ID: <4F704A1E.2040401@hitachi.com>
Date: Mon, 26 Mar 2012 19:51:10 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, acme@infradead.org,
        ananth@in.ibm.com, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        rostedt@goodmis.org
Subject: Re: [RESEND]Re: [PATCH] perf - probe finder fails to resolve function
 name to address
References: <4F6AF410.1010400@linux.vnet.ibm.com> <4F6AFD92.4030603@linux.vnet.ibm.com> <4F6C721B.9060807@hitachi.com> <4F703FB9.9020407@linux.vnet.ibm.com>
In-Reply-To: <4F703FB9.9020407@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/03/26 19:06), Prashanth Nageshappa wrote:
> Fixing a coding style issue..
> 
> On 03/23/2012 06:22 PM, Masami Hiramatsu wrote:
> 
>> Hi,
>>
>> (2012/03/22 19:23), Prashanth Nageshappa wrote:
>>> probe finder fails to resolve valid function names into addresses for
>>> functions which have more than one die entries in DWARF info.
>>>
>>> It is valid for DWARF info to contain more than 1 entries for a given
>>> function name, where one entry corresponds to definition which has code
>>> address/range attributes and remaining entries (which are only
>>> declarations) does not have code address/range attributes.
>>> (example: do_fork, sys_write, sys_wait4, sys_sync etc)
>>
>> Hmm, I'd like to reproduce and see what happened on debuginfo in those cases.
>> Could you tell me your environment or actual dwarf dump of those entries as below?
>>
> 
> $ uname -r
> 3.1.0-7.fc16.x86_64
> 
> $ sudo perf probe  do_fork
> Failed to get entry address of do_fork.
>   Error: Failed to add events. (-2)
> 
> $ readelf -wi /usr/lib/debug/lib/modules/3.1.0-7.fc16.x86_64/vmlinux | grep do_fork -A 16
>     <2691f7>   DW_AT_name        : (indirect string, offset: 0x1b1e0): do_fork	
>     <2691fb>   DW_AT_decl_file   : 3	
>     <2691fc>   DW_AT_decl_line   : 2269	
>     <2691fe>   DW_AT_prototyped  : 1	
>     <2691fe>   DW_AT_type        : <0x2593d1>	
>     <269202>   DW_AT_declaration : 1	

OK, compared with mine, this attribute is actually new one
for this kind of (declaration) entries.

[...]
>>
>> At least we must consider this lazy_line case. If I understand correctly,
>> that can also affect find_probe_point_lazy(sp_die, pf);
>>
>> If I find the different attribute, I'd like to add a checker function and
>> filter it out at early step in this function.
>>
> 
> Based on the above comments I have redone the patch:
> 
> If die entries corresponding to declarations appear before definition
> entry, probe finder returns error instead of continuing to look further
> for a definition entry.
> 
> This patch ensures we reach to the die entry corresponding to the
> definition and get the function address.
> 
> V2: A simpler solution based on Masami's suggestion.
> 
> 
> Signed-off-by: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>

Well, OK. This looks good for me too :)

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> ---
> 
>  tools/perf/util/probe-finder.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> index 5d73262..d5914ee 100644
> --- a/tools/perf/util/probe-finder.c
> +++ b/tools/perf/util/probe-finder.c
> @@ -963,10 +963,12 @@ static int probe_point_search_cb(Dwarf_Die *sp_die, void *data)
>  	struct dwarf_callback_param *param = data;
>  	struct probe_finder *pf = param->data;
>  	struct perf_probe_point *pp = &pf->pev->point;
> +	Dwarf_Attribute attr;
> 
>  	/* Check tag and diename */
>  	if (dwarf_tag(sp_die) != DW_TAG_subprogram ||
> -	    !die_compare_name(sp_die, pp->function))
> +	    !die_compare_name(sp_die, pp->function) ||
> +	    dwarf_attr(sp_die, DW_AT_declaration, &attr))
>  		return DWARF_CB_OK;
> 
>  	/* Check declared file */
> 
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
