Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661Ab2JYHLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 03:11:53 -0400
Received: from mail.lang.hm ([64.81.33.126]:50312 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757021Ab2JYHLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 03:11:52 -0400
Date: Thu, 25 Oct 2012 00:11:43 -0700 (PDT)
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
In-Reply-To: <20121025054255.GB9860@thunk.org>
Message-ID: <alpine.DEB.2.02.1210242358570.31862@asgard.lang.hm>
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com> <m2fw5mtffg.fsf_-_@firstfloor.org> <CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com> <5086F5A7.9090406@vlnb.net> <CAK3OfOjYgTQBeCh1SucYw=Vriw6W3qaygwmiRmude0oAYhcaxg@mail.gmail.com>
 <alpine.DEB.2.02.1210241447210.8519@asgard.lang.hm> <20121025054255.GB9860@thunk.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2012, Theodore Ts'o wrote:

> On Wed, Oct 24, 2012 at 03:03:00PM -0700, david@lang.hm wrote:
>> Like what is being described for sqlite, loosing the tail end of the
>> messages is not a big problem under normal conditions. But there is
>> a need to be sure that what is there is complete up to the point
>> where it's lost.
>>
>> this is similar in concept to write-ahead-logs done for databases
>> (without the absolute durability requirement)
>
> If that's what you require, and you are using ext3/4, usng data
> journalling might meet your requirements.  It's something you can
> enable on a per-file basis, via chattr +j; you don't have to force all
> file systems to use data journaling via the data=journalled mount
> option.
>
> The potential downsides that you may or may not care about for this
> particular application:
>
> (a) This will definitely have a performance impact, especially if you
> are doing lots of small (less than 4k) writes, since the data blocks
> will get run through the journal, and will only get written to their
> final location on disk.
>
> (b) You don't get atomicity if the write spans a 4k block boundary.
> All of the bytes before i_size will be written, so you don't have to
> worry about "holes"; but the last message written to the log file
> might be truncated.
>
> (c) There will be a performance impact, since the contents of data
> blocks will be written at least twice (once to the journal, and once
> to the final location on disk).  If you do lots of small, sub-4k
> writes, the performance might be even worse, since data blocks might
> be written multiple times to the journal.

I'll have to dig into this option. In the case of rsyslog it sounds 
like it could work (not as good as a filesystem independant way of doing 
things, but better than full fsyncs)

Truncated messages are not great, but they are a detectable, and 
acceptable risk.

while the average message size is much smaller than 4K (on my network it's 
~250 bytes), the metadata that's broken out expands this somewhat, and we 
can afford to waste disk space if it makes things safer or more efficient.

If we do update in place with flags with each message, each message will 
need to be written up to three times (on recipt, being processed, finished 
processed). With high message burst rates, I'm worried that we would fill 
up the journal, is there a good way to deal with this?

I believe that ext4 can put the journal on a different device from the 
filesystem, would this help a lot?

If you were to put the journal for an ext4 filesystem on a ram disk, you 
would loose the data recovery protection of the journal, but could you use 
this trick to get ordered data writes onto the filesystem?

David Lang
