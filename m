Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab2DWPUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 11:20:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab2DWPUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 11:20:09 -0400
Message-ID: <4F957318.2070508@redhat.com>
Date: Mon, 23 Apr 2012 15:19:52 +0000
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH] edac: rewrite edac_align_ptr()
References: <20120418140640.GF20813@aftab> <1334773174-11332-1-git-send-email-mchehab@redhat.com> <20120423140559.GA30677@aftab.osrc.amd.com>
In-Reply-To: <20120423140559.GA30677@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 23-04-2012 14:05, Borislav Petkov escreveu:
> On Wed, Apr 18, 2012 at 03:19:34PM -0300, Mauro Carvalho Chehab wrote:
>> The edac_align_ptr() function is used to prepare data for a single
>> memory allocation kzalloc() call. It counts how many bytes are needed
>> by some data structure.
>>
>> Using it as-is is not that trivial, as the quantity of memory elements
>> reserved is not there, but, instead, it is on a next call.
>>
>> In order to avoid mistakes when using it, move the number of allocated
>> elements into it, making easier to use it.
>>
>> Cc: Aristeu Rozanski <arozansk@redhat.com>
>> Cc: Doug Thompson <norsk5@yahoo.com>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>> ---
>>
>> v14: fixes a badly-solved rebase conflict, uses NULL instead of 0, adds more comments
>>      and renames the counter for the number of structures to "count"
>>
>>  drivers/edac/edac_device.c |   27 +++++++++++----------------
>>  drivers/edac/edac_mc.c     |   31 +++++++++++++++++++++++--------
>>  drivers/edac/edac_module.h |    2 +-
>>  drivers/edac/edac_pci.c    |    6 +++---
>>  4 files changed, 38 insertions(+), 28 deletions(-)
>>
>> diff --git a/drivers/edac/edac_device.c b/drivers/edac/edac_device.c
>> index 4b15459..cb397d9 100644
>> --- a/drivers/edac/edac_device.c
>> +++ b/drivers/edac/edac_device.c
>> @@ -79,7 +79,7 @@ struct edac_device_ctl_info *edac_device_alloc_ctl_info(
>>  	unsigned total_size;
>>  	unsigned count;
>>  	unsigned instance, block, attr;
>> -	void *pvt;
>> +	void *pvt, *p;
>>  	int err;
>>  
>>  	debugf4("%s() instances=%d blocks=%d\n",
>> @@ -92,35 +92,30 @@ struct edac_device_ctl_info *edac_device_alloc_ctl_info(
>>  	 * to be at least as stringent as what the compiler would
>>  	 * provide if we could simply hardcode everything into a single struct.
>>  	 */
>> -	dev_ctl = (struct edac_device_ctl_info *)NULL;
>> +	p = NULL;
>> +	dev_ctl = edac_align_ptr(&p, sizeof(*dev_ctl), 1);
>>  
>>  	/* Calc the 'end' offset past end of ONE ctl_info structure
>>  	 * which will become the start of the 'instance' array
>>  	 */
>> -	dev_inst = edac_align_ptr(&dev_ctl[1], sizeof(*dev_inst));
>> +	dev_inst = edac_align_ptr(&p, sizeof(*dev_inst), nr_instances);
>>  
>>  	/* Calc the 'end' offset past the instance array within the ctl_info
>>  	 * which will become the start of the block array
>>  	 */
>> -	dev_blk = edac_align_ptr(&dev_inst[nr_instances], sizeof(*dev_blk));
>> +	count = nr_instances * nr_blocks;
>> +	dev_blk = edac_align_ptr(&p, sizeof(*dev_blk), count);
>>  
>>  	/* Calc the 'end' offset past the dev_blk array
>>  	 * which will become the start of the attrib array, if any.
>>  	 */
>> -	count = nr_instances * nr_blocks;
>> -	dev_attrib = edac_align_ptr(&dev_blk[count], sizeof(*dev_attrib));
>> -
>> -	/* Check for case of when an attribute array is specified */
>> -	if (nr_attrib > 0) {
>> -		/* calc how many nr_attrib we need */
>> +	/* calc how many nr_attrib we need */
>> +	if (nr_attrib > 0)
>>  		count *= nr_attrib;
>> +	dev_attrib = edac_align_ptr(&p, sizeof(*dev_attrib), count);
>>  
>> -		/* Calc the 'end' offset past the attributes array */
>> -		pvt = edac_align_ptr(&dev_attrib[count], sz_private);
>> -	} else {
>> -		/* no attribute array specificed */
>> -		pvt = edac_align_ptr(dev_attrib, sz_private);
>> -	}
>> +	/* Calc the 'end' offset past the attributes array */
>> +	pvt = edac_align_ptr(&p, sz_private, 1);
>>  
>>  	/* 'pvt' now points to where the private data area is.
>>  	 * At this point 'pvt' (like dev_inst,dev_blk and dev_attrib)
>> diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
>> index ffedae9..775a3ff 100644
>> --- a/drivers/edac/edac_mc.c
>> +++ b/drivers/edac/edac_mc.c
>> @@ -101,16 +101,28 @@ const char *edac_mem_types[] = {
>>  };
>>  EXPORT_SYMBOL_GPL(edac_mem_types);
>>  
>> -/* 'ptr' points to a possibly unaligned item X such that sizeof(X) is 'size'.
>> +/**
>> + * edac_align_ptr - Prepares the pointer offsets for a single-shot allocation
>> + * @p:		pointer to a pointer with the memory offset to be used. At
>> + *		return, this will be incremented to point to the next offset
>> + * @size:	Size of the data structure to be reserved
>> + * @count:	Number of elements that should be reserved
>> + *
>> + * 'ptr' points to a possibly unaligned item X such that sizeof(X) is 'size'.
> 
> There's no 'ptr' argument anymore. Also, the text doesn't apply anymore
> since the ptr is not possibly unaligned but the returned pointer *p is
> properly aligned to size * count.

While this comment were before the function, it actually belongs to the logic
that aligns the pointer. So, I'll move it to be there inside the code.

> Also, this pointer is absolutely needed to keep the proper advancing
> further in memory to the proper offsets when allocating the struct along
> with its embedded structs, as edac_device_alloc_ctl_info() does it
> above, for example.

I'll add the above comment.

> 
>>   * Adjust 'ptr' so that its alignment is at least as stringent as what the
>>   * compiler would provide for X and return the aligned result.
>>   *
>>   * If 'size' is a constant, the compiler will optimize this whole function
>> - * down to either a no-op or the addition of a constant to the value of 'ptr'.
>> + * down to either a no-op or the addition of a constant to the value of '*p'.
>> + *
>> + * At return, the pointer 'p' will be incremented.
>>   */
>> -void *edac_align_ptr(void *ptr, unsigned size)
>> +void *edac_align_ptr(void **p, unsigned size, int count)
> 
> 'count' is non-descriptive and at least ambiguous as to what it relates
> to - call it 'n_elems' instead.

Ok.

>>  {
>>  	unsigned align, r;
>> +	void *ptr = *p;
>> +
>> +	*p += size * count;
>>  
>>  	/* Here we assume that the alignment of a "long long" is the most
>>  	 * stringent alignment that the compiler will ever provide by default.
>> @@ -132,6 +144,8 @@ void *edac_align_ptr(void *ptr, unsigned size)
>>  	if (r == 0)
>>  		return (char *)ptr;
>>  
>> +	*p += align - r;
>> +
>>  	return (void *)(((unsigned long)ptr) + align - r);
>>  }
> 
> In general, this edac_align_ptr is not really helpful because it requres
> the caller to know the exact layout of the struct it allocates memory
> for and what structs it has embedded. And frankly, I don't know how much
> it would help but I hear unaligned pointers are something bad on some
> !x86 architectures.
> 
> Oh well...

AFAIKT, badly aligned data can have serious performance impacts on some RISC
processors.

Anyway, all above points addressed by this diff patch, that I'll fold with
the original patch.

Thanks for the review,
Mauro

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 775a3ff..6ec967a 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -106,25 +106,32 @@ EXPORT_SYMBOL_GPL(edac_mem_types);
  * @p:		pointer to a pointer with the memory offset to be used. At
  *		return, this will be incremented to point to the next offset
  * @size:	Size of the data structure to be reserved
- * @count:	Number of elements that should be reserved
- *
- * 'ptr' points to a possibly unaligned item X such that sizeof(X) is 'size'.
- * Adjust 'ptr' so that its alignment is at least as stringent as what the
- * compiler would provide for X and return the aligned result.
+ * @n_elems:	Number of elements that should be reserved
  *
  * If 'size' is a constant, the compiler will optimize this whole function
  * down to either a no-op or the addition of a constant to the value of '*p'.
  *
- * At return, the pointer 'p' will be incremented.
+ * The 'p' pointer is absolutely needed to keep the proper advancing
+ * further in memory to the proper offsets when allocating the struct along
+ * with its embedded structs, as edac_device_alloc_ctl_info() does it
+ * above, for example.
+ *
+ * At return, the pointer 'p' will be incremented to be used on a next call
+ * to this function.
  */
-void *edac_align_ptr(void **p, unsigned size, int count)
+void *edac_align_ptr(void **p, unsigned size, int n_elems)
 {
 	unsigned align, r;
 	void *ptr = *p;
 
-	*p += size * count;
+	*p += size * n_elems;
 
-	/* Here we assume that the alignment of a "long long" is the most
+	/*
+	 * 'p' can possibly be an unaligned item X such that sizeof(X) is
+	 * 'size'.  Adjust 'p' so that its alignment is at least as
+	 * stringent as what the compiler would provide for X and return
+	 * the aligned result.
+	 * Here we assume that the alignment of a "long long" is the most
 	 * stringent alignment that the compiler will ever provide by default.
 	 * As far as I know, this is a reasonable assumption.
 	 */
diff --git a/drivers/edac/edac_module.h b/drivers/edac/edac_module.h
index 7a19b1b..0ea7d14 100644
--- a/drivers/edac/edac_module.h
+++ b/drivers/edac/edac_module.h
@@ -50,7 +50,7 @@ extern void edac_device_reset_delay_period(struct edac_device_ctl_info
 					   *edac_dev, unsigned long value);
 extern void edac_mc_reset_delay_period(int value);
 
-extern void *edac_align_ptr(void **p, unsigned size, int count);
+extern void *edac_align_ptr(void **p, unsigned size, int n_elems);
 
 /*
  * EDAC PCI functions



