Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362Ab0I2EeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 00:34:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:48136 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087Ab0I2EeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 00:34:03 -0400
Subject: Odd NFS related SIGBUS (& possible fix)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nick Piggin <npiggin@kernel.dk>,
        Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Sep 2010 14:33:45 +1000
Message-ID: <1285734825.14081.87.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick, Trond !

I've been tracking a problem on a heavily SMP machine here where running
LTP "mmapstress01" spawning 64 CPUs with /tmp over NFS causes some of
the tests to sigbus.

The test itself is a relatively boring mmap+fork hammering test.

What I've tracked down so far is that it seems to SIGBUS due to the
statement in nfs_vm_page_mkwrite()

	mapping = page->mapping;
	if (mapping != dentry->d_inode->i_mapping)
		goto out_unlock;

Which will then hit

	return VM_FAULT_SIGBUS;

Now, while I understand the validity of that test if the mapping indeed
-changed-, in the case I'm hitting it's been merely invalidated.

IE. page->mapping is NULL, as a result of something in NFS deciding to
go through one of the gazillion code path that invalidate mappings (in
this case, an mtime change on the server.

Now, I think -this- root cause is bogus and will need some separate
debugging, but regardless, I don't see why at this stage, page_mkwrite()
should cause a SIGBUS if the file has changed on the server, since we
have pushed our our dirty mappings afaik, and so all that tells is is
that we raced with the cache invalidation while the struct page wasn't
locked.

So I'm wondering if the right solution shouldn't be to replay the fault
in that case instead.

Now, I initially thought about returning 0; and hitting the following
code path in __do_fault() but...

				if (unlikely(!(tmp & VM_FAULT_LOCKED))) {
					lock_page(page);
					if (!page->mapping) {
						ret = 0; /* retry the fault */
						unlock_page(page);
						goto unwritable_page;
					}

 ... I'm not too happy about it and I'll need Nick insight here. The thing
is that to hit there, I need to unlock the page first. That means page->mapping
can change, and thus no longer be NULL by the time we get there, in which case
it doesn't sound right at all to move on and make the page writable, which
the code would do. Or am I missing something ?

So my preferred fix, if I'm indeed right and this is a real bug, would be
to do something in nfs_vm_page_mkwrite() along the lines of:

 	lock_page(page);
 	mapping = page->mapping;
-	if (mapping != dentry->d_inode->i_mapping)
+ 	if (mapping != dentry->d_inode->i_mapping) {
+		if (!mapping)
+			ret = 0;
 		goto out_unlock;
+	}

Or am I missing something ?

Now regarding the other bug, unless Trond has an idea already, I think I'll start
a separate email thread once I've collected more data. I -think- it invalidates it
because it sees a the server mtime that is more recent than the inode, but the
server shouldn't be touching at files, so I suspect we get confused somewhere in
the kernel and I don't know why yet (the code path inside NFS aren't obvious to
me at this stage).

Cheers,
Ben.


