Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044Ab0DGQEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 12:04:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38954 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755535Ab0DGQEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 12:04:34 -0400
Date: Wed, 7 Apr 2010 12:04:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Daniel Mack <daniel@caiaq.de>, <linux-kernel@vger.kernel.org>,
       Pedro Ribeiro <pedrib@gmail.com>, <akpm@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, <alsa-devel@alsa-project.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: USB transfer_buffer allocations on 64bit systems
In-Reply-To: <20100407155122.GA13974@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1004071157460.1779-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Apr 2010, Greg KH wrote:

> > FWIW, most drivers I've seen in the past hours use a wild mix of
> > kmalloc(), kzalloc(), kcalloc() and usb_buffer_alloc(). That should
> > really be unified.

Well, kcalloc can easily be replaced by kzalloc, right?  Or the 
equivalent.

The extra overhead of initializing the memory to 0 isn't present in 
kmalloc, so we need to maintain the distinction between kmalloc and 
kzalloc.

However usb_buffer_alloc is fundmentally different from all the others.

> Yes, if it is necessary that we have to handle this type of crappy
> hardware, then it all needs to be unified.  Or at least unified into 2
> types of calls, one that needs the bounce buffer fun (what
> usb_buffer_alloc() does today), and one that doesn't (usb_kzalloc()
> perhaps?)

usb_buffer_alloc has very little to do with bounce buffers.  Its 
purpose is to allocate dma-consistent memory, that it, memory which 
does not need to be mapped for DMA before each I/O operation and 
unmapped afterward.

The mapping and unmapping operations aren't extremely time consuming,
so in general it makes sense to avoid them only when the _same_ buffer
is going to be used for many I/O operations during a short period of
time.  For instance, it makes sense for audio and video, where all the
data streams through a small set of buffers arranged in a ring.

But for most other uses it makes no sense.  Especially since some 
platforms have limited amounts of consistent memory available.

Alan Stern

