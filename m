Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab2ILImz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 04:42:55 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:43383 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab2ILImx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 04:42:53 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-ff-50504b0a943c
From: Namhyung Kim <namhyung@kernel.org>
To: Hyeoncheol Lee <hyc.lee@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip/perf/core] perf probe: Add union member access support
References: <CANFS6baeuSBxPGQ8SUZWZErJ2bWs-Nojg+FSo138E1QK8bJJig@mail.gmail.com>
Date: Wed, 12 Sep 2012 17:35:59 +0900
In-Reply-To: <CANFS6baeuSBxPGQ8SUZWZErJ2bWs-Nojg+FSo138E1QK8bJJig@mail.gmail.com>
	(Hyeoncheol Lee's message of "Wed, 12 Sep 2012 16:57:45 +0900")
Message-ID: <877grzab9s.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hyeoncheol,

It seems you don't use git send-email which adds people on Cc: lines of
changelog into actual CC list automatically.  Or did you send the email
to Masami and Srikar privately?

Thanks,
Namhyung


On Wed, 12 Sep 2012 16:57:45 +0900, Hyeoncheol Lee wrote:
> Union members can be accessed with '.' or '->' like data structure
> member access
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
