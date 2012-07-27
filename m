Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab2G0Dso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 23:48:44 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:47725 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678Ab2G0Dsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 23:48:43 -0400
Message-ID: <50120F8C.8010001@parallels.com>
Date: Fri, 27 Jul 2012 07:48:28 +0400
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
References: <20120725094718.089879534@openvz.org> <20120725095024.842540518@openvz.org>
In-Reply-To: <20120725095024.842540518@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int prep_fdinfo_driver(struct proc_fdinfo_extra *extra)
> +{
> +	struct proc_fdinfo_driver *s;
> +
> +	down_read(&fdinfo_drivers_sem);
> +	list_for_each_entry(s, &fdinfo_drivers, list) {
> +		if (s->probe(extra->f_file)) {
> +			extra->driver = s;
> +			break;
> +		}
> +	}
> +	up_read(&fdinfo_drivers_sem);
> +
> +	return 0;
> +}

Maybe a simple list of file_operations:seq_operations mappings would be simpler?

> +static void *seq_next(struct seq_file *m, void *p, loff_t *pos)
> +{
> +	struct proc_fdinfo_extra *extra = m->private;
> +	void *v = NULL;
> +
> +	if (extra->driver) {
> +		int ret = 0;
> +
> +		if (*pos == 0) {
> +			v = extra->driver->ops->start(m, pos);
> +			if (v) {
> +				ret = extra->driver->ops->show(m, v);

Why is it necessary to call ->show here? The logic should be

seq_start = (pos == 0 ? nop : extra->start)
seq_next  = (pos == 0 ? extra->start : extra->next)
seq_stop  = (pos == 0 ? nop : extra->stop)
seq_show  = (pos == 0 ? proc_show : extra->show)

Or I'm missing something?

Thanks,
Pavel
