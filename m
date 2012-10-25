Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924Ab2JYAUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 20:20:08 -0400
Received: from mailbigip.dreamhost.com ([208.97.132.5]:47000 "EHLO
	homiemail-a66.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755351Ab2JYAUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 20:20:05 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1210241447210.8519@asgard.lang.hm>
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com>
	<m2fw5mtffg.fsf_-_@firstfloor.org>
	<CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com>
	<5086F5A7.9090406@vlnb.net>
	<CAK3OfOjYgTQBeCh1SucYw=Vriw6W3qaygwmiRmude0oAYhcaxg@mail.gmail.com>
	<alpine.DEB.2.02.1210241447210.8519@asgard.lang.hm>
Date: Wed, 24 Oct 2012 19:20:04 -0500
Message-ID: <CAK3OfOh4MEq5PwW5xk07d4fDZi64tF-vgCKYOuA3oq=9PLwyUQ@mail.gmail.com>
Subject: Re: [sqlite] light weight write barriers
From: Nico Williams <nico@cryptonector.com>
To: david@lang.hm
Cc: General Discussion of SQLite Database <sqlite-users@sqlite.org>,
        =?UTF-8?B?5p2o6IuP56uLIFlhbmcgU3UgTGk=?= <suli@cs.wisc.edu>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        drh@hwaci.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 5:03 PM,  <david@lang.hm> wrote:
> I'm doing some work with rsyslog and it's disk-baded queues and there is a
> similar issue there. The good news is that we can have a version that is
> linux specific (rsyslog is used on other OSs, but there is an existing queue
> implementation that they can use, if the faster one is linux-only, but is
> significantly faster, that's just a win for Linux)
>
> Like what is being described for sqlite, loosing the tail end of the
> messages is not a big problem under normal conditions. But there is a need
> to be sure that what is there is complete up to the point where it's lost.
>
> this is similar in concept to write-ahead-logs done for databases (without
> the absolute durability requirement)
>
> [...]
>
> I am not fully understanding how what you are describing (COW, separate
> fsync threads, etc) would be implemented on top of existing filesystems.
> Most of what you are describing seems like it requires access to the
> underlying storage to implement.
>
> could you give a more detailed explination?

COW is "copy on write", which is actually a bit of a misnomer -- all
COW means is that blocks aren't over-written, instead new blocks are
written.  In particular this means that inodes, indirect blocks, data
blocks, and so on, that are changed are actually written to new
locations, and the on-disk format needs to handle this indirection.

As for fsyn() and background threads... fsync() is synchronous, but in
this scheme we want it to happen asynchronously and then we want to
update each transaction with a pointer to the last transaction that is
known stable given an fsync()'s return.

Nico
--
