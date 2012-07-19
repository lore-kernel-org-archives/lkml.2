Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab2GSPDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 11:03:23 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54226 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab2GSPDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 11:03:21 -0400
Date: Thu, 19 Jul 2012 19:03:16 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Matthew Helsley <matt.helsley@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [rfc 5/7] fs, epoll: Add procfs fdinfo helper
Message-ID: <20120719150316.GN10382@moon>
References: <20120627110116.201735815@openvz.org>
 <20120627110512.734751587@openvz.org>
 <CA+RrjuUDR1ZFFQq3tT2K0W0u_KDufOn2rfepndWYVqH6Zqz3bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+RrjuUDR1ZFFQq3tT2K0W0u_KDufOn2rfepndWYVqH6Zqz3bg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 07:52:41AM -0700, Matthew Helsley wrote:
> On Wed, Jun 27, 2012 at 4:01 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> > This allow us to print out eventpoll target file descriptor,
> > events and data, the /proc/pid/fdinfo/fd consists of
> >
> >  | pos: 0
> >  | flags:       02
> >  | tfd:        5 events:       1d data: ffffffffffffffff
> >
> > +#if defined(CONFIG_PROC_FS) && defined(CONFIG_CHECKPOINT_RESTORE)
> > +
> > +struct epitem_fdinfo {
> > +       struct epoll_event      ev;
> > +       int                     fd;
> > +};
> > +
> > +static struct epitem_fdinfo *
> > +seq_lookup_fdinfo(struct proc_fdinfo_extra *extra, struct eventpoll *ep, loff_t num)
> > +{
> > +       struct epitem_fdinfo *fdinfo = extra->priv;
> > +       struct epitem *epi = NULL;
> > +       struct rb_node *rbp;
> > +
> > +       mutex_lock(&ep->mtx);
> > +       for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
> > +               if (num-- == 0) {
> > +                       epi = rb_entry(rbp, struct epitem, rbn);
> > +                       fdinfo->fd = epi->ffd.fd;
> > +                       fdinfo->ev = epi->event;
> > +                       break;
> 
> This will be incredibly slow. epoll was designed to scale to tens of
> thousands of file descriptors. This algorithm is O(N^2) because each
> time we show a new epoll item we walk through the whole rb tree again
> (we're not doing a search so it isn't O(NlogN)).

Yeah, I know, it's quadratic. I'll be reworking this series to use
immediate seq-printf and print out the whole tree once the appropriate
fdinfo file get read.

> Also, we could miss one or more later items if one of the earlier
> items is removed from the epoll set in between "seq_lookup_fdinfo"
> calls. This isn't a problem for checkpoint because we assume the task
> (and everything with this eventpoll file in its fd table) is frozen.
> However it means the file will be worse than useless for almost any
> other purpose because they are unlikely to realize they need to freeze
> all the task(s) to get consistent data.

Well, a bunch of data read from proc is consistent only at moment of
reading.

	Cyrill
