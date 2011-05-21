Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab1EUInF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 04:43:05 -0400
Received: from mail.avalus.com ([89.16.176.221]:48518 "EHLO mail.avalus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584Ab1EUIms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 04:42:48 -0400
Date: Sat, 21 May 2011 09:42:45 +0100
From: Alex Bligh <alex@alex.org.uk>
Reply-To: Alex Bligh <alex@alex.org.uk>
To: Christoph Hellwig <hch@infradead.org>
cc: linux-kernel@vger.kernel.org, Alex Bligh <alex@alex.org.uk>
Subject: Re: REQ_FLUSH, REQ_FUA and open/close of block devices
Message-ID: <60FB7C5F40961417F1605595@nimrod.local>
In-Reply-To: <20110520122010.GA25628@infradead.org>
References: <10C5890F8F477E959B993BFA@nimrod.local>
 <20110520122010.GA25628@infradead.org>
X-Mailer: Mulberry/4.0.8 (Mac OS X)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--On 20 May 2011 08:20:10 -0400 Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, May 19, 2011 at 04:06:27PM +0100, Alex Bligh wrote:
>> Should a close() of a dirty block device result in a REQ_FLUSH?
>
> No, why would it?  That's what fsync is for.

I had thought fsync() was meant to be implicit in a close of a raw device
though perhaps that's my faulty memory; I think you are saying it's
up to userspace to fix these; fair enough.

However, I'm also seeing writes to the device after the last flush when
the device is unmounted. Specifically, a sequence ending
  mount -t ext3 -odata=journal,barrier=1 /dev/nbd0 /mnt
  (cd /mnt ; tar cvzf /dev/null . ; sync) 2>&1 >/dev/null
  dbench -D /mnt 1 &
  sleep 10
  killall dbench
  sleep 2
  killall -KILL dbench
  sync
  umount /mnt

produces these commands (at the end):
  Sending command: NBD_CMD_WRITE [NONE] (0x00000001)
  Sending command: NBD_CMD_WRITE [NONE] (0x00000001)
  Sending command: NBD_CMD_FLUSH [NONE] (0x00000003)
  Sending command: NBD_CMD_WRITE [FUA] (0x00010001)
  Sending command: NBD_CMD_WRITE [NONE] (0x00000001)
  Sending command: NBD_CMD_WRITE [NONE] (0x00000001)
  Sending command: NBD_CMD_WRITE [NONE] (0x00000001)
  Sending command: NBD_CMD_WRITE [NONE] (0x00000001)
  Sending command: NBD_CMD_WRITE [NONE] (0x00000001)
  Sending command: NBD_CMD_WRITE [NONE] (0x00000001)
  Sending command: NBD_CMD_WRITE [NONE] (0x00000001)
  Sending command: NBD_CMD_WRITE [NONE] (0x00000001)
  Sending command: NBD_CMD_WRITE [NONE] (0x00000001)

(I'm testing this out by adding flush and fua support to nbd, see
git.alex.org.uk if this is interesting).

What I am concerned about is that relatively normal actions (e.g. unmount
a filing system) do not appear to be flushing all data, even though I
did "sync" then "umount". I suspect the sync is generating the FLUSH here,
and nothing is flushing the umount writes. How can I know as a block
device that I have to write out a (long lasting) writeback cache if
I don't receive anything beyond the last WRITE?

-- 
Alex Bligh
