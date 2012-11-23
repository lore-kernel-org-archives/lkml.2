Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab2KWUoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 15:44:07 -0500
Received: from ares07.inai.de ([5.9.24.206]:38175 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756046Ab2KWUoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 15:44:05 -0500
Date: Fri, 23 Nov 2012 21:44:02 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: tj@kernel.org, cl@linux-foundation.org
cc: linux-mm@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: percpu section failure with Gold linker
Message-ID: <alpine.LNX.2.01.1211232136380.11359@nerf07.vanv.qr>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


when compiling a kernel with the gold linker (3.7.0-rc6 26d29d06ea0204, 
gcc-4.7 and binutils-2.23 in my case), certain pcpu symbols are 
seemingly errneously copied over from .o files to .ko files, leading to 
a hard warning during depmod:

	gold$ make -j8 LD=gold HOSTLD=gold
	gold$ make modules_install INSTALL_MOD_PATH=/tmp/foo
	[...]
	WARNING: /tmp/foo/lib/modules/3.7.0-rc6-jng6-default+
	/kernel/net/rds/rds_tcp.ko needs unknown symbol
	__pcpu_scope_rds_tcp_stats

This happens with many modules using percpu; looking at things with nm 
reveals:

	gold/net/ipv6$ nm ipv6.o | grep __pcpu_
	0000000000000000 D __pcpu_unique_ipv6_cookie_scratch
	gold/net/ipv6$ nm ipv6.ko | grep __pcpu_
	                 U __pcpu_unique_ipv6_cookie_scratch

On the other hand, in a linux tree built with the original ld (ld.bfd), 
things look like:

	bfd$ make -j8
	[...]
	bfd/net/ipv6$ nm ipv6.o | grep pcpu
	0000000000000000 D __pcpu_unique_ipv6_cookie_scratch
	bfd/net/ipv6$ nm ipv6.ko | grep pcpu
	(no result)
