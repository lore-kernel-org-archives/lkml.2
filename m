Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935002Ab2JXOoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 10:44:19 -0400
Received: from mail.x86-64.org ([217.9.48.20]:33352 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934820Ab2JXOoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 10:44:17 -0400
Date: Wed, 24 Oct 2012 16:44:11 +0200
From: Borislav Petkov <bp@amd64.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Denis Kirjanov <kirjanov@gmail.com>,
        edac-devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] amd64_edac fix for 3.7-rc3
Message-ID: <20121024144411.GC31338@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull this fix for when setting the memory controller scrub rate
in amd64_edac.

Thanks.

The following changes since commit 6f0c0580b70c89094b3422ba81118c7b959c7556:

  Linux 3.7-rc2 (2012-10-20 12:11:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/edac_scrubrates_fix

for you to fetch changes up to 168bfeef7bba3f9784f7540b053e4ac72b769ce9:

  amd64_edac:__amd64_set_scrub_rate(): avoid overindexing scrubrates[] (2012-10-24 16:13:27 +0200)

----------------------------------------------------------------
An array out-of-bounds fix from Andrew when setting the scrub rate of
the memory controller.

----------------------------------------------------------------
Andrew Morton (1):
      amd64_edac:__amd64_set_scrub_rate(): avoid overindexing scrubrates[]

 drivers/edac/amd64_edac.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

Actual patch:

--
>From 168bfeef7bba3f9784f7540b053e4ac72b769ce9 Mon Sep 17 00:00:00 2001
From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 23 Oct 2012 14:09:39 -0700
Subject: [PATCH] amd64_edac:__amd64_set_scrub_rate(): avoid overindexing
 scrubrates[]

If none of the elements in scrubrates[] matches, this loop will cause
__amd64_set_scrub_rate() to incorrectly use the n+1th element.

As the function is designed to use the final scrubrates[] element in the
case of no match, we can fix this bug by simply terminating the array
search at the n-1th element.

Boris: this code is fragile anyway, see here why:
http://marc.info/?l=linux-kernel&m=135102834131236&w=2

It will be rewritten more robustly soonish.

Reported-by: Denis Kirjanov <kirjanov@gmail.com>
Cc: stable@vger.kernel.org
Cc: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 5a297a26211d..cc8e7c78a23c 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -170,8 +170,11 @@ static int __amd64_set_scrub_rate(struct pci_dev *ctl, u32 new_bw, u32 min_rate)
 	 * memory controller and apply to register. Search for the first
 	 * bandwidth entry that is greater or equal than the setting requested
 	 * and program that. If at last entry, turn off DRAM scrubbing.
+	 *
+	 * If no suitable bandwidth is found, turn off DRAM scrubbing entirely
+	 * by falling back to the last element in scrubrates[].
 	 */
-	for (i = 0; i < ARRAY_SIZE(scrubrates); i++) {
+	for (i = 0; i < ARRAY_SIZE(scrubrates) - 1; i++) {
 		/*
 		 * skip scrub rates which aren't recommended
 		 * (see F10 BKDG, F3x58)
@@ -181,12 +184,6 @@ static int __amd64_set_scrub_rate(struct pci_dev *ctl, u32 new_bw, u32 min_rate)
 
 		if (scrubrates[i].bandwidth <= new_bw)
 			break;
-
-		/*
-		 * if no suitable bandwidth found, turn off DRAM scrubbing
-		 * entirely by falling back to the last element in the
-		 * scrubrates array.
-		 */
 	}
 
 	scrubval = scrubrates[i].scrubval;
-- 
1.8.0


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
