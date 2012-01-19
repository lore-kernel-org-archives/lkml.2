Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719Ab2ASTGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 14:06:08 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52729 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485Ab2ASTGE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 14:06:04 -0500
MIME-Version: 1.0
In-Reply-To: <CALLzPKbeXN5gdngo8uYYU8mAow=XhrwBFBhKfG811f37BubQOg@mail.gmail.com>
References: <CALLzPKb6kimUjgj9qN9ehx8RO3-bXvGetFQgx48T1rMm22oD2g@mail.gmail.com>
 <CALLzPKbeXN5gdngo8uYYU8mAow=XhrwBFBhKfG811f37BubQOg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 19 Jan 2012 11:05:41 -0800
X-Google-Sender-Auth: 6G-lM434HpTE2rezK6YtNjpwWFE
Message-ID: <CA+55aFwwkjFsVuSZWgasN4e_d9suRV4Afr94NMvNt4R7Ej0gbw@mail.gmail.com>
Subject: Re: dmsetup fails on latest kernel
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 7:56 AM, Kasatkin, Dmitry
<dmitry.kasatkin@intel.com> wrote:
> On Thu, Jan 19, 2012 at 3:02 PM, Kasatkin, Dmitry
> <dmitry.kasatkin@intel.com> wrote:
>> Hi,
>>
>> (subject added)
>>
>> I rebased on the stop of latest mainline tree and now dmsetup fails...
>> It says: "Failed to create notification semaphore: Function not implemented".
>> I run strace and saw that dmsetup uses "semget" which returns -ENOSYS...
>>
>> It works on
>> 122804ecb59493fbb4d31b3ba9ac59faaf45276f
>>
>> but does not work on
>> ccb19d263fd1c9e34948e2158c53eacbff369344
>>
>> Any ideas?
>>
>> - Dmitry
>
> Hi,
>
> I have bisected the problem...
>
> It is introduced by this commit:
>
> 303395ac3bf3e2cb488435537d416bc840438fcb is the first bad commit
> commit 303395ac3bf3e2cb488435537d416bc840438fcb
> Author: H. Peter Anvin <hpa@linux.intel.com>
> Date:   Fri Nov 11 16:07:41 2011 -0800
>
>    x86: Generate system call tables and unistd_*.h from tables

Interesting. I just munged the old pre-merge

  arch/x86/kernel/syscall_table_32.S

and the new

  arch/x86/syscalls/syscall_32.tbl

with some trivial shell scripting, and they are definitely identical.

So the tables look like they match 1:1.

The compat tables match too, except the new list contains the entry
for bdflush (134), but that's a legacy thing that doesn't matter.

I wonder what else could be going on. Wrong number of system calls
check? Peter, any ideas?

                        Linus
