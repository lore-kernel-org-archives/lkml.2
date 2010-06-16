Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758954Ab0FPOQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 10:16:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:40393 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758943Ab0FPOQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 10:16:23 -0400
Message-ID: <4C18DC69.10704@kernel.org>
Date: Wed, 16 Jun 2010 16:15:05 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
References: <1276551467-21246-1-git-send-email-tj@kernel.org>	 <4C17C598.7070303@kernel.org>	 <1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>	 <4C18BF40.40607@kernel.org> <1276694825.9309.12.camel@m0nster>	 <4C18D1FD.9060804@kernel.org> <1276695665.9309.17.camel@m0nster>	 <4C18D574.1040903@kernel.org> <1276697146.9309.27.camel@m0nster>
In-Reply-To: <1276697146.9309.27.camel@m0nster>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Jun 2010 14:15:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/16/2010 04:05 PM, Daniel Walker wrote:
> On Wed, 2010-06-16 at 15:45 +0200, Tejun Heo wrote:
>> On 06/16/2010 03:41 PM, Daniel Walker wrote:
>>> Any workqueue that has a thread which can be prioritized from userspace.
>>> As long as there is a thread it can usually be given a priority from
>>> userspace, so any _current_ workqueue which uses a single thread or
>>> multiple threads is an example of what I'm talking about.
>>
>> Eh... what's the use case for that?  That's just so wrong.  What do
>> you do after a suspend/resume cycle?  Reprioritize all of them from
>> suspend/resume hooks?
> 
> The use case is any situation when the user wants to give higher
> priority to some set of work items, and there's nothing wrong with that.

Come on.  The user can't even know what's going on each workqueue
thread.  Something you can do doesn't make it a good idea.  In this
case, it's a very bad idea.

> In fact there has been a lot of work in the RT kernel related to
> workqueue prioritization ..

That frankly I don't have much idea about.

> suspend/resume shouldn't touch the thread priorities unless your tearing
> down the threads and remaking them each suspend/resume cycle from inside
> the kernel.

And here's a perfect example of why it's a very bad idea.  The kernel
is *ALREADY* doing that on every suspend/resume cycle, so if you are
thinking that priorities on kernel workqueue threads were being
maintained over suspend/resume cycles, you're wrong and have been
wrong for a very long time.

Mangling workqueue thread priorities from userland is a fundamentally
broken thing to do.  It's not a part of AP|BI and there's no guarantee
whatsoever that something which works currently in certain way will
keep working that way one release later.  If there's something which
wants priority adjustment from userland, the right thing to do is
finding out precisely why it's necesssary and implementing a published
interface to do that.

Thanks.

-- 
tejun
