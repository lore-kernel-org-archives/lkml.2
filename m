Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab1JWMp6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 08:45:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56438 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441Ab1JWMp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 08:45:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: NeilBrown <neilb@suse.de>
Subject: Re: lsusd - The Linux SUSpend Daemon
Date: Sun, 23 Oct 2011 14:48:22 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        John Stultz <john.stultz@linaro.org>,
        mark gross <markgross@thegnar.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20111022093436.0742176c@notabene.brown> <Pine.LNX.4.44L0.1110212125020.8657-100000@netrider.rowland.org> <20111023192147.49413485@notabene.brown>
In-Reply-To: <20111023192147.49413485@notabene.brown>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201110231448.23069.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, October 23, 2011, NeilBrown wrote:
> On Fri, 21 Oct 2011 22:00:13 -0400 (EDT) Alan Stern
> <stern@rowland.harvard.edu> wrote:
> 
> > On Sat, 22 Oct 2011, NeilBrown wrote:
> > 
> > > > >     It uses files in /var/run/suspend for all communication.
> > > > 
> > > > I'm not so keen on using files for communication.  At best, they are
> > > > rather awkward for two-way messaging.  If you really want to use them,
> > > > then at least put them on a non-backed filesystem, like something under
> > > > /dev.
> > > 
> > > Isn't /var/run a tmpfs filesystem?  It should be.
> > > Surely /run is, so in the new world order the files should probably go
> > > there.   But that is just a detail.
> > 
> > On my Fedora-14 systems there is no /run, and /var/run is a regular 
> > directory in a regular filesystem.
> > 
> > > I like files...  I particularly like 'flock' to block suspend.   The
> > > rest.... whatever..
> > > With files, you only need a context switch when there is real communication.
> > > With sockets, every message sent must be read so there will be a context
> > > switch.
> > > 
> > > Maybe we could do something with futexes...
> > 
> > Not easily -- as far as I can tell, futexes enjoy relatively little 
> > support.  In any case, they provide the same service as a mutex, which 
> > means you'd have to build a shared lock on top of them.
> > 
> > > > >     lsusd does not try to be event-loop based because:
> > > > >       - /sys/power/wakeup_count is not pollable.  This could probably be
> > > > >         'fixed' but I want code to work with today's kernel.  It will probably
> > > > 
> > > > Why does this matter?
> > > 
> > > In my mind an event based program should never block.  Every action should be
> > > non-blocking and only taken when 'poll' says it can.
> > > Reading /sys/power/wakeup_count can be read non-blocking, but you cannot find
> > > out when it is sensible to try to read it again.  So it doesn't fit.
> > 
> > There shouldn't be any trouble about making wakeup_count pollable.  It
> > also would need to respect nonblocking reads, which it currently does 
> > not do.
> 
> Hmm.. you are correct.  I wonder why I thought it did support non-blocking
> reads...
> I guess it was the code for handling an interrupted system call.
> 
> I feel a bit uncomfortable with the idea of sysfs files that block but I
> don't think I can convincingly argue against it.
> A non-blocking flag could be passed in, but it would be a very messy change -
> lots of function call signatures changing needlessly:  we would need a flag
> to the 'show' method ... or add a 'show_nonblock' method which would also be
> ugly.
> 
> 
> But I think there is a need to block - if there is an in-progress event then
> it must be possible to wait for it to complete as it may not be visible to
> userspace until then.
> We could easily enable 'poll' for wakeup_count and then make it always
> non-blocking, but I'm not really sure I want to require programs to use poll,
> only to allow them.  And without using poll there is no way to wait.
> 
> As wakeup_count really has to be single-access we could possibly fudge
> something by remembering the last value read (like we remember the last value
> written).
> 
> - if the current count is different from the last value read, then return
>   it even if there are in-progress events.
> - if the current count is the same as the last value read, then block until
>   there are no in-progress events and return the new value.
> - enable sysfs_poll on wakeup_count by calling sysfs_notify_dirent at the
>   end of wakeup_source_deactivated .... or calling something in
>   kernel/power/main.c which calls that.  However we would need to make
>   sysfs_notify_dirent a lot lighter weight first.  Maybe I should do that.
> 
> Then a process that uses 'poll' could avoid reading wakeup_count except when
> it has changed, and then it won't block.  And a process that doesn't use poll
> can block by simply reading twice - either explicitly or by going around a 
>    read then write and it fails
> loop a second time.
> 
> I'm not sure I'm completely comfortable with that, but it is the best I could
> come up with.

Well, you're now considering doing more and more changes to the kernel
just to be able to implement something in user space to avoid making
some _other_ changes to the kernel.  That doesn't sound right to me.

Thanks,
Rafael
