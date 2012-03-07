Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab2CGLMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 06:12:51 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44216 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab2CGLMt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 06:12:49 -0500
MIME-Version: 1.0
In-Reply-To: <op.wasrgptm3l0zgt@mpn-glaptop>
References: <1331090098-25097-1-git-send-email-Barry.Song@csr.com> <op.wasrgptm3l0zgt@mpn-glaptop>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 7 Mar 2012 19:12:28 +0800
Message-ID: <CAGsJ_4ze8V0g0VKBKnfMeKoo_PBpEk86mB7-=L32A5jB65Qa0A@mail.gmail.com>
Subject: Re: [PATCH v3] MM: CMA: add a simple kernel module as the helper to
 test CMA
To: Michal Nazarewicz <mina86@mina86.com>
Cc: m.szyprowski@samsung.com, Barry Song <Barry.Song@csr.com>,
        workgroup.linux@csr.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Barry Song <Baohua.Song@csr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/7 Michal Nazarewicz <mina86@mina86.com>:
> Thanks!  Some minor comments, hopefully last ones:
>
>
> On Wed, 07 Mar 2012 04:14:58 +0100, Barry Song <Barry.Song@csr.com> wrote:
>>
>> +static ssize_t
>> +cma_test_read(struct file *file, char __user *buf, size_t count, loff_t
>> *ppos)
>> +{
>
>
> [...]
>
>
>> +       _dev_info(cma_dev, "free: CM virt: %p dma: %p size:%uK\n",
>
>
> This should read: “size: %zuK”.  “z” is the proper modifier to use for
> size_t type.

ok. thanks.

>
>
>> +               alloc->virt, (void *)alloc->dma, alloc->size / SZ_1K);
>> +       kfree(alloc);
>> +
>> +       return 0;
>> +}
>
>
>> +static ssize_t
>> +cma_test_write(struct file *file, const char __user *buf, size_t count,
>> loff_t *ppos)
>> +{
>> +       struct cma_allocation *alloc;
>> +       size_t size;
>> +       int ret;
>> +
>> +       ret = kstrtouint_from_user(buf, count, 0, &size);
>
>
> kstrtouint_from_user() expects pointer to unsigned int, size_t is not always
> unsigned int.  It may be unsigned long.  As such, size should be of type
> unsigned long and this line should use kstrtoulong_from_user().

it comes to a compiling warning, so re-define "size" to unsigned long:

cma_test_write(struct file *file, const char __user *buf, size_t
count, loff_t *ppos)
 {
        struct cma_allocation *alloc;
-       size_t size;
+       unsigned long size;
        int ret;

-       ret = kstrtouint_from_user(buf, count, 0, &size);
+       ret = kstrtoul_from_user(buf, count, 0, &size);
        if (ret)
                return ret;

@@ -86,8 +86,8 @@ cma_test_write(struct file *file, const char __user
*buf, size_t count, loff_t *
                &alloc->dma, GFP_KERNEL);

        if (alloc->virt) {
-               _dev_info(cma_dev, "alloc: virt: %p dma: %p size: %uK\n",
-                       alloc->virt, (void *)alloc->dma, size);
+               _dev_info(cma_dev, "alloc: virt: %p dma: %p size: %zuK\n",
+                       alloc->virt, (void *)alloc->dma, alloc->size / SZ_1K);

                spin_lock(&cma_lock);
                list_add_tail(&alloc->list, &cma_allocations);

>
> [...]
>
>
>> +       if (alloc->virt) {
>> +               _dev_info(cma_dev, "alloc: virt: %p dma: %p size: %uK\n",
>> +                       alloc->virt, (void *)alloc->dma, size);
>
>
> Like previously, this should be “size: %zuK”.
>
> [...]
>
>> +}
>
>
> --
> Best regards,                                         _     _
> .o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
> ..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
> ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--

-barry
