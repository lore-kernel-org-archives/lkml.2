Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab0I1PCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 11:02:24 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:4116 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755152Ab0I1PCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 11:02:23 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 0,
X-WSS-ID: 0L9GPNS-01-0JF-02
X-M-MSG: 
Date: Tue, 28 Sep 2010 16:59:54 +0200
From: Robert Richter <robert.richter@amd.com>
To: Huang Ying <ying.huang@intel.com>
CC: huang ying <huang.ying.caritas@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2 4/7] x86, NMI, Rewrite NMI handler
Message-ID: <20100928145953.GC13563@erda.amd.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
 <1285549026-5008-4-git-send-email-ying.huang@intel.com>
 <20100927094136.GB32222@erda.amd.com>
 <AANLkTimTg1uqXdAJ+GyZ3_B6n2xKWdqFL96jvv18JBM+@mail.gmail.com>
 <20100927132537.GO13563@erda.amd.com>
 <1285635832.20791.119.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1285635832.20791.119.camel@yhuang-dev>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.09.10 21:03:52, Huang Ying wrote:
> Use priority to enforce the order has some issues except what Don
> pointed out (two registers for two call in chain):
> 
> - Almost all direct call in default_do_nmi() must be turned into
> notifier_block. I know this is what you want. But I am not a big fan of
> notifier chain :)
> 
> - This makes order of notifier call more implicitly. And I think the
> order is important for NMI handler to work properly.
> 
> - In your scheme, both die_val (DIE_NMI or DIE_NMI_UNKNOWN) and priority
> are used to determine the order of call. This makes code more complex
> and no additional benefit.
> 
> So I think it is better to use different die_val to determine the order,
> and insert some direct call between them.

Huang,

registering a notifier is the only clean way to add an NMI handler.
Modifying the NMI control flow in traps.c with global flags is not the
right approach. Currently, execution order depends on die_val, this is
not obvious when reading the code and we all were wondering in the
beginning why there was DIE_NMI, DIE_NMI_IPI and DIE_NMI_UNKNOWN, etc.

So, better we say instead, this is the notifier function with that
priority, add it to the call chain. With priorities we are able to
clearly specify the execution order even more fine grained than
now. And, code in traps.c will become fairly easy. Also, we don't need
two notifiers, because there is no need for different priorities
then. Give me one use case, I don't know of any.

And the setup of a notifier is not that much overhead or complex, sure
we need to change the code, but actually this the work to be done to
clean it up.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

