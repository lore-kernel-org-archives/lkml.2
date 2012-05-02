Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab2EBXHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 19:07:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65496 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694Ab2EBXHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 19:07:34 -0400
Date: Wed, 2 May 2012 16:07:30 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sasikanth babu <sasikanth.v19@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] debugfs: New debugfs interface for creation of files,
 directory and symlinks
Message-ID: <20120502230730.GA20055@kroah.com>
References: <1335963054-24750-1-git-send-email-sasikanth.v19@gmail.com>
 <20120502153100.GA2777@kroah.com>
 <CAOJFanXZEUfM4GQS62u4oR-KwywdLGOciOcgzmrM9zW+kOrXkg@mail.gmail.com>
 <20120502220417.GA2667@kroah.com>
 <20120502152003.d7b6aae9.akpm@linux-foundation.org>
 <20120502223603.GA3103@kroah.com>
 <20120502154438.8b44b5a3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120502154438.8b44b5a3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 03:44:38PM -0700, Andrew Morton wrote:
> On Wed, 2 May 2012 15:36:03 -0700
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > > 
> > > The API is stupid and wrong, actually.  There is no *advantage* to
> > > having done it this way - none at all.
> > 
> > Yes there is, it makes the caller logic trivial, which was the main goal
> > here in getting people to use it over creating new proc files all the
> > time for no good reason.
> > 
> > No one cares about the return value when you create a proc file, either
> > it succeeds or not, and you handle things from there, you never change
> > the name to try it again.
> > 
> > Same thing with debugfs, you only care if it works or not, and really,
> > you don't even care if it works, as the api lets you continue on if it
> > didn't just fine.
> > 
> > These are debugging files, with no set rules on what they contain.  Yes,
> > people have grown to get used to them over the years, but the namespace
> > in which they work has worked out for itself, and I have yet to ever
> > hear of any two people wanting to create the same file/directory
> > anywhere, and have anything fail.
> > 
> > Or am I missing some subsystem that is having problems like this with
> > debugfs?
> 
> grr, you appear to have ignored everything I wrote.  Here it is again:

No, sorry, I didn't ignore it.

> > > That's the whole reason we have errnos: to report on what went wrong,
> > > so operators can understand *why* it failed and so that programmers can
> > > diagnose and fix bugs.
> 
> and
> 
> > > If well-written code checks the return value (as it should) and then
> > > propagates an error code back to its caller (as it should), the stupid
> > > debugfs interface forces that caller to invent an errno from thin air.
> > > And if that guessed errno is wrong, it is actively misleading!
> 
> I would add that an interface which encourages callers to silently
> ignore programming and configuration errors is not a good one.

I would not disagree, but I wrote this interface to be as simple as
possible.  Perhaps I messed up, but I don't think so as it was a strong
point to get people to use it in the first place.  It was less lines of
code to use debugfs instead of proc files, and you can do error
detection, it's just a binary "did this work or not" type of detection,
not a "this failed in this manner" type of error.

And for one-off debugging files, I still think "did this work or not" is
as good as is needed.  The only errors that could come back really would
be:
	-EEXISTS
	-ENOMEM

If we have no more memory, things are messed up and recovering is going
to be hard anyway.

If the file/dir already exists, it was hard-coded in the first place, so
changing it requires changing the code.  So returning NULL for -EEXISTS
is just as good, as the code will not work, it's "obvious" that the
existing file is not the one that you just tried to create, so something
needs to be changed.

A rich error reporting system is good for things that matter.  I didn't
feel that debugfs files really "matter" when I created it.  The fact
that this hasn't come up as a real problem in the 8+ years that debugfs
has been around, either means I was right, or that no one cared until
now :)

thanks,

greg k-h
