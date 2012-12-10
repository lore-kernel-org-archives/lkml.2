Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab2LJSwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 13:52:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab2LJSw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 13:52:29 -0500
Message-ID: <50C62F5F.7040808@redhat.com>
Date: Mon, 10 Dec 2012 13:52:15 -0500
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ric Wheeler <rwheeler@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
References: <20121126025520.GC22858@thunk.org> <20121126091202.GO32450@dastard> <201212051148.28039.Martin@lichtvoll.de> <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com> <20121206120532.GA14100@infradead.org> <20121207011628.GB16373@gmail.com> <50C22923.90102@redhat.com> <alpine.LFD.2.02.1212070956310.23641@air.linux-foundation.org> <20121207190306.GB14972@shiny> <20121208001705.GO27172@dastard> <20121210173739.GA1359@thunk.org>
In-Reply-To: <20121210173739.GA1359@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2012 12:37 PM, Theodore Ts'o wrote:
> On Sat, Dec 08, 2012 at 11:17:05AM +1100, Dave Chinner wrote:
>> I wouldn't recommend XFS_IOC_ALLOCSP as a user-friendly interface.
>> The concept, however, implemented by a new fallocate()
>> flag (say FALLOC_FL_WRITE_ZEROS) so that the filesystem knows that
>> the application considers unwritten extents undesirable is exactly
>> the sort of thing that we should be considering implementing.
> What's the point of using a new flag like this (or XFS's
> XFS_IOC_ALLOCSP) for writing zeros during preallocation as oppoised to
> simply doing a fallocate() followed by zeroing the data via a O_DIRECT
> write system call?

I think that this is actually quite useful if you take it to mean "keep normal 
fallocate semantics and make sure that no meta-data twiddling needs be done"

The existing behaviour (the default one) is preallocate and it is OK to metadata 
twiddling (extent conversion, etc) later on.

Of course, we could well offload either to WRITE_SAME or TRIM, etc if the 
storage target supports it,

ric

>
>> Indeed, if the filesystem is on something with WRITE_SAME or
>> discards to zero, no data would need to be written, you wouldn't
>> have any unwritten extent overhead, and no stale data exposure.
> And if you have a storage device which supports WRITE_SAME or
> persistent discards, you can do this automatically at preallocation
> time without needing a new fallocate(2) flag.  I certainly don't
> oppose adding such optimizations to ext4 or any other file system (I'm
> not entirely convinced that it's worth it to do this optimization at
> the VFS level), but it doesn't help for storage devices that don't
> support this feature.
>
>> This is exactly why Ted should have posted the patch for review. He
>> may not have got the flag through, but the discussion might just end
>> up in a place that is *better for everyone*.
> Both of these suggestions have been made multiple times before when we
> submitted the original patch to support NO_HIDE_STALE, and they aren't
> sufficient for our purposes, so it's not like submitting a patch to
> reserve the bit would have given us any new information.  We've had
> this discussion **ALREADY**, multiple times before, with no one
> beliving that the alternate solutions were sufficient for our needs.
>
> This is why this discussion reminds me so much of the wakelocks
> discussion, and why I've made the same decision the Android folks
> made, except they wasted far more time and got far more frustrated ---
> I'll just keep the dammned thing as a out-of-tree patch, until there
> are enough other people willing to say that they need and are using
> this patch because their workloads and use cases need it.  It will
> save me a whole lot of time.
>
> (BTW, on a similar subject, we have folks at Tao Bao, Oracle, and
> Google saying that disabling stable page writes does improve their
> workloads, despite everyone else claiming it doesn't matter, and both
> Tao Bao and Google have out-of-tree patches that spike out stable page
> writes.  Maybe this will be enough so we don't have to waste more time
> convincing people that it's not an insane workload such benefits from
> a way to disable stable page writes.  But if not, I'm not going to
> waste time trying to convincing everyone else on fs-devel.  Keeping
> the out of tree patch is just way less effort, and requires much less
> resources.)
>
>> And further - what happens if we add changes like I've mentioned
>> above and Google moves to using them instead? We'll have a bit in
>> the interface that nobody uses, nobody will ever implement, and we
>> can't remove. There's many, many good reasons why a revert is the
>> only sane thing to do at this point....
> It's one bit, where we have plenty and plenty of bits.  The only other
> possible uses for the fallocate flags (such as hot vs cold storage,
> etc., have all been bike-sheeded to death on fs-devel already), so I'm
> quite confident that we will never get to the point where even close
> to running out of fallocate flag bits.
>
> The only other bit I'm aware of that might happen soon is the volatile
> ranges patch, and that's just one more bit.  So at this point we'll
> still have 28 bits (out of 32 bits).  So when you talk about an
> interface that we'll never remove, I think you're engaging in
> hyperbole.
>
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

