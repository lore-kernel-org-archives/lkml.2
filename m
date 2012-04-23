Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab2DWQVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:21:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9943 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab2DWQVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:21:08 -0400
X-Authority-Analysis: v=2.0 cv=MNHiabll c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=80hrJ0BkZmIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=57SyGIRnAAAA:8 a=w7Y4ZMMjj58VspLjX1EA:9 a=8FwbeBcvHrydgZL5OgcA:7 a=PUjeQqilurYA:10 a=TIV7c6GJmisA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335198066.28106.103.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 01/11] parse-events: Free flag/sym field on failure path
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 23 Apr 2012 12:21:06 -0400
In-Reply-To: <1335157118-14658-2-git-send-email-namhyung.kim@lge.com>
References: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
	 <1335157118-14658-2-git-send-email-namhyung.kim@lge.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 13:58 +0900, Namhyung Kim wrote:
> If parsing flag/sym field failed after allocating it, it
> should be freed.
> 
> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> ---
>  parse-events.c |   14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/parse-events.c b/parse-events.c
> index bd078ba..81e6581 100644
> --- a/parse-events.c
> +++ b/parse-events.c
> @@ -2166,10 +2166,10 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
>  
>  		value = arg_eval(arg);
>  		if (value == NULL)
> -			goto out_free;
> +			goto out_free_field;

Instead of adding more goto's what, before the first goto "out_free"
add:

	field = NULL;

and since the field is allocated and also memset to zero, we could do in
the out_free:

	if (field) {
		free(field->value);
		free(field);
	}

I think that would be cleaner.

-- Steve

>  		field->value = strdup(value);
>  		if (field->value == NULL)
> -			goto out_free;
> +			goto out_free_field;
>  
>  		free_arg(arg);
>  		arg = alloc_arg();
> @@ -2177,14 +2177,14 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
>  		free_token(token);
>  		type = process_arg(event, arg, &token);
>  		if (test_type_token(type, token, EVENT_OP, "}"))
> -			goto out_free;
> +			goto out_free_field_value;
>  
>  		value = arg_eval(arg);
>  		if (value == NULL)
> -			goto out_free;
> +			goto out_free_field_value;
>  		field->str = strdup(value);
>  		if (field->str == NULL)
> -			goto out_free;
> +			goto out_free_field_value;
>  		free_arg(arg);
>  		arg = NULL;
>  
> @@ -2198,6 +2198,10 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
>  	*tok = token;
>  	return type;
>  
> +out_free_field_value:
> +	free(field->value);
> +out_free_field:
> +	free(field);
>  out_free:
>  	free_arg(arg);
>  	free_token(token);


