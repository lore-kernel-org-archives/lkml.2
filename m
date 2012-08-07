Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab2HGW3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:29:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54583 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932477Ab2HGW3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:29:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [ 038/122] x86/mce: Fix siginfo_t->si_addr value for non-recoverable memory faults
Date: Tue,  7 Aug 2012 15:25:26 -0700
Message-Id: <20120807221951.654665148@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Luck <tony.luck@intel.com>

commit 6751ed65dc6642af64f7b8a440a75563c8aab7ae upstream.

In commit dad1743e5993f1 ("x86/mce: Only restart instruction after machine
check recovery if it is safe") we fixed mce_notify_process() to force a
signal to the current process if it was not restartable (RIPV bit not
set in MCG_STATUS). But doing it here means that the process doesn't
get told the virtual address of the fault via siginfo_t->si_addr. This
would prevent application level recovery from the fault.

Make a new MF_MUST_KILL flag bit for memory_failure() et al. to use so
that we will provide the right information with the signal.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/mcheck/mce.c |    6 ++++--
 include/linux/mm.h               |    1 +
 mm/memory-failure.c              |   14 ++++++++------
 3 files changed, 13 insertions(+), 8 deletions(-)

--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1186,6 +1186,7 @@ void mce_notify_process(void)
 {
 	unsigned long pfn;
 	struct mce_info *mi = mce_find_info();
+	int flags = MF_ACTION_REQUIRED;
 
 	if (!mi)
 		mce_panic("Lost physical address for unconsumed uncorrectable error", NULL, NULL);
@@ -1200,8 +1201,9 @@ void mce_notify_process(void)
 	 * doomed. We still need to mark the page as poisoned and alert any
 	 * other users of the page.
 	 */
-	if (memory_failure(pfn, MCE_VECTOR, MF_ACTION_REQUIRED) < 0 ||
-			   mi->restartable == 0) {
+	if (!mi->restartable)
+		flags |= MF_MUST_KILL;
+	if (memory_failure(pfn, MCE_VECTOR, flags) < 0) {
 		pr_err("Memory error not recovered");
 		force_sig(SIGBUS, current);
 	}
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1591,6 +1591,7 @@ void vmemmap_populate_print_last(void);
 enum mf_flags {
 	MF_COUNT_INCREASED = 1 << 0,
 	MF_ACTION_REQUIRED = 1 << 1,
+	MF_MUST_KILL = 1 << 2,
 };
 extern int memory_failure(unsigned long pfn, int trapno, int flags);
 extern void memory_failure_queue(unsigned long pfn, int trapno, int flags);
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -345,14 +345,14 @@ static void add_to_kill(struct task_stru
  * Also when FAIL is set do a force kill because something went
  * wrong earlier.
  */
-static void kill_procs(struct list_head *to_kill, int doit, int trapno,
+static void kill_procs(struct list_head *to_kill, int forcekill, int trapno,
 			  int fail, struct page *page, unsigned long pfn,
 			  int flags)
 {
 	struct to_kill *tk, *next;
 
 	list_for_each_entry_safe (tk, next, to_kill, nd) {
-		if (doit) {
+		if (forcekill) {
 			/*
 			 * In case something went wrong with munmapping
 			 * make sure the process doesn't catch the
@@ -858,7 +858,7 @@ static int hwpoison_user_mappings(struct
 	struct address_space *mapping;
 	LIST_HEAD(tokill);
 	int ret;
-	int kill = 1;
+	int kill = 1, forcekill;
 	struct page *hpage = compound_head(p);
 	struct page *ppage;
 
@@ -888,7 +888,7 @@ static int hwpoison_user_mappings(struct
 	 * be called inside page lock (it's recommended but not enforced).
 	 */
 	mapping = page_mapping(hpage);
-	if (!PageDirty(hpage) && mapping &&
+	if (!(flags & MF_MUST_KILL) && !PageDirty(hpage) && mapping &&
 	    mapping_cap_writeback_dirty(mapping)) {
 		if (page_mkclean(hpage)) {
 			SetPageDirty(hpage);
@@ -965,12 +965,14 @@ static int hwpoison_user_mappings(struct
 	 * Now that the dirty bit has been propagated to the
 	 * struct page and all unmaps done we can decide if
 	 * killing is needed or not.  Only kill when the page
-	 * was dirty, otherwise the tokill list is merely
+	 * was dirty or the process is not restartable,
+	 * otherwise the tokill list is merely
 	 * freed.  When there was a problem unmapping earlier
 	 * use a more force-full uncatchable kill to prevent
 	 * any accesses to the poisoned memory.
 	 */
-	kill_procs(&tokill, !!PageDirty(ppage), trapno,
+	forcekill = PageDirty(ppage) || (flags & MF_MUST_KILL);
+	kill_procs(&tokill, forcekill, trapno,
 		      ret != SWAP_SUCCESS, p, pfn, flags);
 
 	return ret;


