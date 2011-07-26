Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab1GZNS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 09:18:56 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:17467 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab1GZNSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 09:18:51 -0400
Date: Tue, 26 Jul 2011 15:18:49 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Paulo Marques <pmarques@grupopie.com>
cc: Steven Rostedt <rostedt@goodmis.org>, stufever@gmail.com,
        linux-kernel@vger.kernel.org, Wang Shaoyan <wangshaoyan.pt@taobao.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] TRACING: Fix a copmile warning
In-Reply-To: <4E2EAC70.4030609@grupopie.com>
Message-ID: <alpine.LNX.2.00.1107261516550.11180@swampdragon.chaosbits.net>
References: <1310982010-13849-1-git-send-email-wangshaoyan.pt@taobao.com> <1311618747.3526.32.camel@gandalf.stny.rr.com> <4E2EAC70.4030609@grupopie.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jul 2011, Paulo Marques wrote:

> Steven Rostedt wrote:
> > On Mon, 2011-07-18 at 17:40 +0800, stufever@gmail.com wrote:
> >> From: Wang Shaoyan <wangshaoyan.pt@taobao.com>
> >>
> >> It's harmless but annyoing.
> >>   kernel/trace/trace_printk.c: In function 'module_trace_bprintk_format_notify':
> >>   kernel/trace/trace_printk.c:52: warning: 'fmt' may be used uninitialized in this function
> > 
> > I prefer not to add this patch. Fix gcc. Actually some gcc's do not warn
> > on this, others do. Here's the code that confuses gcc:
> > 
> > 		tb_fmt = kmalloc(sizeof(*tb_fmt), GFP_KERNEL);
> > 		if (tb_fmt)
> > 			fmt = kmalloc(strlen(*iter) + 1, GFP_KERNEL);
> > 		if (tb_fmt && fmt) {
> > 			list_add_tail(&tb_fmt->list, &trace_bprintk_fmt_list);
> > 			strcpy(fmt, *iter);
> > 			tb_fmt->fmt = fmt;
> > 			*iter = tb_fmt->fmt;
> > 
> > 
> > fmt will never be looked at if tb_fmt is NULL, and fmt is initialized if
> > tb_fmt is not NULL.
> 
> Yes, changing code just to please gcc is not nice. In this case,
> changing the code to the more straightforward / naive implementation
> might make it more readable (IMHO) and maybe even improve code
> generation. I.e., something like this:
> 
> tb_fmt = kmalloc(sizeof(*tb_fmt), GFP_KERNEL);
> if (tb_fmt) {
>         fmt = kmalloc(strlen(*iter) + 1, GFP_KERNEL);
> 	if (fmt) {
>         	list_add_tail(&tb_fmt->list, &trace_bprintk_fmt_list);
>         	strcpy(fmt, *iter);
>         	tb_fmt->fmt = fmt;
>         	*iter = tb_fmt->fmt;
>         } else {
> 	        kfree(tb_fmt);
>         	*iter = NULL;
>         }
> } else {
>         *iter = NULL;
> }
> 
> The downside is that the "*iter = NULL" gets repeated twice...
> 

You could avoid that like this:

*iter = NULL;
tb_fmt = kmalloc(sizeof(*tb_fmt), GFP_KERNEL);
if (tb_fmt) {
      fmt = kmalloc(strlen(*iter) + 1, GFP_KERNEL);
      if (fmt) {
              list_add_tail(&tb_fmt->list, &trace_bprintk_fmt_list);
              strcpy(fmt, *iter);
              tb_fmt->fmt = fmt;
              *iter = tb_fmt->fmt;
        } else {
              kfree(tb_fmt);
        }
}


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

