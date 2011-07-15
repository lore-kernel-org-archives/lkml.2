Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab1GOQCr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 12:02:47 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46650 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab1GOQCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 12:02:46 -0400
Message-ID: <4E2064A2.10807@gmail.com>
Date: Fri, 15 Jul 2011 10:02:42 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org
Subject: Re: [PATCH] perf tools: fix endian conversion reading event attr
 from header
References: <1310483959-23621-1-git-send-email-dsahern@gmail.com> <20110715154711.GB6590@somewhere>
In-Reply-To: <20110715154711.GB6590@somewhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2011 09:47 AM, Frederic Weisbecker wrote:
>> -		if (perf_header__getbuffer64(header, fd, &f_attr, sizeof(f_attr)))
>> +		if (readn(fd, &f_attr, sizeof(f_attr)) <= 0)
>>  			goto out_errno;
>>  
>> +		if (header->needs_swap) {
>> +			f_attr.attr.type = bswap_32(f_attr.attr.type);
>> +			f_attr.attr.size = bswap_32(f_attr.attr.size);
>> +			mem_bswap_64(&f_attr.attr.config,
>> +				     sizeof(struct perf_event_attr) - 8);
>> +		}
>> +
> 
> Good catch!

A long, painful discovery

> But would be nice to also handle the wakeup_events and bp_type fields.
> 

I did not think those values were used in userspace, so did not touch
them. But then your inquiry pushed me into cscope and I found the
perf_event__attr_swap() function. I'll redo the patch leveraging the
swapping done there.

David
