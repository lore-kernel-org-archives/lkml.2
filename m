Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760058Ab2JYSaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 14:30:04 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:57577 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758569Ab2JYSaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 14:30:00 -0400
Date: Thu, 25 Oct 2012 14:29:48 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: david@lang.hm
Cc: Nico Williams <nico@cryptonector.com>,
        General Discussion of SQLite Database 
	<sqlite-users@sqlite.org>,
        =?utf-8?B?5p2o6IuP56uL?= Yang Su Li <suli@cs.wisc.edu>,
        linux-fsdevel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>, drh@hwaci.com
Subject: Re: [sqlite] light weight write barriers
Message-ID: <20121025182948.GB16257@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, david@lang.hm,
	Nico Williams <nico@cryptonector.com>,
	General Discussion of SQLite Database <sqlite-users@sqlite.org>,
	=?utf-8?B?5p2o6IuP56uL?= Yang Su Li <suli@cs.wisc.edu>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>, drh@hwaci.com
References: <5086F5A7.9090406@vlnb.net>
 <CAK3OfOjYgTQBeCh1SucYw=Vriw6W3qaygwmiRmude0oAYhcaxg@mail.gmail.com>
 <alpine.DEB.2.02.1210241447210.8519@asgard.lang.hm>
 <CAK3OfOh4MEq5PwW5xk07d4fDZi64tF-vgCKYOuA3oq=9PLwyUQ@mail.gmail.com>
 <alpine.DEB.2.02.1210241748180.8519@asgard.lang.hm>
 <CAK3OfOjtH9qVghb6+33HSb8+dPZVexLC9Z5XO1KKvjoTYiYp4A@mail.gmail.com>
 <20121025060231.GC9860@thunk.org>
 <alpine.DEB.2.02.1210242331060.31862@asgard.lang.hm>
 <20121025140327.GB13562@thunk.org>
 <alpine.DEB.2.02.1210251048280.8519@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1210251048280.8519@asgard.lang.hm>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 11:03:13AM -0700, david@lang.hm wrote:
> I agree, this is why I'm trying to figure out the recommended way to
> do this without needing to do full commits.
> 
> Since in most cases it's acceptable to loose the last few chunks
> written, if we had some way of specifying ordering, without having
> to specify "write this NOW", the solution would be pretty obvious.

Well, using data journalling with ext3/4 may do what you want.  If you
don't do any fsync, the changes will get written every 5 seconds when
the automatic journal sync happens (and sub-4k writes will also get
coalesced to a 5 second granularity).  Even with plain text files,
it's pretty easy to tell whether or not the final record is a
partially written or not after a crash; just look for a trailing
newline.

Better yet, if you are writing to multiple log files with data
journalling, all of the writes will happen at the same time, and they
will be streamed to the file system journal, minimizing random writes
for at least the journal writes.

						- Ted
