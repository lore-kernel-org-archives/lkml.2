Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966979Ab2ERDrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:47:40 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:34067 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760223Ab2ERDri convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 23:47:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAMe9rOprvq3awrunB+HDW=sHb6VNvfB=PGDAP7Fj_NOx3KQU7g@mail.gmail.com>
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
	<1337292816-10839-9-git-send-email-hjl.tools@gmail.com>
	<4FB58EFD.7010302@zytor.com>
	<4FB5C050.9070805@kernel.org>
	<CAMe9rOrKq8Ait8wKudRF535J5c=dDTKekmUN_=HOs5BBLtsoGQ@mail.gmail.com>
	<CAMe9rOprvq3awrunB+HDW=sHb6VNvfB=PGDAP7Fj_NOx3KQU7g@mail.gmail.com>
Date: Thu, 17 May 2012 20:47:37 -0700
Message-ID: <CAMe9rOo-g+RomUQziagrGUZKwZJwkQ3uRW0Tk3bH9uaxv5ejbw@mail.gmail.com>
Subject: Re: [PATCH 08/10] Use __kernel_ulong_t in struct msqid64_ds
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        torvalds@linux-foundation.org, mingo@kernel.org, tglx@linutronix.de,
        Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 8:43 PM, H.J. Lu <hjl.tools@gmail.com> wrote:
> On Thu, May 17, 2012 at 8:39 PM, H.J. Lu <hjl.tools@gmail.com> wrote:
>> On Thu, May 17, 2012 at 8:21 PM, H. Peter Anvin <hpa@kernel.org> wrote:
>>> On 05/17/2012 04:51 PM, H. Peter Anvin wrote:
>>>>
>>>> This patch and the one before it seems to have another problem: we
>>>> currently define __BITS_PER_LONG as:
>>>>
>>>> #ifdef __x86_64__
>>>> # define __BITS_PER_LONG 64
>>>> #else
>>>> # define __BITS_PER_LONG 32
>>>> #endif
>>>>
>>>
>>> H.J., do you see any problem *other* than this wretched struct
>>> msqid64_ds with changing the above from __x86_64__ to
>>>
>>> #if defined(__x86_64__) && !defined(__ILP32__)
>>>
>>> ... in the above?
>>>
>>> As far as struct msqid64_ds,  I think we can fix it simply because x86
>>> is the only compat-aware architecture which has to deal with it.
>>>
>>> (Incidentally, if sh is ever expanded to 64 bits, it will have a problem
>>> in the bigendian configuration...)
>>
>> That will be wrong.   __BITS_PER_LONG defines # bits of long
>> as seen by kernel.  We don't use it in user space.  Remember
>> x32 uses the identical interface as x86-64.  So
>>
>> #ifdef __x86_64__
>> # define __BITS_PER_LONG 64
>> #else
>> # define __BITS_PER_LONG 32
>> #endif
>>
>> struct msqid64_ds {
>>        struct ipc64_perm msg_perm;
>>        __kernel_time_t msg_stime;      /* last msgsnd time */
>> #if __BITS_PER_LONG != 64
>>        unsigned long   __unused1;
>> #endif
>>        __kernel_time_t msg_rtime;      /* last msgrcv time */
>> #if __BITS_PER_LONG != 64
>>        unsigned long   __unused2;
>> #endif
>>        __kernel_time_t msg_ctime;      /* last change time */
>> #if __BITS_PER_LONG != 64
>>        unsigned long   __unused3;
>> #endif
>>
>> are absolutely correct for x32.  You can think
>>
>> #if __BITS_PER_LONG != 64
>>
>> as
>>
>> #ifndef __x86_64__
>>
>> which is used in glibc.
>>
>
> Now I remembered.  Here is another patch.  Here
>
> #if __BITS_PER_LONG == 64
>
> means
>
> #ifdef __x86_64__
>
> Change  __BITS_PER_LONG to __BITS_PER_LONG_AS_SEEN_BY_KERNEL
> may avoid this confusion.
>

Or __BITS_PER_NATURAL_WORD.

-- 
H.J.
