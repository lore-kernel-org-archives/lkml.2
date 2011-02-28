Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab1B1TUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 14:20:17 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56827 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab1B1TUO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 14:20:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=N+P+IO9n5Ltgnsoh0DClE2ITVDvmDrnjUC758VLhCSkoVp/S2rhURAZVY1VTjpSr5E
         IxF2yKSD7RTkZM/dVucvIIwrsHCnjQsxeH8Bou39DLDntyJKoUa4ZK13DLyCbzO0lIzx
         PPY+tKq/PuJIBcBfyVjApky89r6D7yJc9LbDg=
MIME-Version: 1.0
In-Reply-To: <20110228080642.GC1600@elte.hu>
References: <20110225180633.857892225@gulag1.americas.sgi.com>
	<20110225180634.017570095@gulag1.americas.sgi.com>
	<20110227120949.GF16453@elte.hu>
	<20110227121518.GA19165@elte.hu>
	<4D6AFBB0.70401@kernel.org>
	<20110228080642.GC1600@elte.hu>
Date: Mon, 28 Feb 2011 11:18:11 -0800
X-Google-Sender-Auth: 91o4maNG3CBfY3THLQ9WleeQLZk
Message-ID: <AANLkTi=odO0pGRdk5=s4qWm6bqej=CdWyS4CTsTWBxEc@mail.gmail.com>
Subject: Re: [PATCH 1/4] printk: Allocate kernel log buffer earlier
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Travis <travis@sgi.com>, David Rientjes <rientjes@google.com>,
        Jack Steiner <steiner@sgi.com>, Robin Holt <holt@sgi.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 12:06 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yinghai@kernel.org> wrote:
>
>> +     new_addr = memblock_alloc(new_log_buf_len, PAGE_SIZE);
>> +     if (new_addr != MEMBLOCK_ERROR)
>> +             new_log_buf = __va(new_addr);
>> +     else
>> +             new_log_buf = alloc_bootmem(new_log_buf_len);
>
> alloc_bootmem() can fail, especially if someone uses a too large boot parameter
> value - and your code does not check for failure.

alloc_bootmem will panic if it fails.

static void * __init ___alloc_bootmem(unsigned long size, unsigned long align,
                                        unsigned long goal, unsigned long limit)
{
        void *mem = ___alloc_bootmem_nopanic(size, align, goal, limit);

        if (mem)
                return mem;
        /*
         * Whoops, we cannot satisfy the allocation request.
         */
        printk(KERN_ALERT "bootmem alloc of %lu bytes failed!\n", size);
        panic("Out of memory");
        return NULL;
}

so it should be ok.
