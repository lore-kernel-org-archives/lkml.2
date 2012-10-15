Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab2JOVRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 17:17:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:62116 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165Ab2JOVRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 17:17:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,590,1344236400"; 
   d="scan'208";a="156466491"
Message-ID: <507C7D76.3010602@intel.com>
Date: Mon, 15 Oct 2012 14:17:42 -0700
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Dmitry Fleytman <dmitry@daynix.com>
CC: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        Chris Webb <chris.webb@elastichosts.com>,
        Richard Davies <richard.davies@elastichosts.com>
Subject: Re: [PATCH] e1000 driver RX race condition fixed
References: <1350235151-11146-1-git-send-email-dmitry@daynix.com> <507C5BC7.1060108@intel.com> <CAGHCxhe=2N8G8v66uZaNDQKyiRVRN11_Lw17mkOdxxrrpXgPHQ@mail.gmail.com> <507C6C13.4000609@intel.com> <CAGHCxhcad=zx7ihX5zoDB=ZOLGGuZty=Bck6zSoMQ-9S3ZJo7w@mail.gmail.com>
In-Reply-To: <CAGHCxhcad=zx7ihX5zoDB=ZOLGGuZty=Bck6zSoMQ-9S3ZJo7w@mail.gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The datasheets for most of the parts are available at:
http://developer.intel.com/products/ethernet/resource.htm

You just need to select one of the parts supported by e1000 and select
either the datasheet or software developers manual depending on the part.

Thanks,

Alex

On 10/15/2012 01:20 PM, Dmitry Fleytman wrote:
> Hello, Alex
>
> Many thanks for clarification. I think your assumption is
> correct and this is exactly what needs to be fixed in QEMU.
>
> Is there any publicly available specification for Intel devices that
> explains their operation in such a great details?
>
> Dmitry.
>
>
> On Mon, Oct 15, 2012 at 10:03 PM, Alexander Duyck
> <alexander.h.duyck@intel.com> wrote:
>> Hello Dmitry,
>>
>> My concern is that on many of our parts the behavior is to initialize
>> both the head and tail to 0, enable Rx for either the ring or device
>> depending on the queue configuration, and then allocate buffers and bump
>> tail to indicate that the new buffers are present.  The reason behind
>> enabling Rx and bumping tail is because that signals the DMA engine to
>> start fetching buffers.  In my experience most of our hardware will
>> ignore the tail bump if it is done first and the Rx is enabled.
>>
>> With both head and tail at the same value it should not be possible for
>> any of the devices to start a DMA.  This is probably what you should be
>> checking for in fixing QEMU/KVM as it may be incorrectly assuming it can
>> fetch the descriptor pointed to by tail.
>>
>> We have your patch in our queue and can test to verify my assumptions
>> are correct.  If they are we will let you know and reject the patch.
>>
>> Thanks,
>>
>> Alex
>>
>>
>>
>> On 10/15/2012 12:44 PM, Dmitry Fleytman wrote:
>>> Hello, Alex
>>>
>>> Originally this bug was reported for virtual machines running on top
>>> of QEMU/KVM.
>>> After patch preparation I've tested it on physical e1000 card and it
>>> worked fine.
>>>
>>> However, it could be I've missed something, as I see now other Intel
>>> drivers (e1000e, ixgb, etc.)
>>> use the same sequence (RX enable and then ring allocate), so I'm
>>> starting to suspect that this is
>>> the correct behavior.
>>>
>>> If you confirm this is the way HW works, the this patch should be
>>> ignored. This is pure QEMU bug and we'll fix it there.
>>>
>>> Thanks,
>>> Dmitry.
>>>
>>> On Mon, Oct 15, 2012 at 8:53 PM, Alexander Duyck
>>> <alexander.h.duyck@intel.com> wrote:
>>>> On 10/14/2012 10:19 AM, Dmitry Fleytman wrote:
>>>>> There is a race condition in e1000 driver.
>>>>> It enables HW receive before RX rings initalization.
>>>>> In case of specific timing this may lead to host memory corruption
>>>>> due to DMA write to arbitrary memory location.
>>>>> Following patch fixes this issue by reordering initialization steps.
>>>>>
>>>>> Other Intel network drivers does not seem to have this issue.
>>>>>
>>>>> Dmitry Fleytman (1):
>>>>>   RX initialization sequence fixed - enable RX after corresponding ring
>>>>>     initialization only
>>>>>
>>>>>  drivers/net/ethernet/intel/e1000/e1000_ethtool.c |    9 +++++----
>>>>>  drivers/net/ethernet/intel/e1000/e1000_main.c    |   18 ++++++++++++++++--
>>>>>  2 files changed, 21 insertions(+), 6 deletions(-)
>>>>>
>>>> What device was it you saw this issue with?  The reason why I ask is
>>>> because I suspect this change should cause most of our e1000 hardware to
>>>> lock up since normally if you allocate buffers and then enable Rx it
>>>> will mean the ring was not updated and it will treat it as if there are
>>>> no buffers available.
>>>>
>>>> Thanks,
>>>>
>>>> Alex
>
>

