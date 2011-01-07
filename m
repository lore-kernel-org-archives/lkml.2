Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab1AGWfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:35:34 -0500
Received: from smtp-out.google.com ([216.239.44.51]:54174 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab1AGWfd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:35:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kai/OQU+78Tfonw7l1lHz/R5YyuoQ/SXFLzYpvgCeTneC5FDLpUtZ/BYNSVpjbw6qA
         KSERr0nBnKTkdRUKFshA==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1101071416450.23577@chino.kir.corp.google.com>
References: <65795E11DBF1E645A09CEC7EAEE94B9C3A30A295@USINDEVS02.corp.hds.com>
	<alpine.DEB.2.00.1101071416450.23577@chino.kir.corp.google.com>
Date: Fri, 7 Jan 2011 14:35:29 -0800
Message-ID: <AANLkTikQPXWkEJwN5fV2vnUS37Fs+GNzFXuFkKXcnzmu@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/2] Tunable watermark
From: Ying Han <yinghan@google.com>
To: David Rientjes <rientjes@google.com>
Cc: Satoru Moriya <satoru.moriya@hds.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Randy Dunlap <rdunlap@xenotime.net>, dle-develop@lists.sourceforge.net,
        Seiji Aguchi <seiji.aguchi@hds.com>, Ying Han <yinghan@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 7, 2011 at 2:23 PM, David Rientjes <rientjes@google.com> wrote:
> On Fri, 7 Jan 2011, Satoru Moriya wrote:
>
>> This patchset introduces a new knob to control each watermark
>> separately.
>>
>> [Purpose]
>> To control the timing at which kswapd/direct reclaim starts(ends)
>> based on memory pressure and/or application characteristics
>> because direct reclaim makes a memory alloc/access latency worse.
>> (We'd like to avoid direct reclaim to keep latency low even if
>>  under the high memory pressure.)
>>
>> [Problem]
>> The thresholds kswapd/direct reclaim starts(ends) depend on
>> watermark[min,low,high] and currently all watermarks are set
>> based on min_free_kbytes. min_free_kbytes is the amount of
>> free memory that Linux VM should keep at least.
>>
>
> Not completely, it also depends on the amount of lowmem (because of the
> reserve setup next) and the amount of memory in each zone.
>
>> This means the difference between thresholds at which kswapd
>> starts and direct reclaim starts depends on the amount of free
>> memory.
>>
>> On the other hand, the amount of required memory depends on
>> applications. Therefore when it allocates/access memory more
>> than the difference between watemark[low] and watermark[min],
>> kernel sometimes runs direct reclaim before allocation and
>> it makes application latency bigger.
>>
>> [Solution]
>> To avoid the situation above, this patch set introduces new
>> tunables /proc/sys/vm/wmark_min_kbytes, wmark_low_kbytes and
>> wmark_high_kbytes. Each entry controls watermark[min],
>> watermark[low] and watermark[high] separately.
>> By using these parameters one can make the difference between
>> min and low bigger than the amount of memory which applications
>> require.
>>
>
> I really dislike this because it adds additional tunables that should
> already be handled correctly by the VM and it's very difficult for users
> to know what to tune these values to; these watermarks (with the exception
> of min) are supposed to be internal to the VM implementation.
>
> You didn't mention why it wouldn't be possible to modify
> setup_per_zone_wmarks() in some way for your configuration so this happens
> automatically.  If you can find a deterministic way to set these
> watermarks from userspace, you should be able to do it in the kernel as
> well based on the configuration.
>
> I think we should invest time in making sure the VM works for any type of
> workload thrown at it instead of relying on userspace making lots of
> adjustments.

I agree in general that adding the APIs to each wmarks sounds like a
over-kill, and
hard for user to configure most of the time.

On the other hand, having the low/high wmark consider more characters
other than the
size of the zone sounds useful. But I am not sure how to approach that
entirely in the
kernel if we like the reclaim behavior to be reflected from the
different workload.

--Ying

>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom policy in Canada: sign http://dissolvethecrtc.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
