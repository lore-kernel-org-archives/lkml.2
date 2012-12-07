Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab2LGXxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 18:53:46 -0500
Received: from [69.43.206.106] ([69.43.206.106]:42273 "EHLO zill.rb.symas.net"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754928Ab2LGXxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 18:53:44 -0500
X-Greylist: delayed 1647 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Dec 2012 18:53:44 EST
Message-ID: <50C27B01.1010903@symas.com>
Date: Fri, 07 Dec 2012 15:25:53 -0800
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:20.0) Gecko/20100101 Firefox/20.0 SeaMonkey/2.17a1
MIME-Version: 1.0
To: Ric Wheeler <rwheeler@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
References: <1353366267-15629-1-git-send-email-david@fromorbit.com> <20121126025520.GC22858@thunk.org> <20121126091202.GO32450@dastard> <201212051148.28039.Martin@lichtvoll.de> <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com> <20121206120532.GA14100@infradead.org> <20121207011628.GB16373@gmail.com> <50C22923.90102@redhat.com> <alpine.LFD.2.02.1212070956310.23641@air.linux-foundation.org> <20121207193019.GA31591@home.goodmis.org> <20121207211440.GD29435@thunk.org> <50C263D6.9050003@redhat.com>
In-Reply-To: <50C263D6.9050003@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ric Wheeler wrote:
> On 12/07/2012 04:14 PM, Theodore Ts'o wrote:
>> On Fri, Dec 07, 2012 at 02:30:19PM -0500, Steven Rostedt wrote:
>>> How is this similar? By adding this bit, we removed incentive from a
>>> group of developers that have the means to fix the real issue at hand
>>> (the performance problem with ext4). Thus, it means that they have a work
>>> around that's good enough for them, but the rest of us suffer.
>> That assumes that there **is** a way to claw back the performance
>> loss, and Chris Mason has demonstrated the performance hit exists with
>> xfs as well (950 MB/s vs. 400 MB/s; that's more than a factor of two).
>> Sometimes, you have to make the engineering tradeoffs.  That's why
>> we're engineers, for goodness sakes.  Sometimes, it's just not
>> possible to square the circle.
>>
>> I don't believe that the technique of forcing people who need that
>> performance to suffer in order to induce them to try to engineer a
>> solution which may or may not exist is really the best or fairest way
>> to go about things.
>>
>> 					- Ted
>
> This is not a generally useful feature and won't ship in a way that helps most
> users with this issue.

> Let's fix the problem properly.
>
> In the meantime, there are several obvious ways to avoid this performance hit
> without changing the kernel (fully allocate and write the data, certainly
> reasonable for even reasonable sized files).

I have to agree that, if this is going to be an ext4-specific feature, then it 
can just be implemented via an ext4-specific ioctl and be done with it. But 
I'm not convinced this should be an ext4-specific feature.

As for "fix the problem properly" - you're fixing the wrong problem. This type 
of feature is important to me, not just because of the performance issue. As 
has already been pointed out, the performance difference may even be negligible.

But on SSDs, the issue is write endurance. The whole point of preallocating a 
file is to avoid doing incremental metadata updates. Particularly when each of 
those 1-bit status updates costs entire blocks, and gratuitously shortens the 
life of the media. The fact that avoiding the unnecessary wear and tear may 
also yield a performance boost is just icing on the cake. (And if the perf 
boost is over a factor of 2:1 that's some pretty damn good icing.)

There are certainly ways in which a feature like this could be deployed 
safely, or at least, without violating anyone's expectations of security. For 
example, you have braindead filesystems like FAT that don't actually support 
per-file owner/group info. If you have a filesystem where all of the files are 
known to belong to the same user, then the whole argument about "seeing 
someone else's data" is moot. If you provide the uid=/gid= mount options 
generically across all (or most) filesystem types, then you can let a sysadmin 
decide if they want to play this way or not.

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
