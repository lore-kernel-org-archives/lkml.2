Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab0DKNDs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 09:03:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39238 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab0DKNDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 09:03:46 -0400
Date: Sun, 11 Apr 2010 09:03:41 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 6/6] procfs: Kill the bkl in ioctl
Message-ID: <20100411130341.GA6353@infradead.org>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <20100331172208.GB5163@nowhere> <4BB485ED.80806@s5r6.in-berlin.de> <201004011445.32657.arnd@arndb.de> <20100410152813.GE5204@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100410152813.GE5204@nowhere>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 10, 2010 at 05:28:16PM +0200, Frederic Weisbecker wrote:
> So you mean we should attribute explicit default_llseek to the evil
> places instead of explicit generic_file_llseek in the safe ones?
> That's not a bad idea as it would result in much less changes.
> 
> The problem happens the day you switch to generic_file_llseek() as the
> new default llseek(), how do you prove that all remaining fops
> that don't implement .llseek don't use the bkl? There will be
> hundreds of them and saying "we've looked all of them and they don't
> need it" will be a scary justification.
> 
> On the opposite, attributing explicit generic_file_llseek or
> non_seekable_open on the safe places and default_llseek on
> the dozens of others doubtful places is easier to get a
> safe conclusion.
> 
> But yeah we should try, at least attributing explicit
> default_llseek won't harm, quite the opposite.

Note that an lssek that actually does something is the wrong default,
even if we have it that way currently.  If the default is changed it
should be changed to give the semantics that nonseekable_open()
gives us.  Given that you guys are so motivated to do something in
this area it might be a good idea to do this in a few simple steps:

 - make sure every file operation either has a ->llseek instead or
   calls nonseekable_open from ->open
 - remove nonseekable_open and all calls to it
 - switch all users of no_llseek to not set a ->llsek after auditing
   that there's no corner case where we want to allow pread/pwrite
   but not lseek, which is rather unlikely
 - walk through the instances now using default_llseek and chose
   a better implementation for this particular instance.  Often
   this will be just removing the the lssek method as not allowing
   seeks is the right thing to do for character drivers, even if it
   is a behaviour change from the current version which usually
   is the result of sloppy coding.

