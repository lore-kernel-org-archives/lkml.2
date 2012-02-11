Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491Ab2BKNGV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 08:06:21 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53082 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144Ab2BKNGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 08:06:20 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 11 Feb 2012 14:06:05 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Chris Boot <bootc@bootc.net>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/3] firewire-sbp2: Take into account Unit_Unique_ID
Message-ID: <20120211140605.0501e039@stein>
In-Reply-To: <4F365E75.2030302@bootc.net>
References: <EE1CAC85-DF0C-4C21-B2BD-446C481C938F@bootc.net>
	<1328881314-26544-1-git-send-email-bootc@bootc.net>
	<1328881314-26544-2-git-send-email-bootc@bootc.net>
	<20120211121250.5e2fe781@stein>
	<4F365E75.2030302@bootc.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 11 Chris Boot wrote:
> On 11/02/2012 11:12, Stefan Richter wrote:
> > On Feb 10 Chris Boot wrote:
> >> +	if ((leaf[0]&  0xffff0000) != 0x00020000)
> >> +		return -EINVAL;
> >
> > This could be relaxed to "if (leaf[0]<  0x00020000)", but the stricter
> > check is fine too.
> 
> Well the standard does say the length must be exactly 2 rather than just 
> defining it a leaf node that contains an EUI-64. But I did not realise 
> various firmware gets things quite so wrong sometimes...

I expect firmware writers to get length == 2 right, but we need to
protect ourselves against very dumb mistakes or malicious input of course.

Whether the length field is 2 or not could be totally ignored by
firewire-sbp2 just like we ignore the block CRC, except that we need to
catch the corner case of a bogus Config ROM where the descriptor leaf
overlaps the 1 kB ROM size limit, or that it is placed right at the end of
the ROM but is shorter than 2 quadlets.

core-device.c::read_config_rom() already catches the cases of blocks
overlapping the end of the ROM but merely handles them by overwriting the
block length by 0.  Higher-level code which reads a descriptor block or
directory block in the Config ROM cache is required to respect the length
field of the block.  We could simplify this for upper layer code by
overwriting the pointer to the block instead of the header of the block,
like it is done already with pointers to blocks outside of the ROM.

Anyway; if the length of an alleged EUI-64 descriptor leaf is greater than
2, I agree that there is little reason to look at the rest of the
descriptor; it would likely contain garbage too.
-- 
Stefan Richter
-=====-===-- --=- -=-==
http://arcgraph.de/sr/
