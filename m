Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab1CVLAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 07:00:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36081 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940Ab1CVK76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 06:59:58 -0400
Date: Tue, 22 Mar 2011 11:59:32 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Florian Mickler <florian@mickler.org>
Cc: Andy Walls <awalls@md.metrocast.net>, mchehab@infradead.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        js@linuxtv.org, tskd2@yahoo.co.jp, liplianin@me.by, g.marco@freenet.de,
        aet@rasterburn.org, pb@linuxtv.org, mkrufky@linuxtv.org,
        nick@nick-andrew.net, max@veneto.com, janne-dvb@grunau.be,
        Oliver Neukum <oliver@neukum.org>, Greg Kroah-Hartman <greg@kroah.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Joerg Roedel <joerg.roedel@amd.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/6] get rid of on-stack dma buffers
In-Reply-To: <20110321220315.7545a61a@schatten.dmk.lab>
Message-ID: <alpine.LRH.2.00.1103221157510.8710@twin.jikos.cz>
References: <1300732426-18958-1-git-send-email-florian@mickler.org> <a08d026a-d4c3-4ee5-b01a-d561f755b1ec@email.android.com> <20110321220315.7545a61a@schatten.dmk.lab>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Mar 2011, Florian Mickler wrote:

> To be blunt, I'm not shure I fully understand the requirements myself. 
> But as far as I grasped it, the main problem is that we need memory 
> which the processor can see as soon as the device has scribbled upon it. 
> (think caches and the like)
> 
> Somewhere down the line, the buffer to usb_control_msg get's to be a 
> parameter to dma_map_single which is described as part of the DMA API in 
> Documentation/DMA-API.txt
> 
> The main point I filter out from that is that the memory has to begin
> exactly at a cache line boundary... 
> 
> I guess (not verified), that the dma api takes sufficient precautions to 
> abort the dma transfer if a timeout happens.  So freeing _should_ not be 
> an issue. (At least, I would expect big fat warnings everywhere if that 
> were the case)
> 
> I cc'd some people that hopefully will correct me if I'm wrong...

It all boils down to making sure that you don't free the memory which is 
used as target of DMA transfer.

This is very likely to hit you when DMA memory region is on stack, but 
blindly just converting this to kmalloc()/kfree() isn't any better if you 
don't make sure that all the DMA transfers have been finished and device 
will not be making any more to that particular memory region.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

