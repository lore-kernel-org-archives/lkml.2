Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005Ab1JNOFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 10:05:44 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41443 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756822Ab1JNOFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 10:05:42 -0400
Date: Fri, 14 Oct 2011 10:05:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>, Markus Rechberger <mrechberger@gmail.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
In-Reply-To: <CA+O4pCKKOvjRmgpC1fijzmpKOMQGdb1vkKeiSgFTY3Sv7xeaoQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1110140956390.2036-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Oct 2011, Alan Cox wrote:

> Well if the underlying solution is crap hardware with no work around its
> a bit hard to avoid. A more conservative approach would be to put the   
> 'constant' in sysfs where it belongs so it can be adjusted and special  
> cased.

On Fri, 14 Oct 2011, Markus Rechberger wrote:

> even if the value is exposed to sysfs, it still requires the static
> value in the kernel. The current value
> used in the patch is based on what is in the HW specs of device A
> which has the flexible bulk transfer setting.
> The inflexible device which uses 24064 bytes works with all other
> Operating systems by using that value
> and gives exactly the same results with other transfer sizes than that.

When you think about it, what's the real reason for limiting transfer
sizes?  Part of it has to do with avoiding large contiguous memory
allocations, of course, but that can't be the real reason.  After all,
if a memory allocation fails, there's no damage done except to the
program submitting the transfer -- and then it's clearly the program's
own fault for submitting a transfer that's too large.

A little thought shows the only reason for having this sort of limit is
to avoid denial-of-service attacks caused by dedicating too much kernel
memory to URB transfer buffers.  But limiting the size of individual
transfer buffers isn't the right way to do this!  There's nothing to
prevent a program from submitting many, many transfers, each one under
the size limit but all together exhausting available memory.

No, a much better approach is to remove all limits on individual
transfer sizes and instead have a global limit on the total amount of
all usbfs buffers in use at any time.  Maybe something like 16 MB; at 
SuperSpeed, that's about about 30 ms worth of data.

Greg, what do you think?

Alan Stern

