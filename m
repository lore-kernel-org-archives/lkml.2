Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab2KZUFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 15:05:19 -0500
Received: from caiajhbdccac.dreamhost.com ([208.97.132.202]:52203 "EHLO
	homiemail-a35.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755547Ab2KZUFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 15:05:16 -0500
MIME-Version: 1.0
In-Reply-To: <50AADBA8.4090507@vlnb.net>
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com>
	<m2fw5mtffg.fsf_-_@firstfloor.org>
	<CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com>
	<5086F5A7.9090406@vlnb.net>
	<20121025051445.GA9860@thunk.org>
	<508B3EED.2080003@vlnb.net>
	<20121027044456.GA2764@thunk.org>
	<5090532D.4050902@vlnb.net>
	<20121031095404.0ac18a4b@pyramind.ukuu.org.uk>
	<5092D90F.7020105@vlnb.net>
	<20121101212418.140e3a82@pyramind.ukuu.org.uk>
	<50931601.4060102@symas.com>
	<20121102123359.2479a7dc@pyramind.ukuu.org.uk>
	<50A1C15E.2080605@vlnb.net>
	<20121113174000.6457a68b@pyramind.ukuu.org.uk>
	<CAK3OfOgK7a9+g-KU8v5-b2d+8-vLb75kuKKQnPK-zeFV1fLmxw@mail.gmail.com>
	<50A442AF.9020407@vlnb.net>
	<50A52133.9050204@cs.utoronto.ca>
	<50A56E43.3040805@genband.com>
	<50A71A7B.3040407@vlnb.net>
	<50AADBA8.4090507@vlnb.net>
Date: Mon, 26 Nov 2012 14:05:12 -0600
Message-ID: <CAK3OfOjD4XBGfu3cnMwTvCfec0Lvg3zrO16+pXtiFF4UWpFjDw@mail.gmail.com>
Subject: Re: [sqlite] light weight write barriers
From: Nico Williams <nico@cryptonector.com>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Chris Friesen <chris.friesen@genband.com>,
        Ryan Johnson <ryan.johnson@cs.utoronto.ca>,
        General Discussion of SQLite Database 
	<sqlite-users@sqlite.org>,
        linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Richard Hipp <drh@hwaci.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vlad,

You keep saying that programmers don't understand "barriers".  You've
provided no evidence of this.  Meanwhile memory barriers are generally
well understood, and every programmer I know understands that a
"barrier" is a synchronization primitive that says that all operations
of a certain type will have completed prior to the barrier returning
control to its caller.

For some filesystems it is possible to configure fsync() to act as a
barrier: for example, ZFS can be told to perform no synchronous
operations for a given dataset, in which case fsync() devolves into a
simple barrier.  (Cue Simon to tell us that some hardware and some
OSes, and some filesystems simply cannot implement fsync(), with or
without synchronicity.)

So just give us a barrier.  Yes, I know, it's tricky to implement, but
it'd be OK to return EOPNOSUPP, and let the app do something else
(e.g., call fsync() instead, tell the user to expect instability, tell
the user to get a better system, ...).

As for implementation, it helps to have a journalled or log-structured
filesystem.  It also helps to have hardware synchronization primitives
that don't suck, but these aren't entirely necessary: ZFS, for
example, can recover [*] from N incomplete transactions[**], and still
provides fsync() as a barrier given its on-disk structure and the ZIL.
 Note that ZFS recovery from incomplete transactions should never be
necessary where the HW has proper cache flush support, but the
recovery functionality was added precisely because of lousy hardware.

[*]   At volume import time, such as at boot-time.
[**] Granted, this requires user input, but if the user didn't care it
could be made automatic.

Nico
--
