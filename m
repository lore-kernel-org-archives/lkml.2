Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab1GBIKr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 04:10:47 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:54206 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab1GBIKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 04:10:44 -0400
Message-ID: <4E0ED11A.6030905@gmail.com>
Date: Sat, 02 Jul 2011 10:04:42 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Sergiu Iordache <sergiu@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] char drivers: ramoops record_size module parameter
References: <1309483720-1407-1-git-send-email-sergiu@chromium.org> <1309483720-1407-3-git-send-email-sergiu@chromium.org> <4E0E0A76.4080204@gmail.com> <BANLkTi=HqKggFkcLgN22qgTr5drz3_5vO+Q9bM+NqsOYVK5uag@mail.gmail.com>
In-Reply-To: <BANLkTi=HqKggFkcLgN22qgTr5drz3_5vO+Q9bM+NqsOYVK5uag@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 01/07/2011 20:41, Sergiu Iordache ha scritto:
> On Fri, Jul 1, 2011 at 10:57 AM, Marco Stornelli
> <marco.stornelli@gmail.com>  wrote:
>> Hi,
>>
>> Il 01/07/2011 03:28, Sergiu Iordache ha scritto:
>>>
>>> The size of the dump is currently set using the RECORD_SIZE macro which
>>> is set to a page size. This patch makes the record size a module
>>> parameter and allows it to be set through platform data as well to allow
>>> larger dumps if needed.
>>>
>>> Signed-off-by: Sergiu Iordache<sergiu@chromium.org>
>>> Change-Id: Ie5a53acb50d5881d51354f5d9d13e3d6bedf6a2e
>>> ---
>>> The patch was built on the 2.6.38 kernel and is based on the following
>>> patches which were applied from the mmotm tree:
>>> ramoops-add-new-line-to-each-print
>>> ramoops-use-module-parameters-instead-of-platform-data-if-not-available
>>>
>>> ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes
>>>
>>>   drivers/char/ramoops.c  |   33 ++++++++++++++++++++++++++-------
>>>   include/linux/ramoops.h |    1 +
>>>   2 files changed, 27 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
>>> index 5349d94..f34077e 100644
>>> --- a/drivers/char/ramoops.c
>>> +++ b/drivers/char/ramoops.c
>>> @@ -32,8 +32,12 @@
>>>   #include<linux/ramoops.h>
>>>
>>>   #define RAMOOPS_KERNMSG_HDR "===="
>>> +#define MIN_MEM_SIZE 4096UL
>>>
>>> -#define RECORD_SIZE 4096UL
>>> +static ulong record_size = 4096UL;
>>> +module_param(record_size, ulong, 0400);
>>> +MODULE_PARM_DESC(record_size,
>>> +               "size of each dump done on oops/panic");
>>>
>>>   static ulong mem_address;
>>>   module_param(mem_address, ulong, 0400);
>>> @@ -55,6 +59,7 @@ static struct ramoops_context {
>>>         void *virt_addr;
>>>         phys_addr_t phys_addr;
>>>         unsigned long size;
>>> +       unsigned long record_size;
>>>         int dump_oops;
>>>         int count;
>>>         int max_count;
>>> @@ -84,10 +89,10 @@ static void ramoops_do_dump(struct kmsg_dumper
>>> *dumper,
>>>         if (reason == KMSG_DUMP_OOPS&&    !cxt->dump_oops)
>>>                 return;
>>>
>>> -       buf = cxt->virt_addr + (cxt->count * RECORD_SIZE);
>>> +       buf = cxt->virt_addr + (cxt->count * cxt->record_size);
>>>         buf_orig = buf;
>>>
>>> -       memset(buf, '\0', RECORD_SIZE);
>>> +       memset(buf, '\0', cxt->record_size);
>>>         res = sprintf(buf, "%s", RAMOOPS_KERNMSG_HDR);
>>>         buf += res;
>>>         do_gettimeofday(&timestamp);
>>> @@ -95,8 +100,8 @@ static void ramoops_do_dump(struct kmsg_dumper *dumper,
>>>         buf += res;
>>>
>>>         hdr_size = buf - buf_orig;
>>> -       l2_cpy = min(l2, RECORD_SIZE - hdr_size);
>>> -       l1_cpy = min(l1, RECORD_SIZE - hdr_size - l2_cpy);
>>> +       l2_cpy = min(l2, cxt->record_size - hdr_size);
>>> +       l1_cpy = min(l1, cxt->record_size - hdr_size - l2_cpy);
>>>
>>>         s2_start = l2 - l2_cpy;
>>>         s1_start = l1 - l1_cpy;
>>> @@ -119,16 +124,29 @@ static int __init ramoops_probe(struct
>>> platform_device *pdev)
>>>         }
>>>
>>>         rounddown_pow_of_two(pdata->mem_size);
>>> +       rounddown_pow_of_two(pdata->record_size);
>>>
>>> -       if (pdata->mem_size<    RECORD_SIZE) {
>>> +       /* Check for the minimum memory size */
>>> +       if (pdata->mem_size<    MIN_MEM_SIZE) {
>>> +               pr_err("memory size too small, min %lu\n", MIN_MEM_SIZE);
>>> +               goto fail3;
>>> +       }
>>> +
>>> +       if (pdata->mem_size<    pdata->record_size) {
>>>                 pr_err("size too small\n");
>>>                 goto fail3;
>>>         }
>>>
>>> -       cxt->max_count = pdata->mem_size / RECORD_SIZE;
>>> +       if (pdata->record_size<= 0) {
>>> +               pr_err("record size too small\n");
>>> +               goto fail3;
>>> +       }
>>
>> There is something wrong here. First of all if record_size is unsigned it
>> can't negative. In addition, if we are here, we know that:
>>
>> record_size>= mem_size>= MIN_MEM_SIZE
>>
>> So this check have no sense.
>
> The pdata->record size<= 0 check is indeed redundant and should be removed.
>
> I didn't completely understand the second comment, the module errors
> if mem_size<  MIN_MEM_SIZE or mem_size<  record_size, which means that
> mem_size should be larger than MIN_MEM_SIZE and record_size (which
> leads to record_size being between 0 and mem_size). Am I missing
> something?
>
> (Resent after not reply-ing to all by mistake)
>
> Sergiu
>

Yes, my fault. I meant we should check that mem_size *and* record_size 
are bigger or equals than MIN_MEM_SIZE. After that, we can check that 
record_size is lesser than mem_size (I guess has no sense to use 
record_size lesser than MIN_MEM_SIZE).

Marco
