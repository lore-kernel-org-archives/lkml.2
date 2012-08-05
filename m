Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab2HEASf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 20:18:35 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:46112 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab2HEASe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 20:18:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAMbhsRSboLABOD8eX4czk8FsG3QmT60RTr+znVCqwWR6ZGhgaw@mail.gmail.com>
References: <1343184588-20239-1-git-send-email-ccross@android.com>
	<CACRpkdZv4p+QT3Y+=-xh5iJ=sr1_aahroxQ535QpzVD9e_ESJA@mail.gmail.com>
	<20120727233829.GB14835@n2100.arm.linux.org.uk>
	<CAMbhsRSGYmu=eyqik23cECsJPfpo6rUqZUa853nkY35XRo4Q_w@mail.gmail.com>
	<CAMbhsRQg4pETrM7cx+aSBzGn3S1LV_x7vo8X3A300vCWTjkFng@mail.gmail.com>
	<CAMbhsRSboLABOD8eX4czk8FsG3QmT60RTr+znVCqwWR6ZGhgaw@mail.gmail.com>
Date: Sun, 5 Aug 2012 02:18:33 +0200
Message-ID: <CACRpkdbY9E6R+fohGsrEHcmeQJUf3m4duVMC=N5=+Q15a6_gjw@mail.gmail.com>
Subject: Re: [RFC v2] ARM: sched_clock: update epoch_cyc on resume
From: Linus Walleij <linus.walleij@linaro.org>
To: Colin Cross <ccross@android.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Barry Song <21cnbao@gmail.com>,
        Vaibhav Bedia <vaibhav.bedia@ti.com>, Krzysztof Halasa <khc@pm.waw.pl>,
        Nicolas Pitre <nico@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 3, 2012 at 3:28 AM, Colin Cross <ccross@android.com> wrote:
> On Fri, Jul 27, 2012 at 8:30 PM, Colin Cross <ccross@android.com> wrote:
>> On Fri, Jul 27, 2012 at 6:15 PM, Colin Cross <ccross@android.com> wrote:
>>> That patch was merged in 3.4, and my patch is on top of it.  Your
>>> patch updates epoch_cyc and epoch_ns in suspend, but if the first call
>>> to cyc_to_sched_clock after resume gets cyc = 0, cyc - epoch_cyc can
>>> be negative, although it will be cast back to a large positive number.
>>>
>>> With my patch, epoch_cyc is updated in resume to whatever
>>> read_sched_clock() returns, and epoch_ns is still set to the suspend
>>> value, so it appears that sched_clock has not changed between
>>> sched_clock_suspend and sched_clock_resume.  It will work with any
>>> timer behavior (reset to 0, reset to random value, or continuing
>>> counting).  The old setup_sched_clock function maintains the old
>>> behavior to appease those who like their 32kHz sched clock to continue
>>> ticking in suspend, although I think it is more correct for all sched
>>> clocks to be faster than 32 kHz (when possible) and stop in suspend.
>>
>> I think the existing code can cause sched_clock to go backwards if the
>> register read by the read function resets to 0 in suspend:
>>
>> In sched_clock_suspend epoch_cyc is updated to 0x00002000.
>>
>> The first sched_clock call after resume gets cyc = 0, returning
>> epoch_ns + cyc_to_ns(0xffffe000)
>>
>> Later, sched_clock gets cyc = 0x5000, returning epoch_ns +
>> cyc_to_ns(0x3000), which will be much smaller than the previous
>> sched_clock value.
>
> Russell, any update on this?  Should sched_clock.c handle read
> functions that go backwards in suspend, or should I modify the read
> function to track an offset in suspend and always return a
> monotonically increasing value across suspend?

Colin, I suggest you put this into Russell's patch tracker so
he can keep track of it from there.

Yours,
Linus Walleij
