Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979Ab2JYSQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 14:16:05 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:14749 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758510Ab2JYSQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 14:16:02 -0400
Message-ID: <508981E1.4030600@tilera.com>
Date: Thu, 25 Oct 2012 14:16:01 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tilegx: fix some issues in the SW TSO support
References: <201210251737.q9PHbgev032681@farm-0012.internal.tilera.com> <1351187513.2662.9.camel@bwh-desktop.uk.solarflarecom.com>
In-Reply-To: <1351187513.2662.9.camel@bwh-desktop.uk.solarflarecom.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2012 1:51 PM, Ben Hutchings wrote:
> On Thu, 2012-10-25 at 13:25 -0400, Chris Metcalf wrote:
>> This change correctly computes the header length and data length in
>> the fragments to avoid a bug where we would end up with extremely
>> slow performance.  Also adopt use of skb_frag_size() accessor.
> [...]
>
> By the way, since you're doing soft-TSO you should probably set
> net_device::gso_max_segs, as explained in:
>
> commit 30b678d844af3305cda5953467005cebb5d7b687
> Author: Ben Hutchings <bhutchings@solarflare.com>
> Date:   Mon Jul 30 15:57:00 2012 +0000
>
>     net: Allow driver to limit number of GSO segments per skb

We currently have a hard limit of 2048 equeue entries (effectively,
segments) per interface.  The commit message suggests 861 is the largest
number we're likely to see, so I think we're OK from a correctness point of
view.  But, perhaps, we could end up with multiple cores trying to push
separate flows each with this tiny MSS issue, and they would then be
contending for the 2048 equeue entries, and performance might suffer.  I
don't have a good instinct on what value we should choose to set here; I
see that sfc uses 100.

So, we could do nothing since it seems we're technically safe; we could say
2048 to be explicit; we could pick a random fraction of the full size to
help avoid contention effects, like 1024 or 512; or we could mimic sfc and
just say 100.  What do you think?

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

