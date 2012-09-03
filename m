Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab2ICPJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 11:09:28 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:36957 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266Ab2ICPJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 11:09:27 -0400
MIME-Version: 1.0
In-Reply-To: <1346656701.3061.8.camel@sauron.fi.intel.com>
References: <1346001700-26895-1-git-send-email-shijie8@gmail.com>
	<1346656701.3061.8.camel@sauron.fi.intel.com>
Date: Mon, 3 Sep 2012 11:09:26 -0400
Message-ID: <CAMiH66GX7h5tve9CLHzj8MMrUv90fL+4BWYPZ6KQkP5bbXY9ag@mail.gmail.com>
Subject: Re: [PATCH 1/3] mtd: cmdlinepart: make the partitions rule more strict
From: Huang Shijie <shijie8@gmail.com>
To: dedekind1@gmail.com
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, shmulik.ladkani@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 3, 2012 at 3:18 AM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> On Sun, 2012-08-26 at 13:21 -0400, Huang Shijie wrote:
>> + *
>> + * Note:
>> + * If you choose to set the @offset for the <partdef>, please set all
>> + * the partitions with the same syntax, such as:
>> + *     gpmi-nand:100m@0(boot),100m@100m(kernel),1g@200m(rootfs)
>> + *
>> + * Please do _NOT_ set the partitions like this:
>> + *     gpmi-nand:100m@0(boot),100m(kernel),1g@200m(rootfs)
>> + * The `kernel` partition does not set with the @offset, this is not permitted.
>>   */
>
> I guess it is indeed OK to sort the partitions, just makes things a lot
> simpler. But we probably then should also do the following:
>
> 1. Make sure there is only one partition without offset. If there are
> several - error out.

 Why allow `only one partition without offset`?

Take the following unsorted partitions as an example:
     #gpmi-nand:1g@200m(rootfs),100m(boot),100m@100m(kernel)

The current code will parses out the following partitions:
      rootfs: < size = 1g, offset=200m>
      boot:   < size = 100m, offset= OFFSET_CONTINOUS>
      kernel: <size = 100m, offset = 100m>

If we sort the partitions by the offset, we get the following result:
     "kernel" , "rootfs", "boot"

In actually, we expect the following result:
    "boot", "kernel", "rootfs"

What's your idea about this issue?
In my opinion, we should forbid the mixed type.

thanks
Huang Shijie







> 2. Check that partitions do not intersect - I did not notice that we do
> this in the code.
>
> So AFAICS, this patch is not needed and we better have the following
> patches:
>
> 1. Add sorting
> 2. Add a check that partitions do not overlap and there is only one
> offset-less partition.
>
> How does this sound?
>
> --
> Best Regards,
> Artem Bityutskiy
