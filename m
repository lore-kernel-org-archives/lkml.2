Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab0HSUnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 16:43:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331Ab0HSUnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 16:43:31 -0400
Subject: Re: [GIT PULL] notification tree - try 37!
From: Eric Paris <eparis@redhat.com>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Matt Helsley <matthltc@us.ibm.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        Michael Kerrisk <michael.kerrisk@gmail.com>
In-Reply-To: <201008192224.12309.agruen@suse.de>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com>
	 <201008171009.51737.agruen@suse.de>
	 <1282057706.21419.130.camel@acb20005.ipt.aol.com>
	 <201008192224.12309.agruen@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Aug 2010 16:42:45 -0400
Message-ID: <1282250565.21419.1821.camel@acb20005.ipt.aol.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 22:24 +0200, Andreas Gruenbacher wrote:
> On Tuesday 17 August 2010 17:08:26 Eric Paris wrote:
> > On Tue, 2010-08-17 at 10:09 +0200, Andreas Gruenbacher wrote:
> > > On Tuesday 17 August 2010 05:39:47 Eric Paris wrote:
> > > > On Mon, 2010-08-16 at 22:32 +0200, Andreas Gruenbacher wrote:
> > > > > Q: What happens when a process watching for FAN_OPEN_PERM or
> > > > > FAN_ACCESS_PERM events exits or dies while events are in flight?  I
> > > > > can't see anything in the code that would wake sleeping processes up
> > > > > when the fsnotify_group of the listener is torn down.
> > > > 
> > > > We can get stuck.  There was code which cleaned that up, but it got
> > > > accidentally removed long ago when, upon review on list, I was told to
> > > > remove all timeout code.  It's easy enough to fix up.  I'll post a
> > > > patch this week.
> > > 
> > > This needs to be fixed then.  Not such a big deal, but it shows that the
> > > tree wasn't ready for being merged yet and needs further review.
> > 
> > Code with bugs, shocking!  Two other bugs have been found and patches
> > for those will be coming shortly.  I've begged for review how many
> > times?  I don't care when review it comes, I'll address any issues as
> > they come up.
> 
> Here is one more bug: when watching a directory with inotify, doing an ls 
> gives me:
> 
> 	Watching d
> 	d was opened
> 	d not opened for writing was closed
> 
> Watching the same directory with fanotify results in:
> 
> 	.../d: pid=... open_perm
> 	.../d: pid=... open
> 	.../d: pid=... access_perm
> 	.../d: pid=... access_perm
> 	.../d: pid=... close
> 
> Five events seem a bit excessive; I can't explain why so many are generated.  
> The real issue is when watching the same directory both with inotify and 
> fanotify, though: the fanotify result stays the same, but 

The extra events are plainly the new events that inotify doesn't
support: namely permissions events.  You ask for and received extra
events....

> 	Watching d
> 	d has not changed
> 	d was opened
> 	d has not changed
> 	d has not changed
> 	d not opened for writing was closed
> 
> In other words, watching a directory with fanotify causes extra inotify events 
> with mask == 0.

I can't reproduce it.

inotifywait -m /mnt/tmp
fanotify -p /mnt/tmp
ls /mnt/tmp

All I see is:

# /tmp/inotifywait.strace -- inotifywait -m /mnt/tmp/
Setting up watches.  
Watches established.
/mnt/tmp/ OPEN,ISDIR 
/mnt/tmp/ CLOSE_NOWRITE,CLOSE,ISDIR

# /storage/tmp/fanotify/fanotify -p /mnt/tmp
/mnt/tmp: pid=508 open_perm
/mnt/tmp: pid=508 open
/mnt/tmp: pid=508 access_perm
/mnt/tmp: pid=508 close

# ls
file  lost+found

You must have some other testing methodology.....

