Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098Ab2DINeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 09:34:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52215 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2DINee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 09:34:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH 5/6] arch/tile: provide kernel support for the tilegx mPIPE shim
Date: Mon, 9 Apr 2012 13:34:28 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201204062059.q36KxjEO011317@farm-0027.internal.tilera.com> <201204062101.q36L1uIJ011405@farm-0027.internal.tilera.com>
In-Reply-To: <201204062101.q36L1uIJ011405@farm-0027.internal.tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204091334.28991.arnd@arndb.de>
X-Provags-ID: V02:K0:jk9Sfz1fymfcFqEdd8af8qv0PvKLPPudsrdyrBeMPm+
 FgFhb+lKixLxRgHhmi0k8AuXSkJAiJtSu/LC7bJr4VDgXXAKaa
 lVsRyOL4vdjFyiKFdzsuLWsRUWnzAqMAy5IbLPHIM2emH0ZryV
 kZ/xW6aMn/m2EADFAXJSRDePoYq3XvTOYPLIhimC1UC16pSudw
 xDXN2RFmz1fVZ/EAizkOvnAMXmh8EfRAWkd05c9zrFowTzpvf2
 qT0IDnAa+zTATuo8x9Qv3X1eRtJVpiwFwbkuDotENMdxOsPRWb
 kgxdnbtPngazKm3ucBs8ZRLw5BmMS/wa6uF4hVmw/0d/2oT65Q
 t+UrNFvYcaCtAmIlyQRc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 April 2012, Chris Metcalf wrote:
> The TILE-Gx chip includes a packet-processing network engine called
> mPIPE ("Multicore Programmable Intelligent Packet Engine").  This
> change adds support for using the mPIPE engine from within the
> kernel.  The engine has more functionality than is exposed here,
> but to keep the kernel code and binary simpler, this is a subset
> of the full API designed to enable standard Linux networking only.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Hi Chris,

I don't have anything to say about the driver itself, but a few general
comments on coding style.

> +config TILE_GXIO_MPIPE
> +	bool "Tilera Gx mPIPE I/O support"
> +	select TILE_GXIO
> +	select TILE_GXIO_DMA
> +	---help---
> +	  This option supports direct access to the TILE-Gx mPIPE hardware
> +	  from kernel space.  It is not required in order to use the gxio
> +	  library to access mPIPE from user space.

Since this is all library code and does not provide any functionality itself,
you can make the option invisible and just select it from the drivers that
need it.

> +EXPORT_SYMBOL(gxio_mpipe_alloc_buffer_stacks);

Since these are all pretty specific low-level functions, I think it would be
more appropriate to mark them all EXPORT_SYMBOL_GPL.

> +
> +typedef struct {
> +	iorpc_mem_buffer_t buffer;
> +	unsigned int stack;
> +	unsigned int buffer_size_enum;
> +} init_buffer_stack_aux_param_t;

In kernel coding style, we don't use typedef for structures like this.
Just call this a 'struct init_buffer_stack_aux_param' so that a reader
can see that it is a complex data structure and not just a scalar.

> +int gxio_mpipe_link_close(gxio_mpipe_link_t * link)
> +{
> +	return gxio_mpipe_link_close_aux(link->context, link->mac);
> +}
> +
> +EXPORT_SYMBOL(gxio_mpipe_init);
> +EXPORT_SYMBOL(gxio_mpipe_buffer_size_to_buffer_size_enum);
> +EXPORT_SYMBOL(gxio_mpipe_buffer_size_enum_to_buffer_size);
> +EXPORT_SYMBOL(gxio_mpipe_calc_buffer_stack_bytes);
> +EXPORT_SYMBOL(gxio_mpipe_init_buffer_stack);
> +EXPORT_SYMBOL(gxio_mpipe_init_notif_ring);
> +EXPORT_SYMBOL(gxio_mpipe_init_notif_group_and_buckets);
> +EXPORT_SYMBOL(gxio_mpipe_rules_init);
> +EXPORT_SYMBOL(gxio_mpipe_rules_begin);

Move the EXPORT_SYMBOL (_GPL) right after the function, not at the end of the file.

> +// MMIO Ingress DMA Release Region Address.
> +// This is a description of the physical addresses used to manipulate ingress
> +// credit counters.  Accesses to this address space should use an address of
> +// this form and a value like that specified in IDMA_RELEASE_REGION_VAL.
> +

Comment style: You should use

 /*
  * Multi-line
  * comment
  */

or /* single-line comment */

> +__extension__
> +typedef union
> +{
> +  struct
> +  {
> +#ifndef __BIG_ENDIAN__
> +    // Reserved.
> +    uint_reg_t __reserved_0  : 3;
> +    // NotifRing to be released
> +    uint_reg_t ring          : 8;
> +    // Bucket to be released
> +    uint_reg_t bucket        : 13;
> +    // Enable NotifRing release
> +    uint_reg_t ring_enable   : 1;
> +    // Enable Bucket release
> +    uint_reg_t bucket_enable : 1;
> +    // This field of the address selects the region (address space) to be
> +    // accessed.  For the iDMA release region, this field must be 4.
> +    uint_reg_t region        : 3;
> +    // Reserved.
> +    uint_reg_t __reserved_1  : 6;
> +    // This field of the address indexes the 32 entry service domain table.
> +    uint_reg_t svc_dom       : 5;
> +    // Reserved.
> +    uint_reg_t __reserved_2  : 24;
> +#else   // __BIG_ENDIAN__
> +    uint_reg_t __reserved_2  : 24;
> +    uint_reg_t svc_dom       : 5;
> +    uint_reg_t __reserved_1  : 6;
> +    uint_reg_t region        : 3;
> +    uint_reg_t bucket_enable : 1;
> +    uint_reg_t ring_enable   : 1;
> +    uint_reg_t bucket        : 13;
> +    uint_reg_t ring          : 8;
> +    uint_reg_t __reserved_0  : 3;
> +#endif
> +  };
> +  uint_reg_t word;
> +} MPIPE_IDMA_RELEASE_REGION_ADDR_t;

Best try to avoid all bitfields for interfaces like this. Make it an le32
or be32 variable instead and use masks for the accessing the individual
fields.

Do not use capital letters for types.

	Arnd
