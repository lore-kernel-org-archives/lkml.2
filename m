Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab0IMVeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 17:34:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57059 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab0IMVef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 17:34:35 -0400
X-Authority-Analysis: v=1.1 cv=2ipXt8Ao/PPbK329gQN1nC6XU/V8QMABDttguNTIlb0= c=1 sm=0 a=tuVigMI4kdkA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=7d_E57ReAAAA:8 a=vaDVyjBXZxX6rprOiSsA:9 a=P3Zi4okQCbBzAu_HuRONmOGn3mUA:4 a=PUjeQqilurYA:10 a=D6-X0JM3zdQA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: fix string comparison in features
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Tony Lindgren <tony@atomide.com>
In-Reply-To: <20100911174400.GA13462@Krystal>
References: <20100911174400.GA13462@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 13 Sep 2010 17:34:32 -0400
Message-ID: <1284413672.5701.12.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-11 at 13:44 -0400, Mathieu Desnoyers wrote:
> Incorrect handling of the following case:
> 
> INTERACTIVE
> INTERACTIVE_SOMETHING_ELSE
> 
> The comparison only checks up to each element's length.

Replace all your changes with mine, and you have the same effect ;-)

-- Steve

> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---
>  kernel/sched.c |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6-lttng.git/kernel/sched.c
> ===================================================================
> --- linux-2.6-lttng.git.orig/kernel/sched.c
> +++ linux-2.6-lttng.git/kernel/sched.c
> @@ -722,7 +722,7 @@ sched_feat_write(struct file *filp, cons
>  {
>  	char buf[64];
>  	char *cmp = buf;

-	char *cmp = buf;
+	char *cmp;

> -	int neg = 0;
> +	int neg = 0, cmplen;
>  	int i;
>  
>  	if (cnt > 63)
> @@ -732,15 +732,24 @@ sched_feat_write(struct file *filp, cons
>  		return -EFAULT;
>  
>  	buf[cnt] = 0;
> +	for (i = 0; i < cnt; i++) {
> +		if (buf[i] == '\n' || buf[i] == ' ') {
> +			buf[i] = 0;
> +			break;
> +		}
> +	}

+	cmp = strstrip(buf);

>  
>  	if (strncmp(buf, "NO_", 3) == 0) {
>  		neg = 1;
>  		cmp += 3;
>  	}
>  
> +	cmplen = strlen(cmp);
>  	for (i = 0; sched_feat_names[i]; i++) {
>  		int len = strlen(sched_feat_names[i]);

-		int len = strlen(sched_feat_names[i]);

>  
> +		if (cmplen != len)
> +			continue;
>  		if (strncmp(cmp, sched_feat_names[i], len) == 0) {

-		if (strncmp(cmp, sched_feat_names[i], len) == 0) {
+		if (strcmp(cmp, sched_feat_names[i]) == 0) {

>  			if (neg)
>  				sysctl_sched_features &= ~(1UL << i);


