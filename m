Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab0ITHXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 03:23:52 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53394 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab0ITHXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 03:23:51 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
References: <m1y6b48973.fsf@fess.ebiederm.org> <20100917205946.GF2522@local>
	<m139t451b4.fsf_-_@fess.ebiederm.org>
Date: Mon, 20 Sep 2010 00:23:45 -0700
In-Reply-To: <m139t451b4.fsf_-_@fess.ebiederm.org> (Eric W. Biederman's
	message of "Mon, 20 Sep 2010 00:19:59 -0700")
Message-ID: <m1k4mg3mke.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Hans J. Koch" <hjk@linutronix.de>
X-Spam-Relay-Country: 
Subject: [PATCH 4/5] libunload: A library to help remove open files
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The problem of how to remove open files due to module unloading or device
hotunplugging keeps coming up.  We have multiple implementations of roughly
the same logic in proc, sysctl, sysfs, tun and now I am working on yet
another one for uio.  It is time to start working on a generic implementation.

This library does not aim to allow wrapping any arbitray set of file operations
and making it safe to unload any module.  This library aims to work in
conjuction with the code implementiong an object to make it safe to remove
safely remove the object while file handles to it are still open.  libunload
implements the necessary locking and logic to make it striaght forward to
implement file_operations for objects that are removed at runtime.

It is hard to arrange for the ->close method of vm_operations_struct to be
called when an object is being removed, and this code doesn't even attempt
to help with that.  Instead it is assumed that calling ->close is not needed.
Without close support mmap at hotunplug time is simply a matter of calling
umap_mapping_range() to invaildate the mappings, and to arrange for vm_fault
to return VM_FAULT_SIGBUS when the unload_trylock fails.

Wait queues and fasync queues can safely be woken up after unload_barrier
making the semantics clean.   The fasync entries can be freed as a list of
all of the file descriptors is kept.  poll entries can not be freed so the
poll wait queue heads must be kept around.   If someone else's poll method is
being wrapped the wrapped poll wait queue head could be freed, but it requires
that there is a wrapping wait queue head that is kept around.  If there is no
other way wrapping a poll wait queue head seems practical but in general it
isn't a particularly useful.

libunload is best understood from the perspective of code that calls
unload_barrier().  Past the unload barrier it is guaranteed that there
is no code in the critical sections protectecd by the unload lock, and the
unload release lock.  Past the unload barrier it is safe to call the release
methods for remaining file descriptors, to ensure some logical state does
not persist.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/Makefile            |    2 +-
 fs/libunload.c         |  166 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/unload.h |   33 ++++++++++
 3 files changed, 200 insertions(+), 1 deletions(-)
 create mode 100644 fs/libunload.c
 create mode 100644 include/linux/unload.h

diff --git a/fs/Makefile b/fs/Makefile
index e6ec1d3..fa6bd11 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -11,7 +11,7 @@ obj-y :=	open.o read_write.o file_table.o super.o \
 		attr.o bad_inode.o file.o filesystems.o namespace.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
-		stack.o fs_struct.o statfs.o
+		stack.o fs_struct.o statfs.o libunload.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
diff --git a/fs/libunload.c b/fs/libunload.c
new file mode 100644
index 0000000..2470bf2
--- /dev/null
+++ b/fs/libunload.c
@@ -0,0 +1,166 @@
+#include <linux/fs.h>
+#include <linux/mm_types.h>
+#include <linux/mm.h>
+#include <linux/spinlock.h>
+#include <linux/module.h>
+#include <linux/unload.h>
+
+struct unload_barrier {
+	struct completion	completion;
+	int			releasers;
+};
+
+void unload_init(struct unload *unload)
+{
+	INIT_HLIST_HEAD(&unload->ufiles);
+	spin_lock_init(&unload->lock);
+	unload->active = 1;
+	unload->barrier = NULL;
+}
+EXPORT_SYMBOL_GPL(unload_init);
+
+void unload_file_init(struct unload_file *ufile, struct file *file, struct unload *unload)
+{
+	ufile->file = file;
+	ufile->unload = unload;
+	INIT_HLIST_NODE(&ufile->list);
+}
+EXPORT_SYMBOL_GPL(unload_file_init);
+
+bool unload_trylock(struct unload *unload)
+{
+	bool locked = false;
+	spin_lock(&unload->lock);
+	if (likely(!unload->barrier)) {
+		unload->active++;
+		locked = true;
+	}
+	spin_unlock(&unload->lock);
+	return locked;
+}
+EXPORT_SYMBOL_GPL(unload_trylock);
+
+static void __unload_unlock(struct unload *unload)
+{
+	unload->active--;
+	if ((unload->active == 0) && (unload->barrier->releasers == 0))
+		complete(&unload->barrier->completion);
+}
+
+void unload_unlock(struct unload *unload)
+{
+	spin_lock(&unload->lock);
+	__unload_unlock(unload);
+	spin_unlock(&unload->lock);
+}
+EXPORT_SYMBOL_GPL(unload_unlock);
+
+static void __unload_file_attach(struct unload_file *ufile, struct unload *unload)
+{
+	ufile->unload = unload;
+	hlist_add_head(&ufile->list, &unload->ufiles);
+}
+
+void unload_file_attach(struct unload_file *ufile, struct unload *unload)
+{
+	spin_lock(&unload->lock);
+	__unload_file_attach(ufile, unload);
+	spin_unlock(&unload->lock);
+}
+EXPORT_SYMBOL_GPL(unload_file_attach);
+
+static void __unload_file_detach(struct unload_file *ufile)
+{
+	hlist_del_init(&ufile->list);
+}
+
+void unload_file_detach(struct unload_file *ufile)
+{
+	struct unload *unload = ufile->unload;
+
+	spin_lock(&unload->lock);
+	__unload_file_detach(ufile);
+	spin_unlock(&unload->lock);
+}
+EXPORT_SYMBOL_GPL(unload_file_detach);
+
+struct unload_file *find_unload_file(struct unload *unload, struct file *file)
+{
+	struct unload_file *ufile;
+	struct hlist_node *pos;
+
+	spin_lock(&unload->lock);
+	hlist_for_each_entry(ufile, pos, &unload->ufiles, list) {
+		if (ufile->file == file)
+			goto done;
+	}
+	ufile = NULL;
+done:
+	spin_unlock(&unload->lock);
+	return ufile;
+}
+EXPORT_SYMBOL_GPL(find_unload_file);
+
+bool unload_release_trylock(struct unload_file *ufile)
+{
+	struct unload *unload = ufile->unload;
+	bool locked = false;
+
+	spin_lock(&unload->lock);
+	if (!hlist_unhashed(&ufile->list))
+		locked = true;
+	spin_unlock(&unload->lock);
+	return locked;
+}
+EXPORT_SYMBOL_GPL(unload_release_trylock);
+
+void unload_release_unlock(struct unload_file *ufile)
+{
+	struct unload *unload = ufile->unload;
+	struct unload_barrier *barrier;
+
+	spin_lock(&unload->lock);
+	__unload_file_detach(ufile);
+	barrier = unload->barrier;
+	if (barrier) {
+		barrier->releasers -= 1;
+		if ((barrier->releasers == 0) && (unload->active == 0))
+			complete(&barrier->completion);
+	}
+	spin_unlock(&unload->lock);
+}
+EXPORT_SYMBOL_GPL(unload_release_unlock);
+
+
+void unload_barrier(struct unload *unload)
+{
+	struct unload_barrier barrier;
+	struct unload_file *ufile;
+	struct hlist_node *pos;
+
+	/* Guarantee that when this function returns I am not
+	 * executing any code protected by the unload_lock or
+	 * unload_releas_lock, and that I will never again execute
+	 * code protected by those locks.
+	 *
+	 * Also guarantee the file count for every file remaining on
+	 * the unload ufiles list has been incremented.  The increment
+	 * of the file count guarantees __fput will not be called.
+	 */
+	init_completion(&barrier.completion);
+	barrier.releasers = 0;
+
+	spin_lock(&unload->lock);
+	unload->barrier = &barrier;
+
+	hlist_for_each_entry(ufile, pos, &unload->ufiles, list)
+		if (!atomic_long_inc_not_zero(&ufile->file->f_count))
+			barrier.releasers++;
+	unload->active--;
+	if (unload->active || barrier.releasers) {
+		spin_unlock(&unload->lock);
+		wait_for_completion(&barrier.completion);
+		spin_lock(&unload->lock);
+	}
+	spin_unlock(&unload->lock);
+}
diff --git a/include/linux/unload.h b/include/linux/unload.h
new file mode 100644
index 0000000..fc1b4f6
--- /dev/null
+++ b/include/linux/unload.h
@@ -0,0 +1,33 @@
+#ifndef _LINUX_UNLOAD_H
+#define _LINUX_UNLOAD_H
+
+#include <linux/list.h>
+
+struct file;
+struct vm_operations_struct;
+struct unload_barrier;
+
+struct unload {
+	struct hlist_head	ufiles;
+	struct unload_barrier	*barrier;
+	spinlock_t		lock;
+	int			active;
+};
+
+struct unload_file {
+	struct unload		*unload;
+	struct hlist_node	list;
+	struct file 		*file;
+};
+
+void unload_init(struct unload *unload);
+void unload_file_init(struct unload_file *ufile, struct file *file, struct unload *unload);
+bool unload_trylock(struct unload *unload);
+void unload_unlock(struct unload *unload);
+bool unload_release_trylock(struct unload_file *ufile);
+void unload_release_unlock(struct unload_file *ufile);
+void unload_file_attach(struct unload_file *ufile, struct unload *unload);
+void unload_file_detach(struct unload_file *ufile);
+struct unload_file *find_unload_file(struct unload *unload, struct file *file);
+void unload_barrier(struct unload *unload);
+#endif /* _LINUX_UNLOAD_H */
-- 
1.7.2.2

