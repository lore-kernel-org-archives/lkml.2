Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab1F2MeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 08:34:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52033 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab1F2MeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 08:34:13 -0400
Date: Wed, 29 Jun 2011 14:34:09 +0200
From: Tejun Heo <tj@kernel.org>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: Conny Seidel <conny.seidel@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: 32bit NUMA and fakeNUMA broken for AMD CPUs
Message-ID: <20110629123409.GL3386@htj.dyndns.org>
References: <20110621174131.054f0422.conny.seidel_amd.com@marah.osrc.amd.com>
 <20110626102235.GC12200@mtj.dyndns.org>
 <20110626223807.47cef5c6.conny.seidel_amd.com@marah.osrc.amd.com>
 <20110628174613.GP478@escobedo.osrc.amd.com>
 <20110629094451.GJ3386@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629094451.GJ3386@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

I think I found what went wrong.

> > [    0.000000] Node 0 MemBase 0000000000000000 Limit 0000000238000000
> > [    0.000000] Node 1 MemBase 0000000238000000 Limit 0000000638000000
> > [    0.000000] Node 2 MemBase 0000000638000000 Limit 0000000838000000
> > [    0.000000] Node 3 MemBase 0000000838000000 Limit 0000000c38000000
> > [    0.000000] Node 4 MemBase 0000000c38000000 Limit 0000000e38000000
> > [    0.000000] Node 5 MemBase 0000000e38000000 Limit 0000001000000000
> > [    0.000000] Node 6 bogus settings 1238000000-1000000000.
> > [    0.000000] Node 7 bogus settings 1438000000-1000000000.

NUMA nodes are aligned to 27bit - 128MiB.  SPARSEMEM is enabled but on
x86-32 w/ PAE SECTION_SIZE_BITS is 29 - 512MiB, which means that pages
living near the boundary will have wrong nid assigned to them.

> > [    0.000000] BUG: Int 6: CR2   (null)
> > [    0.000000]      EDI   (null)  ESI 00000002  EBP 00000002  ESP c1543ecc
> > [    0.000000]      EBX f2400000  EDX 00000006  ECX   (null)  EAX 00000001
> > [    0.000000]      err   (null)  EIP c16209aa   CS 00000060  flg 00010002
> > [    0.000000] Stack: f2400000 00220000 f7200800 c1620613 00220000 01000000 04400000 00238000
> > [    0.000000]          (null) f7200000 00000002 f7200b58 f7200800 c1620929 000375fe   (null)
> > [    0.000000]        f7200b80 c16395f0 00200a02 f7200a80   (null) 000375fe 00000002   (null)
> > [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.39-rc5-00181-g2706a0b #17
> > [    0.000000] Call Trace:
> > [    0.000000]  [<c136b1e5>] ? early_fault+0x2e/0x2e
> > [    0.000000]  [<c16209aa>] ? mminit_verify_page_links+0x12/0x42

So, mminit_verify_page_links() detects it while the last 512MiB
highmem chunk of node 0 is being initialized and freaks out.

We definitely need a safe guard to check NUMA node alignment and
disable NUMA if it requires finer granuality than supported by the
memory model.  If you use DISCONTIGMEM, which has 64MiB granuality,
instead, it works, right?

-- 
tejun
