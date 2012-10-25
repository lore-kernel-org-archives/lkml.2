Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946042Ab2JYODk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:03:40 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:57489 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933124Ab2JYODi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:03:38 -0400
Date: Thu, 25 Oct 2012 10:03:27 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: david@lang.hm
Cc: Nico Williams <nico@cryptonector.com>,
        General Discussion of SQLite Database 
	<sqlite-users@sqlite.org>,
        =?utf-8?B?5p2o6IuP56uL?= Yang Su Li <suli@cs.wisc.edu>,
        linux-fsdevel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>, drh@hwaci.com
Subject: Re: [sqlite] light weight write barriers
Message-ID: <20121025140327.GB13562@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, david@lang.hm,
	Nico Williams <nico@cryptonector.com>,
	General Discussion of SQLite Database <sqlite-users@sqlite.org>,
	=?utf-8?B?5p2o6IuP56uL?= Yang Su Li <suli@cs.wisc.edu>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>, drh@hwaci.com
References: <m2fw5mtffg.fsf_-_@firstfloor.org>
 <CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com>
 <5086F5A7.9090406@vlnb.net>
 <CAK3OfOjYgTQBeCh1SucYw=Vriw6W3qaygwmiRmude0oAYhcaxg@mail.gmail.com>
 <alpine.DEB.2.02.1210241447210.8519@asgard.lang.hm>
 <CAK3OfOh4MEq5PwW5xk07d4fDZi64tF-vgCKYOuA3oq=9PLwyUQ@mail.gmail.com>
 <alpine.DEB.2.02.1210241748180.8519@asgard.lang.hm>
 <CAK3OfOjtH9qVghb6+33HSb8+dPZVexLC9Z5XO1KKvjoTYiYp4A@mail.gmail.com>
 <20121025060231.GC9860@thunk.org>
 <alpine.DEB.2.02.1210242331060.31862@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1210242331060.31862@asgard.lang.hm>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 11:58:49PM -0700, david@lang.hm wrote:
> The frustrating thing is that when people point out how things like
> sqlite are so horribly slow, the reply seems to be "well, that's
> what you get for doing so many fsyncs, don't do that", when there is
> a 'problem' like the KDE "config loss" problem a few years ago, the
> response is "well, that's what you get for not doing fsync"

Sure... but the answer is to only do the fsync's when you need to.
For example, if GNOME and KDE is rewriting the entire registry file
each time the application is changing a single registry key, sure, if
you rewrite the entire registry file, and then fsync after each
rewrite before you replace the file, you will be safe.  And if the
application needs to update dozens or hundreds of registry keys (or
every time the window gets moved or resized), then yes, it will be
slow.  But the application didn't have to do that!  It could have
updated all the registry keys in memory, and then update the registry
file periodically instead.

Similarly, Firefox didn't need to do a sqllite commit after every
single time its history file was written, causing a third of a
megabyte of write traffic each time you clicked on a web page.  It
could have batched its updates to the history file, since most of the
time, you don't care about making sure the web history is written to
stable store before you're allowed to click on a web page and visit
the next web page.

Or does rsyslog *really* need to issue an fsync after each log
message?  Or could it batch updates so that every N seconds, it
flushes writes to the disk?

(And this is a problem with most Android applications as well.
Apparently the framework API's are such that it's easier for an
application to treat each sqlite statement as an atomic update, so
many/most application writers don't use explicit transaction
boundaries, so updates don't get batched even though it would be more
efficient if they did so.)

Sometimes, the answer is not to try to create exotic database like
functionality in the file system --- the answer is to be more
intelligent at the application leyer.  Not only will the application
be more portable, it will also in the end be more efficient, since
even with the most exotic database technologies, the most efficient
transactional commit is the unneeded commit that you optimize away at
the application layer.

						- Ted
