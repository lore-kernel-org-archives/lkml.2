Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881Ab0LMNuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 08:50:11 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:40737 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757586Ab0LMNuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 08:50:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=rgYPtvtxjHjI0lOeeW9OCNQpO3fYGEvcRh2S3Tlz/ROc2Pk8Owa8DVv0oNOCs/AAHv
         yJjjWi2/J9rhUkAlwl2VvDPRlM2GHG1h+rOI+nO20G++j9skBD4ZxBDrmaY7f8I/DyXZ
         YVDs9bKLbtlTRooCzlC8nrkHczxrQ/x8fKJpo=
Message-ID: <4D06248C.7010904@gmail.com>
Date: Mon, 13 Dec 2010 14:50:04 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Martyn Welch <martyn.welch@ge.com>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] Staging: vme_ca91cx42: fix compiler warning on 64-bit
 build
References: <1292246196-2332-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1292246196-2332-1-git-send-email-namhyung@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2010 02:16 PM, Namhyung Kim wrote:
> The gcc complains about the cast pointer to int on 64-bit as follows.
> Use unsigned long instead and wrap it up in new macro.
> 
>   CC [M]  drivers/staging/vme/bridges/vme_ca91cx42.o
> drivers/staging/vme/bridges/vme_ca91cx42.c: In function ‘ca91cx42_master_read’:
> drivers/staging/vme/bridges/vme_ca91cx42.c:870: warning: cast from pointer to integer of different size
> drivers/staging/vme/bridges/vme_ca91cx42.c:876: warning: cast from pointer to integer of different size
> drivers/staging/vme/bridges/vme_ca91cx42.c: In function ‘ca91cx42_master_write’:
> drivers/staging/vme/bridges/vme_ca91cx42.c:924: warning: cast from pointer to integer of different size
> drivers/staging/vme/bridges/vme_ca91cx42.c:930: warning: cast from pointer to integer of different size
> drivers/staging/vme/bridges/vme_ca91cx42.c: In function ‘ca91cx42_master_rmw’:
> drivers/staging/vme/bridges/vme_ca91cx42.c:983: warning: cast from pointer to integer of different size
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
> I'm not sure about the name. Suggestions?
> 
>  drivers/staging/vme/bridges/vme_ca91cx42.c |   12 +++++++-----
>  1 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
> index d1df7d12f504..cb72a5d1eeca 100644
> --- a/drivers/staging/vme/bridges/vme_ca91cx42.c
> +++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
> @@ -845,6 +845,8 @@ int ca91cx42_master_get(struct vme_master_resource *image, int *enabled,
>  	return retval;
>  }
>  
> +#define check_aligned(addr, align)	((unsigned long)addr & align)
> +
>  ssize_t ca91cx42_master_read(struct vme_master_resource *image, void *buf,
>  	size_t count, loff_t offset)
>  {
> @@ -867,13 +869,13 @@ ssize_t ca91cx42_master_read(struct vme_master_resource *image, void *buf,
>  	 * maximal configured data cycle is used and splits it
>  	 * automatically for non-aligned addresses.
>  	 */
> -	if ((int)addr & 0x1) {
> +	if (check_aligned(addr, 0x1)) {
>  		*(u8 *)buf = ioread8(addr);
>  		done += 1;
>  		if (done == count)
>  			goto out;
>  	}
> -	if ((int)addr & 0x2) {
> +	if (check_aligned(addr, 0x2)) {

It should be IS_ALIGNED(addr, 2) and IS_ALIGNED(addr, 4) respectively
anyway...

>  		if ((count - done) < 2) {
>  			*(u8 *)(buf + done) = ioread8(addr + done);
>  			done += 1;
> @@ -921,13 +923,13 @@ ssize_t ca91cx42_master_write(struct vme_master_resource *image, void *buf,
>  	/* Here we apply for the same strategy we do in master_read
>  	 * function in order to assure D16 cycle when required.
>  	 */
> -	if ((int)addr & 0x1) {
> +	if (check_aligned(addr, 0x1)) {
>  		iowrite8(*(u8 *)buf, addr);
>  		done += 1;
>  		if (done == count)
>  			goto out;
>  	}
> -	if ((int)addr & 0x2) {
> +	if (check_aligned(addr, 0x2)) {
>  		if ((count - done) < 2) {
>  			iowrite8(*(u8 *)(buf + done), addr + done);
>  			done += 1;
> @@ -980,7 +982,7 @@ unsigned int ca91cx42_master_rmw(struct vme_master_resource *image,
>  	/* Lock image */
>  	spin_lock(&(image->lock));
>  
> -	pci_addr = (u32)image->kern_base + offset;
> +	pci_addr = (u32)(unsigned long)image->kern_base + offset;

No, do not hide bugs here. I see no reason why address returned from
ioremap couldn't be larger than 32 bits. Actually it is always on 64bit.

Actually what this code tries to do? Shouldn't it be physical address of
the PCI resource instead?

regards,
-- 
js
