Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab1KGJY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 04:24:56 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:57041 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752374Ab1KGJYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 04:24:54 -0500
X-Authenticated: #7756412
X-Provags-ID: V01U2FsdGVkX1+KNYBnE3iKMYeXKo1kbFlEQMR2zheLFARCPl4uay
	O7HPVad/AWHWGK
Message-ID: <4EB7A3E2.2060400@gmx.net>
Date: Mon, 07 Nov 2011 10:24:50 +0100
From: Arne Jansen <sensille@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: Don't leak mem in scrub_fixup().
References: <alpine.LNX.2.00.1111062331350.5763@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1111062331350.5763@swampdragon.chaosbits.net>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.11.2011 23:33, Jesper Juhl wrote:
> It seems to me that we may leak the memory allocated to 'multi' in
> scrub_fixup() if, for example, 'length' turns out to be less than
> PAGE_SIZE after we call btrfs_map_block(). This patch should take care
> of the leak by always kfree'ing 'multi' before we return in that error
> case.

Thanks for looking into this. The current pull request already contains
a fix for this, from Ilya Dryomov.

-Arne

> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  fs/btrfs/scrub.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
>  Compile tested only since I don't have any btrfs filesystems to test on.
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index a8d03d5..b53433e 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -271,6 +271,7 @@ static void scrub_fixup(struct scrub_bio *sbio, int ix)
>  	ret = btrfs_map_block(map_tree, REQ_WRITE, logical, &length,
>  			      &multi, 0);
>  	if (ret || !multi || length < PAGE_SIZE) {
> +		kfree(multi);
>  		printk(KERN_ERR
>  		       "scrub_fixup: btrfs_map_block failed us for %llu\n",
>  		       (unsigned long long)logical);

