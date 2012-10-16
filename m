Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab2JPEUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 00:20:03 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:60526 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767Ab2JPEUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 00:20:00 -0400
X-AuditID: b753bd60-96850ba000002f78-2b-507ce06ecc93
X-AuditID: b753bd60-96850ba000002f78-2b-507ce06ecc93
Message-ID: <507CE06D.8050806@hitachi.com>
Date: Tue, 16 Oct 2012 13:19:57 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hyeoncheol Lee <hyc.lee@gmail.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH] perf probe: convert_name_to_addr() allocated the wrong
 size buffer for a function name
References: <1350351452-9737-1-git-send-email-hyc.lee@gmail.com>
In-Reply-To: <1350351452-9737-1-git-send-email-hyc.lee@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/10/16 10:37), Hyeoncheol Lee wrote:
> convert_name_to_addr() allocated sizeof(char *) * MAX_PROBE_ARGS
> bytes for a function name

Yeah, that one was from my laziness...

> 
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Signed-off-by: Hyeoncheol Lee <hyc.lee@gmail.com>
> ---
>  tools/perf/util/probe-event.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 49a256e..bb40ed4 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -2352,13 +2352,14 @@ static int convert_name_to_addr(struct perf_probe_event *pev, const char *exec)
>  		free(exec_copy);
>  	}
>  	free(pp->function);
> -	pp->function = zalloc(sizeof(char *) * MAX_PROBE_ARGS);
> +	pp->function = zalloc(sizeof(char) *
> +			      (3 + sizeof(unsigned long long) * 2));

Could you comment that this is enough long here?

>  	if (!pp->function) {
>  		ret = -ENOMEM;
>  		pr_warning("Failed to allocate memory by zalloc.\n");
>  		goto out;
>  	}
> -	e_snprintf(pp->function, MAX_PROBE_ARGS, "0x%llx", vaddr);
> +	sprintf(pp->function, "0x%llx", vaddr);

And at least we should use snprintf instead of sprintf...
(I think ret = e_snprintf(...) is better)

>  	ret = 0;
>  
>  out:
> 

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


