Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab1LLS7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 13:59:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237Ab1LLS7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 13:59:51 -0500
Date: Mon, 12 Dec 2011 13:59:48 -0500
From: Josef Bacik <josef@redhat.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org
Subject: trace_printk is doing weird things with my arguments
Message-ID: <20111212185947.GA3603@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've been using trace_printk() to hash out where I want to put trace points so I
can do leak detection in the btrfs space accounting code.  This has worked out
wonderfully, except in the case where I have trace_printk()'s towards the end of
umount() which is where everything gets freed up.  After a lot of screwing
around I ended up with this in one of the functions

trace_printk("%pU is being released, fsinfo=%p\n", fs_info->fsid, fs_info);
printk(KERN_ERR "%pU is releaseing global_rsv\n", fs_info->fsid);

and then in my trace output I got this (I've cut the unnecessary line beginning)

0080880d-0488-ffff-0a0a-0a0a0a0a0a0a is being released, fsinfo=ffff88040d88b000

and in dmesg I got this

4e78b2a8-707a-4eef-97d5-11c0aa1b8f29 is releaseing global_rsv

The dmesg has the right fsid, and I have a ton of trace_printk()'s in
close_ctree() which is the function that we call from ->put_super, and all of
them will either randomly have the right fsid, they will all have the wrong
fsid, or some mixture, like half will have the right one but the last half will
not.  The '0a' repeating thing is because i put a memset(fs_info, 0xa,
sizeof(*fsinfo)) in our freeing function because I thought we were screwing up,
but it looks like trace_printk is somehow not trying to fill in the arguments
until after the arguments have been freed, which seems wrong and is screwing me
up ;).  Any thoughts?  Thanks,

Josef
