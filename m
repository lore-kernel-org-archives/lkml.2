Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab0EKXzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 19:55:41 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:37116 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab0EKXzj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 19:55:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VSagnLWq7I4eFz24qdXkhibsBAtJdc3iAi1NExpKtg7ouzhyaeXHrBzojPJavKumob
         Iw5WUT822bDmEMaT1GVbI7JpsaPVPqYTHcnTkbeo1o1d/BSD3Uegn7auJc93pBpAS5gr
         XUlGNJxNChzR6nYNj98rHqWmyilR2H2b66158=
MIME-Version: 1.0
In-Reply-To: <201004230717.07086.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1003032142580.6963-100000@netrider.rowland.org>
	 <20100304201548.GA1341@elf.ucw.cz>
	 <y2yf383264b1004221640rd1fca614zfa15d7e7984ab3ba@mail.gmail.com>
	 <201004230717.07086.rjw@sisk.pl>
Date: Tue, 11 May 2010 16:55:38 -0700
Message-ID: <AANLkTikH7DvizJ9340SiksoIWU5KU2n-OCqWc4f_-z9v@mail.gmail.com>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while 
	userspace is frozen?
From: Matt Reimer <mattjreimer@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 10:17 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday 23 April 2010, Matt Reimer wrote:
>> On Thu, Mar 4, 2010 at 1:15 PM, Pavel Machek <pavel@ucw.cz> wrote:
>> > Hi!
>> >
>> >> > My thought exactly.  This is the only approach that also solves the
>> >> > following race:
>> >> >
>> >> >     A driver is unloaded at the same time as a suspend starts.
>> >> >
>> >> >     The writeback thread gets frozen.
>> >> >
>> >> >     Then before the rmmod thread is frozen, it calls del_gendisk.
>> >> >
>> >> > Delaying things by means of a workqueue (or the equivalent) might also
>> >> > work, but it doesn't seem as safe.  For example, some important
>> >> > writebacks might end up getting delayed until too late.
>> >
>> > Delaying writebacks during sleep should be ok... That's why we do
>> > sync() after userspace is frozen -- nothing really important should be
>> > waiting for writeback after that point.
>>
>> Has this been fixed,
>
> No, it hasn't.
>
>> or has a consensus about how to fix this been
>> achieved? I'm hitting the same problem and have some time to work on a
>> fix.
>
> Generally, it looks like del_gendisk should thaw writeback threads, but not
> during suspend, only during resume.

Thawing the writeback thread only during resume does fix the case
Maxim originally presented:

0. build kernel with CONFIG_MMC_UNSAFE_RESUME
1. insert SD card
2. suspend
3. remove SD card while suspended
4. resume from suspend hangs

But if CONFIG_MMC_UNSAFE_RESUME is not set, the kernel oopses during
suspend because the MMC device suspend times out:

mmc0: card e624 removed
**** DPM device timeout: pxa2xx-mci.0 (pxa2xx-mci)
kernel BUG at /home/mreimer/sdg/android/android-2.1/kernel/drivers/base/power/main.c:453!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c0004000
[00000000] *pgd=00000000
Internal error: Oops: 817 [#1] PREEMPT

If I thaw the writeback thread unconditionally in del_gendisk() then
suspend and resume work as expected for both CONFIG_MMC_UNSAFE_RESUME
set/not set, even when the card is removed while suspended.

So what is the proper fix?

Matt
