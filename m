Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab2LEXo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 18:44:27 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:53462 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab2LEXo0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 18:44:26 -0500
MIME-Version: 1.0
In-Reply-To: <50BF600A.1080006@arm.com>
References: <1354617854-25296-1-git-send-email-serban.constantinescu@arm.com>
	<1354617854-25296-2-git-send-email-serban.constantinescu@arm.com>
	<CAMP5Xgf-HC7Lk=mOE-7prksbOu886q2=YMC8PvS2vFu1L9D1ow@mail.gmail.com>
	<50BF600A.1080006@arm.com>
Date: Wed, 5 Dec 2012 15:44:24 -0800
Message-ID: <CAMP5Xgfv2JOFUSovmq6AJOhw5H4hNtpNvDyy6g83ymeuJFCUEQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] Staging: android: binder: Add support for 32bit
 binder calls in a 64bit kernel
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "ccross@android.com" <ccross@android.com>,
        "zach.pfeffer@linaro.org" <zach.pfeffer@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>,
        Dianne Hackborn <hackbod@android.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 5, 2012 at 6:54 AM, Serban Constantinescu
<serban.constantinescu@arm.com> wrote:
> On 05/12/12 00:26, Arve Hjønnevåg wrote:
>>
>> On Tue, Dec 4, 2012 at 2:44 AM, Serban Constantinescu
>> <serban.constantinescu@arm.com> wrote:
>>>
>>> Android's IPC, Binder, does not support calls from a 32-bit userspace
>>> in a 64 bit kernel. This patch adds support for syscalls coming from a
>>> 32-bit userspace in a 64-bit kernel.
>>>
>>
>> It also seems to remove support for 64-bit user-space in a 64 bit
>> kernel at the same time. While we have not started fixing this problem
>> yet, it is not clear that we want to go in this direction. If we want
>> to have any 64 bit user-space processes, the 32-bit processes need to
>> use 64 bit pointers when talking to other processes. It may make more
>> sense to change the user-space binder library to probe for needed
>> pointer size (either by adding an ioctl to the driver to return the
>> pointer size in an ioctl with a fixed size pointer or by calling
>> BINDER_VERSION with the two pointer sizes you support (assuming long
>> and void * are the same size)).
>>
>
> Thanks for the feedback! As described in my previous e-mail, since the
> binder uses 2 layer ioctl we can't know from the top of the ioctl
> handler what is the size of the incoming package. Therefore we can't
> have the same ioctl call servicing both 32bit requests and 64bit
> requests in a 64bit kernel. I consider that the way forward would be to
> support the existing 32bit user space in a 64bit kernel (allowing
> backwards compatibility and what this patch implements) and to extend
> the ioctl space with the needed functionality when and if we will get to
> 64bit Android. Please correct me if I am wrong.
>

I don't think there is a need to support the current 32 bit user space
code on a 64 bit kernel. Applications do not use the binder driver
directly. The code that packs the data to be sent to another process
and calls the binder ioctls is in a library. If we update the
user-space binder library, then it can use 64 bit compatible data in
both 64 bit and 32 bit processes.

If you disagree with this and think supporting the existing binder
library in a 32 bit user-space process on a 64 bit system is
worthwhile, then this needs to be done in a way that does not break 64
bit processes or updated 32 bit processes' ability to talk to 64 bit
processes.

>
>>> Most of the changes were applied to types that change sizes between
>>> 32 and 64 bit world. This will also fix some of the issues around
>>> checking the size of an incoming transaction package in the ioctl
>>> switch. Since  the transaction's ioctl number are generated using
>>> _IOC(dir,type,nr,size), a different userspace size will generate
>>> a different ioctl number, thus switching by _IOC_NR is a better
>>> solution.
>>>
>>
>> I don't understand this change. If you use _IOC_NR you lose the
>> protection that the _IOC macros added. If the size does not match you
>> still dereference the pointer using the size that the kernel has
>> (expect where you added a new size check to replace the one you
>> removed).
>>
>
> Take the following snippet as an example:
>>
>> static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned
>> long arg)
>>
>> unsigned int size = _IOC_SIZE(cmd);
>>
>> switch (cmd) {
>>       case BINDER_WRITE_READ: {
>>
>>           struct binder_write_read bwr;
>>           if (size != sizeof(struct binder_write_read)) {
>>               ret = -EINVAL;
>>               goto err;
>>           }
>
>
> since BINDER_WRITE_READ is defined as:
>
>
>> #define BINDER_WRITE_READ       _IOWR('b', 1, struct binder_write_read)
>
>
> the size checking done here is not of any use since a different size
> would fall in default.

I thought you added a size check, but it looks like you just activated
some currently unreachable code (which probably predates moving to the
_IOC macros). There are many more case statements that don't have
these redundant checks however. They have no size check after your
changes.

> Therefore I thought a nicer version would be to
> switch by the _IOC_NR() - in this case 1, but with the protection
> offered by dir - 'b'. Once again correct me if I am wrong.
>

How does that get you the dir and 'b' protection? You masked off
everything that is not in the NR bits. Why is is nicer? You did not
add any code to handle multiple sizes in the same case statements.

-- 
Arve Hjønnevåg
