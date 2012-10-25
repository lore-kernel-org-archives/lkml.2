Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab2JYG67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 02:58:59 -0400
Received: from mail.lang.hm ([64.81.33.126]:57557 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755486Ab2JYG65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 02:58:57 -0400
Date: Wed, 24 Oct 2012 23:58:49 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Theodore Ts'o" <tytso@mit.edu>
cc: Nico Williams <nico@cryptonector.com>,
        General Discussion of SQLite Database 
	<sqlite-users@sqlite.org>,
        =?GB2312?Q?=D1=EE=CB=D5=C1=A2_Yang_Su_Li?= <suli@cs.wisc.edu>,
        linux-fsdevel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>, drh@hwaci.com
Subject: Re: [sqlite] light weight write barriers
In-Reply-To: <20121025060231.GC9860@thunk.org>
Message-ID: <alpine.DEB.2.02.1210242331060.31862@asgard.lang.hm>
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com> <m2fw5mtffg.fsf_-_@firstfloor.org> <CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com> <5086F5A7.9090406@vlnb.net> <CAK3OfOjYgTQBeCh1SucYw=Vriw6W3qaygwmiRmude0oAYhcaxg@mail.gmail.com>
 <alpine.DEB.2.02.1210241447210.8519@asgard.lang.hm> <CAK3OfOh4MEq5PwW5xk07d4fDZi64tF-vgCKYOuA3oq=9PLwyUQ@mail.gmail.com> <alpine.DEB.2.02.1210241748180.8519@asgard.lang.hm> <CAK3OfOjtH9qVghb6+33HSb8+dPZVexLC9Z5XO1KKvjoTYiYp4A@mail.gmail.com>
 <20121025060231.GC9860@thunk.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2012, Theodore Ts'o wrote:

> On Thu, Oct 25, 2012 at 12:18:47AM -0500, Nico Williams wrote:
>>
>> By trusting fsync().  And if you don't care about immediate Durability
>> you can run the fsync() in a background thread and mark the associated
>> transaction as completed in the next transaction to be written after
>> the fsync() completes.
>
> The challenge is when you have entagled metadata updates.  That is,
> you update file A, and file B, and file A and B might share metadata.
> In order to sync file A, you also have to update part of the metadata
> for the updates to file B, which means calculating the dependencies of
> what you have to drag in can get very complicated.  You can keep track
> of what bits of the metadata you have to undo and then redo before
> writing out the metadata for fsync(A), but that basically means you
> have to implement soft updates, and all of the complexity this
> implies: http://lwn.net/Articles/339337/
>
> If you can keep all of the metadata separate, this can be somewhat
> mitigated, but usually the block allocation records (regardless of
> whether you use a tree, or a bitmap, or some other data structure)
> tends of have entanglement problems.

hmm, two thoughts occur to me.

1. to avoid entanglement, put the two files in separate directories

2. take advantage of entaglement to enforce ordering


thread 1 (repeated): write new message to file 1, spawn new thread to 
fsync

thread 2: write to file 2 that message1-5 are being worked on

thread 2 (later): write to file 2 that messages 1-5 are done

when thread 1 spawns the new thread to do the fsync, the system will be 
forced to write the data to file 2 as of the time it does the fsync.

This should make it so that you never have data written to file2 that 
refers to data that hasn't been written to file1 yet.


> It certainly is not impossible; RDBMS's have implemented this.  On the
> other hand, they generally aren't as fast as file systems for
> non-transactional workloads, and people really care about performance
> on those sorts of workloads for file systems.

the RDBMS's have implemented stronger guarantees than what we are needing

A few years ago I was investigating this for logging. With the reliable 
(RDBMS style) , but inefficent disk queue that rsyslog has, writing to a 
high-end fusion-io SSD, ext2 resulted in ~8K logs/sec, ext3 resultedin ~2K 
logs/sec, and JFS/XFS resulted in ~4K logs/sec (ext4 wasn't considered 
stable enough at the time to be tested)

> Still, if you want to try to implement such a thing, by all means,
> give it a try.  But I think you'll find that creating a file system
> that can compete with existing file systems for performance, and
> *then* also supports a transactional model, is going to be quite a
> challenge.

The question is trying to figure a way to get ordering right with existing 
filesystms (preferrably without using something too tied to a single 
filesystem implementation), not try and create a new one.

The frustrating thing is that when people point out how things like sqlite 
are so horribly slow, the reply seems to be "well, that's what you get for 
doing so many fsyncs, don't do that", when there is a 'problem' like the 
KDE "config loss" problem a few years ago, the response is "well, that's 
what you get for not doing fsync"

Both responses are correct, from a purely technical point of view.

But what's missing is any way to get the result of ordered I/O that will 
let you do something pretty fast, but with the guarantee that, if you 
loose data in a crash, the only loss you are risking is that your most 
recent data may be missing. (either for one file, or using multiple files 
if that's what it takes)

Since this topic came up again, I figured I'd poke a bit and try to either 
get educated on how to do this "right" or try and see if there's something 
that could be added to the kernel to make it possible for userspace 
programs to do this.

What I think userspace really needs is something like a barrier function 
call. "for this fd, don't re-order writes as they go down through the 
stack"

If the hardware is going to reorder things once it hits the hardware, this 
is going to hurt performance (how much depends on a lot of stuff)

but the filesystems are able to make their journals work, so there should 
be some way to let userspace do some sort of similar ordering

David Lang
