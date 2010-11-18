Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab0KRETk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 23:19:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52973 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377Ab0KRETi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 23:19:38 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=v8ohC7cffDsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=GM6LFby-nNad8Qtw8jsA:9 a=oqJncb7p8KUg8Ww2l58A:7 a=qftujDxwlm3NX9FlNBou4BjmLbwA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 2/2] [PATCH 2/2] tracing: Make event based
 trace_printk()
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "jason.wessel" <jason.wessel@windriver.com>,
        "Ted Ts'o" <tytso@mit.edu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20101118040949.782054673@goodmis.org>
References: <20101118035803.453609353@goodmis.org>
	 <20101118040949.782054673@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 17 Nov 2010 23:19:36 -0500
Message-ID: <1290053976.30543.89.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 22:58 -0500, Steven Rostedt wrote:

> +static __init int event_printk_init(void)
> +{
> +	struct event_printk_struct *print;
> +	struct dentry *d_events;
> +	char *topdir;
> +	char *p;
> +	int len;
> +	int ret = -1;
> +
> +	/*
> +	 * Do nothing if we have no trace printks.
> +	 * May change in the future when we support modules.
> +	 */
> +	if (__start_trace_printk == __stop_trace_printk)
> +		return 0;
> +
> +	/*
> +	 * Use this file to find the path for other
> +	 * files. That is, __FILE__ returns the full path,
> +	 * but we don't want the top dir path, so we must
> +	 * chop it off. We know the path of this file as it
> +	 * is (kernel/trace/event_printk.c), so we simply
> +	 * cut that off and then we have the path to cut
> +	 * off of other files.
> +	 */
> +	topdir = kstrdup(__FILE__, GFP_KERNEL);
> +	if (WARN(!topdir, "failed to allocate printk info"))
> +		return -1;
> +
> +	p = strstr(topdir, "kernel/trace/event_printk.c");
> +	if (WARN(!p, "event_printk.c not found. Did the file move?"))
> +		goto out;
> +	*p = '\0';
> +
> +	d_events = event_trace_events_dir();
> +
> +	printk_root = debugfs_create_dir("printk", d_events);
> +	if (WARN(!printk_root, "Could not create printk entry"))
> +		goto out;
> +
> +	trace_create_file("enable", 0644, printk_root,
> +			  NULL, &trace_printk_enable_fops);
> +
> +	len = strlen(topdir);
> +	for_each_printk(print, __start_trace_printk, __stop_trace_printk)
> +		add_event_printk(topdir, len, print);

Oops, I'm missing a:

	ret = 0;

here.

-- Steve

> +
> + out:
> +	kfree(topdir);
> +	return ret;
> +}


