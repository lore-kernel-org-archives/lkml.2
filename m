Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab2G0GXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 02:23:17 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36478 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751286Ab2G0GXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 02:23:14 -0400
Date: Fri, 27 Jul 2012 10:23:10 +0400
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
Message-ID: <20120727062310.GC21246@moon>
References: <20120725094718.089879534@openvz.org>
 <20120725095024.842540518@openvz.org>
 <50120F8C.8010001@parallels.com>
 <20120727060009.GB21246@moon>
 <50123066.20909@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50123066.20909@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 10:08:38AM +0400, Pavel Emelyanov wrote:
> >>> +static void *seq_next(struct seq_file *m, void *p, loff_t *pos)
> >>> +{
> >>> +	struct proc_fdinfo_extra *extra = m->private;
> >>> +	void *v = NULL;
> >>> +
> >>> +	if (extra->driver) {
> >>> +		int ret = 0;
> >>> +
> >>> +		if (*pos == 0) {
> >>> +			v = extra->driver->ops->start(m, pos);
> >>> +			if (v) {
> >>> +				ret = extra->driver->ops->show(m, v);
> >>
> >> Why is it necessary to call ->show here? The logic should be
> >>
> >> seq_start = (pos == 0 ? nop : extra->start)
> >> seq_next  = (pos == 0 ? extra->start : extra->next)
> >> seq_stop  = (pos == 0 ? nop : extra->stop)
> >> seq_show  = (pos == 0 ? proc_show : extra->show)
> >>
> >> Or I'm missing something?
> > 
> > Well, I thought about it as two sequences -- first is procfs
> > seq-file, which prints out a general header, and second
> > is extra fdinfo provider.
> > 
> > Everything starts with printing procfs header
> > 
> > seq_start -> seq_show (prints "pos:\t%lli\nflags:\t0%o\n") ->
> > seq_next -> (if have extra driver we do extra's start/show at first,
> 
> Why show? The generic seq_file.c will call ->next (which will result in
> extra->start), then ->show (which _should_ result in extra->show) thus
> providing correct output.

Yes, indeed i think i've made it more complex than it should be.
Will update, thanks!

	Cyrill
