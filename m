Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab0LPC1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 21:27:16 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:54662 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755154Ab0LPC1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 21:27:12 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAIYHCU15Lc+z/2dsb2JhbACkM3TBfIVKBA
Date: Thu, 16 Dec 2010 00:02:45 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: buggy perf callgraph output
Message-ID: <20101215130245.GA10004@amd>
References: <20101208164015.GA5444@amd>
 <20101208214809.GG1709@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101208214809.GG1709@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 10:48:13PM +0100, Frederic Weisbecker wrote:
> I can not reproduce it. Could you please try to reproduce,
> run perf archive and send me your perf.data.tar.bz2 ?

It seems to be happening all the time, just look further in
callgraphs.

This attached perf.data.bz2 looks like this, when using -g graph

    15.05%        dbench  [kernel.kallsyms]  [k]
copy_user_generic_string
                   |
                   --- copy_user_generic_string
                      |          
                      |---0.16%-- generic_file_aio_read
                      |          do_sync_read
                      |          vfs_read
                      |          |          
                      |           --0.05%-- sys_pread64
                      |                     system_call
                      |                     0x7f64a60bb193
                      |          
                      |--0.10%-- generic_file_buffered_write
                      |          __generic_file_aio_write
                      |          generic_file_aio_write
                      |          do_sync_write
                      |          vfs_write
                      |          sys_pwrite64
                      |          system_call
                      |          0x7f64a60bb203
                      |          0xe01170
                      |          
                       ---0.11%-- dcache_readdir
                                 vfs_readdir
                                 sys_getdents
                                 system_call
                                 0x7f64a60ade65

See, the last element is greater than the second last.

-g fractal looks like this:

    15.05%        dbench  [kernel.kallsyms]  [k]
copy_user_generic_string
                   |
                   --- copy_user_generic_string
                      |          
                      |---1.09%-- generic_file_aio_read
                      |          do_sync_read
                      |          vfs_read
                      |          |          
                      |          |--0.55%-- sys_pread64
                      |          |          system_call
                      |          |          0x7f64a60bb193
                      |          |          
                      |           --2.19%-- sys_read
                      |                     system_call
                      |                     0x7f64a60d3ea0
                      |          
                      |--0.69%-- generic_file_buffered_write
                      |          __generic_file_aio_write
                      |          generic_file_aio_write
                      |          do_sync_write
                      |          vfs_write
                      |          sys_pwrite64
                      |          system_call
                      |          0x7f64a60bb203
                      |          0xe01170
                      |          
                      |---0.72%-- dcache_readdir
                      |          vfs_readdir
                      |          sys_getdents
                      |          system_call
                      |          0x7f64a60ade65


So it's totally screwy.

