Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab1GZN4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 09:56:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47511 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab1GZNz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 09:55:56 -0400
X-Authority-Analysis: v=1.1 cv=sbbt6Wn8j+VvNVI1Ftt/uHhinWyuFt+R57MN9Ty2Tys= c=1 sm=0 a=wp_X8QvuP7UA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=8OccVf2sgDN2yowzGkwA:9 a=il8FLIE3BwiZKmFjCKgA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] TRACING: Fix a copmile warning
From: Steven Rostedt <rostedt@goodmis.org>
To: Paulo Marques <pmarques@grupopie.com>
Cc: Jesper Juhl <jj@chaosbits.net>, stufever@gmail.com,
        linux-kernel@vger.kernel.org, Wang Shaoyan <wangshaoyan.pt@taobao.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
In-Reply-To: <4E2EC1D6.4020102@grupopie.com>
References: <1310982010-13849-1-git-send-email-wangshaoyan.pt@taobao.com>
	 <1311618747.3526.32.camel@gandalf.stny.rr.com>
	 <4E2EAC70.4030609@grupopie.com>
	 <alpine.LNX.2.00.1107261516550.11180@swampdragon.chaosbits.net>
	 <4E2EC1D6.4020102@grupopie.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 26 Jul 2011 09:55:52 -0400
Message-ID: <1311688552.3526.75.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-26 at 14:32 +0100, Paulo Marques wrote:
> Jesper Juhl wrote:

> >> tb_fmt = kmalloc(sizeof(*tb_fmt), GFP_KERNEL);
> >> if (tb_fmt) {
> >>         fmt = kmalloc(strlen(*iter) + 1, GFP_KERNEL);
> >> 	if (fmt) {
> >>         	list_add_tail(&tb_fmt->list, &trace_bprintk_fmt_list);
> >>         	strcpy(fmt, *iter);
> >>         	tb_fmt->fmt = fmt;
> >>         	*iter = tb_fmt->fmt;
> >>         } else {
> >> 	        kfree(tb_fmt);
> >>         	*iter = NULL;
> >>         }
> >> } else {
> >>         *iter = NULL;
> >> }
> >>
> >> The downside is that the "*iter = NULL" gets repeated twice...
> >>
> > 
> > You could avoid that like this:
> > 
> > *iter = NULL;
> > tb_fmt = kmalloc(sizeof(*tb_fmt), GFP_KERNEL);
> > if (tb_fmt) {
> >       fmt = kmalloc(strlen(*iter) + 1, GFP_KERNEL);
> >       if (fmt) {
> >               list_add_tail(&tb_fmt->list, &trace_bprintk_fmt_list);
> >               strcpy(fmt, *iter);
> >               tb_fmt->fmt = fmt;
> >               *iter = tb_fmt->fmt;
> >         } else {
> >               kfree(tb_fmt);
> >         }
> > }
> 
> Yes, but this way you always set *iter to NULL, whereas in the previous
> version that was the very unlikely case (kmalloc returning NULL).
> 
> Probably gcc is smart enough to generate the same code for both
> versions, to avoid setting *iter twice for the likely case (and even if
> it doesn't, then the cache will be hot and probably not written back
> yet, yadda, yadda)...

gcc may not be allowed to optimize it as iter points to a global, and
external functions are called (kmalloc).

But what would work is:

static
void hold_module_trace_bprintk_format(const char **start, const char **end)
{
	const char **iter;
	char *fmt;

	mutex_lock(&btrace_mutex);
	for (iter = start; iter < end; iter++) {
		struct trace_bprintk_fmt *tb_fmt = lookup_format(*iter);
		if (tb_fmt) {
			*iter = tb_fmt->fmt;
			continue;
		}

		fmt = NULL;
		tb_fmt = kmalloc(sizeof(*tb_fmt), GFP_KERNEL);
		if (tb_fmt) {
			fmt = kmalloc(strlen(*iter) + 1, GFP_KERNEL);
			if (fmt) {
				list_add_tail(&tb_fmt->list, &trace_bprintk_fmt_list);
				strcpy(fmt, *iter);
				tb_fmt->fmt = fmt;
			} else
				kfree(tb_fmt);
		}
		*iter = fmt;
	}
	mutex_unlock(&btrace_mutex);
}

The above is easier to read, removes the false warning, and uses local
variables that gcc can optimize.

-- Steve



