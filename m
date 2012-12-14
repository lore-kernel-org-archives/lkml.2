Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab2LNAgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 19:36:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41255 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755594Ab2LNAgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 19:36:47 -0500
Message-ID: <50CA7486.2070804@zytor.com>
Date: Thu, 13 Dec 2012 16:36:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
        x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org
Subject: Re: [PATCH] Add VDSO time function support for x86 32-bit kernel
References: <1355343572-23074-1-git-send-email-stefani@seibold.net> <50C9148C.4040308@zytor.com> <1355378005.24283.11.camel@wall-e> <1d3061cb-76d0-4e42-9b75-a975b05384ec@email.android.com> <1355379433.24701.1.camel@wall-e> <f984cb31-baa5-4176-8e85-37266e2cfb8d@email.android.com> <1355383038.18653.2.camel@wall-e> <CALCETrWmYpEh9pLiohF+yu9FnrVfSNdHB_TQOKL6+LkdTF+cVw@mail.gmail.com> <50CA6E4C.6000305@zytor.com> <CALCETrV1kvhOvDpzTavGb1X9HT+PdEPXJ0H8afs7jzxpcF7Kjg@mail.gmail.com>
In-Reply-To: <CALCETrV1kvhOvDpzTavGb1X9HT+PdEPXJ0H8afs7jzxpcF7Kjg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 04:20 PM, Andy Lutomirski wrote:
>>
>> Whatever data you need you can just map it into the vdso range.  There
>> really shouldn't be anything special about that at all.
>>
>> The fixmap stuff is an x86-64 legacy that you don't have to worry about,
>> obviously.
>
> The fixmap page is new.  It's not ABI -- the layout can freely change,
> but the vdso needs to be able to see.  It would make no sense to cow
> that page, and it would be more complicated to make it be part of the
> (64-bit) vdso, so I left it as a fixmap when I did the vvar cleanups.
>

Well, the vsyscall fixmap is an ABI.  But just because a page is mapped 
into userspace doesn't mean cow.  Think of it as a device mmap, or an 
mmap of a shared file.

> For compat mode, though, I don't think it can be in the fixmap unless
> there are segmentation games that I think are impossible, or unless
> the vdso wants to do a far call (which I would guess is not much
> faster than a system call, although I haven't benchmarked it).  This
> is because there are no addresses at all that can be seen from 32-bit
> code segments and that are in the kernel address range.

Yes, you'd have to nip into 64-bit mode which is not really practical.

> What you could do is probably arrange (using some linker script magic)
> for a symbol to exist that points at the page *before* the vdso
> starts.  Then just map the vvar page there when starting a compat
> task.  You could then address it using a normal symbol reference by
> tweaking the vvar macro.  (I think this'll access it via the GOT.)
> Alternatively, you could just pick an absolute address -- the page is
> NX, so you don't really need to worry about randomization.

IMO it seems this is making it way more complicated than it is.  Just 
make sure you have a section in the vdso where you can map in a data 
page with the symbols in the right offsets.  Extra points for doing 
magic so that it is at the beginning or end, but I think that might be 
harder than necessary.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

