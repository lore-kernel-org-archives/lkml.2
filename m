Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939Ab2JKQsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 12:48:55 -0400
Received: from caiajhbdcaid.dreamhost.com ([208.97.132.83]:41621 "EHLO
	homiemail-a97.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757755Ab2JKQsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 12:48:52 -0400
X-Greylist: delayed 645 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Oct 2012 12:48:52 EDT
MIME-Version: 1.0
In-Reply-To: <CAK3OfOi3E1ePfzWjq1epFaXsjtn8V_=r3h+PG6ankWW2fOr6GA@mail.gmail.com>
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com>
	<m2fw5mtffg.fsf_-_@firstfloor.org>
	<CALwJ=MyR+nU3zqi3V3JMuEGNwd8FUsw9xLACJvd0HoBv3kRi0w@mail.gmail.com>
	<CAK3OfOi3E1ePfzWjq1epFaXsjtn8V_=r3h+PG6ankWW2fOr6GA@mail.gmail.com>
Date: Thu, 11 Oct 2012 11:48:50 -0500
Message-ID: <CAK3OfOjvk0sjjevbr+C5szyzmtZSCOSMvwS_JNbMKqFWAJGawQ@mail.gmail.com>
Subject: Re: [sqlite] light weight write barriers
From: Nico Williams <nico@cryptonector.com>
To: General Discussion of SQLite Database <sqlite-users@sqlite.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, drh@hwaci.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To expand a bit, the on-disk format needs to allow the roots of N of
the last transactions to be/remain reachable at all times.  At open
time you look for the latest transaction, verify that it has been
written[0] completely, then use it, else look for the preceding
transaction, verify it, and so on.

N needs to be at least 2: the last and the preceding transactions.  No
blocks should be freed or reused for any transactions still in use or
possible use (e.g., for power failure recovery).  For high read
concurrency you can allow connections to lock a past transaction so
that no blocks are freed that are needed to access the DB at that
state.

This all goes back to 1980s DB and filesystem concepts.  See, for
example, the BSD4.4 Log Structure Filesystem.  (I mention this in case
there are concerns about patents, though IANAL and I make no
particular assertions here other than that there is plenty of old
prior art and expired patents that can probably be used to obtain
sufficient certainty as to the patent law risks in the approach
described herein.)

[0] E.g., check a transaction block manifest and check that those
blocks were written correctly; or traverse the tree looking for
differences to the previous transaction; this may require checking
block contents checksums.

Nico
--
