Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab0KLEgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 23:36:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968Ab0KLEgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 23:36:52 -0500
Message-ID: <4CDCC457.9030400@redhat.com>
Date: Thu, 11 Nov 2010 23:36:39 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Ted Ts'o" <tytso@mit.edu>, Jeff Layton <jlayton@redhat.com>,
        linux-kernel@vger.kernel.org, esandeen@redhat.com, jmoyer@redhat.com,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>, lmcilroy@redhat.com
Subject: Re: [PATCH] clear PageError bit in msync & fsync
References: <20101109114422.3918e7f6@annuminas.surriel.com>	<20101109142109.224267d0@corrin.poochiereds.net>	<4CD9A209.6070807@redhat.com>	<20101109210715.GJ3099@thunk.org>	<4CD9BA08.2000002@redhat.com> <20101109134139.c6f9f6dc.akpm@linux-foundation.org>
In-Reply-To: <20101109134139.c6f9f6dc.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2010 04:41 PM, Andrew Morton wrote:

> yup.  It's a userspace bug, really.  Although that bug might be
> expressed as "userspace didn't know about linux-specific EIO
> behaviour".

Looking at this some more, I am not convinced this is a userspace
bug.

First, let me describe the problem scenario:
1) process A calls write
2) process B calls write
3) process A calls fsync, runs into an IO error, returns -EIO
4) process B calls fsync, returns success
        (even though data could have been lost!)

Common sense, as well as these snippets from the fsync man
page, suggest that this behaviour is incorrect:

DESCRIPTION
        fsync()  transfers ("flushes") all modified in-core data of (i.e.,
        modified buffer cache pages for) the file referred to by the  file
        descriptor  fd  to  the  disk  device
...
RETURN VALUE
        On  success,  these  system  calls  return  zero.  On error, -1 is
        returned, and errno is set appropriately.

Johannes had the idea of storing an IO error sequence idea
in the file descriptor and the address_space (or inode).
That way when an IO error happens, we can increment the
IO error sequence counter (mapping->io_error_seq).

When doing an fsync or msync, we can see whether the
inode's IO error sequence has been incremented since the
last time we looked.  If it has, we set our own counter
to the same number and return -EIO to userspace.

The problem here is that the same file descriptor may be
shared between multiple processes.  For example, on fork
the child process inherits file descriptors from the parent.
If the child reads 4kB, the file position indicator (f_pos)
will be changed for the parent (and siblings), too.

This is an odd quirk of Unix semantics, maybe inherited
from vfork (I suspect it would have been easier for everybody
if the child got a _copy_ of each file descriptor, instead of
sharing them with parent and siblings), but chances are there
is some program out there by now that relies on this behaviour.

Given that the file descriptors are shared, we will run into
the same race above, when process A and B are siblings or
parent & child.

That leaves the solution of putting the IO error sequence
number in its own little array pointed to by struct files_struct.
Not only will that complicate expand_files, it will also require
that we tell vfs_sync and similar functions either the file
descriptor number or a pointer to the io error sequence counter,
because the "struct file" does not tell us the file descriptor
number...

I'm not sure anyone will like the complexity of the above
solution (hi Al).

There is another "solution" to consider - redirtying pages
when write IO fails.  This has the issue of potentially filling
up system memory with uncleanable dirty pages and deadlocking
the whole system.

There does not seem to be a nice solution to this problem, but
it does look like a problem we may want to fix.

-- 
All rights reversed
