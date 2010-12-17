Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751160Ab0LQFdE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 00:33:04 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:19532 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750742Ab0LQFdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 00:33:03 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEADaDCk15Lc+z/2dsb2JhbACkP3TDEIVKBA
Date: Fri, 17 Dec 2010 16:32:58 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: buggy perf callgraph output
Message-ID: <20101217053258.GC3282@amd>
References: <20101208164015.GA5444@amd>
 <20101208214809.GG1709@nowhere>
 <20101215130245.GA10004@amd>
 <20101216114755.GA1687@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101216114755.GA1687@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 12:47:58PM +0100, Frederic Weisbecker wrote:
> On Thu, Dec 16, 2010 at 12:02:45AM +1100, Nick Piggin wrote:
> > On Wed, Dec 08, 2010 at 10:48:13PM +0100, Frederic Weisbecker wrote:
> > > I can not reproduce it. Could you please try to reproduce,
> > > run perf archive and send me your perf.data.tar.bz2 ?
> > 
> > It seems to be happening all the time, just look further in
> > callgraphs.
> > 
> > This attached perf.data.bz2 looks like this, when using -g graph
> > 
> >     15.05%        dbench  [kernel.kallsyms]  [k]
> > copy_user_generic_string
> >                    |
> >                    --- copy_user_generic_string
> >                       |          
> >                       |---0.16%-- generic_file_aio_read
> >                       |          do_sync_read
> >                       |          vfs_read
> >                       |          |          
> >                       |           --0.05%-- sys_pread64
> >                       |                     system_call
> >                       |                     0x7f64a60bb193
> >                       |          
> >                       |--0.10%-- generic_file_buffered_write
> >                       |          __generic_file_aio_write
> >                       |          generic_file_aio_write
> >                       |          do_sync_write
> >                       |          vfs_write
> >                       |          sys_pwrite64
> >                       |          system_call
> >                       |          0x7f64a60bb203
> >                       |          0xe01170
> >                       |          
> >                        ---0.11%-- dcache_readdir
> >                                  vfs_readdir
> >                                  sys_getdents
> >                                  system_call
> >                                  0x7f64a60ade65
> > 
> > See, the last element is greater than the second last.
> > 
> > -g fractal looks like this:
> > 
> >     15.05%        dbench  [kernel.kallsyms]  [k]
> > copy_user_generic_string
> >                    |
> >                    --- copy_user_generic_string
> >                       |          
> >                       |---1.09%-- generic_file_aio_read
> >                       |          do_sync_read
> >                       |          vfs_read
> >                       |          |          
> >                       |          |--0.55%-- sys_pread64
> >                       |          |          system_call
> >                       |          |          0x7f64a60bb193
> >                       |          |          
> >                       |           --2.19%-- sys_read
> >                       |                     system_call
> >                       |                     0x7f64a60d3ea0
> >                       |          
> >                       |--0.69%-- generic_file_buffered_write
> >                       |          __generic_file_aio_write
> >                       |          generic_file_aio_write
> >                       |          do_sync_write
> >                       |          vfs_write
> >                       |          sys_pwrite64
> >                       |          system_call
> >                       |          0x7f64a60bb203
> >                       |          0xe01170
> >                       |          
> >                       |---0.72%-- dcache_readdir
> >                       |          vfs_readdir
> >                       |          sys_getdents
> >                       |          system_call
> >                       |          0x7f64a60ade65
> > 
> > 
> > So it's totally screwy.
> 
> 
> First time I see this.
> 
> I can reproduce but differently because I miss your perf.data.tar.bz2
> that results after the "perf archive" command, then the chains are based
> on addresses and not on symbols.

Oh I didn't realize perf archive, noted for next time, thanks.

 
> But I found one of these problems on your file even without the symbols:
> 
>                    --- 0x8152b50e
>                       |          
>                       |---6.54%-- 0x810e83a7
>                       |          0x810d8590
>                       |          0x810d8710
>                       |          0x81002cbb
>                       |          0xa60ade65
>                       |          
>                       |--13.76%-- 0x810dbc9f
>                       |          |          
>                       |          |--44.73%-- 0x810d1ff5
>                       |          |          |          
>                       |          |          |--38.87%-- 0x810d44c4
>                       |          |          |          0x810d5242
>                       |          |          |          |          
>                       |          |          |          |--82.03%-- 0x810d5f12
>                       |          |          |          |          0x810cbfd7
>                       |          |          |          |          0x810cc046
>                       |          |          |          |          0x810cc1ff
>                       |          |          |          |          0x81002cbb
>                       |          |          |          |          0xa60d37f5
>                       |          |          |          |          |          
>                       |          |          |          |          |--86.66%-- 0xe01170
>                       |          |          |          |          |          
>                       |          |          |          |           --13.34%-- 0x6c632f73
>                       |          |          |          |          
>                       |          |          |           --17.97%-- 0x810d629f
>                       |          |          |                     0x810c63a3
>                       |          |          |                     0x810c648b
>                       |          |          |                     0x81002cbb
>                       |          |          |                     0xa60d3cb0
> 
> These are not the two last on the chain so it seems to happen even more
> randomly.
> 
> I'll fix that, thanks!

That would be great, thanks! It's a really awesome tool, I appreciate
your effort on it.

Thanks,
Nick

