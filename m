Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab0DCUlX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 16:41:23 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:34108 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585Ab0DCUlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 16:41:16 -0400
Date: Sat, 3 Apr 2010 23:41:18 +0300 (EEST)
From: Aaro Koskinen <aaro.koskinen@iki.fi>
X-X-Sender: aaro@loser
To: Andrew Morton <akpm@linux-foundation.org>
cc: Aaro Koskinen <aaro.koskinen@iki.fi>, linux-kernel@vger.kernel.org,
       hsweeten@visionengravers.com, hpa@zytor.com, eric.piel@tremplin-utc.net,
       stable <stable@kernel.org>
Subject: Re: [PATCH] initramfs: prevent buffer overflow when unpacking to
 rootfs
In-Reply-To: <20100402145702.fb9ccfdc.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.1004032332520.22263@loser>
References: <1270115146-25342-1-git-send-email-aaro.koskinen@iki.fi> <20100402145702.fb9ccfdc.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Apr 2010, Andrew Morton wrote:
> On Thu,  1 Apr 2010 12:45:46 +0300
> Aaro Koskinen <aaro.koskinen@iki.fi> wrote:
>
>> Garbage in the initrd memory area may result in the unpack routine
>> accessing memory outside the buffer. The patch adds a check that the
>> specified area size is not exceeded.
>>
>> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
>> Cc: stable <stable@kernel.org>
>> ---
>>
>> The patch prevents the following kernel panic on Amstrad E3:
>>
>> 	Unpacking initramfs...
>> 	Unable to handle kernel paging request at virtual address c20121a7
>>
>> ...
>>
>> --- a/init/initramfs.c
>> +++ b/init/initramfs.c
>> @@ -460,6 +460,8 @@ static char * __init unpack_to_rootfs(char *buf, unsigned len)
>>  		}
>>  		if (state != Reset)
>>  			error("junk in compressed archive");
>> +		if (my_inptr >= len)
>> +			break;
>>  		this_header = saved_offset + my_inptr;
>>  		buf += my_inptr;
>>  		len -= my_inptr;
>
> OK, so if I'm understanding this right, the call to
>
> 	decompress(buf, len, NULL, flush_buffer, NULL, &my_inptr, error);
>
> has gone and generated more output data than it was asked to generate?
>
> If so, isn't that a bug in the decompressor?  Which one is your system using?

The decompressor is gzip, and it returned correct buffer position.

The problem was that the loop in unpack_to_rootfs() continued
to process the remaining buffer. my_inptr was never again updated
(decompress_method() did not recognize the remaining garbage data, so
there was no further calls to decompressor). The loop kept subtracting
my_inptr from len eventually exceeding it. Perhaps there should be some
better logic to give up earlier.

A.
