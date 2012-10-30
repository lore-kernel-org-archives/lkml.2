Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab2J3XtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 19:49:14 -0400
Received: from mailbigip.dreamhost.com ([208.97.132.5]:42546 "EHLO
	homiemail-a90.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753346Ab2J3XtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 19:49:12 -0400
MIME-Version: 1.0
In-Reply-To: <20121025060231.GC9860@thunk.org>
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com>
	<m2fw5mtffg.fsf_-_@firstfloor.org>
	<CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com>
	<5086F5A7.9090406@vlnb.net>
	<CAK3OfOjYgTQBeCh1SucYw=Vriw6W3qaygwmiRmude0oAYhcaxg@mail.gmail.com>
	<alpine.DEB.2.02.1210241447210.8519@asgard.lang.hm>
	<CAK3OfOh4MEq5PwW5xk07d4fDZi64tF-vgCKYOuA3oq=9PLwyUQ@mail.gmail.com>
	<alpine.DEB.2.02.1210241748180.8519@asgard.lang.hm>
	<CAK3OfOjtH9qVghb6+33HSb8+dPZVexLC9Z5XO1KKvjoTYiYp4A@mail.gmail.com>
	<20121025060231.GC9860@thunk.org>
Date: Tue, 30 Oct 2012 18:49:11 -0500
Message-ID: <CAK3OfOin0WAaJACSn05asYGGvbK_0di0+SAtMfaY5jRxZakW0g@mail.gmail.com>
Subject: Re: [sqlite] light weight write barriers
From: Nico Williams <nico@cryptonector.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Nico Williams <nico@cryptonector.com>,
        david@lang.hm,
        =?UTF-8?B?5p2o6IuP56uLIFlhbmcgU3UgTGk=?= <suli@cs.wisc.edu>,
        linux-fsdevel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Dropping sqlite-users.  Note that I'm not subscribed to any of the
other lists cc'ed.]

On Thu, Oct 25, 2012 at 1:02 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Oct 25, 2012 at 12:18:47AM -0500, Nico Williams wrote:
>>
>> By trusting fsync().  And if you don't care about immediate Durability
>> you can run the fsync() in a background thread and mark the associated
>> transaction as completed in the next transaction to be written after
>> the fsync() completes.

You are all missing some context which I would have added had I
noticed the cc'ing of additional lists.

D.R. Hipp asked for a light-weight barrier API from the OS/filesystem,
the SQLite use-case being to implement fast ACI_ semantics, without
durability (i.e., that it be OK to lose the last few transactions, but
not to end up with a corrupt DB, and maintaining atomicity,
consistency, and isolation).

I noted that a journalled/COW DB file format[0] one could run an
fsync() in a "background" thread to act as a barrier, and then note in
each transaction the last preceding transaction known to have reached
disk (because fsync() returned and the bg thread marked the
transaction in question as durable).  Then refrain from garbage
collecting any transactions not marked as durable.  Now, there are
some caveats, the main one being that this fails if the filesystem or
hardware lie about fsync() / cache flushes.  Other caveats include
that fsync() used this way can have more impact on filesystem
performance than a true light-weight barrier[1], that the filesystem
itself might not be powerfail-safe, and maybe a few others.  But the
point is that fsync() can be used in such a way that one need not wait
for a transaction to reach rotating rust stably and still retain
powerfail safety without durability for the last few transactions.

[0] Like the BSD4.4 log structured filesystem, ZFS, Howard Chu's MDB,
and many others.  Note that ZFS has a pool-import time option to
recover from power failures by ignoring any not completely verifiable
transactions and rolling back to the last verifiable one.

[1] Think of what ZFS does when there's no ZIL and an fsync() comes
along: ZFS will either block the fsync() thread until the current
transaction closes or else close the current transaction and possibly
write a much smaller transaction, thus losing out on making writes as
large and contiguous as possible.

> The challenge is when you have entagled metadata updates.  That is,
> you update file A, and file B, and file A and B might share metadata.
> In order to sync file A, you also have to update part of the metadata
> for the updates to file B, which means calculating the dependencies of
> what you have to drag in can get very complicated.  You can keep track
> of what bits of the metadata you have to undo and then redo before
> writing out the metadata for fsync(A), but that basically means you
> have to implement soft updates, and all of the complexity this
> implies: http://lwn.net/Articles/339337/

I believe that my suggestion composes for multi-file DB file formats,
as long as the sum total forms a COWish on-disk format.  Of course,
adding more fsync()s, even if run in bg threads, may impact system
performance even more (see above).  Also, if one has a COWish DB then
why use more than one file?  If the answer were "to spread contents
across devices" one might ask "why not trust the filesystem/volume
manager to do that?", but hey.

I'm not actually proposing that people try to compose this ACI_
technique though...

Nico
--
