Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab2C1DfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 23:35:04 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36138 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab2C1DfB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 23:35:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120328110350.e2d44e1f66b6ac7f9fd82843@canb.auug.org.au>
References: <20120327213626.GA10022@windriver.com> <20120328110350.e2d44e1f66b6ac7f9fd82843@canb.auug.org.au>
From: Mike Frysinger <vapier@gentoo.org>
Date: Tue, 27 Mar 2012 23:34:39 -0400
X-Google-Sender-Auth: JKbwPc6OPvCR0d5PHyhemw6LKig
Message-ID: <CAMjpGUdJWxrHtaiAE-LQGZU7nNB1DSpiA9P78Rn5bB9+GyThjg@mail.gmail.com>
Subject: Re: Blackfin link issue (Was: linux-next: triage for March 27, 2012)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bob Liu <lliubbo@gmail.com>,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 20:03, Stephen Rothwell wrote:
> On Tue, 27 Mar 2012 17:36:27 -0400 Paul Gortmaker wrote:
>> The blackfin builds are no longer failing on vm_is_stack but instead
>> are all failing with "L1 data A overflow!" at final link, which smells
>> like some kind of binutils/toolchain issue.
>>
>>
>> bfin:***all-builds***
>>       when:   Mar 26
>>       why:    bfin-uclinux-ld: L1 data A overflow!
>>       status: unknown, binutils issue?
>>       fix:
>>       ref:    http://kisskb.ellerman.id.au/kisskb/buildresult/5981475/
>
> It actually looks like this comes from an ASSERT in the blackfin
> vmlinux.lds.S ... looks like some sections overflowed.

yes, the assert is doing the right thing.  it's attempting to put
24KiB into a region that can only hold 16KiB.

this is due to the recent lib/gen_crc32table.c change:
  46c5801eaf86e83cb3a4142ad35188db5011fff0
  crc32: bolt on crc32c

it added 8KiB more data.  looks to me like it's a complete waste of
space ... it's forced into __cacheline_aligned which doesn't let the
linker do garbage collection on symbols/sections, so all systems are
forced to carry this.  seems like this should be a Kconfig knob that
other people would select if they actually need it ?

at any rate, would be easy to fix by disabling Kconfig
CACHELINE_ALIGNED_L1 when CRC32 is enabled considering that makes the
optimization completely useless by totally blowing the size out of the
water.

--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -823,7 +823,7 @@
    bool "Locate cacheline_aligned data to L1 Data Memory"
    default y if !BF54x
    default n if BF54x
-   depends on !SMP && !BF531
+   depends on !SMP && !BF531 && !CRC32
    help
      If enabled, cacheline_aligned data is linked
      into L1 data memory. (less latency)
-mike
