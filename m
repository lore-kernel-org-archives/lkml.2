Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760115Ab0GQS7M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 14:59:12 -0400
Received: from smtpauth01.tellcom.com.tr ([92.45.6.177]:11981 "EHLO
	smtpout1.superonline.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756493Ab0GQS7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 14:59:11 -0400
Message-ID: <4C41FD6E.9090603@superonline.com>
Date: Sat, 17 Jul 2010 21:58:54 +0300
From: "M. Vefa Bicakci" <bicave@superonline.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100619 Icedove/3.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Airlie <airlied@gmail.com>, Chris Wilson <chris@chris-wilson.co.uk>,
        earny@net4u.de, Roman Jarosz <kedgedev@gmail.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        jcnengel@googlemail.com, "A. Boulan" <arnaud.boulan@libertysurf.fr>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Pekka Enberg <penberg@cs.helsinki.fi>, A Rojas <nqn1976list@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, rientjes@google.com,
        michael@reinelt.co.at, stable@kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Selectively enable self-reclaim
References: <alpine.LFD.2.00.1001270327580.24253@localhost.localdomain><1264605932-8540-1-git-send-email-chris@chris-wilson.co.uk><alpine.LFD.2.00.1001270738220.24253@localhost.localdomain><89k77n$ms73l9@fmsmga001.fm.intel.com><alpine.LFD.2.00.1001270917120.24253@localhost.localdomain><AANLkTilpK6FfgbgVf4e7jJSvVwVDVLfrxIy3WmgliuLK@mail.gmail.com><89khjo$fr177d@orsmga002.jf.intel.com><AANLkTilwmuXlNYhlFkmpYHSmegPy3ws4x-YRFwkbk8Xm@mail.gmail.com><AANLkTinLB5YtqsnFwWrP37i3Ucr4fOaQzVuDLnyWBRGQ@mail.gmail.com><4C2D180C.5050805@superonline.com><AANLkTiklUBmNYs3710WftVX0Z3QihxFtDlK7tPlHZh8H@mail.gmail.com><AANLkTilOWu6ZwWjwPfHvNXDhyjb6n4N5KV1rUx6byJmq@mail.gmail.com><AANLkTilfkCBfZtRQlybQ721PSF4lSlqeOKL3rYnEz2G1@mail.gmail.com> <AANLkTikpw42jE5Eh0EkXuRh70mb9x3njX6R4JNshawe5@mail.gmail.com>
In-Reply-To: <AANLkTikpw42jE5Eh0EkXuRh70mb9x3njX6R4JNshawe5@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SMTP-Filter: SurGATE SMTP Filter Engine Release 2.1 ($Revision: 184 $) http://www.endersys.com
X-SurGATE-Result: Clean (Content eval: 2.00 points)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/10 04:28 AM, Linus Torvalds wrote:
> On Thu, Jul 1, 2010 at 5:49 PM, Dave Airlie <airlied@gmail.com> wrote:
>>
>> RECLAIMABLE added also seems fine, of course you can't have
>> RECLAIMABLE and MOVABLE (I find this out when it oopses on boot).
> 
> Yes. They are both flags for the anti-fragmentation code, and I think
> I'll leave the decision as to whether the i915 driver should use
> __GFP_RECLAIMABLE to the people who work with and care about the
> fragmentation issues. I doubt it matters much in practice, at least
> not for the loads that the fragmentation people tend to care most
> about.
> 
>> So I suspect MOVABLE is the problem. but I don't know enough about gfp
>> flags to know what RECLAIMABLE buys us, and where it  might bite us so
>> I can test some more.
> 
> I think I'll just apply your previous tested patch - GFP_HIGHUSER
> should take care of all the flags that matter fundamentally, and then
> the reclaimable flag is really just a small detail for others to worry
> about.
> 

Dear Linus,

I have bad news regarding your fix for self-reclaim and i915.

Apparently, I haven't tried enough hibernate/thaw cycles while
initially testing your fix.

After applying your fix to 2.6.34.1 and using it for two weeks,
I noticed that every now and then I get a black screen or random
kernel errors after thawing. I thought maybe this might be the
same problem caused by d8e0902806c0bd2ccc4f6a267ff52565a3ec933b .
(It turns out that my guess was right.)

So I compiled two vanilla 2.6.34.1 kernels. One with
d8e0902806c0bd2ccc4f6a267ff52565a3ec933b reverted to get back
to pre 2.6.32.8 state, and another one with your fix applied.

Then I set up an automated process where the computer would
hibernate, and reboot at the end of the hibernation sequence
(by setting /sys/power/disk to reboot) and then thaw back.
I made this process loop at least 20 times.

The kernel with d8e0902806c0bd2ccc4f6a267ff52565a3ec933b reverted
was able to hibernate/thaw at least 40 times in one go, while
the one with your fix applied was able to hibernate/thaw at most
17 times (in two separate trials) after which it crashed during
the next thaw.

Is there anything I can do find out the correct flags to use
in addition to GFP_HIGHUSER ? Can I do something like a bisection
for the flags one by one starting from the pre 2.6.32.8 state?
If you could outline a procedure to do this, I would be glad to
follow it.

Sorry to bug you again about this problem because of incomplete
testing on my part.

Regards,

M. Vefa Bicakci
