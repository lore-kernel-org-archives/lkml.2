Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab2DUUxn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 16:53:43 -0400
Received: from smtp.fullrate.dk ([90.185.1.42]:65012 "EHLO smtp.fullrate.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490Ab2DUUxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 16:53:42 -0400
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Apr 2012 16:53:42 EDT
Message-ID: <4F931C6D.8040407@molgaard.org>
Date: Sat, 21 Apr 2012 22:45:33 +0200
From: =?ISO-8859-1?Q?Sune_M=F8lgaard?= <sune@molgaard.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120421 Firefox/14.0a1 SeaMonkey/2.11a1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Boot failure since 3.3-rc?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiya,

My old AMD Duron system (i386 with 2G RAM) has been unable to boot 
recent kernels, and I have bisected it down to:

commit 321bf4ed5ff5f7c62ef59f33b7eec5b154391f0a
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Mon Jan 30 13:57:12 2012 -0800

     drivers/base/memory.c: fix memory_dev_init() long delay

     One system with 2048g ram, reported soft lockup on recent kernel.

[snip the trace of the bug that this should fix]

     Finally it takes about 55s to create 16400 memory entries.

     Root cause: for x86_64, 2048g (with 2g hole at [2g,4g), and TOP2 
will be 2050g), will have 16400 memory block.

     find_memory_block/subsys_find_device_by_id will be expensive with 
that many entries.

     Actually, we don't need to find that memory block for BOOT path.

     Skip that finding make it get back to normal.

     [   34.466696] cpu_dev_init done
     [   35.290080] memory_dev_init done

     Also solved the delay with topology_init when sections_per_block is 
not 1.

     Signed-off-by: Yinghai Lu <yinghai@kernel.org>
     Cc: Kay Sievers <kay.sievers@vrfy.org>
     Cc: Nathan Fontenot <nfont@austin.ibm.com>
     Cc: Robin Holt <holt@sgi.com>
     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

:040000 040000 95174f8192a2303d9e59e5f8523a58780b828e3e 
2de57c6dc44872ac11766616f1cf05d6070b60de M	drivers

Will be happy to test patches, but compilation is obviously slow on this 
machine, so some delay might occur.

Best regards,

Sune Mølgaard

-- 
To err is human--and to blame it on a computer is even more so.
- Orben - Current Comedy

