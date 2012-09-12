Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab2ILPPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:15:11 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:34699 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab2ILPPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:15:08 -0400
X-AuditID: b753bd60-900c0ba0000047ca-f0-5050a6fa9325
X-AuditID: b753bd60-900c0ba0000047ca-f0-5050a6fa9325
Message-ID: <5050A6FA.1080503@hitachi.com>
Date: Thu, 13 Sep 2012 00:15:06 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hyeoncheol Lee <hyc.lee@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH -tip/perf/core] perf probe: Add union member access
 support
References: <CANFS6baeuSBxPGQ8SUZWZErJ2bWs-Nojg+FSo138E1QK8bJJig@mail.gmail.com>
In-Reply-To: <CANFS6baeuSBxPGQ8SUZWZErJ2bWs-Nojg+FSo138E1QK8bJJig@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/09/12 16:57), Hyeoncheol Lee wrote:
> Union members can be accessed with '.' or '->' like data structure
> member access

This seems good to me :)

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!

> 
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> ---
>  tools/perf/util/probe-finder.c |   24 ++++++++++++++++--------
>  1 file changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> index 94a00de..cc2b856 100644
> --- a/tools/perf/util/probe-finder.c
> +++ b/tools/perf/util/probe-finder.c
> @@ -525,8 +525,10 @@ static int convert_variable_fields(Dwarf_Die
> *vr_die, const char *varname,
>  			return -ENOENT;
>  		}
>  		/* Verify it is a data structure  */
> -		if (dwarf_tag(&type) != DW_TAG_structure_type) {
> -			pr_warning("%s is not a data structure.\n", varname);
> +		tag = dwarf_tag(&type);
> +		if (tag != DW_TAG_structure_type && tag != DW_TAG_union_type) {
> +			pr_warning("%s is not a data structure nor an union.\n",
> +				   varname);
>  			return -EINVAL;
>  		}
> 
> @@ -539,8 +541,9 @@ static int convert_variable_fields(Dwarf_Die
> *vr_die, const char *varname,
>  			*ref_ptr = ref;
>  	} else {
>  		/* Verify it is a data structure  */
> -		if (tag != DW_TAG_structure_type) {
> -			pr_warning("%s is not a data structure.\n", varname);
> +		if (tag != DW_TAG_structure_type && tag != DW_TAG_union_type) {
> +			pr_warning("%s is not a data structure nor an union.\n",
> +				   varname);
>  			return -EINVAL;
>  		}
>  		if (field->name[0] == '[') {
> @@ -567,10 +570,15 @@ static int convert_variable_fields(Dwarf_Die
> *vr_die, const char *varname,
>  	}
> 
>  	/* Get the offset of the field */
> -	ret = die_get_data_member_location(die_mem, &offs);
> -	if (ret < 0) {
> -		pr_warning("Failed to get the offset of %s.\n", field->name);
> -		return ret;
> +	if (tag == DW_TAG_union_type) {
> +		offs = 0;
> +	} else {
> +		ret = die_get_data_member_location(die_mem, &offs);
> +		if (ret < 0) {
> +			pr_warning("Failed to get the offset of %s.\n",
> +				   field->name);
> +			return ret;
> +		}
>  	}
>  	ref->offset += (long)offs;
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


