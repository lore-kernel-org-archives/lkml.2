Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab2DWQdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:33:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13848 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab2DWQdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:33:45 -0400
X-Authority-Analysis: v=2.0 cv=MNHiabll c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=3cFP2XwQnlkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=57SyGIRnAAAA:8 a=3H9QUFvBRDey9ZIrhZ0A:9 a=ePtxz06CTBw3iSPRjs0A:7 a=PUjeQqilurYA:10 a=TIV7c6GJmisA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335198822.28106.105.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 03/11] parse-events: Get rid of handling concatenation
 on event_read_print
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 23 Apr 2012 12:33:42 -0400
In-Reply-To: <1335157118-14658-4-git-send-email-namhyung.kim@lge.com>
References: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
	 <1335157118-14658-4-git-send-email-namhyung.kim@lge.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 13:58 +0900, Namhyung Kim wrote:
> The concatenation of subsequent DQUOTE'd strings is handled
> by __read_token() already.
> 

You missed the point of this concat. It's not connecting "xxx" it is
connecting "xxx" "yyy" into "xxxyyy", as some events do this.

-- Steve

> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> ---
>  parse-events.c |   16 ----------------
>  1 file changed, 16 deletions(-)
> 
> diff --git a/parse-events.c b/parse-events.c
> index 0cd79c5..b4ae313 100644
> --- a/parse-events.c
> +++ b/parse-events.c
> @@ -2695,7 +2695,6 @@ static int event_read_print(struct event_format *event)
>  	if (read_expect_type(EVENT_DQUOTE, &token) < 0)
>  		goto fail;
>  
> - concat:
>  	event->print_fmt.format = token;
>  	event->print_fmt.args = NULL;
>  
> @@ -2705,21 +2704,6 @@ static int event_read_print(struct event_format *event)
>  	if (type == EVENT_NONE)
>  		return 0;
>  
> -	/* Handle concatenation of print lines */
> -	if (type == EVENT_DQUOTE) {
> -		char *cat;
> -
> -		cat = malloc_or_die(strlen(event->print_fmt.format) +
> -				    strlen(token) + 1);
> -		strcpy(cat, event->print_fmt.format);
> -		strcat(cat, token);
> -		free_token(token);
> -		free_token(event->print_fmt.format);
> -		event->print_fmt.format = NULL;
> -		token = cat;
> -		goto concat;
> -	}
> -			     
>  	if (test_type_token(type, token, EVENT_DELIM, ","))
>  		goto fail;
>  


