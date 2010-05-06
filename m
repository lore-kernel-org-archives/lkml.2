Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab0EFGX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 02:23:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab0EFGX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 02:23:57 -0400
Date: Thu, 6 May 2010 09:19:46 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH RFC] virtio: put last seen used index into ring itself
Message-ID: <20100506061945.GA8363@redhat.com>
References: <20100505205814.GA7090@redhat.com> <201005061201.35223.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005061201.35223.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 12:01:34PM +0930, Rusty Russell wrote:
> On Thu, 6 May 2010 06:28:14 am Michael S. Tsirkin wrote:
> > Rusty,
> > this is a simplified form of a patch you posted in the past.
> > I have a vhost patch that, using this feature, shows external
> > to host bandwidth grow from 5 to 7 GB/s, by avoiding
> > an interrupt in the window after previous interrupt
> > was sent and before interrupts were disabled for the vq.
> > With vhost under some external to host loads I see
> > this window being hit about 30% sometimes.
> 
> Fascinating.  So you use this to guess if the guest is still processing?

Exactly.

> I haven't thought about it hard, but is that racy?

I thought about this really hard and I don't think it's
necessarily racy, as long as (pseudo code):
	guest:
		start:
			disable interrupts
			read(used)
			write(last used)
			enable interrupts
			mb()
			if read(used)
				goto start

	host:
		write used
		mb()
		if (reached(read(last used), used))
			interrupt

IOW, guest does read then write then read, host does write then read.

Now, the only way to miss an interrupt is if we read last used
value before it is written so we think guest is still processing.
But if that happens, this means that host has written used before
guest updated last used, and for this reason peek will see
used value and restart polling.

IOW, to miss an interrupt host must read a stale value.
For this host must read before guest write, then
host write already happened, so second read in
guest will see an updated value host has written.


Now, I also added an mb() in guest between read and write so
that last used index write can not get ahead of used index read.
It does feel good to have it there, but I can not say why
it's helpful. Works fine without it, but then these
subtle races might be hard to trigger. What do you think?


> Obviously happy to apply this when you finalize it.
> 
> Thanks!
> Rusty.
