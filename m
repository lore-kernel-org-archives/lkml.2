Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965043Ab2JWUhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:37:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56243 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964784Ab2JWUhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:37:11 -0400
Date: Tue, 23 Oct 2012 13:37:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Denis Kirjanov <kirjanov@gmail.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH] edac: fix buffer overrun if no suitable bandwidth found
Message-Id: <20121023133709.21e9cb72.akpm@linux-foundation.org>
In-Reply-To: <20121023202612.GA20526@aftab.osrc.amd.com>
References: <1350919858-26202-1-git-send-email-kirjanov@gmail.com>
	<20121023121005.ed33061a.akpm@linux-foundation.org>
	<20121023202612.GA20526@aftab.osrc.amd.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2012 22:26:12 +0200
Borislav Petkov <bp@amd64.org> wrote:

> From: Denis Kirjanov <kirjanov@gmail.com>
> Date: Mon, 22 Oct 2012 19:30:58 +0400
> Subject: [PATCH] amd64_edac: Fix hypothetical out-of-bounds access
> 
> Make sure we stay within scrubrates' array bounds.
> 
> Boris: this is a correctness fix only because the loop terminates
> earlier due to us capping scrubbing bandwidth to 0.
> 
> Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  drivers/edac/amd64_edac.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index 501bfb938f26..73d9108d6200 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -181,14 +181,16 @@ static int __amd64_set_scrub_rate(struct pci_dev *ctl, u32 new_bw, u32 min_rate)
>  
>  		if (scrubrates[i].bandwidth <= new_bw)
>  			break;
> -
> -		/*
> -		 * if no suitable bandwidth found, turn off DRAM scrubbing
> -		 * entirely by falling back to the last element in the
> -		 * scrubrates array.
> -		 */
>  	}
>  
> +	/*
> +	 * if no suitable bandwidth found, turn off DRAM scrubbing
> +	 * entirely by falling back to the last element in the scrubrates
> +	 * array.
> +	 */
> +	if (i == ARRAY_SIZE(scrubrates))
> +		i--;
> +
>  	scrubval = scrubrates[i].scrubval;
>  
>  	pci_write_bits32(ctl, SCRCTRL, scrubval, 0x001F);

This is still strange.  What's the point in having the initial loop
even consider the last element in the array if we know we'll be using
it anyway?

