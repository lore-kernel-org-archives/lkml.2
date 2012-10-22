Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab2JVU0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 16:26:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:43442 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756155Ab2JVU0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 16:26:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,631,1344236400"; 
   d="scan'208";a="207637403"
Message-ID: <5085ABEF.3060502@linux.intel.com>
Date: Mon, 22 Oct 2012 13:26:23 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jacob Shin <jacob.shin@amd.com>, Tom Rini <trini@ti.com>, hpa@zytor.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: BUG: 1bbbbe7 (x86: Exclude E820_RESERVED regions...) PANIC on
 boot
References: <903a3ead-98b5-4afa-88a4-3dc723895e82@blur> <d556fc0f-da5d-4531-b331-6dc086461f34@blur> <50833F30.4020802@ti.com> <CAE9FiQWpSvKp=Oh+4Y8OpdOjdRnkYVL2HvNNXc29ESpNsMC0AQ@mail.gmail.com> <20121021041858.GA14809@jshin-Toonie> <50843627.4020103@ti.com> <20121021210633.GA14311@jshin-Toonie> <508467EE.4040807@ti.com> <20121022144020.GA14425@jshin-Toonie> <CAE9FiQWvVNCK8Ka6rq+RMf3u4JFn8D18rGMy4Hpz7Rhnrn6VTA@mail.gmail.com> <20121022183858.GA31185@jshin-Toonie> <CAE9FiQWZmwa6EwsfZzz_e3A-tz2LUS2+i+zh4zpXpR_Jj_FQ1w@mail.gmail.com>
In-Reply-To: <CAE9FiQWZmwa6EwsfZzz_e3A-tz2LUS2+i+zh4zpXpR_Jj_FQ1w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 12:46 PM, Yinghai Lu wrote:
> On Mon, Oct 22, 2012 at 11:38 AM, Jacob Shin <jacob.shin@amd.com> wrote:
>>
>> Does EFI do this on above 4G memory? All the EFI BIOSes we have in house looked
>> to be only touching under 4G.
> 
> I have no idea about it.
> 

I don't think we can rely on what is happening right now anyway.

>>> 2. partial page:
>>>    E820 or user could pass memmap that  is not page aligned.
>>>    old cold will guarded by max_low_pfn and max_pfn. so the end partial
>>>    page will be trimmed down, and memblock can one use it.
>>>    middle partial page will still get covered by directly mapping, and
>>> memblock still can use them.
>>>    Now we will not map middle partial page and memblock still try to use it
>>> we could get panic when accessing those pages.
>>>
>>> So I would suggest to just revert that temporary patch at this time,
>>> and later come out one complete patch for stable kernels.
>>
>> Hm okay, I was hoping not, but if it has to be ..
> 
> It's hpa's call.

So the issue is that two E820 RAM ranges (or ACPI, or kernel-reserved)
are immediately adjacent on a non-page-aligned address?  Or is there a
gap in between and memblock is still expecting to use it?

We should not map a partial page at the end of RAM; it is functionally
lost.  Two immediately adjacent pages could be coalesced, but not a
partial page that abuts I/O space (and yes, such abortions can happen in
the real world.)

However, the issue obviously is that what we can realistically put in
3.7 or stable is limited at this point.

	-hpa



