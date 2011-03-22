Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab1CVRk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 13:40:56 -0400
Received: from linux-sh.org ([111.68.239.195]:55052 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756554Ab1CVRkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 13:40:52 -0400
Date: Wed, 23 Mar 2011 02:39:50 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Thomas Hellstrom <thomas@shipmail.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org, Alex Deucher <alexdeucher@gmail.com>,
        Jerome Glisse <j.glisse@gmail.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH] cleanup: Add 'struct dev' in the TTM layer to be passed in for DMA API calls.
Message-ID: <20110322173950.GA5190@linux-sh.org>
References: <1299598789-20402-1-git-send-email-konrad.wilk@oracle.com> <4D769726.2030307@shipmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D769726.2030307@shipmail.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 09:52:54PM +0100, Thomas Hellstrom wrote:
> Is passing a struct device to the DMA api really *strictly* necessary?
> 
Yes.

> I'd like to avoid that at all cost, since we don't want pages that are 
> backing buffer objects
> (coherent pages) to be associated with a specific device.
> 
And what do you do when coherent memory for a given device can only be
obtained from that bus or that device alone?

This API permits for cases where system memory is non-coherent or you are
handling transactions across busses lacking coherency protocols between
each other and so on. There are plenty of cases where coherent DMA
buffers for PCI devices need to be allocated within the context of the
PCI bus and no other coherent memory is possible. More complex examples
exist as well. There are MFDs where DMA transactions are only coherent
with regards to local SRAM that in turn is mapped in and out of an 8051
microcontroller's address space, and so on. The kernel deals with all of
these sorts of cases by way of that dev pointer in the DMA API, and any
attempt to move beyond that scope makes non-portable assumptions about
the nature of coherent memory pools.

> The reason for this is that we probably soon will want to move ttm 
> buffer objects between devices, and that should ideally be a simple 
> operation: If the memory type the buffer object currently resides in is 
> not shared between two devices, then move it out to system memory and 
> change its struct bo_device pointer.
> 
> If pages are associated with a specific device, this will become much 
> harder. Basically we need to change backing pages and copy all the data.
> 
That won't work if a device has consistent buffers locally but system
memory is non-coherent. A not too uncommon situation for embedded
platforms with a PCI bus hanging off of the CPU local bus.
