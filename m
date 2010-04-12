Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab0DLVxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 17:53:33 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:32850 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab0DLVxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 17:53:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EMpkBFk13qu9/yKCkorAqchvbJkVVwU5M2xt0963elR2q2Fl9NojD6CuHW4MAFp3/+
         j9CgV2jGmT2b3ZvPyJzAPXhsG6OiEKFFtQXvR+B2jr30p17gzqG96WjmklxTYKIdiHyK
         sOBStXocmGr72iH4I+jCCCgFT9D4zB1Mjg2zA=
Date: Mon, 12 Apr 2010 23:53:22 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 6/6] procfs: Kill the bkl in ioctl
Message-ID: <20100412215320.GF8285@nowhere>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <20100410152813.GE5204@nowhere> <20100411130341.GA6353@infradead.org> <201004121934.18307.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004121934.18307.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 07:34:17PM +0200, Arnd Bergmann wrote:
> On Sunday 11 April 2010, Christoph Hellwig wrote:
> > On Sat, Apr 10, 2010 at 05:28:16PM +0200, Frederic Weisbecker wrote:
> > > So you mean we should attribute explicit default_llseek to the evil
> > > places instead of explicit generic_file_llseek in the safe ones?
> > > That's not a bad idea as it would result in much less changes.
> > > 
> > > The problem happens the day you switch to generic_file_llseek() as the
> > > new default llseek(), how do you prove that all remaining fops
> > > that don't implement .llseek don't use the bkl? There will be
> > > hundreds of them and saying "we've looked all of them and they don't
> > > need it" will be a scary justification.
> > > 
> > > On the opposite, attributing explicit generic_file_llseek or
> > > non_seekable_open on the safe places and default_llseek on
> > > the dozens of others doubtful places is easier to get a
> > > safe conclusion.
> > > 
> > > But yeah we should try, at least attributing explicit
> > > default_llseek won't harm, quite the opposite.
> > 
> > Note that an lssek that actually does something is the wrong default,
> > even if we have it that way currently.  If the default is changed it
> > should be changed to give the semantics that nonseekable_open()
> > gives us.  Given that you guys are so motivated to do something in
> > this area it might be a good idea to do this in a few simple steps:
> > 
> >  - make sure every file operation either has a ->llseek instead or
> >    calls nonseekable_open from ->open
> 
> I still think it would be better to always set llseek if we do that,
> even if nonseekable_open is already there. I can come up with scripts
> that check that case, but checking that the open function always
> calls nonseekable_open when it returns success is beyond my grep
> skills ;-)
> 
> >  - remove nonseekable_open and all calls to it
> >  - switch all users of no_llseek to not set a ->llsek after auditing
> >    that there's no corner case where we want to allow pread/pwrite
> >    but not lseek, which is rather unlikely
> 
> This parts seems fine.
> 
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



Also even if llseek is useless for a module, turning it into
unseekable somehow changes the userspace ABI. I guess this
is harmless 99% of the time, but still. And maintainers tend
not to like that.



> 
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



It is also hard to determine a given driver really doesn't use
the bkl. A sole lock_kernel() grep in its files is not sufficient.
But a manual second pass should do the trick.


> 
> Once that is done, we can turn the default into nonseekable
> behavior and start removing instances of explicit no_llseek
> and nonseekable_open.


Sounds good.



> Should we also rename default_llseek to deprecated_llseek in the
> process, to go along with the approach for ioctl?


Yeah, preferably.

Thanks.

