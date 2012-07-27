Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab2G0GIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 02:08:53 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:24056 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab2G0GIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 02:08:52 -0400
Message-ID: <50123066.20909@parallels.com>
Date: Fri, 27 Jul 2012 10:08:38 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 3/7] procfs: Add ability to plug in auxiliary fdinfo providers
References: <20120725094718.089879534@openvz.org> <20120725095024.842540518@openvz.org> <50120F8C.8010001@parallels.com> <20120727060009.GB21246@moon>
In-Reply-To: <20120727060009.GB21246@moon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> +static void *seq_next(struct seq_file *m, void *p, loff_t *pos)
>>> +{
>>> +	struct proc_fdinfo_extra *extra = m->private;
>>> +	void *v = NULL;
>>> +
>>> +	if (extra->driver) {
>>> +		int ret = 0;
>>> +
>>> +		if (*pos == 0) {
>>> +			v = extra->driver->ops->start(m, pos);
>>> +			if (v) {
>>> +				ret = extra->driver->ops->show(m, v);
>>
>> Why is it necessary to call ->show here? The logic should be
>>
>> seq_start = (pos == 0 ? nop : extra->start)
>> seq_next  = (pos == 0 ? extra->start : extra->next)
>> seq_stop  = (pos == 0 ? nop : extra->stop)
>> seq_show  = (pos == 0 ? proc_show : extra->show)
>>
>> Or I'm missing something?
> 
> Well, I thought about it as two sequences -- first is procfs
> seq-file, which prints out a general header, and second
> is extra fdinfo provider.
> 
> Everything starts with printing procfs header
> 
> seq_start -> seq_show (prints "pos:\t%lli\nflags:\t0%o\n") ->
> seq_next -> (if have extra driver we do extra's start/show at first,

Why show? The generic seq_file.c will call ->next (which will result in
extra->start), then ->show (which _should_ result in extra->show) thus
providing correct output.

> then next and etc). In other words general header should be
> shown always even if extra's start() fails.
> 
> 	Cyrill
> .
> 

