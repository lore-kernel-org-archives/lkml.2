Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab2JYFSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 01:18:55 -0400
Received: from caiajhbdcbhh.dreamhost.com ([208.97.132.177]:36143 "EHLO
	homiemail-a84.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752947Ab2JYFSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 01:18:53 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1210241748180.8519@asgard.lang.hm>
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com>
	<m2fw5mtffg.fsf_-_@firstfloor.org>
	<CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com>
	<5086F5A7.9090406@vlnb.net>
	<CAK3OfOjYgTQBeCh1SucYw=Vriw6W3qaygwmiRmude0oAYhcaxg@mail.gmail.com>
	<alpine.DEB.2.02.1210241447210.8519@asgard.lang.hm>
	<CAK3OfOh4MEq5PwW5xk07d4fDZi64tF-vgCKYOuA3oq=9PLwyUQ@mail.gmail.com>
	<alpine.DEB.2.02.1210241748180.8519@asgard.lang.hm>
Date: Thu, 25 Oct 2012 00:18:47 -0500
Message-ID: <CAK3OfOjtH9qVghb6+33HSb8+dPZVexLC9Z5XO1KKvjoTYiYp4A@mail.gmail.com>
Subject: Re: [sqlite] light weight write barriers
From: Nico Williams <nico@cryptonector.com>
To: david@lang.hm
Cc: General Discussion of SQLite Database <sqlite-users@sqlite.org>,
        =?UTF-8?B?5p2o6IuP56uLIFlhbmcgU3UgTGk=?= <suli@cs.wisc.edu>,
        linux-fsdevel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>, drh@hwaci.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 8:04 PM,  <david@lang.hm> wrote:
> On Wed, 24 Oct 2012, Nico Williams wrote:
>> COW is "copy on write", which is actually a bit of a misnomer -- all
>> COW means is that blocks aren't over-written, instead new blocks are
>> written.  In particular this means that inodes, indirect blocks, data
>> blocks, and so on, that are changed are actually written to new
>> locations, and the on-disk format needs to handle this indirection.
>
> so how can you do this, and keep the writes in order (especially between two
> files) without being the filesystem?

By trusting fsync().  And if you don't care about immediate Durability
you can run the fsync() in a background thread and mark the associated
transaction as completed in the next transaction to be written after
the fsync() completes.

>> As for fsyn() and background threads... fsync() is synchronous, but in
>> this scheme we want it to happen asynchronously and then we want to
>> update each transaction with a pointer to the last transaction that is
>> known stable given an fsync()'s return.
>
> If you could specify ordering between two writes, I could see a process
> along the lines of
>
> [...]

fsync() deals with just one file.  fsync()s of different files are
another story.  That said, as long as the format of the two files is
COW then you can still compose transactions involving two files.  The
key is the file contents itself must be COW-structured.

Incidentally, here's a single-file, bag of b-trees that uses a COW
format: MDB, which can be found in
git://git.openldap.org/openldap.git, in the mdb.master branch.

> Or, as I type this, it occurs to me that you may be saying that every time
> you want to do an ordering guarantee, spawn a new thread to do the fsync and
> then just keep processing. The fsync will happen at some point, and the
> writes will not be re-ordered across the fsync, but you can keep going,
> writing more data while the fsync's are pending.

Yes, but only if the file's format is COWish.

The point is that COW saves the day.  A file-based DB needs to be COW.
 And the filesystem needs to be as well.

Note that write ahead logging approximates COW well enough most of the time.

> Then if you have a filesystem and I/O subsystem that can consolodate the
> fwyncs from all the different threads together into one I/O operation
> without having to flush the entire I/O queue for each one, you can get
> acceptable performance, with ordering. If the system crashes, data that
> hasn't had it's fsync() complete will be the only thing that is lost.

With the above caveat, yes.

Nico
--
