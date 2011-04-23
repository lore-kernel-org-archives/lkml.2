Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab1DWLeB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 07:34:01 -0400
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:59742 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828Ab1DWLd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 07:33:59 -0400
Subject: Re: End of FAT directories
From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: dosfstools <daniel@debian.org>, mtools <Alain@linux.lu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <87bozxomqd.fsf@devron.myhome.or.jp>
References: <1303498136.8485.128.camel@localhost>
	 <87hb9qnho4.fsf@devron.myhome.or.jp> <1303509408.8485.146.camel@localhost>
	 <87bozxomqd.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 Apr 2011 13:38:31 +0200
Message-ID: <1303558711.8485.166.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-Originating-IP: 87.123.78.250
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, den 23.04.2011, 09:06 +0900 schrieb OGAWA Hirofumi:
> >  - terminate reading at the first zeroed entry
> This is acceptable (stop at zero is an simply optimization), and I'll
> just care about stability and cleanness about it.
OK, then I will dig out my patch for that.

> >  - making sure that if a zeroed entry gets populated, the next entry
> > gets zeroed unless we hit the end of the directory (deviating from
> > Windows behaviour, intentionally, to keep the filesystem consistent)>
> I.e. This is the out of specs anymore. Why can you say those are invalid
> entries even if Windows honors those entries?
My point is that creating a file on a consistent file system (i.e. one
where all cluster chains are referenced by exactly one visible directory
entry) should still result in a consistent file system. And by
"consistent" I mean any state windows chkdsk accepts.

> And the above is simulate Windows implementation over specs, why isn't
> here?
Wow, there actually *is* a formal specification for FAT? I am positively
surprised by that. I used to think that the "spec" for FAT is "do as DOS
does". On a quick google, I do find the MS EFI FAT32 specification,
which is obviuosly non-free. Is there anything else?

>  For overwriting the
> zeroed entry, why we have to check all entries until see next zeroed
> (yeah, now, we allowed the crappy data after zeroed)?
My point was not about checking all entries until the next zeroed entry,
which is overcomplicating stuff. I meant that if we hit the end (i.e.
the first zeroed entry) when searching for free slots, in that case we
just clear the one entry directly following the inserted entries. This
makes sure that no files magically appear. I *do* understand that they
also appear on Windows, though. My point about "modifying a FAT system
that passes MS chkdsk with Linux should result in a FAT system that
passes MS chkdsk" is in my eyes more important than "Windows damages a
file system it considers fine in this situation, so we should do the
same."

In the end, there are two valid interpretations on the problem at hand:
 - DOS/Windows is buggy in exposing the crap when filling the "hole",
which is proven by chkdsk not complaining about the garbage in the
directory, and we should not follow the bug in DOS/Windows
 - chkdsk is buggy in not complaining about trailing garbage in
directories, which are proven to be invalid by DOS/Windows messing up on
them, and we shouldn't complicate our FAT implementation by trying to
work around a bug in chkdsk.

Obviously, I tend to the first interpretation while you prefer the
second interpretation. As you are the maintainer, it looks like I have
to get away with that.

> My state is simple - the current implement should be fine.
> I.e. uninitialized directory is the simply bug.
For the uninitialized entries on Hi-MD media, I agree with you that
these are caused by a firmware bug of older Sony devices. And to support
these devices "good enough", the stop-at-zero would be enough.
Regretfully I don't know the history of the USB flash memory I recently
got where the root directory was ended by a single entry starting with a
NUL byte and containing valid entries past that. The experience with the
inconsistent behaviour of different tools on that flash memory made me
write the mail about the current state of the FAT implementation.

> > And for dosfsck to
> >  - terminate reading at the first zeroed entry
> >  - offer filling the remainder of a directory cluster with zero bytes.
> > Would this set of patches be acceptable?
> Sorry. I can't say about dosfsck, I'm not maintainer of it. Ideas,
> dosfstools maintainer?

I think the *most* important fact is to have at least dosfsck and linux
consistent about directories with trailing garbage. So I won't even try
to submit a patch to the Linux kernel that stops reading at the first
unused directory entry if dosfsck will not accept to stop reading at the
first unused directory entry.

Regards and thanks for discussing,
  Michael Karcher

