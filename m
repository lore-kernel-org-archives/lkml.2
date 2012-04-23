Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab2DWOGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 10:06:07 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:38552 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365Ab2DWOGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 10:06:04 -0400
Date: Mon, 23 Apr 2012 16:05:59 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH] edac: rewrite edac_align_ptr()
Message-ID: <20120423140559.GA30677@aftab.osrc.amd.com>
References: <20120418140640.GF20813@aftab>
 <1334773174-11332-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334773174-11332-1-git-send-email-mchehab@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 03:19:34PM -0300, Mauro Carvalho Chehab wrote:
> The edac_align_ptr() function is used to prepare data for a single
> memory allocation kzalloc() call. It counts how many bytes are needed
> by some data structure.
> 
> Using it as-is is not that trivial, as the quantity of memory elements
> reserved is not there, but, instead, it is on a next call.
> 
> In order to avoid mistakes when using it, move the number of allocated
> elements into it, making easier to use it.
> 
> Cc: Aristeu Rozanski <arozansk@redhat.com>
> Cc: Doug Thompson <norsk5@yahoo.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
> 
> v14: fixes a badly-solved rebase conflict, uses NULL instead of 0, adds more comments
>      and renames the counter for the number of structures to "count"
> 
>  drivers/edac/edac_device.c |   27 +++++++++++----------------
>  drivers/edac/edac_mc.c     |   31 +++++++++++++++++++++++--------
>  drivers/edac/edac_module.h |    2 +-
>  drivers/edac/edac_pci.c    |    6 +++---
>  4 files changed, 38 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/edac/edac_device.c b/drivers/edac/edac_device.c
> index 4b15459..cb397d9 100644
> --- a/drivers/edac/edac_device.c
> +++ b/drivers/edac/edac_device.c
> @@ -79,7 +79,7 @@ struct edac_device_ctl_info *edac_device_alloc_ctl_info(
>  	unsigned total_size;
>  	unsigned count;
>  	unsigned instance, block, attr;
> -	void *pvt;
> +	void *pvt, *p;
>  	int err;
>  
>  	debugf4("%s() instances=%d blocks=%d\n",
> @@ -92,35 +92,30 @@ struct edac_device_ctl_info *edac_device_alloc_ctl_info(
>  	 * to be at least as stringent as what the compiler would
>  	 * provide if we could simply hardcode everything into a single struct.
>  	 */
> -	dev_ctl = (struct edac_device_ctl_info *)NULL;
> +	p = NULL;
> +	dev_ctl = edac_align_ptr(&p, sizeof(*dev_ctl), 1);
>  
>  	/* Calc the 'end' offset past end of ONE ctl_info structure
>  	 * which will become the start of the 'instance' array
>  	 */
> -	dev_inst = edac_align_ptr(&dev_ctl[1], sizeof(*dev_inst));
> +	dev_inst = edac_align_ptr(&p, sizeof(*dev_inst), nr_instances);
>  
>  	/* Calc the 'end' offset past the instance array within the ctl_info
>  	 * which will become the start of the block array
>  	 */
> -	dev_blk = edac_align_ptr(&dev_inst[nr_instances], sizeof(*dev_blk));
> +	count = nr_instances * nr_blocks;
> +	dev_blk = edac_align_ptr(&p, sizeof(*dev_blk), count);
>  
>  	/* Calc the 'end' offset past the dev_blk array
>  	 * which will become the start of the attrib array, if any.
>  	 */
> -	count = nr_instances * nr_blocks;
> -	dev_attrib = edac_align_ptr(&dev_blk[count], sizeof(*dev_attrib));
> -
> -	/* Check for case of when an attribute array is specified */
> -	if (nr_attrib > 0) {
> -		/* calc how many nr_attrib we need */
> +	/* calc how many nr_attrib we need */
> +	if (nr_attrib > 0)
>  		count *= nr_attrib;
> +	dev_attrib = edac_align_ptr(&p, sizeof(*dev_attrib), count);
>  
> -		/* Calc the 'end' offset past the attributes array */
> -		pvt = edac_align_ptr(&dev_attrib[count], sz_private);
> -	} else {
> -		/* no attribute array specificed */
> -		pvt = edac_align_ptr(dev_attrib, sz_private);
> -	}
> +	/* Calc the 'end' offset past the attributes array */
> +	pvt = edac_align_ptr(&p, sz_private, 1);
>  
>  	/* 'pvt' now points to where the private data area is.
>  	 * At this point 'pvt' (like dev_inst,dev_blk and dev_attrib)
> diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
> index ffedae9..775a3ff 100644
> --- a/drivers/edac/edac_mc.c
> +++ b/drivers/edac/edac_mc.c
> @@ -101,16 +101,28 @@ const char *edac_mem_types[] = {
>  };
>  EXPORT_SYMBOL_GPL(edac_mem_types);
>  
> -/* 'ptr' points to a possibly unaligned item X such that sizeof(X) is 'size'.
> +/**
> + * edac_align_ptr - Prepares the pointer offsets for a single-shot allocation
> + * @p:		pointer to a pointer with the memory offset to be used. At
> + *		return, this will be incremented to point to the next offset
> + * @size:	Size of the data structure to be reserved
> + * @count:	Number of elements that should be reserved
> + *
> + * 'ptr' points to a possibly unaligned item X such that sizeof(X) is 'size'.

There's no 'ptr' argument anymore. Also, the text doesn't apply anymore
since the ptr is not possibly unaligned but the returned pointer *p is
properly aligned to size * count.

Also, this pointer is absolutely needed to keep the proper advancing
further in memory to the proper offsets when allocating the struct along
with its embedded structs, as edac_device_alloc_ctl_info() does it
above, for example.

>   * Adjust 'ptr' so that its alignment is at least as stringent as what the
>   * compiler would provide for X and return the aligned result.
>   *
>   * If 'size' is a constant, the compiler will optimize this whole function
> - * down to either a no-op or the addition of a constant to the value of 'ptr'.
> + * down to either a no-op or the addition of a constant to the value of '*p'.
> + *
> + * At return, the pointer 'p' will be incremented.
>   */
> -void *edac_align_ptr(void *ptr, unsigned size)
> +void *edac_align_ptr(void **p, unsigned size, int count)

'count' is non-descriptive and at least ambiguous as to what it relates
to - call it 'n_elems' instead.

>  {
>  	unsigned align, r;
> +	void *ptr = *p;
> +
> +	*p += size * count;
>  
>  	/* Here we assume that the alignment of a "long long" is the most
>  	 * stringent alignment that the compiler will ever provide by default.
> @@ -132,6 +144,8 @@ void *edac_align_ptr(void *ptr, unsigned size)
>  	if (r == 0)
>  		return (char *)ptr;
>  
> +	*p += align - r;
> +
>  	return (void *)(((unsigned long)ptr) + align - r);
>  }

In general, this edac_align_ptr is not really helpful because it requres
the caller to know the exact layout of the struct it allocates memory
for and what structs it has embedded. And frankly, I don't know how much
it would help but I hear unaligned pointers are something bad on some
!x86 architectures.

Oh well...

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
