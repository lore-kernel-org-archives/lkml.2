Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab2FDUHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 16:07:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42341 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760Ab2FDUHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 16:07:22 -0400
Date: Mon, 4 Jun 2012 22:07:20 +0200
From: Jan Kara <jack@suse.cz>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: seq_file dangerous assumption?
Message-ID: <20120604200720.GI11010@quack.suse.cz>
References: <CAFkjPTkmgMY_TkUHvCmN0iQ9Hx4ADBVCLXGrQB8uMyoF0xMj0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFkjPTkmgMY_TkUHvCmN0iQ9Hx4ADBVCLXGrQB8uMyoF0xMj0g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 04-06-12 14:32:02, Eric Van Hensbergen wrote:
> I was merging up someone else's driver code from a much older kernel
> to 3.5-rc1 and ran into some issues with corrupted memory.  The
> character driver in question was using seq-file.c to handle reads to
> the device.  Based on looking around at other drivers, no one else
> does this -- so its probably (well, definitely based on what I found)
> not the right way to do this.
> 
> seq_open seems to make a fairly general assumption:
> (from linux-3.5-rc1 fs/seq_file.c)
> ...
> int seq_open(struct file *file, const struct seq_operations *op)
> {
>         struct seq_file *p = file->private_data;
> 
>         if (!p) {
>                 p = kmalloc(sizeof(*p), GFP_KERNEL);
>                 if (!p)
>                         return -ENOMEM;
>                 file->private_data = p;
>         }
>         memset(p, 0, sizeof(*p));
> ..
> 
> In other words, if something is in file->private_data, then we must
> have already allocated and put our structure there.  In the case of
> this driver, file->private_data was already populated (with a pointer
> to the device structure) -- so the call to seq_open zero'd a portion
> of the device structure and then corrupted it with a seq_file
> structure.
> 
> So, an obvious solution is, don't use seq_file with a character device
> -- but shouldn't there also be a fingerprint or something in the
> seq_file structure as a sanity check so foolish developers don't trip
> over it and corrupt their kernel memory?
  Well, seq_file was never though to be used for devices... It was written
for use by virtual files such as those in /proc. Thus noone really thought
of problems you hit.

Also we don't usually put magics into our data structure just to stop bad
use of interfaces. I agree that in this particular case the interface is
easy to get wrong - but that should be solved by changing the interface to
a more robust one. Actually, I'm not sure if anyone actually passes
->private_data != NULL since seq_open_private() seems to be a standard way
of associating some additional data with seq_file. So maybe
BUG_ON(file->private_data) would be a good robustification of the interface
:).

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
