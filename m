Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab0CXSPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 14:15:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932527Ab0CXSPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 14:15:46 -0400
Date: Wed, 24 Mar 2010 11:14:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Christian Kujau <lists@nerdbynature.de>,
       Zhenyu Wang <zhenyuw@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, David.Woodhouse@intel.com,
       dwmw2@infradead.org, eric@anholt.net, ben@decadent.org.uk,
       gregkh@suse.de
Subject: Re: [PATCH] intel-agp.c: Fix crash when accessing nonexistent GTT 
 entries in i915
Message-Id: <20100324111436.fe5d2906.akpm@linux-foundation.org>
In-Reply-To: <ca2dc2821003230440w3d96612aja0d4e083d3cc8c02@mail.gmail.com>
References: <1268258994.2183.14.camel@carter>
	<ca2dc2821003102331x3d1a7a0fgadb63612e49f77db@mail.gmail.com>
	<20100311083404.GG6896@zhen-devel.sh.intel.com>
	<ca2dc2821003110754r65ab170at39a61fb11fa285e0@mail.gmail.com>
	<20100319132723.118cc16a.akpm@linux-foundation.org>
	<ca2dc2821003200604m7c8cdea4r64ab8c98e7ec8242@mail.gmail.com>
	<20100321135836.GA11661@zhen-devel.sh.intel.com>
	<ca2dc2821003210830h2025df79r477cca7d81ddd28d@mail.gmail.com>
	<20100322205704.ac4cd9ae.akpm@linux-foundation.org>
	<alpine.DEB.2.01.1003222111070.5493@bogon.housecafe.de>
	<ca2dc2821003230440w3d96612aja0d4e083d3cc8c02@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Mar 2010 12:40:05 +0100
Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:

> On Tue, Mar 23, 2010 at 5:14 AM, Christian Kujau <lists@nerdbynature.de> wrote:
> > On Mon, 22 Mar 2010 at 20:57, Andrew Morton wrote:
> >> On Sun, 21 Mar 2010 16:30:20 +0100 Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:
> >> > I bisected in order to find the commit 5877960869333e42ebeb733e8d9d5630ff96d350.
> >
> > I believe this[0] is fc61901373987ad61851ed001fe971f3ee8d96a3 upstream:
> 
> Indeed. Also in
> 
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=commit;h=fc61901373987ad61851ed001fe971f3ee8d96a3

Does reverting that patch from the current code fix the crash?

--- a/drivers/char/agp/intel-agp.c~revert-1
+++ a/drivers/char/agp/intel-agp.c
@@ -207,7 +207,6 @@ static struct _intel_private {
 	 * popup and for the GTT.
 	 */
 	int gtt_entries;			/* i830+ */
-	int gtt_total_size;
 	union {
 		void __iomem *i9xx_flush_page;
 		void *i8xx_flush_page;
@@ -1239,7 +1238,7 @@ static int intel_i915_configure(void)
 	readl(intel_private.registers+I810_PGETBL_CTL);	/* PCI Posting. */
 
 	if (agp_bridge->driver->needs_scratch_page) {
-		for (i = intel_private.gtt_entries; i < intel_private.gtt_total_size; i++) {
+		for (i = intel_private.gtt_entries; i < current_size->num_entries; i++) {
 			writel(agp_bridge->scratch_page, intel_private.gtt+i);
 		}
 		readl(intel_private.gtt+i-1);	/* PCI Posting. */
@@ -1394,8 +1393,6 @@ static int intel_i915_create_gatt_table(
 	if (!intel_private.gtt)
 		return -ENOMEM;
 
-	intel_private.gtt_total_size = gtt_map_size / 4;
-
 	temp &= 0xfff80000;
 
 	intel_private.registers = ioremap(temp, 128 * 4096);
@@ -1485,8 +1482,6 @@ static int intel_i965_create_gatt_table(
 	if (!intel_private.gtt)
 		return -ENOMEM;
 
-	intel_private.gtt_total_size = gtt_size / 4;
-
 	intel_private.registers = ioremap(temp, 128 * 4096);
 	if (!intel_private.registers) {
 		iounmap(intel_private.gtt);
_

