Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933614Ab0GOPoc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 11:44:32 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:18591 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933418Ab0GOPo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 11:44:29 -0400
Message-ID: <4C3F2CDD.80807@caviumnetworks.com>
Date: Thu, 15 Jul 2010 08:44:29 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Don't try to read unmapped memory.
References: <1279145530-782-1-git-send-email-ddaney@caviumnetworks.com>
In-Reply-To: <1279145530-782-1-git-send-email-ddaney@caviumnetworks.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jul 2010 15:44:29.0561 (UTC) FILETIME=[9CAC0690:01CB2434]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one isn't correct.  It prevents the crash, but also can cause many 
trace records to be omitted.  I will try to come up with a new patch for 
the problem I see.

David Daney


On 07/14/2010 03:12 PM, David Daney wrote:
> When tracecmd_peek_data() reads the last event by calling
> translate_data(), it will get type_len = 0, length = -4.  It had to
> read 8 bytes of data, but it adjusts the index by -4, for a net
> increment of 4.  The invariant that the index points to an entire
> event ceases to hold.
>
> If the index were already at the last event in the mapped area, a
> subsequent tracecmd_peek_data() checks that the index is not beyond
> the end of the mapping (which it isn't), but it assumes that the
> entire event will fit (which it doesn't).  It then attempts to read an
> entire event (8 bytes), but the last 4 bytes are now beyond the end of
> the mapping causing a fault.
>
> My fix is to keep the index pointing at the last record when the
> negative length is encountered.
>
> On my x86_64 workstation, the mappings of the trace data were always
> contiguous with other mapped memory, so the reading of 4 bytes past the
> end of the mapping always fell on another piece of mapped memory, so
> no fault was produced.  Running under valgrind or on a MIPS64 host was
> necessary to produce the fault.
>
> Signed-off-by: David Daney<ddaney@caviumnetworks.com>
> ---
>   trace-input.c |   12 ++++++++++++
>   1 files changed, 12 insertions(+), 0 deletions(-)
>
> diff --git a/trace-input.c b/trace-input.c
> index 398d0f9..2ba346d 100644
> --- a/trace-input.c
> +++ b/trace-input.c
> @@ -1530,6 +1530,18 @@ read_again:
>
>   	type_len = translate_data(handle,&ptr,&extend,&length);
>
> +	if (length<  0) {
> +		/*
> +		 * Negative length indicates the end.  Back up ptr so
> +		 * subsequent reads don't fall off the end of the
> +		 * mapping.
> +		 */
> +		ptr -= 8;
> +		handle->cpu_data[cpu].index = calc_index(handle, ptr, cpu);
> +		handle->cpu_data[cpu].next = NULL;
> +		return NULL;
> +	}
> +
>   	switch (type_len) {
>   	case RINGBUF_TYPE_PADDING:
>   		if (!extend) {

