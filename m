Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421Ab1GTKiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 06:38:23 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:57037
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751244Ab1GTKiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 06:38:21 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz1432N98dK4015Lzz1202hzz15d4Rz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LOMO7S-02-1XH-02
X-M-MSG: 
Date: Wed, 20 Jul 2011 12:38:13 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Neil Horman <nhorman@tuxdriver.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Divy LeRay <divy@chelsio.com>, Stanislaw Gruszka <sgruszka@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] dma-debug: hash_bucket_find needs to allow for offsets
 within an entry
Message-ID: <20110720103813.GL15108@amd.com>
References: <1311097278-30841-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1311097278-30841-1-git-send-email-nhorman@tuxdriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

thanks for your work on this :)

On Tue, Jul 19, 2011 at 01:41:18PM -0400, Neil Horman wrote:
>  lib/dma-debug.c |   17 +++++++++++++++--
>  1 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> index db07bfd..333f0ee 100644
> --- a/lib/dma-debug.c
> +++ b/lib/dma-debug.c
> @@ -248,10 +248,23 @@ static struct dma_debug_entry *hash_bucket_find(struct hash_bucket *bucket,
>  {
>  	struct dma_debug_entry *entry, *ret = NULL;
>  	int matches = 0, match_lvl, last_lvl = 0;
> +	u64 estart, eend, rstart, rend;
> +
> +	rstart = ref->dev_addr;
> +	rend = rstart + ref->size;
>  
>  	list_for_each_entry(entry, &bucket->list, list) {
> -		if ((entry->dev_addr != ref->dev_addr) ||
> -		    (entry->dev != ref->dev))
> +		estart = entry->dev_addr;
> +		eend = estart + entry->size;
> +
> +		/*
> +		 * An entry matches if the address range specified by the ref
> +		 * dev_addr and size falls entirely within the range specified
> +		 * by the entries dev_addr and size and the devices match
> +		 */
> +		if (entry->dev != ref->dev)
> +			continue;
> +		if ((estart > rstart) || (eend < rend))
>  			continue;
>  
>  		/*

But it is not that easy. The hash_fn works on the dev_addr, this means
to search all entries which might match you need to scan multiple
hash-buckets potentially.
In fact, you need to scan

	hash_fn(estart) <= idx <= hash_fn(eend)

to be sure. The patch above also lifts up the check_unmap which is not
desired.

Thanks,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

