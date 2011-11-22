Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab1KVHmW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 02:42:22 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:59060 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751328Ab1KVHmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 02:42:21 -0500
X-Sasl-enc: wDTxVs8QVwiYwz9YcvDtghA+o3aXvWWXv/s587G8fJMI 1321947736
Message-ID: <4ECB5257.4040600@ladisch.de>
Date: Tue, 22 Nov 2011 08:42:15 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Tim Blechmann <tim@klingt.org>
CC: LKML <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, Brian Gerst <brgerst@gmail.com>
Subject: Re: [alsa-devel] [bisected] lx6464es fails to open a second time
References: <2428359.JOQWRg64O4@moka>
In-Reply-To: <2428359.JOQWRg64O4@moka>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Blechmann wrote:
> some time ago, i've been developing the driver for the lx6464es ethersound
> sound card, which has been included into the kernel for some time. however i
> haven't been able to use it in kernels after 2.6.33.
> 
> today, i was able to bisect the issue and the first bad commit is:
> 
> commit 6175ddf06b6172046a329e3abfd9c901a43efd2e
> Author: Brian Gerst <brgerst@gmail.com>
> Date:   Fri Feb 5 09:37:07 2010 -0500
> 
>     x86: Clean up mem*io functions.
> 
> the communication with the device is done by passing simple commands via
> memcpy_fromio and memcpy_toio (compare sound/pci/lx6464es/lx_core.c, lines 75
> to 99). any idea, what is going wrong there?

The old and new implementations of memcpy_*io do not have any differences
in the documented API, but the new ones are much more optimized, so they
might not use 8- or 32-bit accesses or a different access pattern.

Does the card's mapped I/O region behave exactly like memory, or has it
any restrictions on how it can be used?  In the latter case, you should
implement your readbuf/writebuf functions by hand to use plain 32-bit
accesses in order (or whatever is required).


Regards,
Clemens
