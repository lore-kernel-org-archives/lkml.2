Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427Ab0HSUYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 16:24:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:55951 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab0HSUYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 16:24:33 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: Eric Paris <eparis@redhat.com>
Subject: Re: [GIT PULL] notification tree - try 37!
Date: Thu, 19 Aug 2010 22:24:11 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, Matt Helsley <matthltc@us.ibm.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        Michael Kerrisk <michael.kerrisk@gmail.com>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com> <201008171009.51737.agruen@suse.de> <1282057706.21419.130.camel@acb20005.ipt.aol.com>
In-Reply-To: <1282057706.21419.130.camel@acb20005.ipt.aol.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008192224.12309.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 August 2010 17:08:26 Eric Paris wrote:
> On Tue, 2010-08-17 at 10:09 +0200, Andreas Gruenbacher wrote:
> > On Tuesday 17 August 2010 05:39:47 Eric Paris wrote:
> > > On Mon, 2010-08-16 at 22:32 +0200, Andreas Gruenbacher wrote:
> > > > Q: What happens when a process watching for FAN_OPEN_PERM or
> > > > FAN_ACCESS_PERM events exits or dies while events are in flight?  I
> > > > can't see anything in the code that would wake sleeping processes up
> > > > when the fsnotify_group of the listener is torn down.
> > > 
> > > We can get stuck.  There was code which cleaned that up, but it got
> > > accidentally removed long ago when, upon review on list, I was told to
> > > remove all timeout code.  It's easy enough to fix up.  I'll post a
> > > patch this week.
> > 
> > This needs to be fixed then.  Not such a big deal, but it shows that the
> > tree wasn't ready for being merged yet and needs further review.
> 
> Code with bugs, shocking!  Two other bugs have been found and patches
> for those will be coming shortly.  I've begged for review how many
> times?  I don't care when review it comes, I'll address any issues as
> they come up.

Here is one more bug: when watching a directory with inotify, doing an ls 
gives me:

	Watching d
	d was opened
	d not opened for writing was closed

Watching the same directory with fanotify results in:

	.../d: pid=... open_perm
	.../d: pid=... open
	.../d: pid=... access_perm
	.../d: pid=... access_perm
	.../d: pid=... close

Five events seem a bit excessive; I can't explain why so many are generated.  
The real issue is when watching the same directory both with inotify and 
fanotify, though: the fanotify result stays the same, but 

	Watching d
	d has not changed
	d was opened
	d has not changed
	d has not changed
	d not opened for writing was closed

In other words, watching a directory with fanotify causes extra inotify events 
with mask == 0.

Andreas
