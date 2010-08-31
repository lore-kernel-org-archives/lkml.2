Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab0HaUbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 16:31:11 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52286 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab0HaUbK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 16:31:10 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1008301114460.10316@router.home>
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>
	<1281374816-904-4-git-send-email-ngupta@vflare.org>
	<alpine.DEB.2.00.1008301114460.10316@router.home>
Date: Tue, 31 Aug 2010 16:31:08 -0400
Message-ID: <AANLkTikdhnr12uU8Wp60BygZwH770RBfxyfLNMzUsQje@mail.gmail.com>
Subject: Re: [PATCH 03/10] Use percpu stats
From: Nitin Gupta <ngupta@vflare.org>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 12:20 PM, Christoph Lameter <cl@linux.com> wrote:
> On Mon, 9 Aug 2010, Nitin Gupta wrote:
>
>> -static void zram_stat_inc(u32 *v)
>> +static void zram_add_stat(struct zram *zram,
>> +                     enum zram_stats_index idx, s64 val)
>>  {
>> -     *v = *v + 1;
>> +     struct zram_stats_cpu *stats;
>> +
>> +     preempt_disable();
>> +     stats = __this_cpu_ptr(zram->stats);
>> +     u64_stats_update_begin(&stats->syncp);
>> +     stats->count[idx] += val;
>> +     u64_stats_update_end(&stats->syncp);
>> +     preempt_enable();
>
> Maybe do
>
> #define zram_add_stat(zram, index, val)
>                this_cpu_add(zram->stats->count[index], val)
>
> instead? It creates an add in a single "atomic" per cpu instruction and
> deals with the fallback scenarios for processors that cannot handle 64
> bit adds.
>
>

Yes, this_cpu_add() seems sufficient. I can't recall why I used u64_stats_*
but if it's not required for atomic access to 64-bit then why was it added to
the mainline in the first place?

Thanks,
Nitin
