Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab2HCK3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 06:29:06 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:63220 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750794Ab2HCK3C convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 06:29:02 -0400
MIME-Version: 1.0
In-Reply-To: <1343980862.1772.211.camel@thor.local>
References: <1343977571-2292-1-git-send-email-chenhc@lemote.com>
	<1343977571-2292-12-git-send-email-chenhc@lemote.com>
	<1343980862.1772.211.camel@thor.local>
Date: Fri, 3 Aug 2012 18:29:00 +0800
Message-ID: <CAAhV-H6+D6zOr6FsBz9P30ojZoq9bwyFf8RLB=nXV7npcqawWA@mail.gmail.com>
Subject: Re: [PATCH V4 11/16] drm/radeon: Make radeon card usable for Loongson.
From: Huacai Chen <chenhuacai@gmail.com>
To: =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        Zhangjin Wu <wuzhangjin@gmail.com>, Hua Yan <yanh@lemote.com>,
        Fuxin Zhang <zhangfx@lemote.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Hongliang Tao <taohl@lemote.com>,
        Huacai Chen <chenhc@lemote.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, I'll split it.

On Fri, Aug 3, 2012 at 4:01 PM, Michel Dänzer <michel@daenzer.net> wrote:
> On Fre, 2012-08-03 at 15:06 +0800, Huacai Chen wrote:
>> 1, Handle io prot correctly for MIPS.
>> 2, Define SAREA_MAX as the size of one page.
>> 3, Include swiotlb.h if SWIOTLB configured.
>>
>> Signed-off-by: Huacai Chen <chenhc@lemote.com>
>> Signed-off-by: Hongliang Tao <taohl@lemote.com>
>> Signed-off-by: Hua Yan <yanh@lemote.com>
>> Cc: dri-devel@lists.freedesktop.org
>> ---
>>  drivers/gpu/drm/drm_vm.c            |    2 +-
>>  drivers/gpu/drm/radeon/radeon_ttm.c |    4 ++++
>>  drivers/gpu/drm/ttm/ttm_bo_util.c   |    2 +-
>>  include/drm/drm_sarea.h             |    2 ++
>>  4 files changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/drm_vm.c b/drivers/gpu/drm/drm_vm.c
>> index 961ee08..3f06166 100644
>> --- a/drivers/gpu/drm/drm_vm.c
>> +++ b/drivers/gpu/drm/drm_vm.c
>> @@ -62,7 +62,7 @@ static pgprot_t drm_io_prot(uint32_t map_type, struct vm_area_struct *vma)
>>               tmp = pgprot_writecombine(tmp);
>>       else
>>               tmp = pgprot_noncached(tmp);
>> -#elif defined(__sparc__) || defined(__arm__)
>> +#elif defined(__sparc__) || defined(__arm__) || defined(__mips__)
>>       tmp = pgprot_noncached(tmp);
>>  #endif
>>       return tmp;
>> diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
>> index 5b71c71..fc3ac22 100644
>> --- a/drivers/gpu/drm/radeon/radeon_ttm.c
>> +++ b/drivers/gpu/drm/radeon/radeon_ttm.c
>> @@ -41,6 +41,10 @@
>>  #include "radeon_reg.h"
>>  #include "radeon.h"
>>
>> +#ifdef CONFIG_SWIOTLB
>> +#include <linux/swiotlb.h>
>> +#endif
>> +
>>  #define DRM_FILE_PAGE_OFFSET (0x100000000ULL >> PAGE_SHIFT)
>>
>>  static int radeon_ttm_debugfs_init(struct radeon_device *rdev);
>> diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
>> index f8187ea..0df71ea 100644
>> --- a/drivers/gpu/drm/ttm/ttm_bo_util.c
>> +++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
>> @@ -472,7 +472,7 @@ pgprot_t ttm_io_prot(uint32_t caching_flags, pgprot_t tmp)
>>       else
>>               tmp = pgprot_noncached(tmp);
>>  #endif
>> -#if defined(__sparc__)
>> +#if defined(__sparc__) || defined(__mips__)
>>       if (!(caching_flags & TTM_PL_FLAG_CACHED))
>>               tmp = pgprot_noncached(tmp);
>>  #endif
>> diff --git a/include/drm/drm_sarea.h b/include/drm/drm_sarea.h
>> index ee5389d..1d1a858 100644
>> --- a/include/drm/drm_sarea.h
>> +++ b/include/drm/drm_sarea.h
>> @@ -37,6 +37,8 @@
>>  /* SAREA area needs to be at least a page */
>>  #if defined(__alpha__)
>>  #define SAREA_MAX                       0x2000U
>> +#elif defined(__mips__)
>> +#define SAREA_MAX                       0x4000U
>>  #elif defined(__ia64__)
>>  #define SAREA_MAX                       0x10000U     /* 64kB */
>>  #else
>
> This should be four separate patches.
>
>
> --
> Earthling Michel Dänzer           |                   http://www.amd.com
> Libre software enthusiast         |          Debian, X and DRI developer
