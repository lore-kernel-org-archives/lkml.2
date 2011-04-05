Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab1DES5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 14:57:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42484 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab1DES51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 14:57:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=ginkel.com; s=google;
        h=mime-version:x-originating-ip:from:date:message-id:subject:to:cc
         :content-type;
        b=YxH4Lm9yMJeqmgichZmCODCUtOKHWuUlQj4NaV+mM6xus+2NrdwaAc9Aphc2kz1J/+
         sr4U8nv97eg16i+A3cZlBlWRGzuIci7ynWcDfiz2mHfOhwPn9dmf73r2YXnrSyTD0rLM
         an0IJGjnGfqO0TeDXbsPf55B5gswOUWGRtDU8=
MIME-Version: 1.0
X-Originating-IP: [91.17.173.6]
From: Thilo-Alexander Ginkel <thilo@ginkel.com>
Date: Tue, 5 Apr 2011 20:56:56 +0200
Message-ID: <BANLkTi=kQgS62c7HwwFGhNCQzWr2N6kZjA@mail.gmail.com>
Subject: Re: Soft lockup during suspend since ~2.6.36 [bisected]
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 4, 2011 at 17:32, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 04 April 2011, Thilo-Alexander Ginkel wrote:
>> ACK. I see two possibilities:
>> a) The bug was introduced after the bisected bug was fixed
>> b) The bug was already present earlier, but was masked by the bug from
>> the bisected change
>>
>> I hope for a) as that would open the possibility to bisect this new bug.
>
> In case of b), you can still bisect it when you either apply the later fix
> or revert the original patch whenever you build a kernel. Or you can try
> to avoid using the usb-hid driver during bisect.

Thanks, that worked pretty well. A bisect with eleven builds later I
have now identified the following candidate commit, which may have
introduced the bug:

dcd989cb73ab0f7b722d64ab6516f101d9f43f88 is the first bad commit
commit dcd989cb73ab0f7b722d64ab6516f101d9f43f88
Author: Tejun Heo <tj@kernel.org>
Date:   Tue Jun 29 10:07:14 2010 +0200

    workqueue: implement several utility APIs

    Implement the following utility APIs.

     workqueue_set_max_active() : adjust max_active of a wq
     workqueue_congested()              : test whether a wq is contested
     work_cpu()                 : determine the last / current cpu of a work
     work_busy()                        : query whether a work is busy

    * Anton Blanchard fixed missing ret initialization in work_busy().

    Signed-off-by: Tejun Heo <tj@kernel.org>
    Cc: Anton Blanchard <anton@samba.org>

:040000 040000 8b7443c650f0af36f1deba560586a91f6a88abcc
065589a95857a2fb73b94dc242c50ba558179a2a M      include
:040000 040000 84ca2de78af16483fa60a423f4f2d6eee0279eed
27487850f11a1e7ee9e4eaac54fd88f16d420d47 M      kernel

Brief summary for Tejun: Starting with this commit my system (x86_64,
4 CPUs) sporadically (probability around 25%) fails to suspend due to
a soft lockup. Full details at:
  https://lkml.org/lkml/2011/4/4/116
or:
  <BANLkTi=n4jLsjOYCd0L3hYb30sgPmdv_WA@mail.gmail.com>

I'd appreciate your help to resolve this issue and would be glad to
test any candidate patches.

Thanks,
Thilo
