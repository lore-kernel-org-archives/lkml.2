Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab1GWLI6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 07:08:58 -0400
Received: from mail.avalus.com ([89.16.176.221]:55478 "EHLO mail.avalus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700Ab1GWLIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 07:08:52 -0400
Date: Sat, 23 Jul 2011 12:08:50 +0100
From: Alex Bligh <alex@alex.org.uk>
Reply-To: Alex Bligh <alex@alex.org.uk>
To: linux-kernel@vger.kernel.org
cc: Alex Bligh <alex@alex.org.uk>
Subject: Creating CoW mmap pages from userspace
Message-ID: <33B049CA913F8768850EDBBD@Ximines.local>
X-Mailer: Mulberry/4.0.8 (Mac OS X)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a threaded application which has a large file mmap'd into a
single large area L. L contains lots of page-aligned data structures
each of an integer number of pages in length.

L is volatile (altered by lots of threads). What I'd like to do
is take memory "snapshots" of bits of L by

1. taking a lock (preventing other threads writing to L)
2. generating an mmap CoW copy of a subset of L (just a few pages)
   which would generate a new mmap'd area S (much smaller).
3. releasing a lock.

I'm not going to write to S, but I will read from it, and I need
it to contain what that bit of L contained at the time, and not
be affected by subsequent changes to L.

At kernel level, I can see how this would work - it's pretty much
what happens with fork().

I can't, however, see any way to do it from userspace. The only
near seems to be MAP_PRIVATE (i.e. open the file backing L
with another fd, or perhaps use the same fd, then create
a new memory map with MAP_PRIVATE set), but as far as I can tell
a) this would require me to msync() the relevant portion of L, and
   there is no need for anything to hit the disk - memcpy() would
   be faster, and
b) MAP_PRIVATE seems to protect L against changes to S, but does
   not protect S against changes to L (which is what I need). The
   manpage says "It is unspecified whether changes made to the file
   after the mmap() call are visible in the mapped region"

Any ideas? Currently I am taking the easy way out and memcpy()'ing
the region, but I'd really rather avoid continuously memcpy()'ing
8MB chunks given that 99.9% of the time the relevant bit of L does
not change.

-- 
Alex Bligh
