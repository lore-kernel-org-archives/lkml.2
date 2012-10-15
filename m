Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab2JOToZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 15:44:25 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:54968 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab2JOToY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 15:44:24 -0400
MIME-Version: 1.0
X-Originating-IP: [91.205.155.63]
In-Reply-To: <507C5BC7.1060108@intel.com>
References: <1350235151-11146-1-git-send-email-dmitry@daynix.com>
	<507C5BC7.1060108@intel.com>
Date: Mon, 15 Oct 2012 21:44:23 +0200
Message-ID: <CAGHCxhe=2N8G8v66uZaNDQKyiRVRN11_Lw17mkOdxxrrpXgPHQ@mail.gmail.com>
Subject: Re: [PATCH] e1000 driver RX race condition fixed
From: Dmitry Fleytman <dmitry@daynix.com>
To: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        Chris Webb <chris.webb@elastichosts.com>,
        Richard Davies <richard.davies@elastichosts.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alex

Originally this bug was reported for virtual machines running on top
of QEMU/KVM.
After patch preparation I've tested it on physical e1000 card and it
worked fine.

However, it could be I've missed something, as I see now other Intel
drivers (e1000e, ixgb, etc.)
use the same sequence (RX enable and then ring allocate), so I'm
starting to suspect that this is
the correct behavior.

If you confirm this is the way HW works, the this patch should be
ignored. This is pure QEMU bug and we'll fix it there.

Thanks,
Dmitry.

On Mon, Oct 15, 2012 at 8:53 PM, Alexander Duyck
<alexander.h.duyck@intel.com> wrote:
> On 10/14/2012 10:19 AM, Dmitry Fleytman wrote:
>> There is a race condition in e1000 driver.
>> It enables HW receive before RX rings initalization.
>> In case of specific timing this may lead to host memory corruption
>> due to DMA write to arbitrary memory location.
>> Following patch fixes this issue by reordering initialization steps.
>>
>> Other Intel network drivers does not seem to have this issue.
>>
>> Dmitry Fleytman (1):
>>   RX initialization sequence fixed - enable RX after corresponding ring
>>     initialization only
>>
>>  drivers/net/ethernet/intel/e1000/e1000_ethtool.c |    9 +++++----
>>  drivers/net/ethernet/intel/e1000/e1000_main.c    |   18 ++++++++++++++++--
>>  2 files changed, 21 insertions(+), 6 deletions(-)
>>
>
> What device was it you saw this issue with?  The reason why I ask is
> because I suspect this change should cause most of our e1000 hardware to
> lock up since normally if you allocate buffers and then enable Rx it
> will mean the ring was not updated and it will treat it as if there are
> no buffers available.
>
> Thanks,
>
> Alex
>



-- 
Dmitry Fleytman
Technology Expert and Consultant,

Daynix Computing Ltd.

Cell: +972-54-2819481

Skype: dmitry.fleytman
