Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab1IGTao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 15:30:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121Ab1IGTam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 15:30:42 -0400
Message-ID: <4E67C659.1080707@redhat.com>
Date: Wed, 07 Sep 2011 15:30:33 -0400
From: Jarod Wilson <jarod@redhat.com>
User-Agent: Postbox 2.5.2 (Macintosh/20110804)
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Neil Horman <nhorman@redhat.com>, Herbert Xu <herbert.xu@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: add blocking facility to urandom
References: <1314974248-1511-1-git-send-email-jarod@redhat.com>  <1315417137-12093-1-git-send-email-jarod@redhat.com>  <1315419179.3576.6.camel@lappy>  <4E67B75B.8010500@redhat.com> <1315422330.3576.22.camel@lappy>
In-Reply-To: <1315422330.3576.22.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin wrote:
> On Wed, 2011-09-07 at 14:26 -0400, Jarod Wilson wrote:
>> Sasha Levin wrote:
>>> On Wed, 2011-09-07 at 13:38 -0400, Jarod Wilson wrote:
>>>> Certain security-related certifications and their respective review
>>>> bodies have said that they find use of /dev/urandom for certain
>>>> functions, such as setting up ssh connections, is acceptable, but if and
>>>> only if /dev/urandom can block after a certain threshold of bytes have
>>>> been read from it with the entropy pool exhausted. Initially, we were
>>>> investigating increasing entropy pool contributions, so that we could
>>>> simply use /dev/random, but since that hasn't (yet) panned out, and
>>>> upwards of five minutes to establsh an ssh connection using an
>>>> entropy-starved /dev/random is unacceptable, we started looking at the
>>>> blocking urandom approach.
>>> Can't you accomplish this in userspace by trying to read as much as you
>>> can out of /dev/random without blocking, then reading out
>>> of /dev/urandom the minimum between allowed threshold and remaining
>>> bytes, and then blocking on /dev/random?
>>>
>>> For example, lets say you need 100 bytes of randomness, and your
>>> threshold is 30 bytes. You try reading out of /dev/random and get 50
>>> bytes, at that point you'll read another 30 (=threshold) bytes
>>> out /dev/urandom and then you'll need to block on /dev/random until you
>>> get the remaining 20 bytes.
>> We're looking for a generic solution here that doesn't require
>> re-educating every single piece of userspace. [...]
>
> A flip-side here is that you're going to break every piece of userspace
> which assumed (correctly) that /dev/urandom never blocks.

Out of the box, that continues to be the case. This just adds a knob so 
that it *can* block at a desired threshold.

> Since this is
> a sysctl you can't fine tune which processes/threads/file-handles will
> block on /dev/urandom and which ones won't.

The security requirement is that everything blocks.

>> [..] And anything done in
>> userspace is going to be full of possible holes [..]
>
> Such as? Is there an example of a case which can't be handled in
> userspace?

How do you mandate preventing reads from urandom when there isn't 
sufficient entropy? You likely wind up needing to restrict access to the 
actual urandom via permissions and selinux policy or similar, and then 
run a daemon or something that provides a pseudo-urandom that brokers 
access to the real urandom. Get the permissions or policy wrong, and 
havoc ensues. An issue with the initscript or udev rule to hide the real 
urandom, and things can fall down. Its a whole lot more fragile than 
this approach, and a lot more involved in setting it up.

>>   [..] there needs to be
>> something in place that actually *enforces* the policy, and centralized
>> accounting/tracking, lest you wind up with multiple processes racing to
>> grab the entropy.
>
> Does the weak entropy you get out of /dev/urandom get weaker the more
> you pull out of it? I assumed that this change is done because you want
> to limit the amount of weak entropy mixed in with strong entropy.

The argument is that once there's no entropy left, an attacker only 
needs X number of samples before they can start accurately determining 
what the next random number will be.

> btw, Is the threshold based on a research done on the linux RNG? Or is
> it an arbitrary number that would be set by your local sysadmin?

Stephan (cc'd on the thread) is attempting to get some feedback from BSI 
as to what they have in the way of an actual number. The implementation 
has a goal of being flexible enough for whatever a given certification 
or security requirement says that number is.

-- 
Jarod Wilson
jarod@redhat.com


