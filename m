Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab1DWNqO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 09:46:14 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:43847 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab1DWNqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 09:46:11 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Cc: dosfstools <daniel@debian.org>, mtools <Alain@linux.lu>,
        linux-kernel@vger.kernel.org
Subject: Re: End of FAT directories
References: <1303498136.8485.128.camel@localhost>
	<87hb9qnho4.fsf@devron.myhome.or.jp>
	<1303509408.8485.146.camel@localhost>
	<87bozxomqd.fsf@devron.myhome.or.jp>
	<1303558711.8485.166.camel@localhost>
Date: Sat, 23 Apr 2011 22:46:05 +0900
In-Reply-To: <1303558711.8485.166.camel@localhost> (Michael Karcher's message
	of "Sat, 23 Apr 2011 13:38:31 +0200")
Message-ID: <8762q5nkrm.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de> writes:

>> And the above is simulate Windows implementation over specs, why isn't
>> here?
> Wow, there actually *is* a formal specification for FAT? I am positively
> surprised by that. I used to think that the "spec" for FAT is "do as DOS
> does". On a quick google, I do find the MS EFI FAT32 specification,
> which is obviuosly non-free. Is there anything else?

I guess it is called fatgen.doc in past, but I'm not sure. I can't help
about what MS does.

>>  For overwriting the
>> zeroed entry, why we have to check all entries until see next zeroed
>> (yeah, now, we allowed the crappy data after zeroed)?
> My point was not about checking all entries until the next zeroed entry,
> which is overcomplicating stuff. I meant that if we hit the end (i.e.
> the first zeroed entry) when searching for free slots, in that case we
> just clear the one entry directly following the inserted entries. This
> makes sure that no files magically appear. I *do* understand that they
> also appear on Windows, though. My point about "modifying a FAT system
> that passes MS chkdsk with Linux should result in a FAT system that
> passes MS chkdsk" is in my eyes more important than "Windows damages a
> file system it considers fine in this situation, so we should do the
> same."

I'll call it - first step of in-kernel fsck.

> In the end, there are two valid interpretations on the problem at hand:
>  - DOS/Windows is buggy in exposing the crap when filling the "hole",
> which is proven by chkdsk not complaining about the garbage in the
> directory, and we should not follow the bug in DOS/Windows

First of all, the bug is non-initialized directory. That's all.

Yes, chkdsk should fix it. But, unfortunately chkdsk is not perfect, I
remember another breakage of chkdsk can't fix.

>  - chkdsk is buggy in not complaining about trailing garbage in
> directories, which are proven to be invalid by DOS/Windows messing up on
> them, and we shouldn't complicate our FAT implementation by trying to
> work around a bug in chkdsk.
>
> Obviously, I tend to the first interpretation while you prefer the
> second interpretation. As you are the maintainer, it looks like I have
> to get away with that.

Because fsck is the job of fsck. Furthermore, without interactivity,
fsck can't perfectly decide how to fix it actually (yes, it can guess,
but that's guess).

>> My state is simple - the current implement should be fine.
>> I.e. uninitialized directory is the simply bug.
> For the uninitialized entries on Hi-MD media, I agree with you that
> these are caused by a firmware bug of older Sony devices. And to support
> these devices "good enough", the stop-at-zero would be enough.
> Regretfully I don't know the history of the USB flash memory I recently
> got where the root directory was ended by a single entry starting with a
> NUL byte and containing valid entries past that. The experience with the
> inconsistent behaviour of different tools on that flash memory made me
> write the mail about the current state of the FAT implementation.

Yes, zero is the end of directory. It's right and said in the above
fatgen. Guys might misread - fatgen says the rest of entries must be
zero (i.e. it means initialized by zero). Or some spec (I know there is
the FS spec in SD specs, I can't recall the detail though) may not
mention about latter part, I don't know.

> I think the *most* important fact is to have at least dosfsck and linux
> consistent about directories with trailing garbage. So I won't even try
> to submit a patch to the Linux kernel that stops reading at the first
> unused directory entry if dosfsck will not accept to stop reading at the
> first unused directory entry.

OK. I think "stop at zero" is not effected by dosfsck though. With "stop
at zero", linux will do like windows does, but crap data is already
showed in current implementation.

Whether dosfsck can fix it or not would be another story. Of course, I
hope it does though.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
