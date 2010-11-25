Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab0KYMSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 07:18:39 -0500
Received: from daytona.panasas.com ([67.152.220.89]:20176 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab0KYMSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 07:18:37 -0500
Message-ID: <4CEE5416.4020904@panasas.com>
Date: Thu, 25 Nov 2010 14:18:30 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Nick Piggin <npiggin@kernel.dk>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
        "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
        Bob Copeland <me@bobcopeland.com>, reiserfs-devel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Evgeniy Dushistov <dushistov@mail.ru>, Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH] Possible data integrity problems in lots of filesystems?
References: <20101125074909.GA4160@amd> <4CEE2C2E.4010003@panasas.com> <20101125100603.GA3164@amd> <4CEE3F9F.9070108@panasas.com> <20101125114711.GA3622@amd>
In-Reply-To: <20101125114711.GA3622@amd>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Nov 2010 12:18:34.0526 (UTC) FILETIME=[E1700BE0:01CB8C9A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2010 01:47 PM, Nick Piggin wrote:
> On Thu, Nov 25, 2010 at 12:51:11PM +0200, Boaz Harrosh wrote:
> 
> It does not get it right, because of the situation I described
> above. Background writeout can come in first, and clear the inode
> dirty bits, and call your ->write_inode for async writeout.
> 
> That means you skip doing the exofs_put_io_state(), and (I presume)
> this means you aren't waiting for write completion there.
> 
> What then happens is that sync_inode_metadata() from your fsync
> does not call ->write_inode because the inode dirty bits are clear.
> It's basically a noop. So you need to either make your .write_inode
> always synchronous, or wait for it in your .fsync and .sync_fs.
> 

Rrr I now see what you mean, that the previous call to
writeback_single_inode(wait==0) came and go without actually
finishing because exofs_write_inode(wait==0).

So I wish there was an
write_inode_async_done() that will actually do the final inode_sync_complete
or something like that, right? (That I could call from exofs::updatei_done)

Sigh. I think I'll go with the always wait==1 at exofs_write_inode() for
now. Just as your patch.

If there is nothing better by the next Kernel I might consider my own
wait_event() in exofs_file_fsync()

ACK-by: Boaz Harrosh <bharrosh@panasas.com>

Thanks
Boaz
