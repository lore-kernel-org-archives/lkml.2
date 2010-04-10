Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab0DJP2Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 11:28:25 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:32922 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab0DJP2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 11:28:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AAABkUE6heY5UqDs6gbhwqOZf4rOlgjSSIymFeU+QFSqG/w1V3bv7Ikk0PIsaJvZrr
         lA6NkXiqwyU0/YUr/q8YxeSkLm3ncikcTqpCl7avBNjfegSfRAcprB2fVDu5xu75v4Mt
         s6gsFsslSlj1vp/FAKRTbgGwrO4OK2fLQpaVQ=
Date: Sat, 10 Apr 2010 17:28:16 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 6/6] procfs: Kill the bkl in ioctl
Message-ID: <20100410152813.GE5204@nowhere>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <20100331172208.GB5163@nowhere> <4BB485ED.80806@s5r6.in-berlin.de> <201004011445.32657.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004011445.32657.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 02:45:32PM +0200, Arnd Bergmann wrote:
> On Thursday 01 April 2010, Stefan Richter wrote:
> > > 
> > > I wonder if we should actually just turn all these into unlocked_ioctl
> > > directly. And then bring a warn on ioctl, and finally schedule the removal
> > > of this callback.
> > 
> > A side note:  A considerable portion of this particular commit in Arnd's
> > git actually does not deal with .ioctl->.unlocked_ioctl at all, but
> > purely with .llseek.  Many(?) of these changes deal with .ioctl and
> > .llseek together.  (Arnd also says so in the last paragraph of his
> > changelog.)
> > 
> > IOW there are less .ioctl implementations left than one could think from
> > a look at the diffstat.
> 
> Given our recent discussions on the llseek topic, it's probably better to
> revert most of the changes that purely deal with llseek. My current idea
> is to use an explicit default_llseek only if one of the following is given:
> 
> - we convert ioctl to unlocked_ioctl in the same file_operations, or
> - the module uses the big kernel lock explicitly elsewhere.
> 
> Even then, there may be a number of cases where we can show it not
> to be necessary, e.g. when the driver does not care about f_pos.
> Concurrent llseek is racy by nature, so in most drivers, using the
> BKL in llseek does not gain anything over using i_mutex.
> 
> 	Arnd



So you mean we should attribute explicit default_llseek to the evil
places instead of explicit generic_file_llseek in the safe ones?
That's not a bad idea as it would result in much less changes.

The problem happens the day you switch to generic_file_llseek() as the
new default llseek(), how do you prove that all remaining fops
that don't implement .llseek don't use the bkl? There will be
hundreds of them and saying "we've looked all of them and they don't
need it" will be a scary justification.

On the opposite, attributing explicit generic_file_llseek or
non_seekable_open on the safe places and default_llseek on
the dozens of others doubtful places is easier to get a
safe conclusion.

But yeah we should try, at least attributing explicit
default_llseek won't harm, quite the opposite.

