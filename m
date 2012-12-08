Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab2LHNwz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 08:52:55 -0500
Received: from [69.43.206.106] ([69.43.206.106]:42938 "EHLO zill.rb.symas.net"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752388Ab2LHNwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 08:52:53 -0500
Message-ID: <50C3461E.7030801@symas.com>
Date: Sat, 08 Dec 2012 05:52:30 -0800
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:20.0) Gecko/20100101 Firefox/20.0 SeaMonkey/2.17a1
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Ric Wheeler <rwheeler@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
References: <201212051148.28039.Martin@lichtvoll.de> <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com> <20121206120532.GA14100@infradead.org> <20121207011628.GB16373@gmail.com> <50C22923.90102@redhat.com> <alpine.LFD.2.02.1212070956310.23641@air.linux-foundation.org> <20121207193019.GA31591@home.goodmis.org> <20121207211440.GD29435@thunk.org> <50C263D6.9050003@redhat.com> <50C27B01.1010903@symas.com> <20121208005042.GQ27172@dastard>
In-Reply-To: <20121208005042.GQ27172@dastard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> On Fri, Dec 07, 2012 at 03:25:53PM -0800, Howard Chu wrote:
>> I have to agree that, if this is going to be an ext4-specific
>> feature, then it can just be implemented via an ext4-specific ioctl
>> and be done with it. But I'm not convinced this should be an
>> ext4-specific feature.
>>
>> As for "fix the problem properly" - you're fixing the wrong problem.
>> This type of feature is important to me, not just because of the
>> performance issue. As has already been pointed out, the performance
>> difference may even be negligible.
>>
>> But on SSDs, the issue is write endurance. The whole point of
>> preallocating a file is to avoid doing incremental metadata updates.
>> Particularly when each of those 1-bit status updates costs entire
>> blocks, and gratuitously shortens the life of the media. The fact
>> that avoiding the unnecessary wear and tear may also yield a
>> performance boost is just icing on the cake. (And if the perf boost
>> is over a factor of 2:1 that's some pretty damn good icing.)
>
> That's a filesystem implementation specific problem, not a generic
> fallocate() or unwritten extent conversion problem.

> Besides, ext4 doesn't write back every metadata modification that is
> made - they are aggregated in memory and only written when the
> journal is full or the metadata ages out. Hence unwritten extent
> conversion has very little impact on the amount of writes that are
> done to the flash because it is vastly dominated by the data writes.
>
> Similarly, in XFS you might see a few thousand or tens of thousands
> of metadata blocks get written once every 30s under such a random
> write workload, but each metadata block might have gone through a
> million changes in memory since the last time it was written.
> Indeed, in that 30s, there would have been a few million random data
> writes so the metadata writes are well and truly lost in the
> noise...

That's only true if write caching is allowed. If you have a transactional 
database running, it's syncing every transaction to media.

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
