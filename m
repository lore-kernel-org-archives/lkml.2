Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab1IPWpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 18:45:41 -0400
Received: from mail-vw0-f42.google.com ([209.85.212.42]:32974 "EHLO
	mail-vw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab1IPWpk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 18:45:40 -0400
MIME-Version: 1.0
In-Reply-To: <20110916200817.GD28519@kvack.org>
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org>
 <201109161616.50004.andres@anarazel.de> <20110916153620.GA9913@parisc-linux.org>
 <201109161927.34472.andres@anarazel.de> <20110916200817.GD28519@kvack.org>
From: Greg Stark <stark@mit.edu>
Date: Fri, 16 Sep 2011 23:44:59 +0100
X-Google-Sender-Auth: Kkm9Zj1lIsyUEPmf6zhhHgnZckU
Message-ID: <CAM-w4HNAJVRx5Vj87hXjL9JDjwbUoDiso_NZcfomk7wpd2zshw@mail.gmail.com>
Subject: Re: Improve lseek scalability v3
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Andres Freund <andres@anarazel.de>, Matthew Wilcox <matthew@wil.cx>,
        Andi Kleen <andi@firstfloor.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        robertmhaas@gmail.com, pgsql-hackers@postgresql.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 9:08 PM, Benjamin LaHaise <bcrl@kvack.org> wrote:
> For such tables, can't Postgres track the size of the file internally?  I'm
> assuming it's keeping file descriptors open on the tables it manages, in
> which case when it writes to a file to extend it, the internally stored size
> could be updated.  Not making a syscall at all would scale far better than
> even a modified lseek() will perform.

There's no hardwired limit on how many tables you can have in a
database, it's not limited by the number of file descriptors. Postgres
would have to keep some kind of LRU for recently opened files and
their sizes or something like that. There would probably still be a
lot of lseeks/fstats going on.

Generally keeping a Postgres cached value for the size would then have
a reliability issue. It's much safer to have a single authoritative
value -- the actual length of the file -- than have the same value
stored in two locations and then need to worry about them getting out
of sync. If a write fails when extending the file due to a filesystem
running out of space then Postgres might not know how to update its
internal cached state accurately for example.

There's no question it could be done but it's not clear it would
necessarily be much faster than a lock-free lseek/fstat.

On Fri, Sep 16, 2011 at 6:27 PM, Andres Freund <andres@anarazel.de> wrote:
> It depends on where the information is used. For some of the uses it needs to
> be exact (the assumed size is rechecked after acquiring a lock preventing
> extension)

Fwiw this might give the wrong impression. I don't believe scans
acquire a lock preventing extension -- that is another process can be
concurrently extending the file at the same time as the scan is
proceeding. The scan only locks out truncation (vacuum). Any blocks
added by another process are ignored by the scan because they can only
contain records invisible to that transaction. This does depend on the
lseek/fstat being done after the transaction snapshot is taken which
is possibly "rechecking" the value taken by the query planner but
they're really two independent things.


-- 
greg
