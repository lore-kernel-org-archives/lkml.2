Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab0IUWSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 18:18:09 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:60067 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949Ab0IUWSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 18:18:07 -0400
X-ASG-Debug-ID: 1285107486-0e12394d0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4C992F12.5090000@fusionio.com>
Date: Wed, 22 Sep 2010 00:17:54 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Christoph Hellwig <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] floppy: switch to one queue per drive instead of  sharing
 a queue (Was: Re: cgq vs bdi names, was "cfq-iosched: fix a kernel  OOPs
 when usb key  is inserted")
References: <20100920130318.GA29565@lst.de> <4C975DCC.9050902@fusionio.com> <20100920223001.GJ6138@redhat.com> <20100921182529.GA31132@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH] floppy: switch to one queue per drive instead of  sharing
 a queue (Was: Re: cgq vs bdi names, was "cfq-iosched: fix a kernel  OOPs
 when usb key  is inserted")
In-Reply-To: <20100921182529.GA31132@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1285107486
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0847 1.0000 -1.4850
X-Barracuda-Spam-Score: -1.49
X-Barracuda-Spam-Status: No, SCORE=-1.49 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.41505
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-21 20:25, Vivek Goyal wrote:
> On Mon, Sep 20, 2010 at 06:30:01PM -0400, Vivek Goyal wrote:
>> On Mon, Sep 20, 2010 at 03:12:44PM +0200, Jens Axboe wrote:
>>> On 2010-09-20 15:03, Christoph Hellwig wrote:
>>>> Hi Vivek, hi Jens,
>>>>
>>>> where was http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff_plain;h=44c74d6292e97f8bd9adfa6b0df3cb4f3c42a6dc posted  on the mailinglist?
>>>>
>>>> I can't find it in my lkml or fsdevel inboxes.  Either way I don't think
>>>> just papering over the underlying issue like this is a good idea.  
>>>>
>>>> The big issue is that cfq tries to scanf the textual representation of
>>>> the dev_t from the request_queue by abusing the bdi.  But the reason why
>>>> we don't have a dev_t in the request_queue is that it's still not
>>>> unique.  If it was we could easily add a dev_t into the request_queue
>>>> and be done with it.
>>>>
>>>> So the fix is either to get rid of the last remaining users of shared
>>>> request_queues (IIRC the various floppy drivers) and just add a dev_t
>>>> in the request_queue for the bdi, tracing and cfq, or add a dev_t into
>>>> the request_queue and add a flag for shared request queues that the
>>>> floppy driver and whoever needs it set and let the bdi sysfs code, cfq
>>>> and blocktrace ignore theis request_queue.  This will also allow to
>>>> get rid of the crap about ignoring failures due to already register
>>>> or prematurely unregistered bdis and actually add real error handling
>>>> to that code.
>>>
>>> I did this one 15 months ago (according to git), but I never got it
>>> tested:
>>>
>>> http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=7a0ebc7ea1db42a71841df6a15be9fd420fae980
>>>
>>> IIRC, the mtd stuff also uses a shared queue. But I think that is it.
>>> Would indeed be VERY nice to finally get rid of that crap, it has
>>> technically been outlawed since 2.5.1.
>>
>> Hi Jens,
>>
>> I have refreshed your patch to apply on latest tree. I did testing with
>> one floppy controller and it was hanging because we were taking
>> floppy_lock both inside and outside of function set_next_request(). I got
>> rid of that and now atleast with one flopply controller this patch is
>> working fine.
>>
>> I tried connecting another floppy controller to see if I see two request
>> queues being registered, but somehow my BIOS does not recognize two 
>> floppy controllers and only makes one of these operational.
>>
> 
> Christoph suggested to use qemu and test with multiple flopply disk
> controller and it worked. Thanks Christoph.
> 
> I exported two floppy disks and they show up as /dev/fd0 and /dev/fd1 in
> the guest.
> 
> With the patch I also verified that changing IO scheduler on fd0 does
> not change it automatically for fd1. That means they both are using 
> separate requests queues after the patch. Without the patch changing
> IO scheduler on one changed it automatically for the other controller
> meaning they were sharing same request queue.
> 
> I did basic testing of being able to mount the floppy disks and being
> able to read/write simple text files.
> 
> Jens, do let me know if you are curious to know about test results in
> some other configuration.

Super, thanks a lot! I will queue this up. If you want to continue
this (very noble) crusade, the next target is
drivers/mtd/mtd_blkdevs.c. I never got that one started, but it was
next on my list.

I will queue up the floppy patch for .37.

-- 
Jens Axboe

