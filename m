Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab1A3NT2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 08:19:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753598Ab1A3NT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 08:19:27 -0500
Message-ID: <4D456555.2030606@redhat.com>
Date: Sun, 30 Jan 2011 15:19:17 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com
Subject: Re: [PATCH v2 6/6] Describe KVM_MSR_STEAL_TIME
References: <1296244340-15173-1-git-send-email-glommer@redhat.com> <1296244340-15173-7-git-send-email-glommer@redhat.com>
In-Reply-To: <1296244340-15173-7-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2011 09:52 PM, Glauber Costa wrote:
> This patch adds documentation about usage of the newly
> introduced KVM_MSR_STEAL_TIME.
>
>
> +
> +MSR_KVM_STEAL_TIME: 0x4b564d03
> +
> +	data: 4-byte alignment physical address of a memory area which must be
> +	in guest RAM, plus an enable bit in bit 0.

64-byte aligned:
- avoids wrapping around a page boundary, which may let us optimize 
things later on (see kvm_write_guest_cached()).
- gives us 5 more unused bits to enable more options

>   This memory is expected to
> +	hold a copy of the following structure:
> +
> +	struct kvm_steal_time {
> +	  	__u64 steal;
> + 		__u32 version;
> + 		__u32 flags;
> +	 	__u32 pad[6];
> +	}
> +
> +	whose data will be filled in by the hypervisor periodically. Only one
> +	write, or registration, is needed for each VCPU. The interval between
> +	updates of this structure is arbitrary and implementation-dependent.
> +	The hypervisor may update this structure at any time it sees fit until
> +	anything with bit0 == 0 is written to it.
> +
> +	Fields have the following meanings:
> +
> +		version: guest has to check version before and after grabbing
> +		time information and check that they are both equal and even.
> +		An odd version indicates an in-progress update.
> +
> +		flags: At this point, always zero. May be used to indicate
> +		changes in this structure in the future.
> +
> +		steal: the amount of time in which this vCPU did not run, in
> +		nanoseconds.
> +

The guest must initialize the entire 64-byte structure to zero before 
enabling the feature.

-- 
error compiling committee.c: too many arguments to function

