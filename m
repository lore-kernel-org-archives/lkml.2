Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab2BGCse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 21:48:34 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:41783 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755447Ab2BGCsd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 21:48:33 -0500
MIME-Version: 1.0
In-Reply-To: <CAMO-S2hCjvcDHheVETr5=+0Ks+G+NyYvr3mnxUV8jQSKzEgVGA@mail.gmail.com>
References: <20120121082857.GC32134@elte.hu>
	<CAMO-S2hq0jGeUdAzMizDOhYJvPSQ=8+HVTUVqzsBOJotxOWrUg@mail.gmail.com>
	<20120121165830.GA9216@elte.hu>
	<CAMO-S2iegkRWGcnDt0SZqJT3Y3JHQZcHfMY=THKMN7n4Ae0Fyw@mail.gmail.com>
	<CA+55aFz=KcR5ji3TBHyfAYxFg8PCjXbdLOWf7aXULYHW4pp2kg@mail.gmail.com>
	<CAMO-S2iRT+uRzzsQRmhhCs4WRefsfFirteeKXtgX3h+kuWi+eQ@mail.gmail.com>
	<CA+55aFyxbieV2-WpFNrEtwQ6gXbW7y_X9oW5N6FcEcxmQKA38g@mail.gmail.com>
	<20120131115855.5861bad7@pyramind.ukuu.org.uk>
	<20120131120922.GD32010@elte.hu>
	<20120131121820.58a1db97@pyramind.ukuu.org.uk>
	<20120131122339.GG32010@elte.hu>
	<CA+55aFw4F-02NxbQHmpy0KtXxKc9++HutgVXd7nGe0G7NqG+Gw@mail.gmail.com>
	<1328144756.2768.57.camel@dabdike.int.hansenpartnership.com>
	<CAMO-S2hCjvcDHheVETr5=+0Ks+G+NyYvr3mnxUV8jQSKzEgVGA@mail.gmail.com>
Date: Tue, 7 Feb 2012 11:48:32 +0900
Message-ID: <CAMO-S2i=DoYz93Ooebx0fyxcbqGqbcdcF9_GFrEor5DcscCXSA@mail.gmail.com>
Subject: Re: [PATCH] NVMe: Fix compilation on architecturs without readq/writeq
From: Hitoshi Mitake <h.mitake@gmail.com>
To: James Bottomley <jbottomley@parallels.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Roland Dreier <roland@purestorage.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 5, 2012 at 00:34, Hitoshi Mitake <h.mitake@gmail.com> wrote:
> On Thu, Feb 2, 2012 at 10:05, James Bottomley <jbottomley@parallels.com> wrote:
>> On Wed, 2012-02-01 at 15:35 -0800, Linus Torvalds wrote:
>>> On Tue, Jan 31, 2012 at 4:23 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>> >
>>> > non-atomic sounds good to me too.
>>>
>>> You both apparently missed the related discussion that some devices
>>> really do care about order, even if they don't care about atomicity.
>>>
>>> So we'd actually have two versions of the header file, one
>>> little-endian, and one big-endian. Then the driver that knows it
>>> doesn't need the atomic 'readq()' that is always defined, but wants a
>>> low-bytes-first version would just do
>>>
>>>    #include <linux/io64-little-endian.h>
>>>
>>> (or "big-endian" if it wants to read/write high bits first). Most
>>> drivers probably don't care, but apparently NVMe does.
>>
>> And this was about the point I concluded last time that it simply wasn't
>> worth it with the number of different possibilities for the primitives
>> and trying to come up with a sensible naming scheme ... it's just easier
>> to open code because then you get exactly what you meant.
>>
>> Incidentally, the last time this came up was with mpt fusion: for a
>> write to a 64 bit register, it didn't care about order, but it did care
>> about interleaving as in if you write one half of a 64 bit register and
>> then write to another register, the 64 bit register effectively gets
>> written with zeros in the part you didn't write to, so we had to put a
>> spin lock in the open coded writeb/w/l/q() to make sure the card didn't
>> get interleaved writes.
>>
>> James
>>
>
> As you say, readq/writeq without any description about the semantics
> of atomicity will cause confusion in such a case.
>
> But new plan for non-atomic readq/writeq is defining non-atomic readq/writeq
> in the header file like asm-generic/io-nonatomic-hi-lo.h, and the file name
> is a good documentation for the description.
>
> The drivers which use readq/writeq without the line like
> #include <asm-generic/io-nonatomic-hi-lo.h>
> will cause compile error in the 32-bit environment.
>
> --
> Hitoshi Mitake
> h.mitake@gmail.com

I sent the patch which implements readq/writeq in the way.
If you have comments, I'd like to hear.

Thanks,

-- 
Hitoshi Mitake
h.mitake@gmail.com
