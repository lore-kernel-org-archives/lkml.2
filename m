Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab2DFETQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 00:19:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:56190 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab2DFETP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 00:19:15 -0400
Message-ID: <4F7E6EBE.50501@kernel.dk>
Date: Thu, 05 Apr 2012 22:19:10 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tao Guo <glorioustao@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        neilb@suse.de, axboe@fusionio.com
Subject: Re: [PATCH] umem: fix up unplugging.
References: <1325254651-15379-1-git-send-email-glorioustao@gmail.com> <20120404144656.7b2a06ec.akpm@linux-foundation.org> <CAAV8rn+T7FM7bG+Q6fyoUrVtzOkYOx94Nh87Rg12UqCdk9HhWQ@mail.gmail.com> <4F7CD6C9.4060509@kernel.dk> <CAAV8rn+s__Uap1_nx8w4USGtAsg0Y=cbo_mUyCWnX2EFNzH3Eg@mail.gmail.com> <4F7E3011.4090803@kernel.dk> <CAAV8rnKuYoyNjhpPSLk4XJiwG7XYL11pUfdNx1Jn9mNji-9+Mw@mail.gmail.com>
In-Reply-To: <CAAV8rnKuYoyNjhpPSLk4XJiwG7XYL11pUfdNx1Jn9mNji-9+Mw@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-05 22:09, Tao Guo wrote:
> On Thu, Apr 5, 2012 at 4:51 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 2012-04-04 17:58, Tao Guo wrote:
>>> On Wed, Apr 4, 2012 at 4:18 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 2012-04-04 16:20, Tao Guo wrote:
>>>>> Hi Andrew,
>>>>>
>>>>> Thanks for your reply.
>>>>>
>>>>> Yes, without this patch the umem driver just doesn't work.
>>>>> It is a bug introduced by commit 7eaceaccab5f40bbfda044629a6298616aeaed50.
>>>>> In that patch, Jens removed the whole mm_unplug_device() function,
>>>>> which used to be
>>>>> the trigger to make umem start to work.
>>>>
>>>> Hmm indeed, that's isn't terribly useful. Why aren't we just calling
>>>> activate_card() on addition of a bio?
>>>>
>>> It is the original design idea, the umem driver also wants to do batch
>>> IO the same as
>>> hard disk drive to fully utilize the IO bandwidth.
>>
>> Sure, just wondering whether the benefits have been tested. But yes, it
>> certainly makes sense.
>>
>> Your patch looks buggy, though. What if the card is currently plugged on
>> another tasks plug list? You seem to assume that it can only be plugged
>> once.
> No, it will register in its own plug callback list successfully, so
> the unplug functions
> will be called separately(twice the same).

So the code loops through the current plug, checking if it's already on
that list. If not, then it adds it. But what if it's on another plug
list? The above loop could be done with just a

        if (!list_empty(&card->plug_cb.list))
                ...

instead. Right now you could have !list_empty(&card->plug_cb.list) but
still add it to a different list.

-- 
Jens Axboe

