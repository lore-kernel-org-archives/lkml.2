Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab1CBM7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 07:59:13 -0500
Received: from smtp.nokia.com ([147.243.1.48]:60361 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756482Ab1CBM7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 07:59:12 -0500
Date: Wed, 2 Mar 2011 14:55:13 +0200 (EET)
From: Aaro Koskinen <aaro.koskinen@nokia.com>
X-X-Sender: aakoskin@esdhcp041196.research.nokia.com
To: linux-mm@kvack.org
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, stable@kernel.org,
        Aaro Koskinen <aaro.koskinen@nokia.com>
Subject: Re: [PATCH] procfs: fix /proc/<pid>/maps heap check
In-Reply-To: <1298996813-8625-1-git-send-email-aaro.koskinen@nokia.com>
Message-ID: <alpine.DEB.1.10.1103021449000.27610@esdhcp041196.research.nokia.com>
References: <1298996813-8625-1-git-send-email-aaro.koskinen@nokia.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 1 Mar 2011, Aaro Koskinen wrote:
> The current check looks wrong and prints "[heap]" only if the mapping
> matches exactly the heap. However, the heap may be merged with some
> other mappings, and there may be also be multiple mappings.
>
> Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
> Cc: stable@kernel.org

Below is a test program and an example output showing the problem,
and the correct output with the patch:

Without the patch:

 	# ./a.out &
 	# cat /proc/$!/maps | head -4
 	00008000-00009000 r-xp 00000000 01:00 9224       /a.out
 	00010000-00011000 rw-p 00000000 01:00 9224       /a.out
 	00011000-00012000 rw-p 00000000 00:00 0
 	00012000-00013000 rw-p 00000000 00:00 0

With the patch:

 	# ./a.out &
 	# cat /proc/$!/maps | head -4
 	00008000-00009000 r-xp 00000000 01:00 9228       /a.out
 	00010000-00011000 rw-p 00000000 01:00 9228       /a.out
 	00011000-00012000 rw-p 00000000 00:00 0          [heap]
 	00012000-00013000 rw-p 00000000 00:00 0          [heap]

The test program:

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>

int main (void)
{
 	if (sbrk(4096) == (void *)-1) {
 		perror("first sbrk(): ");
 		return EXIT_FAILURE;
 	}

 	if (mlockall(MCL_FUTURE)) {
 		perror("mlockall(): ");
 		return EXIT_FAILURE;
 	}

 	if (sbrk(4096) == (void *)-1) {
 		perror("second sbrk(): ");
 		return EXIT_FAILURE;
 	}

 	while (1)
 		sleep(1);
}
