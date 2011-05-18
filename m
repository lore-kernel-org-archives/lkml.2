Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933601Ab1ERSxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:53:21 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:53866 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933567Ab1ERSxR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:53:17 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-131.messagelabs.com!1305744789!3395970!22
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.72]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Russell King <linux@arm.linux.org.uk>, Mel Gorman <mgorman@suse.de>
Date: Wed, 18 May 2011 13:53:08 -0500
Subject: RE: [PATCH] ARM: sparsemem: allow pfn_valid to be overridden when
 using	SPARSEMEM
Thread-Topic: [PATCH] ARM: sparsemem: allow pfn_valid to be overridden when
 using	SPARSEMEM
Thread-Index: AcwVdWikNrfrVB19QhepAjpMfpiRkAAFbxxg
Message-ID: <0D753D10438DA54287A00B027084269764D2F73AC4@AUSP01VMBX24.collaborationhost.net>
References: <1305734639-6561-1-git-send-email-will.deacon@arm.com>
In-Reply-To: <1305734639-6561-1-git-send-email-will.deacon@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 18, 2011 9:04 AM, Will Deacon wrote:
>
> In commit eb33575c ("[ARM] Double check memmap is actually valid with a
> memmap has unexpected holes V2"), a new function, memmap_valid_within,
> was introduced to mmzone.h so that holes in the memmap which pass
> pfn_valid in SPARSEMEM configurations can be detected and avoided.
>
> The fix to this problem checks that the pfn <-> page linkages are
> correct by calculating the page for the pfn and then checking that
> page_to_pfn on that page returns the original pfn. Unfortunately, in
> SPARSEMEM configurations, this results in reading from the page flags to
> determine the correct section. Since the memmap here has been freed,
> junk is read from memory and the check is no longer robust.
>
> In the best case, reading from /proc/pagetypeinfo will give you the
> wrong answer. In the worst case, you get SEGVs, Kernel OOPses and hung
> CPUs.
>
> This patch allows architectures to provide their own pfn_valid function
> instead of using the default implementation used by sparsemem. The
> architecture-specific version is aware of the memmap state and will
> return false when passed a pfn for a freed page within a valid section.
>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Mel Gorman <mgorman@suse.de>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>

I tested this on an EP93xx based system which uses ARCH_HAS_HOLES_MEMORYMODEL.
The EP9307A has 64MB of memory that appears as two 32MB blocks at addresses
0xc0000000 and 0xc4000000.  Currently the EP93xx uses a Flat Memory model and
the hole used to cause a Kernel OOPs before commit e80d6a24 ("[ARM] Skip memory
holes in FLATMEM when reading /proc/pagetypeinfo"), which is where I think this
all started.

Without your patch I get this when reading /proc/pagetypeinfo:

# cat /proc/pagetypeinfo
Page block order: 10
Pages per block:  1024

Free pages count per migrate type at order       0      1      2      3      4      5      6      7      8      9     10
Node    0, zone   Normal, type    Unmovable      3      4      3      0      2      2      4      5      2      2      3
Node    0, zone   Normal, type  Reclaimable      2      0      0      0      1      0      0      1      0      1      0
Node    0, zone   Normal, type      Movable      0      3      4      1      1      1      0      1      0      2      4
Node    0, zone   Normal, type      Reserve      1      1      1      2      0      0      0      0      0      0      0
Node    0, zone   Normal, type      Isolate      0      0      0      0      0      0      0      0      0      0      0

Number of blocks type     Unmovable  Reclaimable      Movable      Reserve      Isolate
Node 0, zone   Normal            8            1            6            1            0

After your patch I get this:

# cat /proc/pagetypeinfo
Page block order: 10
Pages per block:  1024

Free pages count per migrate type at order       0      1      2      3      4      5      6      7      8      9     10
Node    0, zone   Normal, type    Unmovable      1      0      2      0      1      3      4      3      3      2      3
Node    0, zone   Normal, type  Reclaimable      0      1      0      0      1      0      0      1      0      1      0
Node    0, zone   Normal, type      Movable      1      1      1      1      0      0      1      1      0      2      4
Node    0, zone   Normal, type      Reserve      1      1      1      2      0      0      0      0      0      0      0
Node    0, zone   Normal, type      Isolate      0      0      0      0      0      0      0      0      0      0      0

Number of blocks type     Unmovable  Reclaimable      Movable      Reserve      Isolate
Node 0, zone   Normal            8            1            6            1            0

I'm not sure what the output "should" be, but the patch does not seem to
cause any issues.  So feel free to add:

Tested-by: H Hartley Sweeten <hsweeten@visionengravers.com>
