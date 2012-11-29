Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab2K2OS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 09:18:58 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:46962 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562Ab2K2OSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 09:18:55 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <CAPXgP11wq+u8JuBhOAYWKrwVp-c-aiJ18RgnghHPCMs-1MJWKg@mail.gmail.com>
References: <1336004953.4240.9.camel@mop> <CAHO5Pa2_D_L6wKPWccaYH2BYWYFc=4Khe0Om5GWU3D-tcAH0OQ@mail.gmail.com>
 <CAPXgP12jXOJzTTgwQkm7XK_ig2iEKAbhgNkF+MRR6_S49Tqx_A@mail.gmail.com>
 <CA+55aFxVyqScRU_c6RWVVub-tteuwjSq5JmThUtoxU-arBuh1w@mail.gmail.com>
 <CAPXgP11teRC8bFNzF2NHJ78Bj-jf0fgRz++5vjeHVEHY=+Xe+A@mail.gmail.com>
 <1354125084.20578.1.camel@nja> <CAKgNAkiFKPf44Q+X76TSGbR2LuyrFSWP7FLq_YdD8Twd2_25Ew@mail.gmail.com>
 <CAPXgP10OW_XuPMHn=KQzaESfpNhehkUx6=hKL2dHdGytZkGmng@mail.gmail.com>
 <CAKgNAkhQuugAOChSroXFgSPQ_=zyfFOZHzL3PGfU2SdmJcmj4w@mail.gmail.com> <CAPXgP11wq+u8JuBhOAYWKrwVp-c-aiJ18RgnghHPCMs-1MJWKg@mail.gmail.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Thu, 29 Nov 2012 15:18:34 +0100
Message-ID: <CAKgNAkhtTUAB82eBp5yABJL3ZfQ0=Q4y=CuJA-O98WYEHc2G0Q@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Kay Sievers <kay@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartmann <greg@kroah.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 3:08 PM, Kay Sievers <kay@vrfy.org> wrote:
> On Thu, Nov 29, 2012 at 2:37 PM, Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
>> On Thu, Nov 29, 2012 at 2:28 PM, Kay Sievers <kay@vrfy.org> wrote:
>>> On Thu, Nov 29, 2012 at 2:18 PM, Michael Kerrisk (man-pages)
>>> <mtk.manpages@gmail.com> wrote:
>>>> On Wed, Nov 28, 2012 at 6:51 PM, Kay Sievers <kay@vrfy.org> wrote:
>>>
>>>>> Before:
>>>>>   syslog(SYSLOG_ACTION_SIZE_UNREAD, 0, 0) = 286965
>>>>>   syslog(SYSLOG_ACTION_READ_CLEAR, "<12>"..., 1000000) = 24000
>>>>>   syslog(SYSLOG_ACTION_SIZE_UNREAD, 0, 0) = 286965
>>>>>
>>>>> After:
>>>>>   syslog(SYSLOG_ACTION_SIZE_UNREAD, 0, 0) = 90402
>>>>>   syslog(SYSLOG_ACTION_READ_CLEAR, "<5>"..., 1000000) = 90402
>>>>>   syslog(SYSLOG_ACTION_SIZE_UNREAD, 0, 0) = 0
>>>
>>>> I'm going to call my report yesterday bogus. Somewhere along the way,
>>>> I got confused while testing something, and my statement about 2.6.31
>>>> behavior is wrong: the 2.6.31 and 3.5 behaviors are the same. As such,
>>>> your patch is unneeded. Sorry for wasting your time.
>>>
>>> I think you have been right with your report. The above pasted
>>> before/after from the patch commit text is actually a result of real
>>> testing with current git. And your initial description sounds right,
>>> and the patch seems to produce the expected results here. I just
>>> confused the numbers in your report and wrongly parsed 2.6 > 3.6.
>>>
>>> Hmm, at least do far we did not blame anybody else than ourselves as
>>> confused. One of us at least is right, and it looks you have been, and
>>> I also think the patch is at least intended to be right. :)
>>
>> Okay -- I'm pretty sure I am right about being wrong ;-).
>>
>> Could you do some comparative testing please between 3.5 and pre-3.5.
>> I have a little test program below. When I rechecked 2.6.31 and 3.5
>> using this program I found the behavior was the same, which is why I
>> conclude my report is wrong. (And also, your proposed patch in
>> response to my bogus report produces different behavior from 2.6.31).
>
> Oh, seems you are right.
>
> The old kernel does not return 0, while it probably should. The
> current kernel seems to do the same thing.
>
> But the behaviour with the patch stills seems like the better and the
> obvious and expected behaviour to me. :)

The point here I think is that the semantics of the various syslog()
commands are surprising, which is what led me into some confusion in
testing. Essentially, command 5 ("clear ring buffer") does not really
clear anything, it simply sets bookkeeping variables that affect the
behavior of commands 3 and 4. Of particular note is that command 5
does NOT affect commands 2 and 9, and command 9 is only returning the
number of bytes that would be read by command 2. The man page could do
with some improvement (and will get it).

So, just to be clear: you better not apply your patch; it might break
something ;-).

Cheers,

Michael
