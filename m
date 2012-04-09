Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab2DIVEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 17:04:54 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:32061 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321Ab2DIVEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 17:04:52 -0400
Message-ID: <4F834EF1.4080006@tilera.com>
Date: Mon, 9 Apr 2012 17:04:49 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] arch/tile: provide kernel support for the tilegx
 mPIPE shim
References: <201204062059.q36KxjEO011317@farm-0027.internal.tilera.com> <201204062101.q36L1uIJ011405@farm-0027.internal.tilera.com> <201204091334.28991.arnd@arndb.de>
In-Reply-To: <201204091334.28991.arnd@arndb.de>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/9/2012 9:34 AM, Arnd Bergmann wrote:
> On Friday 06 April 2012, Chris Metcalf wrote:
>> The TILE-Gx chip includes a packet-processing network engine called
>> mPIPE ("Multicore Programmable Intelligent Packet Engine").  This
>> change adds support for using the mPIPE engine from within the
>> kernel.  The engine has more functionality than is exposed here,
>> but to keep the kernel code and binary simpler, this is a subset
>> of the full API designed to enable standard Linux networking only.
>>
>> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
>>
>>
>> +config TILE_GXIO_MPIPE
>> +	bool "Tilera Gx mPIPE I/O support"
>> [...]
> Since this is all library code and does not provide any functionality itself,
> you can make the option invisible and just select it from the drivers that
> need it.

Good point.  Before last week they were actually full-scale user options
that you had select to be able to enable networking support, which I
realized was pretty broken when I looked at it.  I had reversed the
"depends" to be "selects", but I hadn't realized I should just make them
purely internal.  Done.

>> +EXPORT_SYMBOL(gxio_mpipe_alloc_buffer_stacks);
> Since these are all pretty specific low-level functions, I think it would be
> more appropriate to mark them all EXPORT_SYMBOL_GPL.

Done.

>> +
>> +typedef struct {
>> +	iorpc_mem_buffer_t buffer;
>> +	unsigned int stack;
>> +	unsigned int buffer_size_enum;
>> +} init_buffer_stack_aux_param_t;
> In kernel coding style, we don't use typedef for structures like this.
> Just call this a 'struct init_buffer_stack_aux_param' so that a reader
> can see that it is a complex data structure and not just a scalar.

This is machine-generated code from "upstream" (the Tilera hypervisor).  I
will look into how straightforward it is to use plain structs here.

>> +int gxio_mpipe_link_close(gxio_mpipe_link_t * link)
>> +{
>> +	return gxio_mpipe_link_close_aux(link->context, link->mac);
>> +}
>> +
>> +EXPORT_SYMBOL(gxio_mpipe_init);
>> +EXPORT_SYMBOL(gxio_mpipe_buffer_size_to_buffer_size_enum);
>> +EXPORT_SYMBOL(gxio_mpipe_buffer_size_enum_to_buffer_size);
>> +EXPORT_SYMBOL(gxio_mpipe_calc_buffer_stack_bytes);
>> +EXPORT_SYMBOL(gxio_mpipe_init_buffer_stack);
>> +EXPORT_SYMBOL(gxio_mpipe_init_notif_ring);
>> +EXPORT_SYMBOL(gxio_mpipe_init_notif_group_and_buckets);
>> +EXPORT_SYMBOL(gxio_mpipe_rules_init);
>> +EXPORT_SYMBOL(gxio_mpipe_rules_begin);
> Move the EXPORT_SYMBOL (_GPL) right after the function, not at the end of the file.

Done.  There were some shared-code issues that made this initially ugly
(this code is shared by a userspace library and by the kernel), but some
more aggressive use of "unifdef" and "sed" left things cleaner when the
dust settled. :-)

>> +// MMIO Ingress DMA Release Region Address.
>> +// This is a description of the physical addresses used to manipulate ingress
>> +// credit counters.  Accesses to this address space should use an address of
>> +// this form and a value like that specified in IDMA_RELEASE_REGION_VAL.
>> +
> Comment style

Yes, more of the machine-generated code here.  I will look into this one as
well.

> [...]
> +    uint_reg_t __reserved_0  : 3;
> +#endif
> +  };
> +  uint_reg_t word;
> +} MPIPE_IDMA_RELEASE_REGION_ADDR_t;
> Best try to avoid all bitfields for interfaces like this. Make it an le32
> or be32 variable instead and use masks for the accessing the individual
> fields.

We've had good experiences with bitfields, in fact.  In practice, in our
experience, bitfields result in code that's easier to get right, especially
when doing read-modify-write of something that's more than a bit wide, vs.
using shifts/masks.  (And especially when the overall item is 64 bits wide;
you have to remember to make your masks properly "UL" or you get mysterious
truncation, etc.)  Our compiler has well-understood bitfield management
properties.  This was less true with older compilers on other
architectures, I think.

> Do not use capital letters for types.

We normally don't, but these types are in fact exactly the representation
of the structure of the MMIO word whose structure is given by #defines of
the form MPIPE_IDMA_RELEASE_REGION_ADDR__* in the lower-level headers. 
(Note that I've pruned the headers so as not to spam the kernel with
multiple 200KB+ headers that we only use a few dozen lines in, so this is
less obvious than it otherwise would be.)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

