Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751123Ab0EJOUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 10:20:25 -0400
Received: from smtp.nokia.com ([192.100.122.233]:57722 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab0EJOUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 10:20:23 -0400
Date: Mon, 10 May 2010 17:22:48 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: ext Paul Mundt <lethal@linux-sh.org>
Cc: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       Linux-OMAP <linux-omap@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       ext Tony Lindgren <tony@atomide.com>,
       ext Kevin Hilman <khilman@deeprootsystems.com>,
       "De-Schrijver Peter (Nokia-D/Helsinki)" 
	<Peter.De-Schrijver@nokia.com>,
       "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
       Ambresh <a0393775@ti.com>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
Subject: Re: [PATCHv4 1/4] procfs: Introduce socinfo under /proc
Message-ID: <20100510142248.GD11804@besouro.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <1273487857-32281-1-git-send-email-eduardo.valentin@nokia.com>
 <1273487857-32281-3-git-send-email-eduardo.valentin@nokia.com>
 <1273487857-32281-1-git-send-email-eduardo.valentin@nokia.com>
 <1273487857-32281-2-git-send-email-eduardo.valentin@nokia.com>
 <20100510111259.GA14680@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100510111259.GA14680@linux-sh.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 10 May 2010 14:19:16.0236 (UTC) FILETIME=[C5A10CC0:01CAF04B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again,

On Mon, May 10, 2010 at 01:13:00PM +0200, ext Paul Mundt wrote:
> On Mon, May 10, 2010 at 01:37:34PM +0300, Eduardo Valentin wrote:
> > + */
> > +#include <linux/fs.h>
> > +#include <linux/init.h>
> > +#include <linux/proc_fs.h>
> > +#include <linux/seq_file.h>
> > +
> > +extern const struct seq_operations socinfo_op;
> 
> This doesn't look promising..
> 
> > +static int socinfo_open(struct inode *inode, struct file *file)
> > +{
> > +	return seq_open(file, &socinfo_op);
> > +}
> > +
> If you use single_open() ..
> 
> > +static const struct file_operations proc_socinfo_operations = {
> > +	.open		= socinfo_open,
> > +	.read		= seq_read,
> > +	.llseek		= seq_lseek,
> > +	.release	= seq_release,
> > +};
> > +
> .. and single_release(), then none of the seq_operations are necessary.
> 
> > +static int __init proc_socinfo_init(void)
> > +{
> > +	proc_create("socinfo", 0, NULL, &proc_socinfo_operations);
> > +	return 0;
> > +}
> > +module_init(proc_socinfo_init);
> 
> proc_create() can fail, so some error handling here would be nice.
> 
> On Mon, May 10, 2010 at 01:37:35PM +0300, Eduardo Valentin wrote:
> > +static int c_show(struct seq_file *m, void *v)
> > +{
> > +	seq_printf(m, "SoC\t: %s\n", socinfo);
> > +
> > +	return 0;
> > +}
> > +
> > +static void *c_start(struct seq_file *m, loff_t *pos)
> > +{
> > +	return *pos < 1 ? (void *)1 : NULL;
> > +}
> > +
> > +static void *c_next(struct seq_file *m, void *v, loff_t *pos)
> > +{
> > +	++*pos;
> > +	return NULL;
> > +}
> > +
> > +static void c_stop(struct seq_file *m, void *v)
> > +{
> > +}
> > +
> > +const struct seq_operations socinfo_op = {
> > +	.start	= c_start,
> > +	.next	= c_next,
> > +	.stop	= c_stop,
> > +	.show	= c_show
> > +};
> 
> You'll still need the show function, but all of the rest of this is just
> duplicating what single_open() already does. If the socinfo string is
> static you may also want to rework this a bit so you can just stash the
> string in the proc_dir_entry private data. Combine this with something
> like kstrdup() and you'll save yourself a bit of stack while you're at
> it.

While still here, about cleaning this, so, let me see if I got your point.
Basically, the file under fs/proc/socinfo.c whould do the thing with single_open &
single_release, as you stated. But then there is the .show and its data.
One idea would then be to have a function:

int register_socinfo_show(int (*show)(struct seq_file *, void *), void *data);

Which would be exported to other parts of the kernel (something placed under
include/linux/socinfo.h for instance). Then the soc core code
(like arch/arm/mach-omap[1,2]) would then register its local show function and pass its data.

This way I think we can avoid the exports inside .c files (as in this patch)
and also pass the static char * needed during the show.

What do you think?

BR,

--
Eduardo Valentin
