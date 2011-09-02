Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab1IBPIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 11:08:52 -0400
Received: from mxout5.netvision.net.il ([194.90.9.29]:56984 "EHLO
	mxout5.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab1IBPIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 11:08:48 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <4E60F270.4020208@billauer.co.il>
Date: Fri, 02 Sep 2011 18:12:48 +0300
From: Eli Billauer <eli@billauer.co.il>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
To: LKML <linux-kernel@vger.kernel.org>
Cc: monstr@monstr.eu
Subject: Re: [PATCH] arch/microblaze: Added sync method support for DMA  and
 made refinements
References: <4E60A276.7010903@billauer.co.il> <4E60CCE9.5050900@monstr.eu>
In-reply-to: <4E60CCE9.5050900@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Simek wrote:

>
> DMA_TO_DEVICE is fine - data has to be flushed.
>
> For DMA_FROM_DEVICE you expect that allocated space will contains data 
> from device.
> Which means if you flush them, they will be rewritten by DMA in the 
> next step.
> Which means that IMHO you can invalidate them which is faster than 
> flushing.
The flushing is only necessary when a certain memory region is written 
to, not flushed, and then allocated for DMA from device. This is not 
what drivers usually do, but it's nevertheless legal to do so. Maybe it 
can also happen as a result of memory being freed but not flushed, and 
then allocated as a DMA buffer. So this flushing prevents, at most, an 
extremely rare problem. I don't expect to see something go wrong right 
away in the lack of this flush.

In light of this, I can't see why flushing would be slower than 
invalidation, if the cache lines aren't expected to be dirty except for 
very rare conditions.

As for invalidation of a dirty cache line: Looking at the Microblaze 
reference manual's description of the wdc instruction, I'm under the 
impression that each cache line has two flags: Valid and Dirty, as they 
appear in the pseudocode. I'm not on the clear about what happens if a 
dirty cache line is invalidated. It would make sense to clear both 
flags. It also makes sense to write the data back to the RAM in this 
case. But I really don't know what's actually implemented.

Patch with the corrections soon to be posted.

   Eli

-- 
Web: http://www.billauer.co.il

