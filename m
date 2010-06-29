Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752Ab0F2NDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 09:03:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57909 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab0F2NDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 09:03:19 -0400
X-Authority-Analysis: v=1.1 cv=4GK1Slht3WUdSXXcSOu+TCe3GQnvEFDsQSvVHKX2gdo= c=1 sm=0 a=RJKtCkfBdskA:10 a=UBIxAjGgU1YA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=omOdbC7AAAAA:8 a=kcL8E1igYm8vRKDrUs8A:9 a=IPiQxuxxcb5GbF8l1cwA:7 a=7km2U3g0TBQcdRH83rZ3K1tWBBkA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] trace-cmd: Add to ignore event not found error
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: John Kacur <jkacur@redhat.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100629144832.38C6.A69D9226@jp.fujitsu.com>
References: <20100629144832.38C6.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 29 Jun 2010 09:03:17 -0400
Message-ID: <1277816597.9181.73.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-29 at 15:06 +0900, KOSAKI Motohiro wrote:
> Usually trace-cmd die If 'trace-cmd start' find wrong -e argument.
> It mean an admin can't pass the trace point of unloaded kernel module.
> It can cause nightmare if he manage lots and various computers.
> 
> That said, admin want to use the same trace configuration. but, example,
> some machine loaded ext4 module, others unloaded. It makes harder to
> reuse.
> 
> So, I simply implement ignore option.

Thanks! I'll pull it and I'll also update the documentation to reflect
this change.

-- Steve

> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  trace-cmd.c |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/trace-cmd.c b/trace-cmd.c
> index cdb0735..b4eb0fe 100644
> --- a/trace-cmd.c
> +++ b/trace-cmd.c
> @@ -113,6 +113,8 @@ struct events {
>  
>  static struct tracecmd_recorder *recorder;
>  
> +static int ignore_event_not_found = 0;
> +
>  static char *get_temp_file(int cpu)
>  {
>  	char *file = NULL;
> @@ -738,7 +740,7 @@ static void update_event(const char *name, const char *filter,
>  
>  		ret = update_glob(str, filter, filter_only, update);
>  		free(str);
> -		if (!ret)
> +		if (!ret && !ignore_event_not_found)
>  			die("No events enabled with %s", name);
>  		return;
>  	}
> @@ -752,7 +754,7 @@ static void update_event(const char *name, const char *filter,
>  	ret2 = update_glob(str, filter, filter_only, update);
>  	free(str);
>  
> -	if (!ret && !ret2)
> +	if (!ret && !ret2 && !ignore_event_not_found)
>  		goto fail;
>  
>  	return;
> @@ -1431,7 +1433,7 @@ int main (int argc, char **argv)
>  		   (strcmp(argv[1], "start") == 0) ||
>  		   ((extract = strcmp(argv[1], "extract") == 0))) {
>  
> -		while ((c = getopt(argc-1, argv+1, "+he:f:Fp:do:O:s:r:vg:l:n:P:N:tb:k")) >= 0) {
> +		while ((c = getopt(argc-1, argv+1, "+he:f:Fp:do:O:s:r:vg:l:n:P:N:tb:ki")) >= 0) {
>  			switch (c) {
>  			case 'h':
>  				usage(argv);
> @@ -1543,6 +1545,9 @@ int main (int argc, char **argv)
>  			case 'k':
>  				keep = 1;
>  				break;
> +			case 'i':
> +				ignore_event_not_found = 1;
> +				break;
>  			}
>  		}
>  


