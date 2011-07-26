Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab1GZTkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 15:40:16 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:43742
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753564Ab1GZTkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 15:40:14 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zzbb2dK9371M1432N98dKzz1202hzzz32i668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LOYH9J-01-TKD-02
X-M-MSG: 
Message-ID: <4E2F1889.8030708@amd.com>
Date: Tue, 26 Jul 2011 21:42:01 +0200
From: Andre Przywara <andre.przywara@amd.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.14) Gecko/20101020 Thunderbird/3.0.9
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <bp@amd64.org>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
References: <1311340547-7861-1-git-send-email-bp@amd64.org> <4E2F0068.1080001@redhat.com> <20110726181304.GD32536@aftab> <4E2F0498.8050005@zytor.com> <20110726183721.GF32536@aftab> <4E2F09BB.9060605@zytor.com>
In-Reply-To: <4E2F09BB.9060605@zytor.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2011 08:38 PM, H. Peter Anvin wrote:
> On 07/26/2011 11:37 AM, Borislav Petkov wrote:
>>>
>>> I think the question was the width (and position) for the mask... i.e.
>>> your [14:12] above which *is* magic.
>>
>> Oh, that's easy: family 15h means bits [14:12] - those bits are used for
>> I$ index generation.
>>
>
> In other words, it's completely ad hoc.

There is no need to determine it by calculating, because it caused by 
the special design of the BD L1 cache and thus fixed.
And a calculation would be even more confusing:

The L1I is virtually indexed, but physically tagged.
64KB L1I cache, 64 Bytes per Cacheline = 1024 cache lines
1024 lines / 2 way associative = 512 indexes
64 Bytes per Cacheline (6 bits) + 512 indexes (9 bits) = bits [14:0]
virtual and physical addresses are the same for bits [11:0], which 
leaves the remaining 14:12 susceptible for aliasing.

So bit 12 comes from PAGESIZE and yes, the 14 could be derived from the 
CPUID cache info, but I don't see much value in breaking this down this way.
But I agree that there should be some comment in the patch which at 
least notes that bits [14:12] are due to the L1I design, maybe we can 
copy a nicer version of the above math in the commit message for reference.

Regards,
Andre.

-- 
Andre Przywara
AMD-Operating System Research Center (OSRC), Dresden, Germany

