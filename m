Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab1CURVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 13:21:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35266 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab1CURVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 13:21:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qwfzrtPnWb6VxcWZV671WMAZYOvL7DCXmvUSXA6JQStXNAX500q8irhMl/87Hb8PFD
         mWxFx5VgIOSe/biqn85rMwRhGTiizFtaNURgCuDgoOY6uYeDfouGsZEva3U1nZ+2mTxC
         /hvc/FmbRmjUJfVlYkpa1r0WgMVEu74+8FPzc=
Message-ID: <4D87888D.4050400@gmail.com>
Date: Mon, 21 Mar 2011 20:19:09 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Jack Steiner <steiner@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86, UV: Fix NMI handler for UV platforms
References: <20110321160135.GA31562@sgi.com> <20110321161425.GC23614@elte.hu> <4D877C4B.9090602@gmail.com> <4D878042.9080708@gmail.com> <4D878445.6090709@gmail.com> <20110321170832.GC12718@sgi.com>
In-Reply-To: <20110321170832.GC12718@sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2011 08:08 PM, Jack Steiner wrote:
> On Mon, Mar 21, 2011 at 08:00:53PM +0300, Cyrill Gorcunov wrote:
>> On 03/21/2011 07:43 PM, Cyrill Gorcunov wrote:
>> ...
>>>
>>> I think Jack might need to setup priority for his notifier, like
>>>
>>> static struct notifier_block uv_dump_stack_nmi_nb = {
>>> 	.notifier_call	= uv_handle_nmi,
>>> 	.priority	= NMI_LOCAL_HIGH_PRIOR+1,
>>> };
>>>
>>> so it would be called before perf nmi. Don, am I right?
>>>
>>> Since for perf nmis we do have
>>>
>>> static __read_mostly struct notifier_block perf_event_nmi_notifier = {
>>> 	.notifier_call		= perf_event_nmi_handler,
>>> 	.next			= NULL,
>>> 	.priority		= NMI_LOCAL_LOW_PRIOR,
>>> };
>>>
>>
>>   I must admit I've missed the fact that Jack has tried NMIs priorities, right?
>> x86_platform_ops seems to be a cleaner indeed (btw I think p4 pmu kgdb issue
>> is exactly the same problem) but same time this might end up in over-swelled
>> ideas behind this small code snippet. Dunno. Probably we need some per-cpu
>> system status for nmi reasons other than unknown nmis...
> 
> We use KDB internally, and yes, it has the same issue. The version of the
> patch that uses KDB OR's the "handled" status for both KDB & the UV NMI handler.
> If either KDB or the UV NMI handler returns "handled", the code in traps.c exits
> after the call to the first die notifier.
> 
> Not particularily pretty but I could not find a better way to do it.
> 
> --- jack

  Another option might be to add pre-nmi notifier chain, which of course
not much differ from platform ops but I guess platform ops stands mostly
for one-shot events while chain might be more flexible. Ie I mean something
like

	if (notify_pre_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
		return;

-- 
    Cyrill
