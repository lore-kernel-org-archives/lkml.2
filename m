Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab2JJWpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:45:12 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:46767 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757215Ab2JJWpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:45:09 -0400
MIME-Version: 1.0
In-Reply-To: <20121009235446.GZ2616@ZenIV.linux.org.uk>
References: <20110917001215.GA961@zombie.hq.fstein.net>
	<CAOH1cHkn_Yndw55y8QU-ipygRMfDyCG+An-qqBERtu4P-tt3MA@mail.gmail.com>
	<20121009233927.GX2616@ZenIV.linux.org.uk>
	<CAOH1cHmueHV9AiPkNSHXpEKm94nf2XZM9STv=qd7fJ+-n1VK-Q@mail.gmail.com>
	<20121009235446.GZ2616@ZenIV.linux.org.uk>
Date: Wed, 10 Oct 2012 15:45:08 -0700
Message-ID: <CAOH1cHkowcv6k0D2bkXFcjU3k4UtG2WX3nSwNa267qmODNfs_w@mail.gmail.com>
Subject: Re: linux-audit: reconstruct path names from syscall events?
From: Mark Moseley <moseleymark@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-audit@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 9, 2012 at 4:54 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Oct 09, 2012 at 04:47:17PM -0700, Mark Moseley wrote:
>> > BTW, what makes you think that container's root is even reachable from
>> > "the host's /"?  There is no such thing as "root of the OS itself"; different
>> > processes can (and in case of containers definitely do) run in different
>> > namespaces.  With entirely different filesystems mounted in those, and
>> > no promise whatsoever that any specific namespace happens to have all
>> > filesystems mounted somewhere in it...
>>
>> Nothing beyond guesswork, since it's been a while since I've played
>> with LXC. In any case, I was struggling a bit for the correct
>> terminology.
>>
>> Am I similarly off-base with regards to the chroot'd scenario?
>
> chroot case is going to be reachable from namespace root, but I seriously
> doubt that pathname relative to that will be more useful...

Possibly not, but it'd still be good to have some sort of indicator
that this entry is being logged relative to the chroot, like an
additional item in the audit entry or even some kind of flag. But in
this case, and far more so in the unlinkat/chmodat/chownat case, I'd
think the least surprising thing (to me, at least) would be for the
directory item in the audit entry to have a pathname relative to
namespace root.

> Again, relying on pathnames for forensics (or security in general) is
> a serious mistake (cue unprintable comments about apparmor and similar
> varieties of snake oil).  And using audit as poor man's ktrace analog
> is... misguided, to put it very mildly.

Caveat: I'm just a sysadmin, so this stuff is as darn near "magic" as
I get to see on a regular basis, so it's safe to expect some naivety
and/or misguidedness on my part :)

I'm just using it as a log of files that have been written/changed on
moderately- to heavily-used systems. If there's another in-kernel
mechanism that'd be better suited for that sort of thing (at least
without adding a lot of overhead), I'd be definitely eager to know
about it. It's a web hosting environment, with customer files all
solely on NFS, so writes to the same directory can come from an
arbitrary number of servers. When they get swamped with write
requests, the amount of per-client stats exposed by our Netapp and
Oracle NFS servers is often only enough to point us at a client server
with an abusive user on it (but not much more, without turning on
debugging). Having logs of who's doing writes would be quite useful,
esp when writes aren't happening at that exact moment and wouldn't
show up in tools like iotop. The audit subsystem seemed like the best
fit for this kind of thing, but I'm more than open to whatever works.
