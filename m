Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab0IWCvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 22:51:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:40392 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711Ab0IWCvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 22:51:54 -0400
Date: Thu, 23 Sep 2010 12:51:46 +1000
From: Neil Brown <neilb@suse.de>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the nfsd tree
Message-ID: <20100923125146.01755207@notabene>
In-Reply-To: <20100923023315.GA10764@fieldses.org>
References: <20100923113429.88f865d2.sfr@canb.auug.org.au>
	<20100923023315.GA10764@fieldses.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Sep 2010 22:33:15 -0400
"J. Bruce Fields" <bfields@fieldses.org> wrote:

> On Thu, Sep 23, 2010 at 11:34:29AM +1000, Stephen Rothwell wrote:
> > Hi Bruce,
> > 
> > After merging the nfsd tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> > 
> > ERROR: ".get_task_comm" [fs/nfsd/nfsd.ko] undefined!
> > 
> > Caused by commit c67874f942e30039442d925b03793e0a46ddcddd ("nfsd:
> > formally deprecate legacy nfsd syscall interface").
> > 
> > get_task_comm is not exported to modules.
> > 
> > I have used the version of the nfsd tree from next-20100921 for today.
> 
> Oops, thanks.
> 
> It looks like a lot of places just do a
> 
> 	printk("%s using deprecated interface ...", current->comm);
> 
> so maybe we can get away with just that?
> 
> --b.

sched.h says:

	char comm[TASK_COMM_LEN]; /* executable name excluding path
				     - access with [gs]et_task_comm (which lock
				       it with task_lock())
				     - initialized normally by setup_new_exec */

So we should lock...

But then fs/exec.c says:
void set_task_comm(struct task_struct *tsk, char *buf)
{
	task_lock(tsk);

	/*
	 * Threads may access current->comm without holding
	 * the task lock, so write the string carefully.
	 * Readers without a lock may see incomplete new
	 * names but are safe from non-terminating string reads.
	 */
     .....

So I guess we are safe to use it unlocked for informational purposes.
That first comment could do with an update, and where-ever it was that I
copied that code from can probably be simplified too.....

NeilBrown
