Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab2KSJkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 04:40:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14080 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab2KSJk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 04:40:29 -0500
X-Authority-Analysis: v=2.0 cv=cuMZYiEi c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=8a6ZbOSNe-0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=YJblWX91ImEA:10 a=VnNF1IyMAAAA:8 a=pGLkceISAAAA:8 a=B4pjgTTb2GTu7ZcghzwA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=lK8Wcptowqp_EoKJ:21 a=1AhJjlHsW_FDXDjQ:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1353318027.20727.6.camel@gandalf.local.home>
Subject: Re: uprobe: checking probe event include directory
From: Steven Rostedt <rostedt@goodmis.org>
To: Jovi Zhang <bookjovi@gmail.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 19 Nov 2012 04:40:27 -0500
In-Reply-To: <CACV3sb+1=qaNu6ozHS+iRnKntoJw46zyamRPzcu-hWY34-qO8Q@mail.gmail.com>
References: <CACV3sbLu81jrkfSXQxJ+_XtZHVTA6YfwJO3hjRxYsaDwbbLi6A@mail.gmail.com>
	 <20120717105936.GC28744@somewhere>
	 <20120717172736.GA6854@linux.vnet.ibm.com>
	 <CACV3sbKBsj288s=2FKKM+zuoga7Jy9QOxgzciTwREFVHLgR=Lw@mail.gmail.com>
	 <20120718110731.GE5006@linux.vnet.ibm.com>
	 <CACV3sb+1=qaNu6ozHS+iRnKntoJw46zyamRPzcu-hWY34-qO8Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been cleaning out my inbox and found this patch hasn't made it into
mainline yet.

There were a couple of versions of the patch in this thread. Please
re-submit the final version with the associated acks. And not within
this thread.

Patches that are added to replies in threads seldom get applied.

-- Steve

On Wed, 2012-07-18 at 19:38 +0800, Jovi Zhang wrote:
> On Wed, Jul 18, 2012 at 7:07 PM, Srikar Dronamraju
> <srikar@linux.vnet.ibm.com> wrote:
> > The patch looks good,
> >
> > Can you modify the description a bit. However you are free to ignore
> > these comments. After knowing your response,  I will ack the patch.
> >
> > I would probably put this as:
> >
> > The subject could be
> > tracing: Verify target file before registering a uprobe event
> >
> > Description:
> > Without this patch, we can register a uprobe event for a directory.
> > Enabling such a uprobe event would anyway fail.
> >
> > Example:
> >
> > $ echo 'p /bin:0x4245c0' > /sys/kernel/debug/tracing/uprobe_events
> >
> > However directories cannot be valid targets for uprobe.
> > Hence verify if the target is a regular file during the probe
> > registration.
> 
> Thanks srikar, your description is more clear than mine.
> 
> 
> >From fd5077196038cc271e2116e1fca359a0011e1669 Mon Sep 17 00:00:00 2001
> From: Jovi Zhang <bookjovi@gmail.com>
> Date: Wed, 18 Jul 2012 18:16:44 +0800
> Subject: [PATCH] tracing: Verify target file before registering a uprobe
>  event
> 
> Without this patch, we can register a uprobe event for a directory.
> Enabling such a uprobe event would anyway fail.
> 
> Example:
> $ echo 'p /bin:0x4245c0' > /sys/kernel/debug/tracing/uprobe_events
> 
> However dirctories cannot be valid targets for uprobe.
> Hence verify if the target is a regular file during the probe
> registration.
> 
> Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
> Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> ---
>  kernel/trace/trace_uprobe.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 85158fa..3b5f646 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -259,6 +259,10 @@ static int create_trace_uprobe(int argc, char **argv)
>  		goto fail_address_parse;
> 
>  	inode = igrab(path.dentry->d_inode);
> +	 if (!S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)) {
> +		ret = -EINVAL;
> +		goto fail_address_parse;
> +	}
> 
>  	argc -= 2;
>  	argv += 2;
> @@ -358,7 +362,7 @@ fail_address_parse:
>  	if (inode)
>  		iput(inode);
> 
> -	pr_info("Failed to parse address.\n");
> +	pr_info("Failed to parse address or file.\n");
> 
>  	return ret;
>  }


