Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934518Ab0EZWxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 18:53:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58314 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933709Ab0EZWxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 18:53:35 -0400
Date: Thu, 27 May 2010 00:00:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Brian Swetland <swetland@google.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Peter Zijlstra <peterz@infradead.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Arve =?ISO-8859-14?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Jim Collar <jim.collar@eqware.net>, Greg Kroah-Hartman <gregkh@suse.de>,
       Avi Kivity <avi@redhat.com>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Magnus Damm <damm@igel.co.jp>,
       Nigel Cunningham <nigel@tuxonice.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/8] PM: suspend_block: Add driver to access suspend 
 blockers from user-space
Message-ID: <20100527000004.2da62052@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTikqYwcJfCSJgBlXKyyDJFAVJmrZmyt38KOby97j@mail.gmail.com>
References: <1274482015-30899-1-git-send-email-arve@android.com>
	<1274482015-30899-3-git-send-email-arve@android.com>
	<1274863428.5882.4860.camel@twins>
	<201005262357.28933.rjw@sisk.pl>
	<20100526231448.41c5be7f@lxorguk.ukuu.org.uk>
	<AANLkTikqYwcJfCSJgBlXKyyDJFAVJmrZmyt38KOby97j@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> desired.  The device node interface came about after discussions last
> year and concerns that userspace could create an unbounded number of
> suspend blockers.

Surely you only need one block per task (or better yet one expression of
latency per task). If not can you explain why a setup which has a per
task expression of latency needs (and a 'hard limit' set which you can't
then bump back down except as root) isn't enough ?

I'd really like this lot to also fix the hard real time and power
management problem we have today and to try an fix the "suspend is
special and different" mentality in the kernel, which is getting less and
less true on a variety of chips.

> > It's all an economic system, proprietary app vendors are in it to make
> > money, some will therefore game the system and the rest will be forced to
> > follow to keep their playing field fair.
> 
> Untrusted (non-system) code can't directly access the device node from
> userspace in the Android world -- so directly created suspend blockers

Great - but the world is not Android and even if they can't access it
directly but get passed a handle they can play.

> For suspend blockers created by drivers and by trusted userspace
> processes, having a meaningful name significantly helps statistics
> gathering.

By drivers I agree but in the driver case the cost is minimal because
there should not be many and it is bounded clearly. Again I really think
'suspend blocking' is the wrong expression.

A driver needs to express

'Don't go below this latency'

and

'Don't go below this state'

This is more generic and helps our power management do the right thing on
all boxes. For example a serial port can meaningfully say 'I want X
latency worst case' based upon the fact the fifo is 64 bytes and the user
space just asked for 115,200 baud.

The don't go below for states out of which the device must wake but
cannot. Eg if your device is being told by user space to set wake on lan
and can only wake on lan from a higher state than 'off' it needs to say
so.

Alan
