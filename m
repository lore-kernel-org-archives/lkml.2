Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174Ab0EZXqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 19:46:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60711 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759053Ab0EZXqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 19:46:43 -0400
Date: Thu, 27 May 2010 00:52:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arve =?ISO-8859-14?B?SGr4bm5lduVn?= <arve@android.com>
Cc: Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Peter Zijlstra <peterz@infradead.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Jim Collar <jim.collar@eqware.net>, Greg Kroah-Hartman <gregkh@suse.de>,
       Avi Kivity <avi@redhat.com>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Magnus Damm <damm@igel.co.jp>,
       Nigel Cunningham <nigel@tuxonice.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/8] PM: suspend_block: Add driver to access suspend 
 blockers from user-space
Message-ID: <20100527005245.1c19675d@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTilz8z2rWV2gj48FLnIG9UIYA2W-pY_WiTmj6LH1@mail.gmail.com>
References: <1274482015-30899-1-git-send-email-arve@android.com>
	<1274482015-30899-3-git-send-email-arve@android.com>
	<1274863428.5882.4860.camel@twins>
	<201005262357.28933.rjw@sisk.pl>
	<20100526231448.41c5be7f@lxorguk.ukuu.org.uk>
	<AANLkTikqYwcJfCSJgBlXKyyDJFAVJmrZmyt38KOby97j@mail.gmail.com>
	<20100527000004.2da62052@lxorguk.ukuu.org.uk>
	<AANLkTilz8z2rWV2gj48FLnIG9UIYA2W-pY_WiTmj6LH1@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No, many suspend blockers protect data, not tasks. We block suspend
> when there are unprocessed input events in the kernel queue.
> User-space then blocks suspend before reading those events, and it
> blocks suspend using a different suspend blocker when its queue of
> processed events become not-empty.

That sounds to me like higher level user space implementation plus a
kernel driver imposing a power level limit.

The fact your suspend blockers as a user construct are tied to data isn't
neccessarily what the kernel needs to provide.

That aside we could equally provide latency constraints using a file
handle based semantic like your suspend blockers. That would make it
easier to do suspend blockers in those terms and provide an interface
that can be used for more elegant expression of desire.

I suggested setpidle() to keep resources tied and bounded to tasks and
to make SMP work nicely. I have no problem with the latency constraints
being floating file handles, although some thought would be needed as to
how that is then mapped to SMP.

The problem with an arbitary mapping is that if I have an 8 processor
system I might want to use the latency info to stuff tasks onto different
cores so that most of them are in a deeper idle than the others. I can't
do that unless I know who the latency constraint applies to. But
hopefully someone in scheduler land has bright ideas - eg could we keep a
per task variable and adjust it when people open/close blockers with the
assumption being anyone who has open a given constraint is bound by it
and nobody else is.

Might need it to be a constraintfs so you can open other people's
constraints but all the framework for that is there in the kernel too.

Alan
