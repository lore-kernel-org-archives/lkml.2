Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab0EJLNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 07:13:46 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:38820 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728Ab0EJLNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 07:13:45 -0400
Date: Mon, 10 May 2010 20:13:00 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Eduardo Valentin <eduardo.valentin@nokia.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
       Linux-OMAP <linux-omap@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       ext Tony Lindgren <tony@atomide.com>,
       ext Kevin Hilman <khilman@deeprootsystems.com>,
       Peter De-Schrijver <Peter.De-Schrijver@nokia.com>,
       santosh.shilimkar@ti.com, Ambresh <a0393775@ti.com>,
       felipe.balbi@nokia.com
Subject: Re: [PATCHv4 1/4] procfs: Introduce socinfo under /proc
Message-ID: <20100510111259.GA14680@linux-sh.org>
References: <1273487857-32281-1-git-send-email-eduardo.valentin@nokia.com> <1273487857-32281-3-git-send-email-eduardo.valentin@nokia.com> <1273487857-32281-1-git-send-email-eduardo.valentin@nokia.com> <1273487857-32281-2-git-send-email-eduardo.valentin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273487857-32281-3-git-send-email-eduardo.valentin@nokia.com> <1273487857-32281-2-git-send-email-eduardo.valentin@nokia.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 01:37:34PM +0300, Eduardo Valentin wrote:
> + */
> +#include <linux/fs.h>
> +#include <linux/init.h>
> +#include <linux/proc_fs.h>
> +#include <linux/seq_file.h>
> +
> +extern const struct seq_operations socinfo_op;

This doesn't look promising..

> +static int socinfo_open(struct inode *inode, struct file *file)
> +{
> +	return seq_open(file, &socinfo_op);
> +}
> +
If you use single_open() ..

> +static const struct file_operations proc_socinfo_operations = {
> +	.open		= socinfo_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= seq_release,
> +};
> +
.. and single_release(), then none of the seq_operations are necessary.

> +static int __init proc_socinfo_init(void)
> +{
> +	proc_create("socinfo", 0, NULL, &proc_socinfo_operations);
> +	return 0;
> +}
> +module_init(proc_socinfo_init);

proc_create() can fail, so some error handling here would be nice.

On Mon, May 10, 2010 at 01:37:35PM +0300, Eduardo Valentin wrote:
> +static int c_show(struct seq_file *m, void *v)
> +{
> +	seq_printf(m, "SoC\t: %s\n", socinfo);
> +
> +	return 0;
> +}
> +
> +static void *c_start(struct seq_file *m, loff_t *pos)
> +{
> +	return *pos < 1 ? (void *)1 : NULL;
> +}
> +
> +static void *c_next(struct seq_file *m, void *v, loff_t *pos)
> +{
> +	++*pos;
> +	return NULL;
> +}
> +
> +static void c_stop(struct seq_file *m, void *v)
> +{
> +}
> +
> +const struct seq_operations socinfo_op = {
> +	.start	= c_start,
> +	.next	= c_next,
> +	.stop	= c_stop,
> +	.show	= c_show
> +};

You'll still need the show function, but all of the rest of this is just
duplicating what single_open() already does. If the socinfo string is
static you may also want to rework this a bit so you can just stash the
string in the proc_dir_entry private data. Combine this with something
like kstrdup() and you'll save yourself a bit of stack while you're at
it.
