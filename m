Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab1DHNU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 09:20:58 -0400
Received: from mtoichi13.ns.itscom.net ([219.110.2.183]:64108 "EHLO
	mtoichi13.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab1DHNU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 09:20:57 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        Nick Piggin <npiggin@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: Q. locking order of dcache_lru_lock
Date: Fri, 08 Apr 2011 22:20:31 +0900
Message-ID: <9769.1302268831@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello Al Viro, Christoph Hellwig and Nick Piggin,

I have a question about the locking order of dcache_lru_lock.

The comment in fs/dcache.c says
 * Ordering:
 * dentry->d_inode->i_lock
 *   dentry->d_lock
 *     dcache_lru_lock
	:::

d_lock should be before dcache_lru_lock.
Actually dentry_lru_(add|del|move_tail) functions (and their callers) do
it expectedly.
But __shrink_dcache_sb() looks different.

__shrink_dcache_sb()
{
	:::
relock:
	spin_lock(&dcache_lru_lock);
	while (!list_empty(&sb->s_dentry_lru)) {
		::
		if (!spin_trylock(&dentry->d_lock)) {
			spin_unlock(&dcache_lru_lock);
			cpu_relax();
			goto relock;
		}
	:::
}

When spin_trylock(&dentry->d_lock) successfully acquired d_lock, does
the violation of locking order happen (or a deadlock, in worse case)?

By the way, the code is introduced by the commit
	2304450 2011-01-07 fs: dcache scale lru
by Nick Piggin.
Is he allright? Does anyone know anything?
We have not received from him for a long time.


J. R. Okajima
