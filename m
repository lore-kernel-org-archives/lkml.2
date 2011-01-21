Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab1AUIzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 03:55:17 -0500
Received: from adelie.canonical.com ([91.189.90.139]:48386 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab1AUIzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 03:55:07 -0500
Message-ID: <4D3949E4.9010407@canonical.com>
Date: Fri, 21 Jan 2011 09:55:00 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning safter merge of the swiotlb-xen tree
References: <20110121124159.135c7f5f.sfr@canb.auug.org.au>
In-Reply-To: <20110121124159.135c7f5f.sfr@canb.auug.org.au>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/mixed;
 boundary="------------060908050600080004090004"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060908050600080004090004
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 01/21/2011 02:41 AM, Stephen Rothwell wrote:
> Hi Konrad,
> 
> After merging the swiotlb-xen tree, today's linux-next build (x86_64
> allmodconfig) produced these warnings:
> 
> arch/x86/xen/p2m.c: In function 'xen_build_dynamic_phys_to_machine':
> arch/x86/xen/p2m.c:251: warning: passing argument 1 of 'p2m_init' from incompatible pointer type
> arch/x86/xen/p2m.c:121: note: expected 'long unsigned int *' but argument is of type 'long unsigned int **'
> arch/x86/xen/p2m.c:254: warning: assignment makes pointer from integer without a cast
> arch/x86/xen/p2m.c:256: warning: assignment from incompatible pointer type
> 
> Introduced by commit fc0976e2c086e6e518e32dcafedb5a2ba3ea297d ("xen: p2m:
> correctly initialize partial p2m leave").
> 
Sorry about that. For some reason I was blinded to the fact that p2m holds longs
not pointers. And "unfortunately" it works either way. The following update
would remove the warnings. Not sure it can still be folded into the original patch.

-Stefan



--------------060908050600080004090004
Content-Type: text/x-diff;
 name="0002-xen-p2m-Use-the-correct-type-for-p2m-page.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0002-xen-p2m-Use-the-correct-type-for-p2m-page.patch"

>From fc26a9b0a6b87ee7d5d7cef77664c0d58bfc9761 Mon Sep 17 00:00:00 2001
From: Stefan Bader <stefan.bader@canonical.com>
Date: Fri, 21 Jan 2011 09:46:07 +0100
Subject: [PATCH 2/2] xen: p2m: Use the correct type for p2m page

In "xen: p2m: correctly initialize partial p2m leave" I introduced new
compiler warnings by using unsigned long ** instead of unsigned long *
for the 3rd level tree structure. Due to the nature of pointers and long
this works practically but it should be done right.

BugLink: http://bugs.launchpad.net/bugs/686692

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 arch/x86/xen/p2m.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index c9307ec..ddc81a0 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -247,7 +247,7 @@ void __init xen_build_dynamic_phys_to_machine(void)
 		 */
 		if (unlikely(pfn + P2M_PER_PAGE > max_pfn)) {
 			unsigned long p2midx;
-			unsigned long **p2m = extend_brk(PAGE_SIZE, PAGE_SIZE);
+			unsigned long *p2m = extend_brk(PAGE_SIZE, PAGE_SIZE);
 			p2m_init(p2m);
 
 			for (p2midx = 0; pfn + p2midx < max_pfn; p2midx++) {
-- 
1.7.0.4


--------------060908050600080004090004--
