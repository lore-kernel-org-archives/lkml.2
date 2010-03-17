Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705Ab0CQDIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 23:08:37 -0400
Received: from mail-yw0-f201.google.com ([209.85.211.201]:51663 "EHLO
	mail-yw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab0CQDIg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 23:08:36 -0400
X-Greylist: delayed 461 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Mar 2010 23:08:36 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Q1ndb9ge2iMxGIjdRMoobrjU9BKRlGICaonByq2sQgRx04dmYCrKwYjJcM15qCE2a6
         uJpFqW4o75v93SFVnDcSMi/ZY7S4MgI6VaIYN0ycnH9ZTHyyGiKM7g2r7RAoVpQBZEls
         Z1lsT9pdjCPlnGdKx/vFiV0R24/GZXdXYiHZo=
MIME-Version: 1.0
In-Reply-To: <20100317024101.GH12369@dastard>
References: <20100316155350.GB18579@localhost.localdomain>
	 <20100317024101.GH12369@dastard>
Date: Wed, 17 Mar 2010 11:00:54 +0800
Message-ID: <628d1651003162000u537790b4k697a0112375649ef@mail.gmail.com>
Subject: Re: [PATCH] xfs: Fix integer overflow in fs/xfs/linux-2.6/xfs_ioctl*.c
From: wzt wzt <wzt.wzt@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
       aelder@sgi.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your help, i'll send a new patch soon.

On Wed, Mar 17, 2010 at 10:41 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Mar 16, 2010 at 11:53:50PM +0800, wzt.wzt@gmail.com wrote:
>> STATIC int
>> xfs_compat_attrmulti_by_handle(
>>         struct file                             *parfilp,
>>         void                                    __user *arg)
>> {
>> ...
>>         if (copy_from_user(&am_hreq, arg,
>>                            sizeof(compat_xfs_fsop_attrmulti_handlereq_t)))
>>                 return -XFS_ERROR(EFAULT);
>> ...
>>         error = E2BIG;
>>         /* Not check the am_hreq.opcount max value from userspace,
>>         m_hreq.opcount * sizeof(compat_xfs_attr_multiop_t) can make
>>         integer overflow, and the if condition can be bypass. Though,
>>         it can not make security problem, but fix it maybe better. */
>>         size = am_hreq.opcount * sizeof(compat_xfs_attr_multiop_t);
>>         if (!size || size > 16 * PAGE_SIZE)
>>                 goto out_dput;
>> ...
>> }
>
> This description could use a little work. ;)
>
> Perhaps something like:
>
> The am_hreq.opcount field in the xfs_attrmulti_by_handle() interface
> is not bounded correctly. The opcount is used to determine the size
> of the buffer required. The size is bounded, but can overflow and so
> the size checks may not be sufficient to catch invalid opcounts.
> Fix it by catching opcount values that would cause overflows before
> calculating the size.
>
>
>>
>> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>
>>
>> ---
>>  fs/xfs/linux-2.6/xfs_ioctl.c   |    4 ++++
>>  fs/xfs/linux-2.6/xfs_ioctl32.c |    4 ++++
>>  2 files changed, 8 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
>> index 4ea1ee1..b05b3b7 100644
>> --- a/fs/xfs/linux-2.6/xfs_ioctl.c
>> +++ b/fs/xfs/linux-2.6/xfs_ioctl.c
>> @@ -526,6 +526,10 @@ xfs_attrmulti_by_handle(
>>       if (copy_from_user(&am_hreq, arg, sizeof(xfs_fsop_attrmulti_handlereq_t)))
>>               return -XFS_ERROR(EFAULT);
>>
>> +     /* overflow check */
>> +     if (am_hreq.opcount >= INT_MAX / sizeof(xfs_attr_multiop_t))
>> +             return -ENOMEM;
>> +
>
> The code currently return E2BIG for an opcount that is too large.
> I think this should also return E2BIG rather then ENOMEM. Does that
> seem reasonable?
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
