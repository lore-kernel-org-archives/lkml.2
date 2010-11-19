Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab0KSU4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 15:56:43 -0500
Received: from mail.lang.hm ([64.81.33.126]:36629 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755704Ab0KSU4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 15:56:43 -0500
Date: Fri, 19 Nov 2010 12:55:46 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Willy Tarreau <w@1wt.eu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Marcus Meissner <meissner@suse.de>, linux-kernel@vger.kernel.org,
        tj@kernel.org, akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
In-Reply-To: <20101119201614.GB19329@1wt.eu>
Message-ID: <alpine.DEB.2.00.1011191238140.19579@asgard.lang.hm>
References: <20101116104600.GA24015@suse.de> <20101119191906.GA31760@xanatos> <AANLkTi=OsWEdrfCOHKz+SAtqo7DmK0nNxku7Ev21f0Lh@mail.gmail.com> <alpine.DEB.2.00.1011191156470.19579@asgard.lang.hm> <AANLkTikP5MpT6-WBBfNsP2nK1Cdh=St+nWky_bU9FhSO@mail.gmail.com>
 <20101119201614.GB19329@1wt.eu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Nov 2010, Willy Tarreau wrote:

> On Fri, Nov 19, 2010 at 12:04:47PM -0800, Linus Torvalds wrote:
>> On Fri, Nov 19, 2010 at 11:58 AM,  <david@lang.hm> wrote:
>>>
>>> how far back do we need to maintain compatibility with userspace?
>>>
>>> Is this something that we can revisit in a few years and lock it down then?
>>
>> The rule is basically "we never break user space".
>>
>> But the "out" to that rule is that "if nobody notices, it's not
>> broken". In a few years? Who knows?
>>
>> So breaking user space is a bit like trees falling in the forest. If
>> there's nobody around to see it, did it really break?
>
> FWIW, I appreciate a lot that non-breaking rule. I have some testing
> machines which boot from PXE or USB on a file-system with some old
> tools and libc, that are both 2.4 and 2.6 compatible. Everything works
> like a charm, the only point of care was to have both module-init-tools
> and modutils (obviously) but even that integrates smoothly.
>
> I know quite a lot of people who never replace user-space but only
> kernels on their systems, so this non-breaking rule is much welcome !

Please don't get me wrong, as a general rule I like it a lot (I almost 
never run the stock kernel from a distro and I upgrade kernels _far_ more 
frequently than anything else).

However, like every other general rule, there are reasons to make 
exceptions.

In this case we are changing the default to make it more secure, I think 
that's worth something.

Yes, distros can all add the chmod command to their startup to get similar 
behavior. But by the same token, if we change the default, someone running 
an old distro can add a chmod command into their bootup to allow their old 
software to still work. In the case that has been identified, the problem 
is that syslog is unable to get the kernel messages. this can be 
important, but in my opinion it's a long way from being a fatal flaw. I've 
already seen this sort of problem happen in the wild without this change. 
I was running a development version of rsyslog and on a ubuntu system a 
year or so ago (before they switched to rsyslog), I had a situation where 
firing up rsyslog would generate a lot of messages about being unable to 
read the kernel logs (I don't remember the exact message, it wasn't this 
kallsyms file, it was something else)

my full-time job is in security for banks, so I'm a bit more sensitive to 
the security issues than most people (but tend to agree with Linus about 
the security industry and security circus), but I see this as something 
that is useful enough to put in (with a compile-time flag if the 
compatibility is that critical for this function). I expect that there are 
going to be a few more security patches coming down the road that would be 
good to put under the same or similar flag (either because they may break 
some old software like eliminating /proc/kmem, or because they add a 
slight amount of overhead like the nx/read-only patches). As a result I 
think something similar to the 'embedded' option would be appropriate, 
have these new features on by default, but have some way that people who 
need to disable them can do so.

David Lang
