Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab2LOM7t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 07:59:49 -0500
Received: from mx1.fusionio.com ([66.114.96.30]:35903 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756393Ab2LOM7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 07:59:48 -0500
X-ASG-Debug-ID: 1355576386-03d6a559e0928920001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <50CC743E.6040307@fusionio.com>
Date: Sat, 15 Dec 2012 13:59:42 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Kent Overstreet <koverstreet@google.com>
CC: Jack Wang <jack.wang.usish@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "zab@redhat.com" <zab@redhat.com>, "bcrl@kvack.org" <bcrl@kvack.org>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 00/26] AIO performance improvements/cleanups, v2
References: <1354568322-29029-1-git-send-email-koverstreet@google.com> <20121213211808.GJ25017@kernel.dk> <CA+res+SKXjXTgrxPaj+kuekd-CZMp4POkSpsdJ7Csfg0HsD=bA@mail.gmail.com> <50CAD6D9.5070703@fusionio.com> <20121215092526.GA10411@moria.home.lan> <50CC46F8.3070600@fusionio.com> <20121215103658.GB10411@moria.home.lan>
X-ASG-Orig-Subj: Re: [PATCH 00/26] AIO performance improvements/cleanups, v2
In-Reply-To: <20121215103658.GB10411@moria.home.lan>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1355576386
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.117082
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-15 11:36, Kent Overstreet wrote:
> On Sat, Dec 15, 2012 at 10:46:32AM +0100, Jens Axboe wrote:
>> On 2012-12-15 10:25, Kent Overstreet wrote:
>>> Cool, thanks for the numbers!
>>>
>>> I suspect the difference is due to contention on the ringbuffer,
>>> completion side. You didn't enable my batched completion stuff, did you?
>>
>> No, haven't tried the batching yet.
>>
>>> I suspect the numbers would look quite a bit different with that,
>>> based on my own profiling. If the driver for the device you're testing
>>> on is open source, I'd be happy to do the conversion (it's a 5 minute
>>> job).
>>
>> Knock yourself out - I already took a quick look at it, and conversion
>> should be pretty simple. It's the mtip32xx driver, it's in the kernel. I
>> would suggest getting rid of the ->async_callback() (since it's always
>> bio_endio()) since that'll make it cleaner.
> 
> Just pushed my conversion - it's untested, but it's pretty
> straightforward.

Let me give it a whirl. It'll likely improve the situation, since we are
CPU limited at this point. I will definitely add the batching on my side
too, it's a clear win for the (usual) case of reaping multiple
completion events per IRQ.

>>> since I looked at your patch but you're getting rid of the aio
>>> ringbuffer and using a linked list instead, right? My batched completion
>>> stuff should still benefit that case.
>>
>> Yes, I make the ring interface optional. Basically you tell aio to use
>> the ring or not at io_queue_init() time. If you don't care about the
>> ring, we can use a lockless list for the completions.
> 
> Yeah, it is a good idea - I'm certainly not attached to the current
> ringbuffer implementation (though a ringbuffer isn't a terrible idea if
> we had one that was implemented correctly).

I agree, ringbuffer isn't necessarily a bad interface. But the fact is
that:

1) Current ringbuffer is broken
2) And nobody uses it

So as an interface, I think it's dead.

>> You completely remove the cancel, I just make it optional for the gadget
>> case. I'm fine with either of them, though I did not look at your usb
>> change in detail. If it's clean, I suspect we should just kill cancel
>> completion as you did.
> 
> We (Zach and I) actually made it optional too, more or less - I haven't
> looked at how you did it yet, but in my tree the linked list is there,
> but the kiocb isn't added to the kioctx's list until something sets a
> cancel function.

Sounds like the same approach I took - list is still there, and whether
the node is empty or not signifies whether we need to lock and remove
the entry on completion.

>>> Though - hrm, I'd have expected getting rid of the cancellation linked
>>> list to make a bigger difference and both our patchsets do that.
>>
>> The machine in question runs out of oomph, which is hampering the
>> results. I should have it beefed up next week. It's running E5-2630
>> right now, will move to E5-2690. I think that should make the results
>> clearer.
> 
> Well, the fact that it's cpu bound just means the throughput numbers for
> our various patches are different... and what I'm really interested in
> is the profiles, I can't think of any reason cpu speed would affect that
> much.

Sure, that's a given, since they have the same horse power available and
the setup is identical (same process pinning, irq pinning, etc).

-- 
Jens Axboe

