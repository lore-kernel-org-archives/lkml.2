Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab0KNEug (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 23:50:36 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55602 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab0KNEud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 23:50:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vfv4vX2P0NfMuZoI9uPnIfjCvUF9L33ycUkGNNjFektUZxTFXSTjiCf/yD/frshJ7g
         mjCk3a0m5fl8seZIwqDRy46ZKfjOzsHyxyyB7+3Kjk+iHnts77N37P0nSpvIFC5PNHWx
         4roNR/iblugspKYkHj0AAB4KJrj7kybQZNHls=
Subject: Re: [PATCH update 2] firewire: net: throttle TX queue before
 running out of tlabels
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <tkrat.83117f4523f0d928@s5r6.in-berlin.de>
References: <tkrat.036c5d10fb83f85d@s5r6.in-berlin.de>
	 <tkrat.39c164e4c52e2fc8@s5r6.in-berlin.de>
	 <tkrat.eaac597cf54bb660@s5r6.in-berlin.de>
	 <tkrat.83117f4523f0d928@s5r6.in-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Nov 2010 06:50:28 +0200
Message-ID: <1289710228.8581.16.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-11-13 at 23:07 +0100, Stefan Richter wrote:
> This prevents firewire-net from submitting write requests in fast
> succession until failure due to all 64 transaction labels were used up
> for unfinished split transactions.  The netif_stop/wake_queue API is
> used for this purpose.
> 
> Without this stop/wake mechanism, datagrams were simply lost whenever
> the tlabel pool was exhausted.  Plus, tlabel exhaustion by firewire-net
> also prevented other unrelated outbound transactions to be initiated.
> 
> The high watermark is set to considerably less than 64 (I chose 8)
> because peers which run current Linux firewire-ohci are still easily
> saturated by this (i.e. some datagrams are dropped with ack-busy-*
> events), depending on the hardware at transmitter and receiver side.
> 
> I did not see changes to resulting throughput that were discernible from
> the usual measuring noise.  To do:  Revisit the choice of queue depth
> once firewire-ohci's AR DMA was improved.
> 
> I wonder what a good net_device.tx_queue_len value is.  I just set it
> to the same value as the chosen watermark for now.
> 
> Note:  This removes some netif_wake_queue from reception code paths.
> They were apparently copy&paste artefacts from a nonsensical
> netif_wake_queue use in the older eth1394 driver.  This belongs only
> into the transmit path.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
> Update 2:  Maxim told me to de-obfuscate status tracking.  I realized
> that netif_queue_stopped can be used for that and thereby noticed bogus
> usages of it in the rx path.

In fact after lot of testing I see that original patch, 
'[PATCH 4/4] firewire: net: throttle TX queue before running out of
tlabels' works the best here.
With AR fixes, I don't see even a single fwnet_write_complete error on
ether side.

However the 'update 2' (maybe update 1 too, didn't test), lowers
desktop->laptop throughput somewhat.
(250 vs 227 Mbits/s). I tested this many times.

Actuall raw troughput possible with UDP stream and ether no throttling
or higher packets in flight count (I tested 50/30), it 280 Mbits/s.

BTW, I still don't understand fully  why my laptop sends only at 180
Mbits/s pretty much always regardless of patches or TCP/UDP.

I also tested performance impact of other patches, and it is too small
to see through the noise.

Not bad, ah? From complete trainwreck, the IP over 1394, turned out into
very stable and fast connection that beats 100 Mbit ethernet a bit.

Now next on my list a POC (Piece of cake) items.

I need to figure out why s2ram hoses the network connection.
In fact usually, firewire-ohci does work, and reload of firewire-net
restores the connection.

Also, I need to add all required bits to make firewire-net work with NM.

I need to make resets more robust. Currently after cable plug it takes
some time until connection starts working.

So thanks again, especially to Clemens Ladisch for the hardest fixes
that made all this possible.

And of course feel free to not merge my AR rewrite, it is mostly done
as a prof of concept to see if my hardware is buggy or not.
I am sure these patches can be done better.

Best regards,
	Maxim Levitsky

