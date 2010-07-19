Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760816Ab0GSR3D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 13:29:03 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42765 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760755Ab0GSR3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 13:29:01 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTikP1szEIZK4jw9sSgGa_0ojOMYk8MTsIsvH5a1a@mail.gmail.com>
References: <AANLkTikP1szEIZK4jw9sSgGa_0ojOMYk8MTsIsvH5a1a@mail.gmail.com>
Date: Mon, 19 Jul 2010 10:22:45 -0700
Message-ID: <AANLkTilq-vCQux83WRzN18AbLi41-YlG-afCia3oLerm@mail.gmail.com>
Subject: Fwd: persistent ramfs issue
From: "Ryan O'Neill" <ryan@bitlackeys.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure how active fsdevel is so I forwarded my question along to you
guys as well. Many thanks.


---------- Forwarded message ----------
From: Ryan O'Neill <ryan@bitlackeys.com>
Date: Mon, Jul 19, 2010 at 10:09 AM
Subject: persistent ramfs issue
To: linux-fsdevel@vger.kernel.org


I have developed a file system, it is a virtual memory (RAM) file system
with persistence -- the persistence essentially works by storing the
fs data (from memory) into the slack space
of ext3 files (We are working on CentOS 5.3 -- old I know). The
following details should be sufficient.

I keep the inode size the same so that utilities don't see the hidden
data -- it appears do_sync_read which ext3 uses and the function that
it uses (such as generic_file_read) do not read past the size of the
inode.

When storing this persistent data in the slack space of ext3, I create
something like a journal that contains the names of the ext3 files and
how much data we have in the slack space. So when I remount my file
system, a read_Journal()
happens, and here is the issue --

I temporarily extend the size of the inode of the ext3 file so I can
get at the hidden data, then I put the inode size back. For along time
this returned 0's, I then ( believe this made the change) marked the
inode as dirty
and flushed the page so it forced the change of the inode extension,
because I knew the data was there. Now I get the actual data -- but it
only works for the first file in the journal. read_journal() works in
a loop, it reads through each journal entry, and when it tries to
perforrm
the same operation on another ext3 file, after extending the inode it
just gets zeroes back. But I know the data is there, because if I
leave the inode extended, I use 'vi' to open the file and I can see
the data.

Is this some type of page cache issue? How can I get around this? Any
input would be greatly appreciated. Thank you.

I can't really give code slices, but the general idea is

i_size = i_size_read(inode);
i_size += extended_size;
i_size_write(inode, isize);
mark_inode_dirty(ext3_inode);
wakeup_pdflush(0); <- I realize this is an overkill, but I was just
trying to get it to work before I used aops->commit_write on the
actual page of the inode.

ext3_file->f_op->llseek(seek to start of hidden data);
ext3_file->f_op->read(read in the data that is hidden at this location)

The first time I go through this operation it works, I get the data
back into memory and can reconstruct a file in virtual memory
all subsequent attempts fail -- although I believe once or twice it did work.

I simply don't understand the underlying page cache enough I'm
guessing. Any help would be greatly appreciated on this, thank you
all.

Regards, Ryan.
