Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab2LGWwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 17:52:08 -0500
Received: from sandeen.net ([63.231.237.45]:42455 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582Ab2LGWwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 17:52:06 -0500
Message-ID: <50C272F5.9040301@sandeen.net>
Date: Fri, 07 Dec 2012 16:51:33 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>, Ric Wheeler <rwheeler@redhat.com>,
        Chris Mason <clmason@fusionio.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
References: <20121206120532.GA14100@infradead.org> <20121207011628.GB16373@gmail.com> <50C22923.90102@redhat.com> <alpine.LFD.2.02.1212070956310.23641@air.linux-foundation.org> <20121207190306.GB14972@shiny> <20121207204325.GC29435@thunk.org> <20121207210932.GA25713@shiny> <20121207212743.GE29435@thunk.org> <20121207214325.GB25713@shiny> <50C26450.8060909@redhat.com> <20121207215731.GC25713@shiny>
In-Reply-To: <20121207215731.GC25713@shiny>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/7/12 3:57 PM, Chris Mason wrote:
> On Fri, Dec 07, 2012 at 02:49:04PM -0700, Ric Wheeler wrote:
>> On 12/07/2012 04:43 PM, Chris Mason wrote:
>>> On Fri, Dec 07, 2012 at 02:27:43PM -0700, Theodore Ts'o wrote:
>>>> On Fri, Dec 07, 2012 at 04:09:32PM -0500, Chris Mason wrote:
>>>>> Persistent trim is what I had in mind, but there are other ideas that do
>>>>> imply a change in behavior as well.  Can we safely assume this feature
>>>>> won't matter on spinning media?  New features like persistent
>>>>> trim do make it much easier to solve securely, and using a bit for it
>>>>> means we can toss back an error to the app if the underlying storage
>>>>> isn't safe.
>>>> We originally implemented no hide stale for spinning media.  Some
>>>> folks have claimed that for XFS their superior technology means that
>>>> no hide stale doesn't buy them anything for HDD's.  I'm not entirely
>>>> sure I buy this, since if you need to update metadata, it means at
>>>> least one extra seek for each random write into 4k preallocated space,
>>>> and 7200 RPM disks only have about 200 seeks per second.
>>> True, 7200 RPM disks are slow, but even allowing them to expose stale
>>> data just makes them a little less slow.
>>>
>>> I know it's against the rules to pretend that disks don't matter.  But
>>> really, once you're doing random IO into a spindle you've given up on
>>> performance anyway.
>>>
>>> -chris
>>
>> That's right.
>>
>> And equally true, once you have moved the disk heads to that track, you can 
>> write a lot as cheaply as a little (i.e., do 1MB instead of 4KB). That will also 
>> avoid fragmentation of the extents.
> 
> When you do a 4K write, you have to remember that you've written just
> those 4K.  When you do a 1MB write, you have to remember that you've
> written just that 1MB.  It's the same operation, except with the 1MB
> you've also had to setup all the bios and send down the zeros, and do
> the proper locking to make sure you're not sending zeros down over
> some concurrent IO.
> 
> The 1MB setup is actually more work, but it does greatly reduce the
> amount of time the workload needs to run before it goes into a steady
> state.  For smaller files it may work well, but for larger ones I don't
> think it will be enough.

Ext4 already does this, actually, I think - see s_extent_max_zeroout_kb
and how it's used.

        /* If extent is less than s_max_zeroout_kb, zeroout directly */

It's not a tunable (*gasp* ;)) but it's currently set to "32" as in
32 kb.  Would be fun to bump that up and see how your test goes.

-Eric

> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

