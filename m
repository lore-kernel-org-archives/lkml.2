Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab1GPWIN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 18:08:13 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:43855 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658Ab1GPWIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 18:08:12 -0400
Date: Sat, 16 Jul 2011 17:16:18 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: halfdog <me@halfdog.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Possible ext2/3/4 filesysystem iov_length integer overflow and
 strange behavior on large writes
Message-ID: <20110716211618.GA2717@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, halfdog <me@halfdog.net>,
	linux-kernel@vger.kernel.org
References: <4DFB7E1C.3010509@halfdog.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFB7E1C.3010509@halfdog.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 04:17:32PM +0000, halfdog wrote:
> 
> If I understand it correctly, there might be multiple iov_length
> interger overflows on 32bit arch in ext2, ext3, ext4, e.g.

> Can someone confirm or refute that? I wrote a small test program, but
> failed to inflict damage on the kernel or filesystem, so I might have
> missed something. From source grep, also other filesystems might have
> the same problem.

The iovec is checked in the VFS layer.  See the function
rw_copy_check_uvector() in fs/read_write.c.

> Apart from that, large iov writes seem to be uninteruptible. Sending a
> kill signal to the process in writev terminates it after finishing the
> syscall.

That's partially historical.  There are a programs out there which
assume that reads and writes to files on disk can't get interrupted in
media res.  (Worse yet are the progams which make this assumption on
network connections, but that's another story.)  Programs should check
the return value, on a partial read or write, retry the read/write.
Many don't.  Writes are fast enough most of the time that it's not
worth it to make them be interruptible.

Your questions about what happens if someone is trying to perform a
Denial of Service attack and send a writev of 1 TB is a interesting
one.  I'm currently not in a place where I can do experiments about
this, but I did want to acknowledge your concern.  It may be that the
right thing to do is to allow a SIGKILL to interrupt a disk write.

Apologies for not responding earlier; this managed to slip through my
inbox and I only saw it now.

      	       	     	      		   - Ted
