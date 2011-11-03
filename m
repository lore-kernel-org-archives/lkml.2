Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934519Ab1KCTTD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 15:19:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39128 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933862Ab1KCTTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 15:19:00 -0400
Message-ID: <4EB2E91B.5060705@gmail.com>
Date: Thu, 03 Nov 2011 20:18:51 +0100
From: =?UTF-8?B?xYF1a2FzeiBTb3dh?= <luksow@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111001 Thunderbird/7.0.1
MIME-Version: 1.0
To: Will Drewry <wad@chromium.org>
CC: Paul Menage <paul@paulmenage.org>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [RFC] cgroup: syscalls limiting subsystem
References: <4E9E17F4.7080306@gmail.com> <CALdu-PDzw=6oGBU25K0TSAckuRmfQOnA6Aw-WZJkxLj1LyvNWg@mail.gmail.com> <4EA0935C.4020605@gmail.com> <CABqD9hY0A4EBP+C4uJvrhtFZKr=S3GV_js5Z2bhmmZbVgOkKUw@mail.gmail.com>
In-Reply-To: <CABqD9hY0A4EBP+C4uJvrhtFZKr=S3GV_js5Z2bhmmZbVgOkKUw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks a lot for all valuable remarks and for supporting the idea!

> 
> Have you considered doing this as a system call namespace instead of a
> cgroup?  (Just curious!)
> 

Yes, I have but I didn't see any advantages of system call namespace
over cgroup (maybe I missed something?). However, I think that using
namespace is in this particular case harder - less dynamic and thus less
useful.

> Have you considered using the semi-slow path used by auditsc? It uses
> a thread_info flag but doesn't take the completely slow-path if _only_
> audit is selected.  You may be able to get by with a new TIF flag that
> fits in with the same mask that is always called for all syscalls,
> then only fork if the process is in a filtered cgroup.  It will be
> messy to ensure all the paths work correctly, but it should mean that
> the overhead for normal applications is unchanged, and you might avoid
> the total slow-path overhead (just something similar to audit
> overhead).

I will try thread_info flag in next patch series. However, what I am
worried about is breaking consistency when you end up having processes
in a cgroup that does nothing because of TIF flags set. Another dirty
thing is that the TIF flag cannot be hierarchical (cannot be inherited)
so it's somehow breaking the idea of cgroups.
Another thing - what's better in using TIF flag instead of a per-cgroup
variable (held internally in struct) - is the performance that makes the
difference?

> That said, your approach won't work on platforms which offset system
> call start points, have gaps, and different ABI modes which change
> those.  You might want to consider a btree or something that doesn't
> need a pre-allocated array, etc.
> 
> (If not, you'll need to populate helpers for arches that need it to
> get their starting number for the current abi and the max numbers and
> then make sure processes either can't flip-flop, like CONFIG_COMPAT,
> and exceed the sized array.  But perhaps the btree lookup cost is too
> much.)

That sounds worrying. Could you elaborate on that? I'm not very
other-arches-aware and those things may be important for future work.

> 
> Have you considered supporting ftrace filters?
> 

No I haven't yet. Now, I'm reading through the seccomp patchset (and
discussion) you mentioned. At first glance it seems a nice idea but it
looks like a hard task to get it right. Another thing - isn't the
performance really bad when using those filters?

> Good luck - I look forward to seeing your next patch series!

I hope to post another patch for RFC next week. I will implement Paul's
remarks and TIF flag option and measure the performance again. I'm
looking forward to a nice and fruitful discussion then :).

Thanks,
Lukasz Sowa

