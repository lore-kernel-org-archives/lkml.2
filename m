Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab0HCLn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 07:43:58 -0400
Received: from www.tglx.de ([62.245.132.106]:38104 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755936Ab0HCLn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 07:43:57 -0400
Date: Tue, 3 Aug 2010 13:43:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <teheo@suse.de>
cc: lkml <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: [GIT PULL tip/genirq] Please pull from lost-spurious-irq
In-Reply-To: <4C57D836.1060106@suse.de>
Message-ID: <alpine.LFD.2.00.1008031217120.3225@localhost.localdomain>
References: <4C5033D9.7030800@kernel.org> <4C50349F.7020002@suse.de> <alpine.LFD.2.00.1007291042441.2471@localhost.localdomain> <4C529F59.3020404@suse.de> <alpine.LFD.2.00.1008020956080.9198@localhost.localdomain> <4C56E42D.5010300@suse.de>
 <alpine.LFD.2.00.1008021730250.27107@localhost.localdomain> <4C572F26.1040200@suse.de> <alpine.LFD.2.00.1008022353220.3225@localhost.localdomain> <4C57D836.1060106@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun,

On Tue, 3 Aug 2010, Tejun Heo wrote:
> I agree that timer multiplexing is a rather ugly thing and it would be
> great to remove it.  You're right that it doesn't make whole lot of
> difference whether the timer is global or local if it's low frequency
> and in fast paths expect/unexpect would be able to just test its list
> entry and set/clear currently expecting status without messing with
> the global timer or lock.  Then, we can have a single low freq timer
> for expect/unexpect and the other for actual polling.

And the third one for watch, right ? That would give us separate timer
functions which each serve a particular purpose.

When you go for it, can you please simplify all the heuristics? 

spurious poll: 

 One fixed poll interval is enough. The retry logic can be made
 simple, just set it back to interrupt delivery once per minute and
 limit the storm to 10.

watch:

 Get rid of the interrupt context work and do all the work in the
 timer. Use a fixed interval and either keep it forever or remove it.

expect:

 Use a slow fixed interval and just do the expect/unexpect fast
 marking. A nice thing would be to have a counter of expect calls so
 we can switch off the timer when there is no activity within 10
 seconds.

> How does that sound to you?

Way better. :)

Thanks,

	tglx
