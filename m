Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab2LUC0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 21:26:38 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:47143 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab2LUC0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 21:26:35 -0500
Date: Fri, 21 Dec 2012 04:18:39 +0200
From: Ido Yariv <ido@wizery.com>
To: Sjur =?iso-8859-1?Q?Br=E6ndeland?= 
	<sjur.brandeland@stericsson.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org,
        Sjur =?iso-8859-1?Q?Br=E6ndeland?= <sjur@brendeland.net>
Subject: Re: [RFCv2 08/11] remoteproc: Refactor function
 rproc_elf_find_rsc_table
Message-ID: <20121221021839.GE28692@WorkStation.localnet>
References: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
 <1355501220-4572-9-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1355501220-4572-9-git-send-email-sjur.brandeland@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Fri, Dec 14, 2012 at 05:06:57PM +0100, Sjur Brændeland wrote:
> Refatcor rproc_elf_find_rsc_table and split out the scanning

Small typo there.

> for the section header named resource table. This is done to
> prepare for loading firmware once.
> 
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>

...

> +static struct elf32_shdr *
> +find_rsc_shdr(struct device *dev, struct elf32_hdr *ehdr)
>  {
> -	struct elf32_hdr *ehdr;
>  	struct elf32_shdr *shdr;
> +	int i;
>  	const char *name_table;
> -	struct device *dev = &rproc->dev;
>  	struct resource_table *table = NULL;
> -	int i;
> -	const u8 *elf_data = fw->data;
> +	const u8 *elf_data = (void *)ehdr;
>  
> -	ehdr = (struct elf32_hdr *)elf_data;
> +	/* look for the resource table and handle it */
>  	shdr = (struct elf32_shdr *)(elf_data + ehdr->e_shoff);
>  	name_table = elf_data + shdr[ehdr->e_shstrndx].sh_offset;
>  
> -	/* look for the resource table and handle it */
>  	for (i = 0; i < ehdr->e_shnum; i++, shdr++) {
>  		int size = shdr->sh_size;
>  		int offset = shdr->sh_offset;
> @@ -249,12 +230,6 @@ rproc_elf_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
>  
>  		table = (struct resource_table *)(elf_data + offset);
>  
> -		/* make sure we have the entire table */
> -		if (offset + size > fw->size) {
> -			dev_err(dev, "resource table truncated\n");
> -			return NULL;
> -		}
> -

This should probably be kept in the internal function, since it
dereferences the table as well. Moreover, this function will also be
called from other function locations.

It might also be a good idea to verify the offset as well, not just the
size.

Thanks,
Ido.
