Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933937Ab1J2C1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 22:27:43 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59195 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933039Ab1J2C1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 22:27:41 -0400
Message-ID: <4EAB6495.40707@gmail.com>
Date: Sat, 29 Oct 2011 13:27:33 +1100
From: Julian Calaby <julian.calaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20111010 Icedove/3.1.15
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: "John W. Linville" <linville@tuxdriver.com>,
        kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] drivers/net/wireless/brcm80211/brcmsmac/dma.c: eliminate
 a null pointer dereference
References: <1319846297-2985-2-git-send-email-julia@diku.dk>
In-Reply-To: <1319846297-2985-2-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/10/11 10:58, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Delete di->name from the error reporting code, as it is meaningless if di
> is NULL.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r@
> expression E, E1;
> identifier f;
> statement S1,S2,S3;
> @@
> 
> if (E == NULL)
> {
>   ... when != if (E == NULL || ...) S1 else S2
>       when != E = E1
> *E->f
>   ... when any
>   return ...;
> }
> else S3
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/dma.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
> index b56a302..1d66f53 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
> @@ -361,7 +361,7 @@ static uint _dma_ctrlflags(struct dma_info *di, uint mask, uint flags)
>  	uint dmactrlflags = di->dma.dmactrlflags;

If di is null, we've already failed as it's dereferenced here.

>  	if (di == NULL) {
> -		DMA_ERROR(("%s: _dma_ctrlflags: NULL dma handle\n", di->name));
> +		DMA_ERROR(("_dma_ctrlflags: NULL dma handle\n"));
>  		return 0;
>  	}

So, a better patch would be something like this:

(apologies if this doesn't apply - I've pretty much built it manually)

---

Though it's unlikely, di may be null, so we can't dereference
di->dma.dmactrlflags until we've checked it.

Move this de-reference after the check, and adjust the error
message to not require de-referencing di.

This is based upon Julia's original patch:
<1319846297-2985-2-git-send-email-julia@diku.dk>

Reported-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
CC: Julia Lawall <julia@diku.dk>

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
index b56a302..6ebec8f 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
@@ -358,13 +358,14 @@ static uint nrxdactive(struct dma_info *di, uint h, uint t
 
 static uint _dma_ctrlflags(struct dma_info *di, uint mask, uint flags)
 {
-       uint dmactrlflags = di->dma.dmactrlflags;
+       uint dmactrlflags;
 
        if (di == NULL) {
-               DMA_ERROR(("%s: _dma_ctrlflags: NULL dma handle\n", di->name));
+               DMA_ERROR(("_dma_ctrlflags: NULL dma handle\n"));
                return 0;
        }
 
+       dmactrlflags = di->dma.dmactrlflags;
        dmactrlflags &= ~mask;
        dmactrlflags |= flags;
 




-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby
