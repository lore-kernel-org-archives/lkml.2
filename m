Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab1DNMZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 08:25:17 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46379 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab1DNMZN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 08:25:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=ginkel.com; s=google;
        h=mime-version:x-originating-ip:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-type:content-transfer-encoding;
        b=KKVjm9DjC9V93jSClHYgt2J7KKKh9msNZbS79Av95wwsUhpqNyI/5OZncvsz2bjGgW
         V7Z6bBOmDUilP2oSPojzLdMCtOTvWDXm/6XR1LnIw+Hz2/tPrhr+uqlCAn1p2gS9Fyq9
         c2v2gxeWo9gRN6ZuM1CGkmON4/QjSOpi8dotA=
MIME-Version: 1.0
X-Originating-IP: [91.17.157.37]
In-Reply-To: <BANLkTi=aED731W4WoKK1HUU88qR7RxpW6Q@mail.gmail.com>
References: <BANLkTi=kQgS62c7HwwFGhNCQzWr2N6kZjA@mail.gmail.com>
 <201104060128.33887.arnd@arndb.de> <BANLkTi=aED731W4WoKK1HUU88qR7RxpW6Q@mail.gmail.com>
From: Thilo-Alexander Ginkel <thilo@ginkel.com>
Date: Thu, 14 Apr 2011 14:24:42 +0200
Message-ID: <BANLkTimDOz7M6m6Xo==DbLHP6q2pMBzd9g@mail.gmail.com>
Subject: Re: Soft lockup during suspend since ~2.6.36 [bisected]
To: Arnd Bergmann <arnd@arndb.de>, Tejun Heo <tj@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 6, 2011 at 08:03, Thilo-Alexander Ginkel <thilo@ginkel.com> wrote:
> On Wed, Apr 6, 2011 at 01:28, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Tuesday 05 April 2011, Thilo-Alexander Ginkel wrote:
>>> Thanks, that worked pretty well. A bisect with eleven builds later I
>>> have now identified the following candidate commit, which may have
>>> introduced the bug:
>>>
>>> dcd989cb73ab0f7b722d64ab6516f101d9f43f88 is the first bad commit
>>> commit dcd989cb73ab0f7b722d64ab6516f101d9f43f88
>>> Author: Tejun Heo <tj@kernel.org>
>>> Date:   Tue Jun 29 10:07:14 2010 +0200
>>
>> Sorry, but looking at the patch shows that it can't possibly have introduced
>> the problem, since all the code that is modified in it is new code that
>> is not even used anywhere at that stage.
>>
>> As far as I can tell, you must have hit a false positive or a false negative
>> somewhere in the bisect.
>
> Well you're right. I hit "Reply" too early and should have paid closer
> attention to what change the bisect actually brought up.
>
> I already found a false negative (fortunately pretty close to the end
> of the bisect sequence) and also verified the preceding good commits,
> which gives me two new commits to test. I'll provide an update once
> the builds and tests are through, which may however take until early
> next week as I will be on vacation until then.

All right... I verified all my bisect tests and actually found yet
another bug. After correcting that one (and verifying the correctness
of the other tests), git bisect actually came up with a commit, which
makes some more sense:

| e22bee782b3b00bd4534ae9b1c5fb2e8e6573c5c is the first bad commit
| commit e22bee782b3b00bd4534ae9b1c5fb2e8e6573c5c
| Author: Tejun Heo <tj@kernel.org>
| Date:   Tue Jun 29 10:07:14 2010 +0200
|
|     workqueue: implement concurrency managed dynamic worker pool

The good news is that I am able to reproduce the issue within a KVM
virtual machine, so I am able to test for the soft lockup (which
somewhat looks like a race condition during worker / CPU shutdown) in
a mostly automated fashion. Unfortunately, that also means that this
issue is all but hardware specific, i.e., it most probably affects all
SMP systems (with a varying probability depending on the number of
CPUs).

Adding some further details about my configuration (which I replicated
in the VM):
- lvm running on top of
- dmcrypt (luks) running on top of
- md raid1

If anyone is interested in getting hold of this VM for further tests,
let me know and I'll try to figure out how to get it (2*8 GB, barely
compressible due to dmcrypt) to its recipient.

Regards,
Thilo
