Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab1IZJey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 05:34:54 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:38793 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab1IZJew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 05:34:52 -0400
Subject: Re: [BUG] INFO: inconsistent lock state
From: Paul Bolle <pebolle@tiscali.nl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <1317026416.3536.23.camel@x61.thuisdomein>
References: <4E7859EC.4070904@linux.vnet.ibm.com>
	 <1317026416.3536.23.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Sep 2011 11:34:38 +0200
Message-ID: <1317029678.3536.29.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-26 at 10:40 +0200, Paul Bolle wrote:
> Something very similar happened to be in the logs of a machine running
> v3.0.4 too. It happened a few days ago (but I missed it initially). I
> have no idea what triggered this:
> 
> kernel: [ 3501.569697] 
> kernel: [ 3501.569699] =================================
> kernel: [ 3501.569703] [ INFO: inconsistent lock state ]
> kernel: [ 3501.569706] 3.0.4-local0.fc14.x86_64 #1
> kernel: [ 3501.569708] ---------------------------------
> kernel: [ 3501.569711] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
> kernel: [ 3501.569714] kswapd0/25 [HC0[0]:SC0[0]:HE1:SE1] takes:
> kernel: [ 3501.569717]  (&sb->s_type->i_mutex_key#13){+.+.?.}, at: [<ffffffff811b08eb>] ext4_evict_inode+0x41/0x255
> [...]

A bit of background: ext4_evict_inode+0x41 should be the call to
mutex_lock() in ext4_evict_inode():

(gdb) disass /m ext4_evict_inode+48,+17
Dump of assembler code from 0xffffffff811b08da to 0xffffffff811b08eb:
193		mutex_lock(&inode->i_mutex);
   0xffffffff811b08da <ext4_evict_inode+48>:	lea    0x80(%rbx),%r12
   0xffffffff811b08e1 <ext4_evict_inode+55>:	xor    %esi,%esi
   0xffffffff811b08e3 <ext4_evict_inode+57>:	mov    %r12,%rdi
   0xffffffff811b08e6 <ext4_evict_inode+60>:	callq  0xffffffff814edf03 <mutex_lock_nested>

End of assembler dump.

That call to mutex_lock() and the following call to mutex_unlock() was
added by the backport of commit 2581fdc8 ("ext4: call ext4_ioend_wait
and ext4_flush_completed_IO in ext4_evict_inode") to v3.0 in the v3.0.4
patch.


Paul Bolle

