Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161230Ab2JXVSC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 17:18:02 -0400
Received: from caiajhbdcaib.dreamhost.com ([208.97.132.81]:39821 "EHLO
	homiemail-a29.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758782Ab2JXVSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 17:18:00 -0400
MIME-Version: 1.0
In-Reply-To: <5086F5A7.9090406@vlnb.net>
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com>
	<m2fw5mtffg.fsf_-_@firstfloor.org>
	<CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com>
	<5086F5A7.9090406@vlnb.net>
Date: Wed, 24 Oct 2012 16:17:59 -0500
Message-ID: <CAK3OfOjYgTQBeCh1SucYw=Vriw6W3qaygwmiRmude0oAYhcaxg@mail.gmail.com>
Subject: Re: [sqlite] light weight write barriers
From: Nico Williams <nico@cryptonector.com>
To: General Discussion of SQLite Database <sqlite-users@sqlite.org>
Cc: =?UTF-8?B?5p2o6IuP56uLIFlhbmcgU3UgTGk=?= <suli@cs.wisc.edu>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        drh@hwaci.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 2:53 PM, Vladislav Bolkhovitin
<vvvvvst@gmail.com> wrote:
>> As most of the time the order we need do not involve too many blocks
>> (certainly a lot less than all the cached blocks in the system or in
>> the disk's cache), that topological order isn't likely to be very
>> complicated, and I image it could be implemented efficiently in a
>> modern device, which already has complicated caching/garbage
>> collection/whatever going on internally. Particularly, it seems not
>> too hard to be implemented on top of SCSI's ordered/simple task mode?

If you have multiple layers involved (e.g., SQLite then the
filesystem, and if the filesystem is spread over multiple storage
devices), and if transactions are not bounded, and on top of that if
there are other concurrent writers to the same filesystem (even if not
the same files) then the set of blocks to write and internal ordering
can get complex.  In practice filesystems try to break these up into
large self-consistent chunks and write those -- ZFS does this, for
example -- and this is aided by the lack of transactional semantics in
the filesystem.

For SQLite with a VFS that talks [i]SCSI directly then things could be
much more manageable as there's only one write transaction in progress
at any given time.  But that's not realistic, except, perhaps, in some
embedded systems.

> Yes, SCSI has full support for ordered/simple commands designed exactly for
> that task: [...]
>
> [...]
>
> But historically for some reason Linux storage developers were stuck with
> "barriers" concept, which is obviously not the same as ORDERED commands,
> hence had a lot troubles with their ambiguous semantic. As far as I can tell
> the reason of that was some lack of sufficiently deep SCSI understanding
> (how to handle errors, believe that ACA is something legacy from parallel
> SCSI times, etc.).

Barriers are a very simple abstraction, so there's that.

> Hopefully, eventually the storage developers will realize the value behind
> ordered commands and learn corresponding SCSI facilities to deal with them.
> It's quite easy to demonstrate this value, if you know where to look at and
> not blindly refusing such possibility. I have already tried to explain it a
> couple of times, but was not successful.

Exposing ordering of lower-layer operations to filesystem applications
is a non-starter.  About the only reasonable thing to do with a
filesystem is add barrier operations.  I know, you're talking about
lower layer capabilities, and SQLite could talk to that layer
directly, but let's face it: it's not likely to.

> Before that happens, people will keep returning again and again with those
> simple questions: why the queue must be flushed for any ordered operation?
> Isn't is an obvious overkill?

That [cache flushing] is not what's being asked for here.  Just a
light-weight barrier.  My proposal works without having to add new
system calls: a) use a COW format, b) have background threads doing
fsync()s, c) in each transaction's root block note the last
known-committed (from a completed fsync()) transaction's root block,
d) have an array of well-known ubberblocks large enough to accommodate
as many transactions as possible without having to wait for any one
fsync() to complete, d) do not reclaim space from any one past
transaction until at least one subsequent transaction is fully
committed.  This obtains ACI- transaction semantics (survives power
failures but without durability for the last N transactions at
power-failure time) without requiring changes to the OS at all, and
with support for delayed D (durability) notification.

Nico
--
