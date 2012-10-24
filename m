Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422711Ab2JXWDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 18:03:17 -0400
Received: from mail.lang.hm ([64.81.33.126]:50658 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422648Ab2JXWDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 18:03:16 -0400
Date: Wed, 24 Oct 2012 15:03:00 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Nico Williams <nico@cryptonector.com>
cc: General Discussion of SQLite Database <sqlite-users@sqlite.org>,
        =?GB2312?Q?=D1=EE=CB=D5=C1=A2_Yang_Su_Li?= <suli@cs.wisc.edu>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        drh@hwaci.com
Subject: Re: [sqlite] light weight write barriers
In-Reply-To: <CAK3OfOjYgTQBeCh1SucYw=Vriw6W3qaygwmiRmude0oAYhcaxg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1210241447210.8519@asgard.lang.hm>
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com> <m2fw5mtffg.fsf_-_@firstfloor.org> <CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com> <5086F5A7.9090406@vlnb.net>
 <CAK3OfOjYgTQBeCh1SucYw=Vriw6W3qaygwmiRmude0oAYhcaxg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012, Nico Williams wrote:

>> Before that happens, people will keep returning again and again with those
>> simple questions: why the queue must be flushed for any ordered operation?
>> Isn't is an obvious overkill?
>
> That [cache flushing] is not what's being asked for here.  Just a
> light-weight barrier.  My proposal works without having to add new
> system calls: a) use a COW format, b) have background threads doing
> fsync()s, c) in each transaction's root block note the last
> known-committed (from a completed fsync()) transaction's root block,
> d) have an array of well-known ubberblocks large enough to accommodate
> as many transactions as possible without having to wait for any one
> fsync() to complete, d) do not reclaim space from any one past
> transaction until at least one subsequent transaction is fully
> committed.  This obtains ACI- transaction semantics (survives power
> failures but without durability for the last N transactions at
> power-failure time) without requiring changes to the OS at all, and
> with support for delayed D (durability) notification.

I'm doing some work with rsyslog and it's disk-baded queues and there is a 
similar issue there. The good news is that we can have a version that is 
linux specific (rsyslog is used on other OSs, but there is an existing 
queue implementation that they can use, if the faster one is linux-only, 
but is significantly faster, that's just a win for Linux)

Like what is being described for sqlite, loosing the tail end of the 
messages is not a big problem under normal conditions. But there is a need 
to be sure that what is there is complete up to the point where it's lost.

this is similar in concept to write-ahead-logs done for databases (without 
the absolute durability requirement)

1. new messages arrive and get added to the end of the queue file.

2. a thread updates the queue to indicate that it is in the process 
of delivering a block of messages

3. the thread updates the queue to indicate that the block of messages has 
been delivered

4. garbage collection happens to delete the old messages to free up space 
(if queues go into files, this can just be to limit the file size, 
spilling to multiple files, and when an old file is completely marked as 
delivered, delete it)

I am not fully understanding how what you are describing (COW, separate 
fsync threads, etc) would be implemented on top of existing filesystems. 
Most of what you are describing seems like it requires access to the 
underlying storage to implement.

could you give a more detailed explination?

David Lang
