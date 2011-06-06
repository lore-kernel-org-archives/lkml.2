Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab1FFSUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:20:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:50826 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab1FFSUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:20:19 -0400
Subject: Re: Change in functionality of futex() system call.
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Oliver <david@rgmadvisors.com>, linux-kernel@vger.kernel.org,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Zachary Vonler <zvonler@rgmadvisors.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1307380297.3098.74.camel@edumazet-laptop>
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>
	 <1307373819.3098.40.camel@edumazet-laptop>
	 <1307376672.2322.167.camel@twins>  <1307376989.2322.171.camel@twins>
	 <1307377349.3098.65.camel@edumazet-laptop>
	 <1307377782.2322.183.camel@twins>
	 <1307378564.3098.67.camel@edumazet-laptop>
	 <1307379926.2322.219.camel@twins>
	 <1307380297.3098.74.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 20:23:54 +0200
Message-ID: <1307384634.2497.736.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 19:11 +0200, Eric Dumazet wrote:
> Le lundi 06 juin 2011 à 19:05 +0200, Peter Zijlstra a écrit :
> 
> > Dunno, using futexes on private file maps is stupid imo, its just asking
> > for trouble, ro private file maps are even worse. Forcing the COW is the
> > only sane answer in that it gives consistent results and 'breaks' silly
> > expectations early instead of sometimes.
> > 
> > Anyway, that's not really the issue here, as David uses MAP_SHARED (as
> > one should if one is interested in the shared value).
> 
> Sure, but maybe another guy is 'stupid' and uses MAP_PRIVATE on its
> read-only mappings. With old kernels this was working, and we were not
> doing the COW.
> 
> (Note : the other process writes to the file, using MAP_SHARED)

That's really not the point, what do we do when the COW happens during
the FUTEX_WAIT? At that point the process vaddr changes mapping and we
cannot continue the wait on the old page, since that would expose
invisible information, nor can we switch to the new page since we queued
on the old page.

Therefore we have to force the COW and queue on the private copy, it
really is the only semi sane semantic.




