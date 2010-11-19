Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab0KSVwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:52:17 -0500
Received: from kroah.org ([198.145.64.141]:51771 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757299Ab0KSVp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:45:28 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:44:10 2010
Message-Id: <20101119214410.822848883@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:42:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, avi@redhat.com,
        mtosatti@redhat.com, Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [17/45] KVM: MMU: fix conflict access permissions in direct sp
In-Reply-To: <20101119214439.GA26350@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

commit 5fd5387c89ec99ff6cb82d2477ffeb7211b781c2 upstream.

In no-direct mapping, we mark sp is 'direct' when we mapping the
guest's larger page, but its access is encoded form upper page-struct
entire not include the last mapping, it will cause access conflict.

For example, have this mapping:
        [W]
      / PDE1 -> |---|
  P[W]          |   | LPA
      \ PDE2 -> |---|
        [R]

P have two children, PDE1 and PDE2, both PDE1 and PDE2 mapping the
same lage page(LPA). The P's access is WR, PDE1's access is WR,
PDE2's access is RO(just consider read-write permissions here)

When guest access PDE1, we will create a direct sp for LPA, the sp's
access is from P, is W, then we will mark the ptes is W in this sp.

Then, guest access PDE2, we will find LPA's shadow page, is the same as
PDE's, and mark the ptes is RO.

So, if guest access PDE1, the incorrect #PF is occured.

Fixed by encode the last mapping access into direct shadow page

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/paging_tmpl.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -360,6 +360,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu
 			/* advance table_gfn when emulating 1gb pages with 4k */
 			if (delta == 0)
 				table_gfn += PT_INDEX(addr, level);
+			access &= gw->pte_access;
 		} else {
 			direct = 0;
 			table_gfn = gw->table_gfn[level - 2];


