Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab2JRIbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 04:31:19 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:49689 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab2JRIbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 04:31:16 -0400
X-AuditID: b753bd60-97c52ba000002f78-8a-507fbe5161e5
X-AuditID: b753bd60-97c52ba000002f78-8a-507fbe5161e5
Message-ID: <507FBE50.1060603@hitachi.com>
Date: Thu, 18 Oct 2012 17:31:12 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hyeoncheol Lee <hyc.lee@gmail.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH v2] perf probe: convert_name_to_addr() allocated the wrong
 size buffers for names
References: <1350523077-21258-1-git-send-email-hyc.lee@gmail.com>
In-Reply-To: <1350523077-21258-1-git-send-email-hyc.lee@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/10/18 10:17), Hyeoncheol Lee wrote:
> The function allocated wrong size buffers for names
> 
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Signed-off-by: Hyeoncheol Lee <hyc.lee@gmail.com>

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks!


> ---
>  v2: - Added a comment for MAX_ADDRNAME_LEN
> 
>  tools/perf/util/probe-event.c |   17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 49a256e..661bbdf 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -2274,6 +2274,14 @@ int show_available_funcs(const char *target, struct strfilter *_filter,
>  }
>  
>  /*
> + * MAX_ADDRNAME_LEN is the maximum length of a function name for uprobe_events
> + * Because each half byte is encoded in one hex character,
> + * sizeof(type)*2 is the maximum length of hexadecimal number of the type.
> + * Another 3 bytes are for "0x" and a null character
> + */
> +#define MAX_ADDRNAME_LEN  (3 + sizeof(unsigned long long) * 2)
> +
> +/*
>   * uprobe_events only accepts address:
>   * Convert function and any offset to address
>   */
> @@ -2332,7 +2340,7 @@ static int convert_name_to_addr(struct perf_probe_event *pev, const char *exec)
>  	if (!pev->group) {
>  		char *ptr1, *ptr2, *exec_copy;
>  
> -		pev->group = zalloc(sizeof(char *) * 64);
> +		pev->group = zalloc(sizeof(char) * 64);
>  		exec_copy = strdup(exec);
>  		if (!exec_copy) {
>  			ret = -ENOMEM;
> @@ -2352,14 +2360,15 @@ static int convert_name_to_addr(struct perf_probe_event *pev, const char *exec)
>  		free(exec_copy);
>  	}
>  	free(pp->function);
> -	pp->function = zalloc(sizeof(char *) * MAX_PROBE_ARGS);
> +	pp->function = zalloc(sizeof(char) * MAX_ADDRNAME_LEN);
>  	if (!pp->function) {
>  		ret = -ENOMEM;
>  		pr_warning("Failed to allocate memory by zalloc.\n");
>  		goto out;
>  	}
> -	e_snprintf(pp->function, MAX_PROBE_ARGS, "0x%llx", vaddr);
> -	ret = 0;
> +	ret = e_snprintf(pp->function, MAX_ADDRNAME_LEN, "0x%llx", vaddr);
> +	if (ret > 0)
> +		ret = 0;
>  
>  out:
>  	if (map) {
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


