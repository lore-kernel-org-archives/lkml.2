Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab0EFSrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 14:47:37 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37761 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754798Ab0EFSrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 14:47:35 -0400
Date: Thu, 6 May 2010 14:47:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tony Lindgren <tony@atomide.com>
cc: Matthew Garrett <mjg@redhat.com>, Brian Swetland <swetland@google.com>,
       mark gross <mgross@linux.intel.com>, <markgross@thegnar.org>,
       Len Brown <len.brown@intel.com>, <linux-doc@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
In-Reply-To: <20100506183335.GE30928@atomide.com>
Message-ID: <Pine.LNX.4.44L0.1005061440370.1708-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 May 2010, Tony Lindgren wrote:

> Well if your hardware runs off-while-idle or even just
> retention-while-idle, then the basic shell works just fine waking up
> every few seconds or so.
> 
> Then you could keep init/shell/suspend policy deamon running until
> it's time to suspend the whole device. To cut down runaway timers,
> you could already freeze the desktop/GUI/whatever earlier.

This comes down mostly to efficiency.  Although the suspend blocker
patch does the actual suspending in a workqueue thread, AFAIK there's
no reason it couldn't use a user thread instead.

The important difference lies in what happens when a suspend fails
because a driver is busy.  Without suspend blockers, the kernel has to
go through the whole procedure of freezing userspace and kernel threads
and then suspending a bunch of drivers before hitting the one that's
busy.  Then all that work has to be undone.  By contrast, with suspend
blockers the suspend attempt can fail right away with minimal overhead.

There's also a question of reliability.  With suspends controlled by 
userspace there is a possibility of races, which could lead the system 
to suspend when it shouldn't.  With control in the kernel, these races 
can be eliminated.

Alan Stern

