Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543Ab0DGJGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 05:06:36 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:32918 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269Ab0DGJG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 05:06:29 -0400
Date: Wed, 7 Apr 2010 11:06:23 +0200
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Pedro Ribeiro <pedrib@gmail.com>, akpm@linux-foundation.org,
       Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
       alsa-devel@alsa-project.org, linux-usb@vger.kernel.org
Subject: USB transfer_buffer allocations on 64bit systems
Message-ID: <20100407090623.GN30807@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was pointed to https://bugzilla.kernel.org/show_bug.cgi?id=15580 by
Pedro Ribeiro, and unfortunately I'm pretty late in the game. I wasn't
aware of that thread until yesterday.

While the report is quite confusing, the reason seams pretty clear to me
as I've been thru quite some time-demanding debugging of a very similar
issue on Mac OS X. But I'm not totally sure whether we really hit the
same issue here, so I'd like to have your opinions first.

The problem is appearantly the way the transfer buffer is allocated in
the drivers. In the snd-usb-caiaq driver, I used kzalloc() to get memory
which works fine on 32bit systems. On x86_64, however, it seems that
kzalloc() hands out memory beyond the 32bit addressable boundary, which
the DMA controller of the 32bit PCI-connected EHCI controller is unable
to write to or read from. Am I correct on this conclusion?

Depending on the condition of the memory management, things might work
or not, and especially right after a reboot, there's a better chance to
get lower memory.

The fix is to use usb_buffer_alloc() for that purpose which ensures
memory that is suitable for DMA. And on x86_64, this also means that the
upper 32 bits of the address returned are all 0's.

If what I've stated is true, there are quite some more drivers affected
by this issue. I collected a list of places where similar fixes are
needed, and I can send patches if I get a thumbs-up.

Pedro is currently testing a patch I sent out yesterday.

Thanks,
Daniel

