Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab0DLRfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 13:35:25 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57767 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab0DLRfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 13:35:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/6] procfs: Kill the bkl in ioctl
Date: Mon, 12 Apr 2010 19:34:17 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <20100410152813.GE5204@nowhere> <20100411130341.GA6353@infradead.org>
In-Reply-To: <20100411130341.GA6353@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004121934.18307.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18Bw9eYlBvZI78xj5FPey8xdHkKq/3iU0mHtcp
 ohYQaQFjo6uaQ9VLWNOmDY+o3PPVMoZ4f6FDmXCbPSLyz+9Jdb
 Zd94Bwb8Q2EpQG5WGnjIQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 April 2010, Christoph Hellwig wrote:
> On Sat, Apr 10, 2010 at 05:28:16PM +0200, Frederic Weisbecker wrote:
> > So you mean we should attribute explicit default_llseek to the evil
> > places instead of explicit generic_file_llseek in the safe ones?
> > That's not a bad idea as it would result in much less changes.
> > 
> > The problem happens the day you switch to generic_file_llseek() as the
> > new default llseek(), how do you prove that all remaining fops
> > that don't implement .llseek don't use the bkl? There will be
> > hundreds of them and saying "we've looked all of them and they don't
> > need it" will be a scary justification.
> > 
> > On the opposite, attributing explicit generic_file_llseek or
> > non_seekable_open on the safe places and default_llseek on
> > the dozens of others doubtful places is easier to get a
> > safe conclusion.
> > 
> > But yeah we should try, at least attributing explicit
> > default_llseek won't harm, quite the opposite.
> 
> Note that an lssek that actually does something is the wrong default,
> even if we have it that way currently.  If the default is changed it
> should be changed to give the semantics that nonseekable_open()
> gives us.  Given that you guys are so motivated to do something in
> this area it might be a good idea to do this in a few simple steps:
> 
>  - make sure every file operation either has a ->llseek instead or
>    calls nonseekable_open from ->open

I still think it would be better to always set llseek if we do that,
even if nonseekable_open is already there. I can come up with scripts
that check that case, but checking that the open function always
calls nonseekable_open when it returns success is beyond my grep
skills ;-)

>  - remove nonseekable_open and all calls to it
>  - switch all users of no_llseek to not set a ->llsek after auditing
>    that there's no corner case where we want to allow pread/pwrite
>    but not lseek, which is rather unlikely

This parts seems fine.

>  - walk through the instances now using default_llseek and chose
>    a better implementation for this particular instance.  Often
>    this will be just removing the the lssek method as not allowing
>    seeks is the right thing to do for character drivers, even if it
>    is a behaviour change from the current version which usually
>    is the result of sloppy coding.

This part is really hard. While in many cases, the driver maintainer
might know what user space is potentially opening some character
device, it's really hard to tell for outsiders whether the behaviour
should be no_llseek (then the default) or noop_llseek to work around
broken user space.

I think the rule set for the conversion needs to be one that can
be done purely based on the code. How about this:

For each file operation {
	if (uses f_pos) {
		if (same module uses BKL)
			-> default_llseek
		else
			-> generic_file_llseek
	} else {
		if (driver maintained)
			-> no_llseek (with maintainer ACK)
		else
			-> noop_llseek
	}
}

Once that is done, we can turn the default into nonseekable
behavior and start removing instances of explicit no_llseek
and nonseekable_open.

Should we also rename default_llseek to deprecated_llseek in the
process, to go along with the approach for ioctl?

	Arnd
