Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab2EILBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 07:01:33 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:49682 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756711Ab2EILBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 07:01:31 -0400
Message-ID: <4FAA4E85.6020305@mev.co.uk>
Date: Wed, 9 May 2012 12:01:25 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120414 Thunderbird/11.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: comedi: remove __user annotation inside of struct's
References: <201205081641.00358.hartleys@visionengravers.com> <ADE657CA350FB648AAC2C43247A983F0020698A1774D@AUSP01VMBX24.collaborationhost.net> <4FAA44D7.1040209@mev.co.uk> <20120509103111.GR22134@mwanda>
In-Reply-To: <20120509103111.GR22134@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-09 11:31, Dan Carpenter wrote:
> On Wed, May 09, 2012 at 11:20:07AM +0100, Ian Abbott wrote:
>> On 2012-05-09 00:55, H Hartley Sweeten wrote:
>>> On Tuesday, May 08, 2012 4:41 PM, H Hartley Sweeten wrote:
>>>>
>>>> The structs' comedi_insn, coomedi_insnlist, comedi_cmd,
>>>> comedi_chaninfo, and comedi_rangeinfo are all passed to
>>>> the kernel from user space using ioctl commands. They
>>>> are then copied to kernel space using copy_from_user()
>>>> before the data is passed to the drivers.
>>>>
>>>> The __user annotation should not be used with variables
>>>> inside the struct. This produces a lot of sparse warnings
>>>> like:
>>>>
>>>> warning: dereference of noderef expression
>>>>
>>>> Note: This patch exposes some new warnings about different
>>>> address space. These will be addressed.
>>>
>>> Please ignore this patch.
>>>
>>> It appears the annotations in the struct definitions are correct.
>>
>> Personally, I think you were on the mark with the patch.  It's
>> better to avoid using __user in comedi.h so it can be used as-is in
>> user-space.
>
> Sparse is useful so we shouldn't break it.  I always run sparse over
> my patches before submission and look at the warnings.  Except if
> they scroll off the page.  In that case, I just figure that the
> author deserves the bugs.
>
> We could just do some ifdeferry to fix it for userspace.

That doesn't help in cases such as 'struct comedi_insn' where the 'data' 
pointer is a user-space pointer in the user-space copy of the object and 
a kernel-space pointer in the kernel-space copy of the object.  The only 
fix for that is to have separate "k" versions of the struct or to do a 
load of casting, which is slightly error-prone and makes the code less 
readable.

Are there any handy macros for casting pointers to __user pointers, 
something like

#define _user(p) ((typeof(*(p)) __user *)(p))

but preferably without the repeated expansion of 'p' in case of 
side-effects?

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
