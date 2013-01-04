Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab3ADEaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 23:30:06 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:58394 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab3ADEaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 23:30:03 -0500
X-AuditID: 9c93016f-b7b54ae000000e9e-b1-50e65ac999a1
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jovi Zhang <bookjovi@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] tracing: Verify target file before registering a uprobe event
References: <20130102225035.140076434@goodmis.org>
	<20130103004212.690763002@goodmis.org>
Date: Fri, 04 Jan 2013 13:30:01 +0900
In-Reply-To: <20130103004212.690763002@goodmis.org> (Steven Rostedt's message
	of "Wed, 02 Jan 2013 17:50:38 -0500")
Message-ID: <87vcbdr2nq.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Steve.

On Wed, 02 Jan 2013 17:50:38 -0500, Steven Rostedt wrote:
> From: Jovi Zhang <bookjovi@gmail.com>
>
> Without this patch, we can register a uprobe event for a directory.
> Enabling such a uprobe event would fail anyway .
>
> Example:
> $ echo 'p /bin:0x4245c0' > /sys/kernel/debug/tracing/uprobe_events
>
> However dirctories cannot be valid targets for uprobe.
> Hence verify if the target is a regular file during the probe
> registration.
>
> Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
> Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_uprobe.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 03003cd..0815f25 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -257,6 +257,10 @@ static int create_trace_uprobe(int argc, char **argv)
>  		goto fail_address_parse;
>  
>  	inode = igrab(path.dentry->d_inode);
> +	 if (!S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)) {

Doesn't !S_ISREG() include S_ISDIR() case too?

Anyway I can see an additional whitespace in front of the "if".

Thanks,
Namhyung


> +		ret = -EINVAL;
> +		goto fail_address_parse;
> +	}
>  
>  	argc -= 2;
>  	argv += 2;
> @@ -356,7 +360,7 @@ fail_address_parse:
>  	if (inode)
>  		iput(inode);
>  
> -	pr_info("Failed to parse address.\n");
> +	pr_info("Failed to parse address or file.\n");
>  
>  	return ret;
>  }
