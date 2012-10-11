Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897Ab2JKQit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 12:38:49 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:37505 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758266Ab2JKQir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 12:38:47 -0400
MIME-Version: 1.0
In-Reply-To: <CALwJ=MyR+nU3zqi3V3JMuEGNwd8FUsw9xLACJvd0HoBv3kRi0w@mail.gmail.com>
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com>
	<m2fw5mtffg.fsf_-_@firstfloor.org>
	<CALwJ=MyR+nU3zqi3V3JMuEGNwd8FUsw9xLACJvd0HoBv3kRi0w@mail.gmail.com>
Date: Thu, 11 Oct 2012 11:38:06 -0500
Message-ID: <CAK3OfOi3E1ePfzWjq1epFaXsjtn8V_=r3h+PG6ankWW2fOr6GA@mail.gmail.com>
Subject: Re: [sqlite] light weight write barriers
From: Nico Williams <nico@cryptonector.com>
To: General Discussion of SQLite Database <sqlite-users@sqlite.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, drh@hwaci.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 12:48 PM, Richard Hipp <drh@sqlite.org> wrote:
>> Could you list the requirements of such a light weight barrier?
>> i.e. what would it need to do minimally, what's different from
>> fsync/fdatasync ?
>
> For SQLite, the write barrier needs to involve two separate inodes.  The
> requirement is this:

...

> Note also that when fsync() works as advertised, SQLite transactions are
> ACID.  But when fsync() is reduced to a write-barrier, we loss the D
> (durable) and transactions are only ACI.  In our experience, nobody really
> cares very much about durable across a power-loss.  People are mainly
> interested in Atomic, Consistent, and Isolated.  If you take a power loss
> and then after reboot you find the 10 seconds of work prior to the power
> loss is missing, nobody much cares about that as long as all of the prior
> work is still present and consistent.

There is something you can do: use a combination of COW on-disk
formats in such a way that it's possible to detect partially-committed
transactions and rollback to the last good known root, and
backgrounded fsync()s (i.e., in a separate thread, without waiting for
the fsync() to complete).

Nico
--
