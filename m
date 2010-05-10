Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab0EJXQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:16:30 -0400
Received: from kroah.org ([198.145.64.141]:51788 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932888Ab0EJW6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:05 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:38 2010
Message-Id: <20100510223538.635685746@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:34:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Prarit Bhargava <prarit@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [47/98] x86, AMD: Fix stale cpuid4_info shared_map data in shared_cpu_map cpumasks
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Prarit Bhargava <prarit@redhat.com>

commit ebb682f522411abbe358059a256a8672ec0bd55b upstream.

The per_cpu cpuid4_info shared_map can contain stale data when CPUs are added
and removed.

The stale data can lead to a NULL pointer derefernce panic on a remove of a
CPU that has had siblings previously removed.

This patch resolves the panic by verifying a cpu is actually online before
adding it to the shared_cpu_map, only examining cpus that are part of
the same lower level cache, and by updating other siblings lowest level cache
maps when a cpu is added.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
LKML-Reference: <20091209183336.17855.98708.sendpatchset@prarit.bos.redhat.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -647,18 +647,19 @@ static void __cpuinit cache_shared_cpu_m
 {
 	struct _cpuid4_info	*this_leaf, *sibling_leaf;
 	unsigned long num_threads_sharing;
-	int index_msb, i;
+	int index_msb, i, sibling;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
 	if ((index == 3) && (c->x86_vendor == X86_VENDOR_AMD)) {
-		struct cpuinfo_x86 *d;
-		for_each_online_cpu(i) {
+		for_each_cpu(i, c->llc_shared_map) {
 			if (!per_cpu(cpuid4_info, i))
 				continue;
-			d = &cpu_data(i);
 			this_leaf = CPUID4_INFO_IDX(i, index);
-			cpumask_copy(to_cpumask(this_leaf->shared_cpu_map),
-				     d->llc_shared_map);
+			for_each_cpu(sibling, c->llc_shared_map) {
+				if (!cpu_online(sibling))
+					continue;
+				set_bit(sibling, this_leaf->shared_cpu_map);
+			}
 		}
 		return;
 	}


