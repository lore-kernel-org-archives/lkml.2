Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab1K1IdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 03:33:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40359 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070Ab1K1IdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 03:33:17 -0500
Date: Mon, 28 Nov 2011 09:33:13 +0100
From: Michal Hocko <mhocko@suse.cz>
To: stable@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andy Lutomirski <luto@amacapital.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] hugetlb: release pages in the error path of hugetlb_cow()
 (was: Re: 3.2-rc2+: Reported regressions from 3.0 and 3.1)
Message-ID: <20111128083313.GA18337@tiehlicka.suse.cz>
References: <lx6sezwGldO.A.IhF.UBpWOB@chimera>
 <201111212249.31196.rjw@sisk.pl>
 <CA+55aFygSFt+O5KLoiE_0V+o45eKfsoDDV5ML8EF=J0n9z_D-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFygSFt+O5KLoiE_0V+o45eKfsoDDV5ML8EF=J0n9z_D-Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 21-11-11 14:18:29, Linus Torvalds wrote:
> On Mon, Nov 21, 2011 at 1:49 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > Subject    : hugetlb oops on 3.1.0-rc8-devel
> > Submitter  : Andy Lutomirski <luto@amacapital.net>
> > Date       : 2011-11-01 22:20
> > Message-ID : CALCETrW1mpVCz2tO5roaz1r6vnno+srHR-dHA6_pkRi2qiCfdw@mail.gmail.com
> > References : http://marc.info/?l=linux-kernel&m=132018604426692&w=2
> 
> Despite the subject line, that's not an oops, it's a BUG_ON().
> 
> And it *should* be fixed by commit ea4039a34c4c ("hugetlb: release
> pages in the error path of hugetlb_cow()") although I don't think Andy
> ever confirmed that (since it was hard to trigger).

AFAICS the issue has been introduced by 0fe6e20b (hugetlb, rmap:
add reverse mapping for hugepage) in 2.6.36-rc1 so this is a stable
material. I do not see the patch in any stable branch so here we go.
The patch is on top of 3.0.y branch and it applies as is to 3.1.y
as well.
---
>From fdaa4aaa008cce149a5fd60934112acd8988e0b6 Mon Sep 17 00:00:00 2001
From: Hillf Danton <dhillf@gmail.com>
Date: Tue, 15 Nov 2011 14:36:12 -0800
Subject: [PATCH] hugetlb: release pages in the error path of hugetlb_cow()

commit ea4039a34c4c206d015d34a49d0b00868e37db1d upstream.

If we fail to prepare an anon_vma, the {new, old}_page should be released,
or they will leak.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/hugetlb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index bfcf153..2b57cd9 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2415,6 +2415,8 @@ retry_avoidcopy:
 	 * anon_vma prepared.
 	 */
 	if (unlikely(anon_vma_prepare(vma))) {
+		page_cache_release(new_page);
+		page_cache_release(old_page);
 		/* Caller expects lock to be held */
 		spin_lock(&mm->page_table_lock);
 		return VM_FAULT_OOM;
-- 
1.7.7.3


-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
