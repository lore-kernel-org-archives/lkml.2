Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab0HWQqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 12:46:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556Ab0HWQqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 12:46:33 -0400
Subject: Re: [GIT PULL] notification tree - try 37!
From: Eric Paris <eparis@redhat.com>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Matt Helsley <matthltc@us.ibm.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, Michael Kerrisk <michael.kerrisk@gmail.com>
In-Reply-To: <201008201438.16637.agruen@suse.de>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com>
	 <201008192307.32526.agruen@suse.de>
	 <1282276236.21419.2101.camel@acb20005.ipt.aol.com>
	 <201008201438.16637.agruen@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Aug 2010 12:46:13 -0400
Message-ID: <1282581973.2681.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-20 at 14:38 +0200, Andreas Gruenbacher wrote:
> On Friday 20 August 2010 05:50:36 Eric Paris wrote:
> > We must be doing something different...  What kernel?  what kconfig?
> > What exact FS setup?  What exact steps are you taking?  What programs
> > are you using to test east side?
> 
> I'm runnning 2.6.36-rc1, with CONFIG_FANOTIFY and 
> CONFIG_FANOTIFY_ACCESS_PERMISSIONS on apparently.  I am watching the same 
> directory with inotify and fanotify at the same time, that is, with both an 
> inotify and an fanotify listener running in two separate processes.  The 
> inotify listener is code I cannot send so easily, but I've shown the resulting 
> strace.  The fanotify listener is the one from [1].
> 
> 	[1] http://git.kernel.org/?p=linux/kernel/git/agruen/fanotify-example.git
> 
> Together with the traces I've provided this should give you way enough clues 
> to be able to look up in the code why listening for fanotify events apparently 
> causes a concurrent inotify listener to return an inotify event with struct 
> inotify_event->mask == 0 for each fanotify perm event.

Spent a bit of the weekend trying to figure out what you were doing and
couldn't reproduce it or find it in the code because I had already fixed
it (albeit for slightly different reasons).  The patch in question was:

http://marc.info/?l=linux-kernel&m=128214903125780&w=2

the vfsmount_test_mask was always initialized but since no vfsmount
marks were found it was never cleared.  This left the code thinking that
the given (inode) mark was interested in the event.  I think you could
reproduce it differently

inotifywait -m -e open /mnt/tmp
inotifywait -m -e close /mnt/tmp

and you would get both event types for both watches.

-Eric

