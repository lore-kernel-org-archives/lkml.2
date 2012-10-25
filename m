Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933394Ab2JYGCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 02:02:45 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:57412 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176Ab2JYGCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 02:02:42 -0400
Date: Thu, 25 Oct 2012 02:02:31 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Nico Williams <nico@cryptonector.com>
Cc: david@lang.hm,
        General Discussion of SQLite Database 
	<sqlite-users@sqlite.org>,
        =?utf-8?B?5p2o6IuP56uL?= Yang Su Li <suli@cs.wisc.edu>,
        linux-fsdevel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>, drh@hwaci.com
Subject: Re: [sqlite] light weight write barriers
Message-ID: <20121025060231.GC9860@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Nico Williams <nico@cryptonector.com>, david@lang.hm,
	General Discussion of SQLite Database <sqlite-users@sqlite.org>,
	=?utf-8?B?5p2o6IuP56uL?= Yang Su Li <suli@cs.wisc.edu>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>, drh@hwaci.com
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com>
 <m2fw5mtffg.fsf_-_@firstfloor.org>
 <CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com>
 <5086F5A7.9090406@vlnb.net>
 <CAK3OfOjYgTQBeCh1SucYw=Vriw6W3qaygwmiRmude0oAYhcaxg@mail.gmail.com>
 <alpine.DEB.2.02.1210241447210.8519@asgard.lang.hm>
 <CAK3OfOh4MEq5PwW5xk07d4fDZi64tF-vgCKYOuA3oq=9PLwyUQ@mail.gmail.com>
 <alpine.DEB.2.02.1210241748180.8519@asgard.lang.hm>
 <CAK3OfOjtH9qVghb6+33HSb8+dPZVexLC9Z5XO1KKvjoTYiYp4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK3OfOjtH9qVghb6+33HSb8+dPZVexLC9Z5XO1KKvjoTYiYp4A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 12:18:47AM -0500, Nico Williams wrote:
> 
> By trusting fsync().  And if you don't care about immediate Durability
> you can run the fsync() in a background thread and mark the associated
> transaction as completed in the next transaction to be written after
> the fsync() completes.

The challenge is when you have entagled metadata updates.  That is,
you update file A, and file B, and file A and B might share metadata.
In order to sync file A, you also have to update part of the metadata
for the updates to file B, which means calculating the dependencies of
what you have to drag in can get very complicated.  You can keep track
of what bits of the metadata you have to undo and then redo before
writing out the metadata for fsync(A), but that basically means you
have to implement soft updates, and all of the complexity this
implies: http://lwn.net/Articles/339337/

If you can keep all of the metadata separate, this can be somewhat
mitigated, but usually the block allocation records (regardless of
whether you use a tree, or a bitmap, or some other data structure)
tends of have entanglement problems.

It certainly is not impossible; RDBMS's have implemented this.  On the
other hand, they generally aren't as fast as file systems for
non-transactional workloads, and people really care about performance
on those sorts of workloads for file systems.  (About a decade ago,
Oracle tried to claim that you could run file system workloads using
an Oracle databsae as a back-end.  Everyone laughed at them, and the
idea died a quick, merciful death.)

Still, if you want to try to implement such a thing, by all means,
give it a try.  But I think you'll find that creating a file system
that can compete with existing file systems for performance, and
*then* also supports a transactional model, is going to be quite a
challenge.

     	      		      	     	      	 - Ted
