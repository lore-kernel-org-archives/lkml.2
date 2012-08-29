Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab2H2Ice (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 04:32:34 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38482 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab2H2Icb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 04:32:31 -0400
Date: Wed, 29 Aug 2012 11:32:26 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] fs/proc: Move kfree outside pde_unload_lock
Message-ID: <20120829083226.GA4511@p183.telecom.by>
References: <n>
 <1345653510-22000-1-git-send-email-nzimmer@sgi.com>
 <1345660110.5158.1969.camel@edumazet-glaptop>
 <1345671778.5158.2369.camel@edumazet-glaptop>
 <20120828203826.GA5868@p183.telecom.by>
 <1346213517.2522.2.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346213517.2522.2.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 09:11:57PM -0700, Eric Dumazet wrote:
> On Tue, 2012-08-28 at 23:38 +0300, Alexey Dobriyan wrote:
> 
> > Nothing can stop RCU!
> > 
> > After running "modprobe;rmmod" in a loop and "cat" in another loop for a while
> > rmmod got stuck in D-state inside remove_proc_entry() with trace amounts of CPU time
> > being consumed.
> > 
> > It didn't oopsed, though.
> 
> Thanks ! 
> 
> I'll polish this patch once LKS/LPC is over...
> 
> What particular module and/or proc file did you use for your tests ?

Just dummy one.

#include <linux/init.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>

static int foo_proc_show(struct seq_file *m, void *v)
{
	seq_puts(m, "foo\n");
	return 0;
}

static int foo_proc_open(struct inode *inode, struct file *file)
{
	return single_open(file, foo_proc_show, NULL);
}

static const struct file_operations foo_proc_ops = {
	.open	= foo_proc_open,
	.read	= seq_read,
	.llseek	= seq_lseek,
	.release = single_release,
};

static int __init foo_module_init(void)
{
	proc_create("foo", 0, NULL, &foo_proc_ops);
	return 0;
}

static void __exit foo_module_exit(void)
{
	remove_proc_entry("foo", NULL);
}
module_init(foo_module_init);
module_exit(foo_module_exit);
