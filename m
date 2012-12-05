Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab2LEOxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 09:53:51 -0500
Received: from service87.mimecast.com ([91.220.42.44]:60884 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab2LEOxu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 09:53:50 -0500
Message-ID: <50BF600A.1080006@arm.com>
Date: Wed, 5 Dec 2012 14:54:02 +0000
From: Serban Constantinescu <serban.constantinescu@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: =?windows-1252?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "ccross@android.com" <ccross@android.com>,
        "zach.pfeffer@linaro.org" <zach.pfeffer@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>,
        Dianne Hackborn <hackbod@android.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/2] Staging: android: binder: Add support for 32bit binder
 calls in a 64bit kernel
References: <1354617854-25296-1-git-send-email-serban.constantinescu@arm.com> <1354617854-25296-2-git-send-email-serban.constantinescu@arm.com> <CAMP5Xgf-HC7Lk=mOE-7prksbOu886q2=YMC8PvS2vFu1L9D1ow@mail.gmail.com>
In-Reply-To: <CAMP5Xgf-HC7Lk=mOE-7prksbOu886q2=YMC8PvS2vFu1L9D1ow@mail.gmail.com>
X-MC-Unique: 112120514534813901
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/12 00:26, Arve Hjønnevåg wrote:
> On Tue, Dec 4, 2012 at 2:44 AM, Serban Constantinescu
> <serban.constantinescu@arm.com> wrote:
>> Android's IPC, Binder, does not support calls from a 32-bit userspace
>> in a 64 bit kernel. This patch adds support for syscalls coming from a
>> 32-bit userspace in a 64-bit kernel.
>>
>
> It also seems to remove support for 64-bit user-space in a 64 bit
> kernel at the same time. While we have not started fixing this problem
> yet, it is not clear that we want to go in this direction. If we want
> to have any 64 bit user-space processes, the 32-bit processes need to
> use 64 bit pointers when talking to other processes. It may make more
> sense to change the user-space binder library to probe for needed
> pointer size (either by adding an ioctl to the driver to return the
> pointer size in an ioctl with a fixed size pointer or by calling
> BINDER_VERSION with the two pointer sizes you support (assuming long
> and void * are the same size)).
>

Thanks for the feedback! As described in my previous e-mail, since the
binder uses 2 layer ioctl we can't know from the top of the ioctl
handler what is the size of the incoming package. Therefore we can't
have the same ioctl call servicing both 32bit requests and 64bit
requests in a 64bit kernel. I consider that the way forward would be to
support the existing 32bit user space in a 64bit kernel (allowing
backwards compatibility and what this patch implements) and to extend
the ioctl space with the needed functionality when and if we will get to
64bit Android. Please correct me if I am wrong.

>> Most of the changes were applied to types that change sizes between
>> 32 and 64 bit world. This will also fix some of the issues around
>> checking the size of an incoming transaction package in the ioctl
>> switch. Since  the transaction's ioctl number are generated using
>> _IOC(dir,type,nr,size), a different userspace size will generate
>> a different ioctl number, thus switching by _IOC_NR is a better
>> solution.
>>
>
> I don't understand this change. If you use _IOC_NR you lose the
> protection that the _IOC macros added. If the size does not match you
> still dereference the pointer using the size that the kernel has
> (expect where you added a new size check to replace the one you
> removed).
>

Take the following snippet as an example:
> static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>
> unsigned int size = _IOC_SIZE(cmd);
>
> switch (cmd) {
>       case BINDER_WRITE_READ: {
>           struct binder_write_read bwr;
>           if (size != sizeof(struct binder_write_read)) {
>               ret = -EINVAL;
>               goto err;
>           }

since BINDER_WRITE_READ is defined as:

> #define BINDER_WRITE_READ       _IOWR('b', 1, struct binder_write_read)

the size checking done here is not of any use since a different size
would fall in default. Therefore I thought a nicer version would be to
switch by the _IOC_NR() - in this case 1, but with the protection
offered by dir - 'b'. Once again correct me if I am wrong.


Kind regards,
Serban Constantinescu
`

-- IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium.  Thank you.

