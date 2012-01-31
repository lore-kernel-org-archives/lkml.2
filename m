Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab2AaS6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 13:58:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33140 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab2AaS60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 13:58:26 -0500
Date: Tue, 31 Jan 2012 10:58:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Niels de Vos <ndevos@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Mikulas Patocka <mpatocka@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH v3] fs: Invalidate the cache for a parent block-device
 if fsync() is called for a partition
Message-Id: <20120131105824.c48351b6.akpm@linux-foundation.org>
In-Reply-To: <4F28102C.1070207@redhat.com>
References: <4F213E1A.4060808@redhat.com>
	<1327584802-14298-1-git-send-email-ndevos@redhat.com>
	<20120126134051.6add3cd2.akpm@linux-foundation.org>
	<20120126214534.GA9319@infradead.org>
	<4F28102C.1070207@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jan 2012 16:00:44 +0000
Niels de Vos <ndevos@redhat.com> wrote:

> On 01/26/2012 09:45 PM, Christoph Hellwig wrote:
> > On Thu, Jan 26, 2012 at 01:40:51PM -0800, Andrew Morton wrote:
> >> The Right Thing To Do here is to make the kernel behave logically and
> >> predictably, then modify the userspace tools.  But if we're modifying
> >> the userspace tools then we would just change userspace to issue a
> >> BLKFLSBUF to /dev/sda and leave the kernel alone.
> > 
> > The right fix is to make partition and whole disk access coherent,
> > which is fairly simply:
> > 
> >  - create the block device inode/mapping per gendisk, and only reference
> >    count it per block_device
> >  - make sure blkdev_get_block(s) applies the correct offset if used on
> >    partitions
> > 
> 
> This surely looks like a better way to fix this issue. I am not sure yet
> how much work that would involve and if I am the right person to fix
> this. If nobody beats me to it, I might send a patch for review some
> (undefined) time later.

One concern I have with the proposal is that it would forever rule out
support of >16T devices on 32-bit machines.

At present with 64-bit sector_t and 32-bit pgoff_t, I think we'd have a
reasonable chance of supporting, say, four 8T partitions on a 32T
device.  But if we were to switch the kernel from using four 4T
address_spaces (sda1-4) over to using a single 32T address_space (sda)
then we can rule it all out.

