Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab0FDCJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 22:09:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60544 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab0FDCJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 22:09:13 -0400
Message-ID: <4C0860DE.5020609@cn.fujitsu.com>
Date: Fri, 04 Jun 2010 10:11:42 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>,
       James Bottomley <James.Bottomley@suse.de>,
       Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH][GIT PULL][v2.6.35] tracing/events: Convert format output
 to seq_file
References: <1275594103.15884.35.camel@gandalf.stny.rr.com>
In-Reply-To: <1275594103.15884.35.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static void *f_start(struct seq_file *m, loff_t *pos)
> +{
> +	loff_t l = 1;
> +	void *p;
> +
> +	/* Start by showing the header */
> +	if (!*pos) {
> +		(*pos)++;

We shoudn't increment *pos in start() handler. It's a common mistake when
using seqfile. 

What we need to do in start() is move the pointer to postion *pos.

> +		return (void *)FORMAT_HEADER;
>  	}
>  
> -	if (r)
> -		r = trace_seq_printf(s, "\nprint fmt: %s\n",
> -				call->print_fmt);
> +	p = (void *)FORMAT_HEADER;
> +	do {
> +		p = f_next(m, p, &l);
> +	} while (p && l < *pos);
>  
> -	if (!r) {
> -		/*
> -		 * ug!  The format output is bigger than a PAGE!!
> -		 */
> -		buf = "FORMAT TOO BIG\n";
> -		r = simple_read_from_buffer(ubuf, cnt, ppos,
> -					      buf, strlen(buf));
> -		goto out;
> +	return p;
> +}
