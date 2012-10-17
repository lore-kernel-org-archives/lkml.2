Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab2JQIfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 04:35:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50222 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab2JQIfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 04:35:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jaegeuk Kim <jaegeuk.kim@gmail.com>
Subject: Re: [PATCH 11/16] f2fs: add inode operations for special inodes
Date: Wed, 17 Oct 2012 08:35:02 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        "'Changman Lee'" <cm224.lee@gmail.com>,
        "'Vyacheslav Dubeyko'" <slava@dubeyko.com>, viro@zeniv.linux.org.uk,
        "'Theodore Ts'o'" <tytso@mit.edu>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, chur.lee@samsung.com,
        cm224.lee@samsung.com, jooyoung.hwang@samsung.com
References: <001201cda2f1$633db960$29b92c20$%kim@samsung.com> <201210161614.15636.arnd@arndb.de> <1350423780.1958.86.camel@kjgkr>
In-Reply-To: <1350423780.1958.86.camel@kjgkr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201210170835.02902.arnd@arndb.de>
X-Provags-ID: V02:K0:PZ3DoxfNx4saXJxnJjxyh74227yUJN8ydDdPP9WCz9F
 0APAoXmdA/gJMYnWt4iggPFjyZ6URnD6KEx7DR3I8qCyI4U/iT
 fzYkuo2gK7NDQsfU8fQhN0bGVfNvBbYafsIQgF9fi9qwlSFDxL
 jyPMg2lVekJg6OvF8tKakiihM0+h6himJp20pkN/nVJW5Uqlz8
 5NHwtIVxeCowwAEyx6N15bmtWlqNpXW6PTRAdaOW7iGqaxM3ih
 CWRcis4Y3d6FSxBcKkeNuLrJtf0P4wedqVMz862nlR2H3cKzfI
 ZykmQx6ehmmTv2KD7NzznI7L1X3ugTaSwAaDwzRmPwh4QIiReb
 MuK4BcylqoWxDwATWzXk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 October 2012, Jaegeuk Kim wrote:
> 2012-10-16 (화), 16:14 +0000, Arnd Bergmann:
> > On Tuesday 16 October 2012, Jaegeuk Kim wrote:
> > For the lower bound, being able to support as little as 2 logs for
> > cheap hardware would be nice, but 4 logs is the important one.
> > 
> > 5 logs is probably not all that important, as long as you have the
> > choice between 4 and 6. If you implement three different ways, I
> > would prefer have the choice of 2/4/6 over 4/5/6 logs.
> 
> Ok, I'll try, but in the case of 2 logs, it may need to change recovery
> routines.

Ok, I see. If it needs any changes that require a lot of extra code or
if it would make the common (six logs) case less efficient, then
you should probably not do it.

> > I fear that this might not be good enough for a lot of cases when
> > the page sizes grow and there is no sufficient amount of nonvolatile
> > write cache in the device. I wonder whether there is something that can
> > be done to ensure we always write with a minimum alignment, and pad
> > out the data with zeroes if necessary in order to avoid getting into
> > garbage collection on devices that can't handle sub-page writes.
> 
> You're very familiar with flash. :)
> Yes, as the page size grows, the sub-page write issue is one of the
> most critical problems.
> I also thought this before, but I have not made a conclusion until now.
> Because, I don't know how to deal with this in other companies, but,
> I've seen that so many firmware developers in samsung have tried to
> reduce this overhead by adapting many schemes.
> I guess very cautiously that other companies also handle this well.
> Therefore, I keep a question whether file system should care about
> this perfectly or not.

My guess is that most devices would be able to handle this well enough
as long as the writes are only in the log areas, but some would fail
when there are cached sub-page writes by the time you update the metadata
in the beginning of the drive.

Besides the extreme case of getting into garbage collect when the device
runs out of nonvolatile cache to keep sub-pages, there is also the other
problem that it is always more efficient not to need the NV cache than
having to use it to do sub-page writes. This is especially true if the
NV cache is implemented as a log on a regular flash block. In those cases,
it would be better to pad the current write with zeroes to the next
page boundary and rely on garbage collection to do the compaction later.

As I mentioned before, my design avoided the problem by using larger
clusters to start with and then mitigating the space overhead from this
by allowing to put multiple inodes into a single cluster. The tradeoffs
from this are very different than what you have with a fixed 4KB block
size, and it's probably not worth redesigning f2fs to handle this on
such a global scale.

One thing that you can do though is pad each flash page with data from
garbage collection: There should basically always be data that needs
to be GC'd, and as soon as you have decided that you want to write
a block to a new location and the hardware requires that it writes
a block of data to pad the page, you might just as well send down that
block. In the opposite case where you have a full page worth of actual
data that needs to be written (e.g. for a sync()) and half a page
worth of data from garbage collection, you can decide not send the GC
data in order to stay inside on a page boundary.

Doing this systematically would allow using the eMMC-4.5 "large-unit"
context for all of the logs, which can be a significant performance
improvement, depending on the underlying implementation.

	Arnd
