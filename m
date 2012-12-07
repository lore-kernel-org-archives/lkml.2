Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab2LGVmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 16:42:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838Ab2LGVmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 16:42:17 -0500
Message-ID: <50C262AE.5060701@redhat.com>
Date: Fri, 07 Dec 2012 16:42:06 -0500
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Chris Mason <clmason@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
References: <20121126025520.GC22858@thunk.org> <20121126091202.GO32450@dastard> <201212051148.28039.Martin@lichtvoll.de> <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com> <20121206120532.GA14100@infradead.org> <20121207011628.GB16373@gmail.com> <50C22923.90102@redhat.com> <alpine.LFD.2.02.1212070956310.23641@air.linux-foundation.org> <20121207190306.GB14972@shiny> <20121207204325.GC29435@thunk.org> <20121207210932.GA25713@shiny>
In-Reply-To: <20121207210932.GA25713@shiny>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2012 04:09 PM, Chris Mason wrote:
> On Fri, Dec 07, 2012 at 01:43:25PM -0700, Theodore Ts'o wrote:
>> On Fri, Dec 07, 2012 at 02:03:06PM -0500, Chris Mason wrote:
>>> That's not what happened though, and the right way forward from here is
>>> to give the bit to the feature, maybe with a generic name like
>>> FALLOCATE_WITHOUT_BEING_HORRIBLY_SLOW.
>> I don't think that's a good idea, because the current name explicitly
>> calls out the fact that we are making a tradeoff between what
>> ***might*** be a security exposure in some cases (but which might be
>> perfectly fine in others) for performance.  Using the generic name
>> would hide the fact that this tradeoff is being made, and the
>> arguments (which I've never seen backed up with a specific design) is
>> that it's possible to speed up random writes into preallocated space
>> on a flash device without making any kind of tradeoff that might imply
>> a security tradeoff.
> Grin, we're really good at debating names.  But I do see what you mean.
> I'd hope that whatever generic facility we put in doesn't have the
> security implications.

I would suggest a name like "let me see other peoples data, pronto"

>> If indeed it is possible to speed up this particular workload without
>> making any kind of no-hide-stale tradeoff, then we won't need the bit
>> --- writes into fallocated space will just get faster, with or without
>> the bit
>>
>> I am sure it will be possible to do this in some cases (for example if
>> you have a device that supports persistent trim which can quickly
>> zeroize the blocks in question), but I would be very surprised if it's
>> possible to completely eliminate the performance degradation for all
>> devices and workloads.  (Not all storage devices support persistent
>> trim, just for starters.)
> Persistent trim is what I had in mind, but there are other ideas that do
> imply a change in behavior as well.  Can we safely assume this feature
> won't matter on spinning media?  New features like persistent
> trim do make it much easier to solve securely, and using a bit for it
> means we can toss back an error to the app if the underlying storage
> isn't safe.
>
> If google wants to have a block device patch that pretends to persistent
> trim on devices that can't, great.

The other things that I think we should try would be to convert over larger 
chunks as we discussed on the list back in the summer (just because the user 
writes 4KB does not mean that we cannot flip over 1MB and zero that).

>
>> In answer's to Linus's question, the reason why people are
>> hyperventilating so badly about this is that in some circles,
>> revealing stale data is so horrible that anyone who even tries to
>> suggest this should be excommunicated.  The mere existence of the
>> code, or that people are using it, horribly offends those people.
> So I've always said this was a real performance problem and that it
> isn't just limited to ext4.  But can we please move past this part?  I
> don't think it is completely accurate.

The thing that bothers me is that no one wants to use this "feature" to see the 
stale data, just to benefit from a coincidental performance bump

Most features need to have a defined use case as opposed to a side effect as 
their motivation.

Let's focus on fixing the performance in a way that would be useful to a broader 
swath of users. To be clear, I certainly would never ship this in a distro I was 
involved in.

With or without the bit, we need to fix this properly if it is a meaningful 
workload.

ric



