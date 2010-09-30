Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab0I3NeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 09:34:12 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:56799 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755995Ab0I3NeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 09:34:10 -0400
Date: Thu, 30 Sep 2010 09:19:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Ian Jackson <Ian.Jackson@eu.citrix.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: Powertop shows events/0 waking at high rate due to ptys
Message-ID: <20100930071907.GA2429@ucw.cz>
References: <4CA0D660.3010804@goop.org>
 <20100927191536.1de29492@lxorguk.ukuu.org.uk>
 <4CA1367F.7040106@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA1367F.7040106@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2010-09-27 17:27:43, Jeremy Fitzhardinge wrote:
>  On 09/27/2010 11:15 AM, Alan Cox wrote:
> > Really the line discipline should wake the work queue when it sets
> > tty->receive_room non-zero, but while only n_tty currently uses that
> > facility the existing code doesn't do it in any kind of race-free manner
> > and sometimes is only saved by the polling picking it up.
> >
> > It's all really just a symptom of the fact that input and output buffers
> > shouldn't be attached to the tty in the first place but to a struct
> > representing the physical port. Fix that and the race conditions in
> > serial output go away, as do the potential crashes and this wakeup stuff
> > as well as a ton of locking in the irq/tx/rx paths. In several cases it
> > also saves you an entire copy.
> >
> > Unfortunately while I got the tty port structures into lots of places
> > needed the job never gone done.
> 
> OK, so it sounds like there's a basic design problem here which will
> need some non-trivial work to fix.  In the meantime we'll need to look
> at doing something to work around the issue, since it ends up consuming
> a non-trivial amount of CPU in events/0.  I guess reducing HZ would be
> the first, simplest thing to do, but changing xenconsoled to avoid
> writing to readerless ptys might not be too hard.

Replace "1" in schedule_delayed_work with (HZ/100) should make it
better, and looks like good thing while better fix is prepared?



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
