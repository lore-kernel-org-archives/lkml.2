Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab2KYAFF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 19:05:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43568 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab2KYAFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 19:05:03 -0500
Message-ID: <50B16080.7040809@zytor.com>
Date: Sat, 24 Nov 2012 16:04:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Rob Landley <rob@landley.net>, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v3 11/12] x86, boot: add fields to support load bzImage
 and ramdisk high
References: <1353482170-10160-1-git-send-email-yinghai@kernel.org> <1353482170-10160-12-git-send-email-yinghai@kernel.org> <50AD0CA1.8000904@zytor.com> <CAE9FiQUSjRT-r5ZE3WHVaKkUOhwFWkm9CTCv1Aa63DOsfMQMiQ@mail.gmail.com> <50AD291A.10600@zytor.com> <CAE9FiQVed0tXhbtmc_Gug0gFZ=s=j=N4B5Vr2_ZTmSj6L-65dw@mail.gmail.com> <a1ca794a-09d4-4d36-8c8c-67100cb3696e@email.android.com> <CAE9FiQXJO8uxT9Gzjv9e8XeiLzwBX7fwTFzDVy=oPfboG4L=3Q@mail.gmail.com> <CAE9FiQWeGz2TkLBrBZcoPrNABx51XK3xk58P+Zam_LRGoJdSiw@mail.gmail.com> <a8b15bf0-4e3b-4fde-9190-26890f9abf77@email.android.com> <CAE9FiQUoj9k0Tbqp8LC8Wb21_s_x8naiWX4zkX9pJG-oFnAQ9g@mail.gmail.com> <50AE70E7.6060204@zytor.com> <87haofi3d3.fsf@xmission.com> <50B104BC.90208@zytor.com> <50B124E9.400@zytor.com> <87vccud0i5.fsf@xmission.com>
In-Reply-To: <87vccud0i5.fsf@xmission.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2012 03:50 PM, Eric W. Biederman wrote:
>
> It was conservative at the time the code was introduced and it most
> definitely is not wrong.  The code predates the verbage in boot.txt.
> Apparently no one bothered to see what /sbin/kexec was actually doing
> when they documented the 32bit boot loader interface.  I was under the
> impression that it was actual practice that was documented but in this
> particular something else was documented instead.  Since /sbin/kexec did
> not need any of the more recent features we simply have not noticed it
> until now.
>

The problem is that kexec and others didn't follow any protocol at all, 
but rather did something that happened to work... but could trivially be 
shown had no way of being forward compatible.

>>> We could work around it with a sentinel hack... except you *also*
>>> probably modify *some* fields and now we have a horrid mix of
>>> initialized and uninitialized fields to sort out... and there really
>>> isn't any sane way for the kernel to sort that out.
>>>
>>> We have a huge problem on our hands now because of it.
>>
>> So, given the mess we now have on our hands... any suggestions how to best solve
>> it?  There is the option of simply declaring old kexec binaries broken; they
>> will then not work reliably with newer kernels, if they even work reliably now
>> -- it is hard to know for certain.
>
> I believe all added variables between the last version of the boot
> protocol /sbin/kexec knows about and the current time were added in the
> initialized data section.  Certainly we can check and that will tell us
> how likely changes in arch/x86/boot/ have been regressions in the 32bit
> entry point support.
>
> As for solving this there is a simple solution.  Add a second jump
> right after the first jump.   The variables after the second jump can
> all be zero initialized.

It doesn't work for the variables *before* the initialized section, and 
that is actually where we have most problems... there really are only 
very few bytes left after the initialized section.  The reason we can't 
do anything about the area before it is because that has to have stuff 
in it, like the EFI header, to work.

> And if we really care about breaking other boot loaders we can take a
> survey and actually look and see what they do.  There really aren't that
> many x86 boot loaders.

There are more than you think... a lot of them are hiding in grotty 
corners.  However, they are minority users.

It sounds like we are leaning toward some form of the sentinel hack, 
which means we need an enumerated list of things that should *not* be 
zeroed if the sentinel is present.

The option of declaring the list frozen makes me a bit nervous, because 
it isn't clear that we don't already have fields that will be 
misinterpreted by the kernel if filled in from the file.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

