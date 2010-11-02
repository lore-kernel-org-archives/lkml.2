Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab0KBBXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 21:23:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547Ab0KBBXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 21:23:11 -0400
Subject: Re: [PATCH v1.1 0/5] IMA: making i_readcount a first class inode
 citizen
From: Eric Paris <eparis@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, jmorris@namei.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
In-Reply-To: <1288640739-3246-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1288640739-3246-1-git-send-email-zohar@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Nov 2010 21:22:47 -0400
Message-ID: <1288660967.3017.83.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-01 at 15:45 -0400, Mimi Zohar wrote:
> Based on the previous posting discussion, i_readcount is now defined as
> atomic.
> 
> This patchset separates the incrementing/decrementing of the i_readcount,
> in the VFS layer, from other IMA functionality, by replacing the current
> ima_counts_get() call with iget_readcount(). Its unclear whether this
> call to increment i_readcount should be made earlier, like i_writecount.
> 
> The patch ordering is a bit redundant in order to leave removing the ifdef
> around i_readcount until the last patch. The first four patches: redefines 
> i_readcount as atomic, defines iget/iput_readcount(), moves the IMA
> functionality in ima_counts_get() to ima_file_check(), and removes the IMA
> imbalance code, simplifying IMA. The last patch moves iput_readcount()
> to the fs directory and removes the ifdef around i_readcount, making
> i_readcount into a "first class inode citizen".
> 
> The generic_setlease code could then take advantage of i_readcount.

Hey Mimi, 

couple of comment and questions, can you help me understand what you
believe the three locks in question are currently protecting?  And
remember I already said I don't think they are quite right before you
started so try not to use that as your example   :)

inode->i_lock
inode->i_mutex
iint->mutex

I also question you finishing in patch 5/5 with:

+void iput_readcount(struct inode *inode)
+{
+       spin_lock(&inode->i_lock);
+       if (unlikely((atomic_read(&inode->i_readcount) == 0)))
+               printk(KERN_INFO "i_readcount: imbalance ino %ld\n",
+                      inode->i_ino);
+       else
+               atomic_dec(&inode->i_readcount);
+       spin_unlock(&inode->i_lock);
+}

obviously I wonder what the locking is for, but really I question why we
need this as a conditional at all.  If we are really worried it should
be a WARN_ON() or BUG() but personally I wonder if we need it at all.
The VFS is by supposed to get stuff right.  All of the interesting
checks around IMA were mostly needed because IMA was an object that hung
off the side of the VFS and you couldn't be certain that all filesystems
were adhering to the calling conventions you thought were correct.
Since we've pretty much moved all of this into the VFS its about time we
stop wasting time wondering if our assumptions are correct.  These are
pretty hot paths and I'm all for cutting down the IMA overhead on them.
If we do that this function becomes:

BUG_ON(!atomic_read(&inode->i_readcount))
atomic_dec(&inode->i_readcont);

it also means that we don't need to set the i_readcount to 0 in
inode_init_always() from patch 3....

