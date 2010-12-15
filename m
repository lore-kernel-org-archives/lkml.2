Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab0LOBzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 20:55:13 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:61624 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab0LOBzL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 20:55:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MF/L/GPuPaJTHxbSDLOGsBK8AuCOzHSHF0Csp4Tri3xOhaI63gh9YfujWkxNQXVCxD
         dH3rnIQKzAs67OFLpjUPfXMYksaWdTYD3sgTEZTfL4Iscza4XyeqBau4grhyMdnzZMYm
         HWafTYn/K0uGRWjxEs49bvGc3ZwrS6SoAeOgk=
MIME-Version: 1.0
In-Reply-To: <1292340409.2538.40.camel@localhost>
References: <1290156045-11719-1-git-send-email-r64343@freescale.com>
	<1292340409.2538.40.camel@localhost>
Date: Wed, 15 Dec 2010 09:55:08 +0800
Message-ID: <AANLkTi=zB7UBjkvGYv_wdwZpH1Ghatn6eye1z5616h4X@mail.gmail.com>
Subject: Re: [PATCH 1/1] mtd: nand: add check for out of page read
From: Jason Liu <liu.h.jason@gmail.com>
To: dedekind1@gmail.com
Cc: Jason Liu <r64343@freescale.com>, David.Woodhouse@intel.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Artem,

2010/12/14 Artem Bityutskiy <dedekind1@gmail.com>:
> On Fri, 2010-11-19 at 16:40 +0800, Jason Liu wrote:
>> When run mtd_oobtest case, there will be one error for step(4),
>> which turned out it need add one check for out of page read in
>> nand_do_read_oob just like mtd_do_write_oob did it already.
>> This commit also fix one typo error for comments in mtd_do_write_oob
>>
>> Signed-off-by: Jason Liu <r64343@freescale.com>
>
> I cannot reproduce this with nandsim, can you?
>
> I tried:
>
> 1. sudo modprobe nandsim
> š sudo modprobe mtd_oobtest dev=0
>
> 2. sudo ./load_nandsim.sh 128 128 2048
> š sudo modprobe mtd_oobtest dev=0
>
> In both cases the test passes: "mtd_oobtest: finished with 0 errors"
>
> And in 'nand_do_read_oob()' I see the following piece of code:
>
> š š š š/* Do not allow reads past end of device */
> š š š šif (unlikely(from >= mtd->size ||
> š š š š š š š š š š ops->ooboffs + readlen > ((mtd->size >> chip->page_shift) -
> š š š š š š š š š š š š š š š š š š š š(from >> chip->page_shift)) * len)) {
> š š š š š š š šDEBUG(MTD_DEBUG_LEVEL0, "%s: Attempt read beyond end "
> š š š š š š š š š š š š š š š š š š š š"of device\n", __func__);
> š š š š š š š šreturn -EINVAL;
> š š š š}

Here the mtd->size in nand_base.c should be the NAND flash chip size,
while in nand_oobtest,

              /* Attempt to read off end of device */
                ops.mode      = MTD_OOB_AUTO;
                ops.len       = 0;
                ops.retlen    = 0;
                ops.ooblen    = mtd->ecclayout->oobavail;
                ops.oobretlen = 0;
                ops.ooboffs   = 1;
                ops.datbuf    = NULL;
                ops.oobbuf    = readbuf;
                printk(PRINT_PREF "attempting to read past end of device\n");
                printk(PRINT_PREF "an error is expected...\n");
                err = mtd->read_oob(mtd, mtd->size - mtd->writesize, &ops);
                if (err) {
                        printk(PRINT_PREF "error occurred as expected\n");
                        err = 0;
                } else {
                        printk(PRINT_PREF "error: read past end of device\n");
                        errcnt += 1;
                }
        }

here, mtd->size is mtd partition size right? when the mtd partition is
not the last MTD partition, the error will happen.

I have tested on real NAND, while not on nandsim.

>
> which should handle the case AFAICS.
>
> So, although I did think hard about this, it looks like there is no
> problem. What is the kernel version you are looking at? I checked it
> with my l2-mtd-2.6.git, which is the latest mtd-2.6.git plus a revert
> commit of your patch:
>
> http://git.infradead.org/users/dedekind/l2-mtd-2.6.git

Yes, as I have written the email to you before in a private email to
tell that this patch has issue and please drop it.

Thanks,

>
> --
> Best Regards,
> Artem Bityutskiy (áÒÔ£Í âÉÔÀÃËÉÊ)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at šhttp://vger.kernel.org/majordomo-info.html
> Please read the FAQ at šhttp://www.tux.org/lkml/
>
