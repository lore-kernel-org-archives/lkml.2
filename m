Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab0DMSDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 14:03:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51071 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab0DMSDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 14:03:38 -0400
Date: Tue, 13 Apr 2010 14:03:32 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 6/6] procfs: Kill the bkl in ioctl
Message-ID: <20100413180332.GB21302@infradead.org>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <20100410152813.GE5204@nowhere> <20100411130341.GA6353@infradead.org> <201004121934.18307.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004121934.18307.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 07:34:17PM +0200, Arnd Bergmann wrote:
> >  - make sure every file operation either has a ->llseek instead or
> >    calls nonseekable_open from ->open
> 
> I still think it would be better to always set llseek if we do that,
> even if nonseekable_open is already there. I can come up with scripts
> that check that case, but checking that the open function always
> calls nonseekable_open when it returns success is beyond my grep
> skills ;-)

Yes, it's not quite easily greppable.  Making no seek allowed the
implicit default will fortunately allow us to get rid of that oddness.

> >  - walk through the instances now using default_llseek and chose
> >    a better implementation for this particular instance.  Often
> >    this will be just removing the the lssek method as not allowing
> >    seeks is the right thing to do for character drivers, even if it
> >    is a behaviour change from the current version which usually
> >    is the result of sloppy coding.
> 
> This part is really hard. While in many cases, the driver maintainer
> might know what user space is potentially opening some character
> device, it's really hard to tell for outsiders whether the behaviour
> should be no_llseek (then the default) or noop_llseek to work around
> broken user space.

That's why it's last on the list.

> I think the rule set for the conversion needs to be one that can
> be done purely based on the code. How about this:
> 
> For each file operation {
> 	if (uses f_pos) {
> 		if (same module uses BKL)
> 			-> default_llseek
> 		else
> 			-> generic_file_llseek
> 	} else {
> 		if (driver maintained)
> 			-> no_llseek (with maintainer ACK)
> 		else
> 			-> noop_llseek
> 	}
> }
> 
> Once that is done, we can turn the default into nonseekable
> behavior and start removing instances of explicit no_llseek
> and nonseekable_open.

That plan sounds good to me.

> Should we also rename default_llseek to deprecated_llseek in the
> process, to go along with the approach for ioctl?

I wouldn't bother.  If you can actually work on your plan default_llseek
should be gone soon enough.

