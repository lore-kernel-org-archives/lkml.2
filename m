Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab3AGP5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 10:57:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14112 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab3AGP5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 10:57:48 -0500
X-Authority-Analysis: v=2.0 cv=YruNtvkX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=DpZN2MZ322sA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=0QnN7xjQLoUA:10 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=Fef7hBMMvpD2EiAO-ZAA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=fNJR0txfQMmowiFA:21 a=HCQJ6qO1gMVVijd9:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1357574265.5190.1.camel@gandalf.local.home>
Subject: Re: [PATCH 3/3] tracing: Verify target file before registering a
 uprobe event
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jovi Zhang <bookjovi@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Mon, 07 Jan 2013 10:57:45 -0500
In-Reply-To: <20130103004212.690763002@goodmis.org>
References: <20130102225035.140076434@goodmis.org>
	 <20130103004212.690763002@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jovi,

As Namhyung pointed out. Can you fix the below and resend.


On Wed, 2013-01-02 at 17:50 -0500, Steven Rostedt wrote:
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

Bad whitespace before 'if'.

Also, S_ISDIR() implies S_ISREG(), you can remove the "S_ISDIR()" check.

Thanks,

-- Steve

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


