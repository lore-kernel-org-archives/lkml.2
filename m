Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab1IBXvs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 19:51:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751459Ab1IBXvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 19:51:47 -0400
Date: Fri, 2 Sep 2011 16:51:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bob Pearson <rpearson@systemfabricworks.com>
Cc: linux-kernel@vger.kernel.org, fzago@systemfabricworks.com,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        George Spelvin <linux@horizon.com>
Subject: Re: [PATCH v6 03/10] crc32-replace-self-test.diff
Message-Id: <20110902165138.927100ce.akpm@linux-foundation.org>
In-Reply-To: <4E5EB5E6.3040202@systemfabricworks.com>
References: <20110831213729.395283830@systemfabricworks.com>
	<4E5EB5E6.3040202@systemfabricworks.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Aug 2011 17:29:58 -0500
Bob Pearson <rpearson@systemfabricworks.com> wrote:

> Replaced the unit test provided in crc32.c, which doesn't have a
> makefile and doesn't compile with current headers, with a simpler
> self test routine that also gives a measure of performance and
> runs at module init time. The self test option can be enabled
> through a configuration option CONFIG_CRC32_SELFTEST.
> 
> The test stresses the pre and post loops and is thus not very
> realistic since actual uses will likely have addresses and lengths
> that are at least 4 byte aligned. However, the main loop is long
> enough so that the performance is dominated by that loop.
> 
> The expected values for crc32_le and crc32_be were generated
> with the original version of crc32.c using CRC_BITS_LE = 8 and
> CRC_BITS_BE = 8. These values were then used to check all the
> values of the BITS parameters in both the original and new versions.
> 
> The performance results show some variability from run to run
> in spite of attempts to both warm the cache and reduce the amount
> of OS noise by limiting interrutps during the test. To get comparable
> results and to analyse options wrt performance the best time
> reported over a small sample of runs has been taken.
> 

I don't object to a self-test which actually works, but it seems pretty
lame that the self-test exists in kernel mode when it is so simple to
prepare a much more useful and powerful correctness/performance test
harness in userspace.

> ...
>
> -static u32 test_step(u32 init, unsigned char *buf, size_t len)
> -{
> -	u32 crc1, crc2;
> -	size_t i;
> +		crc ^= crc32_be(test[i].crc, test_buf +
> +		    test[i].start, test[i].length);
> +	}
>  
> -	crc1 = crc32_be(init, buf, len);
> -	store_be(crc1, buf + len);
> -	crc2 = crc32_be(init, buf, len + 4);
> -	if (crc2)
> -		printf("\nCRC cancellation fail: 0x%08x should be 0\n",
> -		       crc2);
> -
> -	for (i = 0; i <= len + 4; i++) {
> -		crc2 = crc32_be(init, buf, i);
> -		crc2 = crc32_be(crc2, buf + i, len + 4 - i);
> -		if (crc2)
> -			printf("\nCRC split fail: 0x%08x\n", crc2);
> +	/* reduce OS noise */

This comment is useless.

> +	local_irq_save(flags);
> +	local_irq_disable();

local_irq_save() already does local_irq_disable().

local_irq_disable() doesn't protect against actions of other CPUs.  I'd
know if this was a bug if the comment wasn't useless :)

> +	getnstimeofday(&start);
> +	for (i = 0; i < 100; i++) {
> +		if (test[i].crc_le != crc32_le(test[i].crc, test_buf +
> +		    test[i].start, test[i].length))
> +			errors++;
> +
> +		if (test[i].crc_be != crc32_be(test[i].crc, test_buf +
> +		    test[i].start, test[i].length))
> +			errors++;
>  	}
> ...
