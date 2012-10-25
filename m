Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968Ab2JYBEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 21:04:46 -0400
Received: from mail.lang.hm ([64.81.33.126]:35835 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757302Ab2JYBEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 21:04:44 -0400
Date: Wed, 24 Oct 2012 18:04:34 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Nico Williams <nico@cryptonector.com>
cc: General Discussion of SQLite Database <sqlite-users@sqlite.org>,
        =?GB2312?Q?=D1=EE=CB=D5=C1=A2_Yang_Su_Li?= <suli@cs.wisc.edu>,
        linux-fsdevel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>, drh@hwaci.com
Subject: Re: [sqlite] light weight write barriers
In-Reply-To: <CAK3OfOh4MEq5PwW5xk07d4fDZi64tF-vgCKYOuA3oq=9PLwyUQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1210241748180.8519@asgard.lang.hm>
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com> <m2fw5mtffg.fsf_-_@firstfloor.org> <CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com> <5086F5A7.9090406@vlnb.net> <CAK3OfOjYgTQBeCh1SucYw=Vriw6W3qaygwmiRmude0oAYhcaxg@mail.gmail.com>
 <alpine.DEB.2.02.1210241447210.8519@asgard.lang.hm> <CAK3OfOh4MEq5PwW5xk07d4fDZi64tF-vgCKYOuA3oq=9PLwyUQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012, Nico Williams wrote:

> On Wed, Oct 24, 2012 at 5:03 PM,  <david@lang.hm> wrote:
>> I'm doing some work with rsyslog and it's disk-baded queues and there is a
>> similar issue there. The good news is that we can have a version that is
>> linux specific (rsyslog is used on other OSs, but there is an existing queue
>> implementation that they can use, if the faster one is linux-only, but is
>> significantly faster, that's just a win for Linux)
>>
>> Like what is being described for sqlite, loosing the tail end of the
>> messages is not a big problem under normal conditions. But there is a need
>> to be sure that what is there is complete up to the point where it's lost.
>>
>> this is similar in concept to write-ahead-logs done for databases (without
>> the absolute durability requirement)
>>
>> [...]
>>
>> I am not fully understanding how what you are describing (COW, separate
>> fsync threads, etc) would be implemented on top of existing filesystems.
>> Most of what you are describing seems like it requires access to the
>> underlying storage to implement.
>>
>> could you give a more detailed explination?
>
> COW is "copy on write", which is actually a bit of a misnomer -- all
> COW means is that blocks aren't over-written, instead new blocks are
> written.  In particular this means that inodes, indirect blocks, data
> blocks, and so on, that are changed are actually written to new
> locations, and the on-disk format needs to handle this indirection.

so how can you do this, and keep the writes in order (especially between 
two files) without being the filesystem?

> As for fsyn() and background threads... fsync() is synchronous, but in
> this scheme we want it to happen asynchronously and then we want to
> update each transaction with a pointer to the last transaction that is
> known stable given an fsync()'s return.

If you could specify ordering between two writes, I could see a process 
along the lines of

Append new message to file1

append tiny status updates to file2

every million messages, move to new files. once the last message has been 
processed for the old set of files, delete them.

since file2 is small, you can reconstruct state fairly cheaply

But unless you are a filesystem, how can you make sure that the message 
data is written to file1 before you write the metadata about the message 
to file2?

right now it seems that there is no way for an application to do this 
other than doing a fsync(file1) before writing the metadata to file2

And there is no way for the application to tell the filesystem to write 
the data in file2 in order (to make sure that block 3 is not written and 
then have the system crash before block 2 is written), so the application 
needs to do frequent fsync(file2) calls.

If you need complete durability of your data, there are well documented 
ways of enforcing it (including the lwn.net article 
http://lwn.net/Articles/457667/ )

But if you don't need the gurantee that your data is on disk now, you just 
need to have it ordered so that if you crash you can be guaranteed only to 
loose data off of the tail of your file, there doesn't seem to be any way 
to do this other than using the fsync() hammer and wait for the overhead 
of forcing the data to disk now.


Or, as I type this, it occurs to me that you may be saying that every time 
you want to do an ordering guarantee, spawn a new thread to do the fsync 
and then just keep processing. The fsync will happen at some point, and 
the writes will not be re-ordered across the fsync, but you can keep 
going, writing more data while the fsync's are pending.

Then if you have a filesystem and I/O subsystem that can consolodate the 
fwyncs from all the different threads together into one I/O operation 
without having to flush the entire I/O queue for each one, you can get 
acceptable performance, with ordering. If the system crashes, data that 
hasn't had it's fsync() complete will be the only thing that is lost.

David Lang
