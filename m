Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab0DXL3o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 07:29:44 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:54172 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab0DXL3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 07:29:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:cc:date:message-id:user-agent:mime-version
         :content-type;
        b=cDDmz0h2lFsDTOI+PFOA5JQfbfZMw+w/0dFW2yeFb6lgeNeM24VsyvkwHYPQ8TCsCJ
         6JlUZi1S1rSSaX7KSL7lzcauP1DQ3OnzkjM4eUPsfO43ORIw+mf1zuEFWOJjA1T6rrbJ
         IJNlmGM19kT+egiSKMNiSnVhfRenNcDbXMXu4=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Direct aio_write/truncate question
CC: Andrew Morton <akpm@linux-foundation.org>, jens.axboe@oracle.com
Date: Sat, 24 Apr 2010 15:29:36 +0400
Message-ID: <87633hdr6n.fsf@openvz.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My be my question appeared to obvious for someone, but still

fd = open("a", O_DIRECT, )
fd2 = open("b", O_DIRECT, )
write(fd, buf ,size) /* allocate blocks for a file */
fsync(fd) /* Now, it is guaranteed that blocks are allocated.*/
/* Submit async rewrite request */ 
io_prep_pwrite(io, fd, io->u.c.buf, size, 0);
io_submit(myctx, 1, io); /* Io is in flight after this */
/* Ok, truncate the file */
ftruncate(fd, 0)
/* Reuse truncated block blocks for a new file */
write(fd2,buf ,size)     /* old a's blocks belongs to b now. */

What protect us from aio request to rewrite content of new file?
Or even corrupt fs because old blocks may be used as metadata now.
Seems unmap_underlying_metadata() can not help us here because async
io context does not dirty or locked any bh because they was already
allocated. Fairly to say. I can not reproduce rewrite effect.
I use ext4 with external journal, so where a io_barriers in fs_dev's
blktrace log.
Seems what rewrite effect no happens only because blklayer does not
reorganized issued requests. But nothing is preventing this right?
