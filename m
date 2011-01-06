Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab1AFFZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 00:25:57 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31189 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab1AFFZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 00:25:56 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6217"; a="69226787"
Message-ID: <4D255263.7040106@codeaurora.org>
Date: Wed, 05 Jan 2011 21:25:55 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: mm: Poison freed init memory
References: <1294256845-29517-1-git-send-email-sboyd@codeaurora.org> <20110105202645.GL8638@n2100.arm.linux.org.uk>
In-Reply-To: <20110105202645.GL8638@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2011 12:26 PM, Russell King - ARM Linux wrote:
> On Wed, Jan 05, 2011 at 11:47:25AM -0800, Stephen Boyd wrote:
>> Poisoning __init marked memory can be useful when tracking down
>> obscure memory corruption bugs. When a pointer is 0xCCCCCCCC in an
>
> That's a bad idea for a value.  With a 3GB page offset and 256MB or
> more memory, accesses to such an address will always succeed.
>
> There's two things to be considered when selecting a possible poison
> value:
>
> 1. what value is guaranteed to provoke an undefined instruction exception?
> 2. what value when used as an address and dereferenced is mostly always
>    going to abort?
>
> 1 for ARM mode implies an 0xe7fXXXfX value.  For Thumb mode 0xdeXX.  We
> use this space for breakpoints.
>
> 2 unfortunately depends on the platform. 

A coworker proposed we use a SWI instruction. We could do that if the
poison is 0xEF and then do something in the SWI handler where that
number causes us to blow up?

If I'm following correctly, point 1 is about __init functions and point
2 is about __initdata. I'm more concerned about __initdata because
__init functions called from non __init marked functions are usually
caught with section mismatch checks. Also, if we're jumping to
0xCCCCCCCC we're probably not in the text section of the kernel with a
3GB offset anymore, right? __initdata is easier to reference from
anywhere (ignoring function pointers) and it would definitely be nice to
find those invalid accesses quicker. For point 2, perhaps an unaligned
access would trigger sometimes?

Swapping the cheese for some cheese flavored poison is better than nothing.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

