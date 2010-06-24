Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab0FXOpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 10:45:12 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35342 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754063Ab0FXOpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 10:45:10 -0400
Date: Thu, 24 Jun 2010 10:45:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andy Lutomirski <luto@mit.edu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, mark gross <640e9920@gmail.com>,
       Neil Brown <neilb@suse.de>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <Arve@smtp1.linux-foundation.org>,
       Florian Mickler <florian@mickler.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [update] Re: [RFC][PATCH] PM: Avoid losing wakeup events during
 suspend
In-Reply-To: <4C2368C8.7020708@mit.edu>
Message-ID: <Pine.LNX.4.44L0.1006241037080.1654-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jun 2010, Andy Lutomirski wrote:

> How does userspace handle this without races?  (I don't see an example 
> in a driver that talks to userspace in your code...)
> 
> For example, if I push a button on my keyboard, the driver calls 
> pm_wakeup_begin().  Then userspace reads the key from the evdev device 
> and tells the userspace suspend manager not to go to sleep.
> 
> But there's a race: the keyboard driver (or input subsystem) could call 
> pm_wakeup_end() before the userspace program has a chance to tell the 
> suspend manager not to sleep.

The assumption is that the user program will poll the evdev device.  
When the poll indicates data is available, the program will tell the 
userspace power manager not to go to sleep before reading the data.  
This avoids the race.

> One possibility would be for poll to report that events are pending 
> without calling pm_wakeup_end(), giving userspace a chance to prevent 
> itself from suspending before actually reading the event.

Exactly.  The critical section doesn't end until the events have been 
read.  Polling alone doesn't affect the critical section.

> (Also, should "echo mem >/sys/power/state" be different from "echo 
> mem_respect_suspend_blockers >/sys/power/state?"  If I physically press 
> the suspend key on my laptop, I want it to go to sleep even though I'm 
> still holding the Fn key that was part of the suspend hotkey.)

With Rafael's scheme, the difference is not in the write to
/sys/power/state but rather in the write to /sys/power/wakeup_count.  
If the power manager program doesn't write to /sys/power/wakeup_count
first then /sys/power/state takes effect immediately, just as it does
now.

Alan Stern

