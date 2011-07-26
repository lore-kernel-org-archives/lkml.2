Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab1GZMSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 08:18:51 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:36889 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab1GZMSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 08:18:46 -0400
X-Greylist: delayed 1076 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jul 2011 08:18:46 EDT
Message-ID: <4E2EAC70.4030609@grupopie.com>
Date: Tue, 26 Jul 2011 13:00:48 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: stufever@gmail.com, linux-kernel@vger.kernel.org,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] TRACING: Fix a copmile warning
References: <1310982010-13849-1-git-send-email-wangshaoyan.pt@taobao.com> <1311618747.3526.32.camel@gandalf.stny.rr.com>
In-Reply-To: <1311618747.3526.32.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Mon, 2011-07-18 at 17:40 +0800, stufever@gmail.com wrote:
>> From: Wang Shaoyan <wangshaoyan.pt@taobao.com>
>>
>> It's harmless but annyoing.
>>   kernel/trace/trace_printk.c: In function 'module_trace_bprintk_format_notify':
>>   kernel/trace/trace_printk.c:52: warning: 'fmt' may be used uninitialized in this function
> 
> I prefer not to add this patch. Fix gcc. Actually some gcc's do not warn
> on this, others do. Here's the code that confuses gcc:
> 
> 		tb_fmt = kmalloc(sizeof(*tb_fmt), GFP_KERNEL);
> 		if (tb_fmt)
> 			fmt = kmalloc(strlen(*iter) + 1, GFP_KERNEL);
> 		if (tb_fmt && fmt) {
> 			list_add_tail(&tb_fmt->list, &trace_bprintk_fmt_list);
> 			strcpy(fmt, *iter);
> 			tb_fmt->fmt = fmt;
> 			*iter = tb_fmt->fmt;
> 
> 
> fmt will never be looked at if tb_fmt is NULL, and fmt is initialized if
> tb_fmt is not NULL.

Yes, changing code just to please gcc is not nice. In this case,
changing the code to the more straightforward / naive implementation
might make it more readable (IMHO) and maybe even improve code
generation. I.e., something like this:

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
        	*iter = NULL;
        }
} else {
        *iter = NULL;
}

The downside is that the "*iter = NULL" gets repeated twice...

-- 
Paulo Marques - www.grupopie.com

"This version has many new and good features. Sadly, the good ones are
not new and the new ones are not good."
