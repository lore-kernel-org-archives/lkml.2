Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab2LEOaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 09:30:52 -0500
Received: from service88.mimecast.com ([195.130.217.12]:38745 "EHLO
	service88.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2LEOav convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 09:30:51 -0500
Message-ID: <50BF5AA6.5080103@arm.com>
Date: Wed, 5 Dec 2012 14:31:02 +0000
From: Serban Constantinescu <serban.constantinescu@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arve@android.com" <arve@android.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "ccross@android.com" <ccross@android.com>,
        "zach.pfeffer@linaro.org" <zach.pfeffer@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "arve@android.com" <arve@android.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 1/2] Staging: android: binder: Add support for 32bit binder
 calls in a 64bit kernel
References: <1354617854-25296-1-git-send-email-serban.constantinescu@arm.com> <1354617854-25296-2-git-send-email-serban.constantinescu@arm.com> <20121204161756.GB17860@kroah.com>
In-Reply-To: <20121204161756.GB17860@kroah.com>
X-MC-Unique: 112120514304903802
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/12 16:17, Greg KH wrote:
> On Tue, Dec 04, 2012 at 10:44:13AM +0000, Serban Constantinescu wrote:
>> Android's IPC, Binder, does not support calls from a 32-bit userspace
>> in a 64 bit kernel. This patch adds support for syscalls coming from a
>> 32-bit userspace in a 64-bit kernel.
>>
>> Most of the changes were applied to types that change sizes between
>> 32 and 64 bit world. This will also fix some of the issues around
>> checking the size of an incoming transaction package in the ioctl
>> switch. Since  the transaction's ioctl number are generated using
>> _IOC(dir,type,nr,size), a different userspace size will generate
>> a different ioctl number, thus switching by _IOC_NR is a better
>> solution.
>>
>> The patch has been successfully tested on ARMv8 AEM and Versatile
>> Express V2P-CA9.
>
> Has it also been properly tested on a 32bit kernel and userspace to
> verify that nothing broke?

We have tested this patch set with a 32-bit kernel (on a Versatile
Express platform with an 4xA9 (ARMv7a)) as well as a 64-bit kernel (on
ARMv8 simulation platform). For both test cases we used the same 32-bit
Android file system (ICS, JB). Both platforms have been running browser
loads for days without any problems. We are currently extending the test
cases by running Android CTS test.

>
> I was wondering when someone would notice that this code was not going
> to work for this type of system, nice to see that you are working to fix
> it up.  But, I'll reask Dan's question here, why not use the compat32
> ioctl interface instead?  Shouldn't that be the easier way to do this?

Binder uses a 2 layer ioctl structure i.e. you can't know from the top
of the ioctl handler the size of the incoming package. Therefore adding
a wrapper for a 64bit kernel is not an option. Should a 64bit Android
ever appear we would probably want to support 32bit legacy applications.
For this we will need the same binder/ashmem driver to service both a
32bit application as well as a 64bit application in a 64bit kernel.
Therefore I guess the way forward will be to support 32bit file systems
in a 64bit kernel without any change to the existing user space
(implemented in this patch) and at some point extend the ioctl range
with the needed functionality for 64bit user space.

>
> Also, one meta comment, never use the uint32_t types, use the native
> kernel types (u32 and the like.)  If you are crossing the user/kernel
> boundry, use the other correct types for those data structures (__u32
> and the like).  What you did here is mix and match things so much that I
> really can't verify that it is all correct.

I have tried to in-line my changes with the types already used in the
driver but I will update to using the suggested types.

>
> thanks,
>
> greg k-h
>

Thanks for the feedback,
Serban Constantinescu
`

-- IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium.  Thank you.

