Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205Ab2GKS0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 14:26:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49400 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab2GKS0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 14:26:39 -0400
Message-ID: <4FFDC54F.5030402@vflare.org>
Date: Wed, 11 Jul 2012 11:26:23 -0700
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] zsmalloc: remove x86 dependency
References: <1341263752-10210-1-git-send-email-sjenning@linux.vnet.ibm.com> <1341263752-10210-2-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1341263752-10210-2-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2012 02:15 PM, Seth Jennings wrote:
> This patch replaces the page table assisted object mapping
> method, which has x86 dependencies, with a arch-independent
> method that does a simple copy into a temporary per-cpu
> buffer.
> 
> While a copy seems like it would be worse than mapping the pages,
> tests demonstrate the copying is always faster and, in the case of
> running inside a KVM guest, roughly 4x faster.
>
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> ---
>  drivers/staging/zsmalloc/Kconfig         |    4 --
>  drivers/staging/zsmalloc/zsmalloc-main.c |   99 +++++++++++++++++++++---------
>  drivers/staging/zsmalloc/zsmalloc_int.h  |    5 +-
>  3 files changed, 72 insertions(+), 36 deletions(-)
> 


>  struct mapping_area {
> -	struct vm_struct *vm;
> -	pte_t *vm_ptes[2];
> -	char *vm_addr;
> +	char *vm_buf; /* copy buffer for objects that span pages */
> +	char *vm_addr; /* address of kmap_atomic()'ed pages */
>  };
>  

I think we can reduce the copying overhead by not copying an entire
compressed object to another (per-cpu) buffer. The basic idea of the
method below is to:
 - Copy only the amount of data that spills over into the next page
 - No need for a separate buffer to copy into

Currently, we store objects that split across pages as:

+-Page1-+
|	|
|	|
|-------| <-- obj-1 off: 0
|<ob1'>	|
+-------+ <-- obj-1 off: s'

+-Page2-+ <-- obj-1 off: s'
|<ob1''>|
|-------| <-- obj-1 off: obj1_size, obj-2 off: 0
|<ob2>	|
|-------| <-- obj-2 off: obj2_size
+-------+

But now we would store it as:

+-Page1-+
|	|
|-------| <-- obj-1 off: s''
|	|
|<ob1'>	|
+-------+ <-- obj-1 off: obj1_size

+-Page2-+ <-- obj-1 off: 0
|<ob1''>|
|-------| <-- obj-1 off: s'', obj-2 off: 0
|<ob2>	|
|-------| <-- obj-2 off: obj2_size
+-------+

When object-1 (ob1) is to be mapped, part (size: s'-0) of object-2 will
be swapped with ob1'. This swapping can be done in-place using simple
xor swap algorithm. So, after swap, page-1 and page-2 will look like:

+-Page1-+
|	|
|-------| <-- obj-2 off: 0
|	|
|<ob2''>|
+-------+ <-- obj-2 off: (obj1_size - s'')

+-Page2-+ <-- obj-1 off: 0
|	|
|<ob1>	|
|-------| <-- obj-1 off: obj1_size, obj-2 off: (obj1_size - s'')
|<ob2'>	|
+-------+ <-- obj-2 off: obj2_size

Now obj-1 lies completely within page-2, so can be kmap'ed as usual. On
zs_unmap_object() we would just do the reverse and restore objects as in
figure-1.

We can reduce the overhead even further by removing the need to
"restore" the object. For this, we would have to remove the assumption
in zsmalloc that the spilled part begins at offset 0 in the next page.
Not sure how feasible this would be.

Note that doing this transform is always possible since we ensure that
an object can never exceed system page size.

Thanks,
Nitin


