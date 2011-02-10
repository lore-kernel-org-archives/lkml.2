Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045Ab1BJV1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 16:27:44 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:53414 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab1BJV1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 16:27:42 -0500
Message-ID: <4D545812.9050801@oracle.com>
Date: Thu, 10 Feb 2011 13:26:42 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Nitin Gupta <ngupta@vflare.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Allow sharing xvmalloc for zram and zcache
References: <1297371646-11604-1-git-send-email-ngupta@vflare.org> <4D5453CB.7050206@oracle.com> <4D5454CC.1000609@vflare.org> <4D5455CD.3000507@oracle.com> <4D5456AD.5010703@vflare.org>
In-Reply-To: <4D5456AD.5010703@vflare.org>
Content-Type: multipart/mixed;
 boundary="------------020207040302050900010607"
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D545842.0004:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020207040302050900010607
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 02/10/11 13:20, Nitin Gupta wrote:
> On 02/11/2011 02:47 AM, Randy Dunlap wrote:
>> On 02/10/11 13:12, Nitin Gupta wrote:
>>> On 02/11/2011 02:38 AM, Randy Dunlap wrote:
>>>> On 02/10/11 13:00, Nitin Gupta wrote:
>>>>> Both zram and zcache use xvmalloc allocator. If xvmalloc
>>>>> is compiled separately for both of them, we will get linker
>>>>> error if they are both selected as "built-in". We can also
>>>>> get linker error regarding missing xvmalloc symbols if zram
>>>>> is not built.
>>>>>
>>>>> So, we now compile xvmalloc separately and export its symbols
>>>>> which are then used by both of zram and zcache.
>>>>>
>>>>> Signed-off-by: Nitin Gupta<ngupta@vflare.org>
>>>>
>>>> Acked-by: Randy Dunlap<randy.dunlap@oracle.com>
>>>>
>>>>
>>>> but what does this patch apply to?  It does not apply cleanly to
>>>> linux-next of 20110210.
>>>>
>>>
>>> This applies to staging-2.6. I thought linux-next won't be that
>>> different so as to produce conflicts. Can you please send reject files,
>>> or let me fetch linux-next tree and will soon post patch against the
>>> same.
>>
>> I'll let you fetch linux-next.  I merged it by hand and test-built it
>> successfully.
>>
> 
> So, can you post the patch against linux-next then? :)


it's attached since I don't trust thunderbird.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

--------------020207040302050900010607
Content-Type: text/x-patch;
 name="xvmalloc-sharing.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xvmalloc-sharing.patch"

Both zram and zcache use xvmalloc allocator. If xvmalloc
is compiled separately for both of them, we will get linker
error if they are both selected as "built-in". We can also
get linker error regarding missing xvmalloc symbols if zram
is not built.

So, we now compile xvmalloc separately and export its symbols
which are then used by both of zram and zcache.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 drivers/staging/Makefile        |    1 +
 drivers/staging/zcache/Makefile |    4 +++-
 drivers/staging/zram/Kconfig    |    5 +++++
 drivers/staging/zram/Makefile   |    3 ++-
 drivers/staging/zram/xvmalloc.c |    8 ++++++++
 5 files changed, 19 insertions(+), 2 deletions(-)

--- linux-next-20110210.orig/drivers/staging/Makefile
+++ linux-next-20110210/drivers/staging/Makefile
@@ -46,6 +46,7 @@ obj-$(CONFIG_DX_SEP)            += sep/
 obj-$(CONFIG_IIO)		+= iio/
 obj-$(CONFIG_CS5535_GPIO)	+= cs5535_gpio/
 obj-$(CONFIG_ZRAM)		+= zram/
+obj-$(CONFIG_XVMALLOC)		+= zram/
 obj-$(CONFIG_ZCACHE)		+= zcache/
 obj-$(CONFIG_WLAGS49_H2)	+= wlags49_h2/
 obj-$(CONFIG_WLAGS49_H25)	+= wlags49_h25/
--- linux-next-20110210.orig/drivers/staging/zcache/Makefile
+++ linux-next-20110210/drivers/staging/zcache/Makefile
@@ -1 +1,3 @@
-obj-$(CONFIG_ZCACHE)	+=	zcache.o tmem.o
+zcache-y	:=	tmem.o
+
+obj-$(CONFIG_ZCACHE)	+=	zcache.o
--- linux-next-20110210.orig/drivers/staging/zram/Kconfig
+++ linux-next-20110210/drivers/staging/zram/Kconfig
@@ -1,6 +1,11 @@
+config XVMALLOC
+	bool
+	default n
+
 config ZRAM
 	tristate "Compressed RAM block device support"
 	depends on BLOCK && SYSFS
+	select XVMALLOC
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
 	default n
--- linux-next-20110210.orig/drivers/staging/zram/Makefile
+++ linux-next-20110210/drivers/staging/zram/Makefile
@@ -1,3 +1,4 @@
-zram-y	:=	zram_drv.o zram_sysfs.o xvmalloc.o
+zram-y	:=	zram_drv.o zram_sysfs.o
 
 obj-$(CONFIG_ZRAM)	+=	zram.o
+obj-$(CONFIG_XVMALLOC)	+=	xvmalloc.o
\ No newline at end of file
--- linux-next-20110210.orig/drivers/staging/zram/xvmalloc.c
+++ linux-next-20110210/drivers/staging/zram/xvmalloc.c
@@ -14,6 +14,8 @@
 #define DEBUG
 #endif
 
+#include <linux/module.h>
+#include <linux/kernel.h>
 #include <linux/bitops.h>
 #include <linux/errno.h>
 #include <linux/highmem.h>
@@ -315,11 +317,13 @@ struct xv_pool *xv_create_pool(void)
 
 	return pool;
 }
+EXPORT_SYMBOL_GPL(xv_create_pool);
 
 void xv_destroy_pool(struct xv_pool *pool)
 {
 	kfree(pool);
 }
+EXPORT_SYMBOL_GPL(xv_destroy_pool);
 
 /**
  * xv_malloc - Allocate block of given size from pool.
@@ -408,6 +412,7 @@ int xv_malloc(struct xv_pool *pool, u32 
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(xv_malloc);
 
 /*
  * Free block identified with <page, offset>
@@ -484,6 +489,7 @@ void xv_free(struct xv_pool *pool, struc
 	put_ptr_atomic(page_start, KM_USER0);
 	spin_unlock(&pool->lock);
 }
+EXPORT_SYMBOL_GPL(xv_free);
 
 u32 xv_get_object_size(void *obj)
 {
@@ -492,6 +498,7 @@ u32 xv_get_object_size(void *obj)
 	blk = (struct block_header *)((char *)(obj) - XV_ALIGN);
 	return blk->size;
 }
+EXPORT_SYMBOL_GPL(xv_get_object_size);
 
 /*
  * Returns total memory used by allocator (userdata + metadata)
@@ -500,3 +507,4 @@ u64 xv_get_total_size_bytes(struct xv_po
 {
 	return pool->total_pages << PAGE_SHIFT;
 }
+EXPORT_SYMBOL_GPL(xv_get_total_size_bytes);

--------------020207040302050900010607--
