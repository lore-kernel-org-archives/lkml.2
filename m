Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab1BROdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 09:33:31 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:33758 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab1BROd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 09:33:28 -0500
Authentication-Results: sj-iport-3.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAHIRXk2rRN+K/2dsb2JhbACEH6IDc6BIinuQPoEng0F2BIULhwaDOoIa
X-IronPort-AV: E=Sophos;i="4.62,187,1297036800"; 
   d="scan'208";a="265823532"
Message-ID: <4D5E8338.8010602@cisco.com>
Date: Fri, 18 Feb 2011 07:33:28 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, acme@ghostprotocols.net, paulus@samba.org
Subject: Re: [PATCH 1/3] perf events: fix WARN_ON_ONCE for 64-bit raw data,
 SW events
References: <1298008433-22911-1-git-send-email-daahern@cisco.com>	 <1298008433-22911-2-git-send-email-daahern@cisco.com> <1298026821.5226.642.camel@laptop>
In-Reply-To: <1298026821.5226.642.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/18/11 04:00, Peter Zijlstra wrote:
> On Thu, 2011-02-17 at 22:53 -0700, David Ahern wrote:
>> This check does not work out for 64-bit counter:
>>
>>     sizeof(u32) + sizeof(u64) = 4 + 8 = 12
>>
>> which does not pass the WARN_ON_ONCE test. I'm guessing (hoping
>> really) that the intent is that the size of the raw data is a
>> multiple of 4 bytes, not 8.
> 
> No the data must come in 8bytes strides.
> 

Then the sizeof the size field needs to be moved to u64; right now it is
u32:

struct perf_raw_record {
    u32             size;
    void                *data;
};

So size should be changed to u64 rather than modifying the WARN_ON_ONCE?


Another gotcha is in perf_output_sample there is:
            struct {
                u32 size;
                u32 data;
            } raw = {
                .size = sizeof(u32),
                .data = 0,
            };

While that meets the 8-byte stride I was concerned that changing the
size field to u64 breaks ABI.

David
