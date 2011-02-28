Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab1B1TPD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 14:15:03 -0500
Received: from relay1.sgi.com ([192.48.179.29]:54093 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812Ab1B1TO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 14:14:59 -0500
Message-ID: <4D6BF431.1090404@sgi.com>
Date: Mon, 28 Feb 2011 11:14:57 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: David Rientjes <rientjes@google.com>, Jack Steiner <steiner@sgi.com>,
        Robin Holt <holt@sgi.com>, Len Brown <len.brown@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 1/4] printk: Allocate kernel log buffer earlier
References: <20110225180633.857892225@gulag1.americas.sgi.com> <20110225180634.017570095@gulag1.americas.sgi.com> <20110227120949.GF16453@elte.hu>
In-Reply-To: <20110227120949.GF16453@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> On larger systems, because of the numerous ACPI, Bootmem and EFI
>> messages, the static log buffer overflows before the larger one
>> specified by the log_buf_len param is allocated.  Minimize the
>> potential for overflow by allocating the new log buffer as soon
>> as possible.
>>
>> We do this by changing the log_buf_len from an early_param to a
>> _setup param.  But _setup params are processed before the
>> alloc_bootmem is available, so this function will now just save
>> the requested log buf len.  The real work routine (setup_log_buf)
>> is called after bootmem is available.
>>
>> Signed-off-by: Mike Travis <travis@sgi.com>
>> Reviewed-by: Jack Steiner <steiner@sgi.com>
>> Reviewed-by: Robin Holt <holt@sgi.com>
>> ---
>>  arch/x86/kernel/setup.c |    5 +++
>>  include/linux/printk.h  |    4 ++
>>  init/main.c             |    1 
>>  kernel/printk.c         |   75 ++++++++++++++++++++++++++++--------------------
>>  4 files changed, 54 insertions(+), 31 deletions(-)
> 
> Well, the modern allocation method is memblock - available on all major 
> architectures.
> 
> You could avoid all this ugly workaround of bootmem limitations by moving the 
> allocation to memblock_alloc() and desupporting the log_buf_len= boot parameter
> on non-memblock architectures.

Is it really that ugly?  I thought in some ways it cleaned it up.

I'm also hesitant to change code for other arch's when I can't test them.  This
approach seemed to be the safest.

> kernel log buffer size can be configured via the .config so they will not be left 
> without larger buffers.

We have asked about this, but distros are reluctant to increase memory usage
for their entire installed base.  I think we're lucky they bumped it up to 256k
from the default 128k.

> 
> Doing this should also have the advantage of getting all the early x86 messages into 
> the larger buffer already, reducing the pressure to apply some of the other patches 
> in your series.

There are only two and both remove only redundant information.

> 
> Thanks,
> 
> 	Ingo
