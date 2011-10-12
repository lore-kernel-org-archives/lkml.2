Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab1JLQH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 12:07:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:42668 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372Ab1JLQH0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 12:07:26 -0400
Subject: Re: [PATCH] uio: Support 36-bit physical addresses on 32-bit systems
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20111012153229.GB21852@local>
Date: Wed, 12 Oct 2011 11:07:09 -0500
Cc: gregkh@suse.de, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        Kai Jiang <Kai.Jiang@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <AD39F4F8-E9C0-4090-9AEA-644F82DD328B@kernel.crashing.org>
References: <1318430145-19898-1-git-send-email-galak@kernel.crashing.org> <20111012153229.GB21852@local>
To: "Hans J. Koch" <hjk@hansjkoch.de>
X-Mailer: Apple Mail (2.1244.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 12, 2011, at 10:32 AM, Hans J. Koch wrote:

> On Wed, Oct 12, 2011 at 09:35:45AM -0500, Kumar Gala wrote:
>> From: Kai Jiang <Kai.Jiang@freescale.com>
>> 
>> To support >32-bit physical addresses for UIO_MEM_PHYS type we need to
>> extend the width of 'addr' in struct uio_mem.  Numerous platforms like
>> embedded PPC, ARM, and X86 have support for systems with larger physical
>> address than logical.
>> 
>> Since 'addr' may contain a physical, logical, or virtual address the
>> easiest solution is to just change the type to 'unsigned long long'
>> regardless of which type is utilized.
> 
> No. There's phys_addr_t for that purpose, defined in include/linux/types.h.
> Please use that.

Do we believe phys_addr_t is always greater than or equal to size need for logical & virtual addresses?

- k


> Thanks,
> Hans
> 
>> 
>> For physical address we can support up to a 44-bit physical address on a
>> typical 32-bit system as we utilize remap_pfn_range() for the mapping of
>> the memory region and pfn's are represnted by shifting the address by
>> the page size (typically 4k).
>> 
>> Signed-off-by: Kai Jiang <Kai.Jiang@freescale.com>
>> Signed-off-by: Minghuan Lian <Minghuan.Lian@freescale.com>
>> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
>> ---
>> drivers/uio/uio.c          |    8 ++++----
>> include/linux/uio_driver.h |    2 +-
>> 2 files changed, 5 insertions(+), 5 deletions(-)
>> 
>> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
>> index d2efe82..a927c51 100644
>> --- a/drivers/uio/uio.c
>> +++ b/drivers/uio/uio.c
>> @@ -69,7 +69,7 @@ static ssize_t map_name_show(struct uio_mem *mem, char *buf)
>> 
>> static ssize_t map_addr_show(struct uio_mem *mem, char *buf)
>> {
>> -	return sprintf(buf, "0x%lx\n", mem->addr);
>> +	return sprintf(buf, "0x%llx\n", mem->addr);
>> }
>> 
>> static ssize_t map_size_show(struct uio_mem *mem, char *buf)
>> @@ -79,7 +79,7 @@ static ssize_t map_size_show(struct uio_mem *mem, char *buf)
>> 
>> static ssize_t map_offset_show(struct uio_mem *mem, char *buf)
>> {
>> -	return sprintf(buf, "0x%lx\n", mem->addr & ~PAGE_MASK);
>> +	return sprintf(buf, "0x%llx\n", mem->addr & ~PAGE_MASK);
>> }
>> 
>> struct map_sysfs_entry {
>> @@ -634,8 +634,8 @@ static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>> 	if (idev->info->mem[mi].memtype == UIO_MEM_LOGICAL)
>> 		page = virt_to_page(idev->info->mem[mi].addr + offset);
>> 	else
>> -		page = vmalloc_to_page((void *)idev->info->mem[mi].addr
>> -							+ offset);
>> +		page = vmalloc_to_page((void *)(unsigned long)
>> +				idev->info->mem[mi].addr + offset);
>> 	get_page(page);
>> 	vmf->page = page;
>> 	return 0;
>> diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
>> index 665517c..c1fdb19 100644
>> --- a/include/linux/uio_driver.h
>> +++ b/include/linux/uio_driver.h
>> @@ -31,7 +31,7 @@ struct uio_map;
>>  */
>> struct uio_mem {
>> 	const char		*name;
>> -	unsigned long		addr;
>> +	unsigned long long	addr;
>> 	unsigned long		size;
>> 	int			memtype;
>> 	void __iomem		*internal_addr;
>> -- 
>> 1.7.3.4
>> 
>> 

