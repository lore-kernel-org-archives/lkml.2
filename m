Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab0LUSXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 13:23:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:38757 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab0LUSXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 13:23:41 -0500
Date: Tue, 21 Dec 2010 16:23:21 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip 2/4] [BUGFIX]perf: Fix strlist__parse_list to
	handle const string
Message-ID: <20101221182321.GA15683@ghostprotocols.net>
References: <20101217131149.24123.96128.stgit@ltc236.sdl.hitachi.co.jp> <20101217131206.24123.87394.stgit@ltc236.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101217131206.24123.87394.stgit@ltc236.sdl.hitachi.co.jp>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Dec 17, 2010 at 10:12:06PM +0900, Masami Hiramatsu escreveu:
> Fix strlist__parse_list to handle const string. Without this patch,
> strlist__parse_list() causes SEGV when caller passes a constant
> string.
 
> +++ b/tools/perf/util/strlist.c
> @@ -136,13 +136,19 @@ static int strlist__parse_list_entry(struct strlist *self, const char *s)
>  
>  int strlist__parse_list(struct strlist *self, const char *s)
>  {
> -	char *sep;
> +	char *sep, *tmp;
>  	int err;
>  
> +	/* This method requires strdup, because this changes given string */
> +	if (!self->dupstr)
> +		return -EINVAL;
> +

Why is the above check needed if you solved the problem by strnduping at
each separator?

Wouldn't be better to just stop changing the string by passing the
length to strlist__parse_list_entry, etc?

>  	while ((sep = strchr(s, ',')) != NULL) {
> -		*sep = '\0';
> -		err = strlist__parse_list_entry(self, s);
> -		*sep = ',';
> +		tmp = strndup(s, sep - s);
> +		if (tmp == NULL)
> +			return -ENOMEM;
> +		err = strlist__parse_list_entry(self, tmp);
> +		free(tmp);
>  		if (err != 0)
>  			return err;
>  		s = sep + 1;
