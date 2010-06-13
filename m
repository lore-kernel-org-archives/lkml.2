Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab0FMUAv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 16:00:51 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57461 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab0FMUAu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 16:00:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=tQtig5czmmBIu5Wo8KD+hAG5zWPg52lbjMSDZFMJFH4NDqMRDv9nhsxqqdtHvi2sKN
         emPvpUyZ+sIRz1OSgkjFPpJsP4ATi26aDdk1vPlVboN9yRn5Jno6Y+y/nCYzNS9yzFmv
         MYewhL2aTjvjqFqz1Wk73vh7Jx1riowB394wQ=
MIME-Version: 1.0
In-Reply-To: <20100613194949.GC8055@thunk.org>
References: <E1OMQ88-0002a1-Gb@closure.thunk.org>
	<AANLkTilqc0jpwnIwe3OIQvB9avaXXzrBK4Hz0huESygy@mail.gmail.com>
	<20100613194949.GC8055@thunk.org>
Date: Mon, 14 Jun 2010 06:00:49 +1000
Message-ID: <AANLkTilQLk7ofSJBm9KIa2g1KQ35GC1D1vOZlPrv1VRv@mail.gmail.com>
Subject: Re: Why is kslowd accumulating so much CPU time?
From: Dave Airlie <airlied@gmail.com>
To: tytso@mit.edu, Dave Airlie <airlied@gmail.com>,
       Dave Airlie <airlied@redhat.com>, David Howells <dhowells@redhat.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 5:49 AM,  <tytso@mit.edu> wrote:
> On Sun, Jun 13, 2010 at 06:23:45PM +1000, Dave Airlie wrote:
>>
>> Its an output polling feature of KMS, however it shouldn't cause
>> disruption elsewhere, but we are holding a mutex in there that there
>> isn't a real need to hold, so I suspect I'll drop that.
>
>> What GPU is it?
>
> It's a Lenovo T400, with an Intel GPU:
>
> (--) PCI:*(0:0:2:0) 8086:2a42:17aa:20e4 Intel Corporation Mobile 4 Series Chipse
> t Integrated Graphics Controller rev 7, Mem @ 0xf4400000/4194304, 0xd0000000/268
> 435456, I/O @ 0x00001800/8
>
> Why does KMS need to poll so frequently?  40 minutes of CPU time
> accumulated in 4 hours of uptime translates to 16% of the CPU being
> consumed by kslowd daemons, which seems... excessive.
>
> I've seen upgraded the userspace to Ubuntu Lucid (from Karmic) and the
> kernel to a post 2.6.35-rc2 (without the vt memory corruptor), and
> after 4 days, 5 hours of uptime, and I'm seeing something better:
>
> root      6390  4.7  0.0      0     0 ?        S<   Jun12  49:12 [kslowd001]
> root      6784  2.4  0.0      0     0 ?        S<   Jun09 150:50 [kslowd003]
> root     20047  2.7  0.0      0     0 ?        S<   Jun10 122:38 [kslowd002]
> root     32324  4.6  0.0      0     0 ?        S<   Jun12  49:54 [kslowd000]
>
> So that's 372 minutes of CPU time accumulated by kslowd in 6060
> minutes, or about 6% of the CPU --- but part of tha time the laptop
> was suspended --- and it still seems high.
>
> I have the following patch which I'm going to install later tonight to
> see if I can figure out if it really is drm_crtc_helper.c which is
> really responsible for all of the kslowd time being burned, but an
> examination of the source doesn't seem to show any other that I'm
> using that would likely be using the slow workqueue.

It most likely is, but polling shouldn't really be taking huge amounts
of CPU, unless there are some u/mdelays in there which would be bad.

In theory on Intel with hotplug irqs we shouldn't be poilling at all,
I must check why, the other thing is you could be suffering from the
hotplug irq problem that others have reported, this would cause slow
work triggers which aren't part of the normal poll cycle.

Dave.
