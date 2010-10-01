Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab0JASM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 14:12:58 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:38537 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab0JASM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 14:12:56 -0400
Subject: Re: Odd NFS related SIGBUS (& possible fix)
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Nick Piggin <npiggin@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org
In-Reply-To: <1285734825.14081.87.camel@pasglop>
References: <1285734825.14081.87.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Oct 2010 14:12:47 -0400
Message-ID: <1285956768.30373.39.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 5 msgs/h 1 sum rcpts/h 6 sum msgs/h 1 total rcpts 1016 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 6DB0DA05C6D81B114F10AA7BE2B961E88CF5038A
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 401 max/h 7 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-29 at 14:33 +1000, Benjamin Herrenschmidt wrote:
> Hi Nick, Trond !
> 
> I've been tracking a problem on a heavily SMP machine here where running
> LTP "mmapstress01" spawning 64 CPUs with /tmp over NFS causes some of
> the tests to sigbus.
> 
> The test itself is a relatively boring mmap+fork hammering test.
> 
> What I've tracked down so far is that it seems to SIGBUS due to the
> statement in nfs_vm_page_mkwrite()
> 
> 	mapping = page->mapping;
> 	if (mapping != dentry->d_inode->i_mapping)
> 		goto out_unlock;
> 
> Which will then hit
> 
> 	return VM_FAULT_SIGBUS;
> 
> Now, while I understand the validity of that test if the mapping indeed
> -changed-, in the case I'm hitting it's been merely invalidated.
> 
> IE. page->mapping is NULL, as a result of something in NFS deciding to
> go through one of the gazillion code path that invalidate mappings (in
> this case, an mtime change on the server.
> 
> Now, I think -this- root cause is bogus and will need some separate
> debugging, but regardless, I don't see why at this stage, page_mkwrite()
> should cause a SIGBUS if the file has changed on the server, since we
> have pushed our our dirty mappings afaik, and so all that tells is is
> that we raced with the cache invalidation while the struct page wasn't
> locked.
> 
> So I'm wondering if the right solution shouldn't be to replay the fault
> in that case instead.
> 
> Now, I initially thought about returning 0; and hitting the following
> code path in __do_fault() but...
> 
> 				if (unlikely(!(tmp & VM_FAULT_LOCKED))) {
> 					lock_page(page);
> 					if (!page->mapping) {
> 						ret = 0; /* retry the fault */
> 						unlock_page(page);
> 						goto unwritable_page;
> 					}
> 
>  ... I'm not too happy about it and I'll need Nick insight here. The thing
> is that to hit there, I need to unlock the page first. That means page->mapping
> can change, and thus no longer be NULL by the time we get there, in which case
> it doesn't sound right at all to move on and make the page writable, which
> the code would do. Or am I missing something ?
> 
> So my preferred fix, if I'm indeed right and this is a real bug, would be
> to do something in nfs_vm_page_mkwrite() along the lines of:
> 
>  	lock_page(page);
>  	mapping = page->mapping;
> -	if (mapping != dentry->d_inode->i_mapping)
> + 	if (mapping != dentry->d_inode->i_mapping) {
> +		if (!mapping)
> +			ret = 0;
>  		goto out_unlock;
> +	}
> 
> Or am I missing something ?
> 
> Now regarding the other bug, unless Trond has an idea already, I think I'll start
> a separate email thread once I've collected more data. I -think- it invalidates it
> because it sees a the server mtime that is more recent than the inode, but the
> server shouldn't be touching at files, so I suspect we get confused somewhere in
> the kernel and I don't know why yet (the code path inside NFS aren't obvious to
> me at this stage).

Hi Ben,

We do want the code to be robust w.r.t. cache invalidations. In NFS,
those can happen all the time due to the unordered nature of RPC calls
and the piss-poor mtime/ctime resolution on the exported filesystems on
most Linux servers in particular.

e.g. against most Linux servers, if I'm sending out 2 WRITE requests in
parallel that both append data to the file, I can have the 2 replies
come back with the same ctime/mtime, but with different file lengths. If
those replies are processed in a different order on the client than on
the server (not necessarily due to any client error - the server may
simply have sent the replies in the wrong order), then we may end up
with an incorrect estimate of the file length, and so may be forced to
assume that something weird has happened to the file on the server.

However, it looks to me as if the right thing to do when the
page->mapping has changed would be to do the same thing as
block_page_mkwrite(), and just return VM_FAULT_NOPAGE so that the VM can
retry the fault.
IMO: We should only SIGBUS if the calls to nfs_flush_incompatible()
and/or nfs_updatepage() fail.

Cheers
  Trond

