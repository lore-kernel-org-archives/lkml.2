Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab0JSN52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:57:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60327 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab0JSN50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:57:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Ksummit-2010-discuss] [v2] Remaining BKL users, what to do
Date: Tue, 19 Oct 2010 15:57:56 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org,
        ksummit-2010-discuss@lists.linux-foundation.org
References: <201009161632.59210.arnd@arndb.de> <201010191536.33373.arnd@arndb.de> <1287495832.16971.368.camel@gandalf.stny.rr.com>
In-Reply-To: <1287495832.16971.368.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010191557.56584.arnd@arndb.de>
X-Provags-ID: V02:K0:AM95zF2PMn8m7Ih9DTigQOLWzJv47kQGyQzOYYgAoEU
 MH3xkKuwWw1Xwfz7GLbtE1gE59GpxdZVkyPI7R18vdfU5KPF5O
 WabZG3lR092LtqyT+cafciDwXqjA9MAinVmKMqHPxVwqV3eYv4
 7i3R+TNl8iCpBU2ndxTEzIT9Ff+nJEIh0yd+tZ6/A0Q1K/qcwN
 diCdvYjKOyiAPBwEWBY6Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 October 2010, Steven Rostedt wrote:
> On Tue, 2010-10-19 at 15:36 +0200, Arnd Bergmann wrote:
> > [trimming Cc list]
> > 
> > On Tuesday 19 October 2010, Steven Rostedt wrote:
> > > I think we also need to cover the PREEMPT case too. But that could be a
> > > compile time check, since you can't boot a preempt kernel and make it
> > > non preempt.
> > 
> > Right. Can we turn the lock_kernel() into preempt_disable() in these
> > drivers when we know we never run on SMP?
> 
> I'm not sure that will work. A holder of the BKL can call schedule or
> even a mutex. The schedule code will drop the BKL and re-enable
> preemption. Unless the code is known not to schedule while holding BKL,
> we would need to open code the preempt_enable() around the locations
> that the code may schedule.

Right, that won't work then. I was confused by the fact that __lock_kernel()
turns into preempt_disable() on UP-preempt systems, which only works
because it still maintains current->lock_depth and schedule consequently
enables preemption again in __release_kernel_lock(). With CONFIG_BKL
disabled, that won't happen any more.

	Arnd
