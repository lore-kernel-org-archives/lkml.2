Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab2JYFnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 01:43:11 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:57399 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755157Ab2JYFnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 01:43:08 -0400
Date: Thu, 25 Oct 2012 01:42:55 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: david@lang.hm
Cc: Nico Williams <nico@cryptonector.com>,
        General Discussion of SQLite Database 
	<sqlite-users@sqlite.org>,
        =?utf-8?B?5p2o6IuP56uL?= Yang Su Li <suli@cs.wisc.edu>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        drh@hwaci.com
Subject: Re: [sqlite] light weight write barriers
Message-ID: <20121025054255.GB9860@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, david@lang.hm,
	Nico Williams <nico@cryptonector.com>,
	General Discussion of SQLite Database <sqlite-users@sqlite.org>,
	=?utf-8?B?5p2o6IuP56uL?= Yang Su Li <suli@cs.wisc.edu>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	drh@hwaci.com
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com>
 <m2fw5mtffg.fsf_-_@firstfloor.org>
 <CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com>
 <5086F5A7.9090406@vlnb.net>
 <CAK3OfOjYgTQBeCh1SucYw=Vriw6W3qaygwmiRmude0oAYhcaxg@mail.gmail.com>
 <alpine.DEB.2.02.1210241447210.8519@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1210241447210.8519@asgard.lang.hm>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 03:03:00PM -0700, david@lang.hm wrote:
> Like what is being described for sqlite, loosing the tail end of the
> messages is not a big problem under normal conditions. But there is
> a need to be sure that what is there is complete up to the point
> where it's lost.
> 
> this is similar in concept to write-ahead-logs done for databases
> (without the absolute durability requirement)

If that's what you require, and you are using ext3/4, usng data
journalling might meet your requirements.  It's something you can
enable on a per-file basis, via chattr +j; you don't have to force all
file systems to use data journaling via the data=journalled mount
option.

The potential downsides that you may or may not care about for this
particular application:

(a) This will definitely have a performance impact, especially if you
are doing lots of small (less than 4k) writes, since the data blocks
will get run through the journal, and will only get written to their
final location on disk.

(b) You don't get atomicity if the write spans a 4k block boundary.
All of the bytes before i_size will be written, so you don't have to
worry about "holes"; but the last message written to the log file
might be truncated.

(c) There will be a performance impact, since the contents of data
blocks will be written at least twice (once to the journal, and once
to the final location on disk).  If you do lots of small, sub-4k
writes, the performance might be even worse, since data blocks might
be written multiple times to the journal.

						- Ted
