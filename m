Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab2LEOZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 09:25:18 -0500
Received: from service87.mimecast.com ([91.220.42.44]:55189 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab2LEOZQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 09:25:16 -0500
Message-ID: <50BF5959.2060209@arm.com>
Date: Wed, 5 Dec 2012 14:25:29 +0000
From: Serban Constantinescu <serban.constantinescu@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arve@android.com" <arve@android.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "ccross@android.com" <ccross@android.com>,
        "zach.pfeffer@linaro.org" <zach.pfeffer@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>, gregkh@linuxfoundation.org,
        arve@android.com
Subject: Re: [PATCH 2/2] Staging: android: ashmem: Add support for 32bit ashmem
 calls in a 64bit kernel
References: <1354617854-25296-1-git-send-email-serban.constantinescu@arm.com> <1354617854-25296-3-git-send-email-serban.constantinescu@arm.com> <20121204114511.GI6568@mwanda>
In-Reply-To: <20121204114511.GI6568@mwanda>
X-MC-Unique: 112120514251400201
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/12 11:45, Dan Carpenter wrote:
> I don't understand this, and I'm going to embarrass myself by
> displaying my ignorance for all to see.  Why is this code so
> different from all the other 32 bit compat code that we have in the
> kernel?
>
> On Tue, Dec 04, 2012 at 10:44:14AM +0000, Serban Constantinescu wrote:
>> -static int set_name(struct ashmem_area *asma, void __user *name)
>> +static int set_name(struct ashmem_area *asma, userptr32_t name)
>
> The user passes in a value which is a 32 pointer.  ashmem_ioctl()
> accepts it as "unsigned long arg".  We pass it to set_name() which
> truncates away the high zeros so now its a u32 (userptr32_t).  We
> then cast it to (unsigned long) and then we cast it to a void
> pointer.
>
> What's the point?  Why not just take"unsigned long arg" and cast it
> to a pointer directly?
>
>>      if (unlikely(copy_from_user(asma->name + ASHMEM_NAME_PREFIX_LEN,
>> -                                name, ASHMEM_NAME_LEN)))
>> +                                (void *)(unsigned long)name, ASHMEM_NAME_LEN)))
>>              ret = -EFAULT;
>
> This will introduce a Sparse complaint.  It should be:
>                               (void __user *)(unsigned long)name.

Thanks for taking your time and reviewing this patch set. I have put
together a new version of this patch (ashmem) and I will resend it to
LKML as soon as I finish testing on both 32 and 64 bit platforms.

>
> But actually we shouldn't need to do this casting.  Any casting
> which we need to do should be done in one place instead of pushed
> out to every function.
>
>> +    switch (_IOC_NR(cmd)) {
>> +    case _IOC_NR(ASHMEM_SET_NAME):
>> +            if (_IOC_SIZE(cmd) != sizeof(char[ASHMEM_NAME_LEN]))
>> +                    pr_err("ashmem: ASHMEM_SET_NAME transaction size differs\n");
>
> Don't merge debug code into the kernel.  It just means people can
> spam /var/log/messages.

I see what you mean. I won't include those in the new patch set.

>
> regards,
> dan carpenter
>
>

Kind regards,
Serban Constantinescu
`

-- IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium.  Thank you.

