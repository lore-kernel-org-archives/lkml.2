Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab2G0GAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 02:00:15 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49366 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab2G0GAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 02:00:13 -0400
Date: Fri, 27 Jul 2012 10:00:09 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 3/7] procfs: Add ability to plug in auxiliary fdinfo
 providers
Message-ID: <20120727060009.GB21246@moon>
References: <20120725094718.089879534@openvz.org>
 <20120725095024.842540518@openvz.org>
 <50120F8C.8010001@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50120F8C.8010001@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 07:48:28AM +0400, Pavel Emelyanov wrote:
> > +static int prep_fdinfo_driver(struct proc_fdinfo_extra *extra)
> > +{
> > +	struct proc_fdinfo_driver *s;
> > +
> > +	down_read(&fdinfo_drivers_sem);
> > +	list_for_each_entry(s, &fdinfo_drivers, list) {
> > +		if (s->probe(extra->f_file)) {
> > +			extra->driver = s;
> > +			break;
> > +		}
> > +	}
> > +	up_read(&fdinfo_drivers_sem);
> > +
> > +	return 0;
> > +}
> 
> Maybe a simple list of file_operations:seq_operations mappings would be simpler?

Yeah, I thought about it. This seems to be a way more simplier.
I think i'll switch to this.

> 
> > +static void *seq_next(struct seq_file *m, void *p, loff_t *pos)
> > +{
> > +	struct proc_fdinfo_extra *extra = m->private;
> > +	void *v = NULL;
> > +
> > +	if (extra->driver) {
> > +		int ret = 0;
> > +
> > +		if (*pos == 0) {
> > +			v = extra->driver->ops->start(m, pos);
> > +			if (v) {
> > +				ret = extra->driver->ops->show(m, v);
> 
> Why is it necessary to call ->show here? The logic should be
> 
> seq_start = (pos == 0 ? nop : extra->start)
> seq_next  = (pos == 0 ? extra->start : extra->next)
> seq_stop  = (pos == 0 ? nop : extra->stop)
> seq_show  = (pos == 0 ? proc_show : extra->show)
> 
> Or I'm missing something?

Well, I thought about it as two sequences -- first is procfs
seq-file, which prints out a general header, and second
is extra fdinfo provider.

Everything starts with printing procfs header

seq_start -> seq_show (prints "pos:\t%lli\nflags:\t0%o\n") ->
seq_next -> (if have extra driver we do extra's start/show at first,
then next and etc). In other words general header should be
shown always even if extra's start() fails.

	Cyrill
