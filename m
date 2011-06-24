Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760207Ab1FXBsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 21:48:31 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42513 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760005Ab1FXBsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 21:48:30 -0400
X-SecurityPolicyCheck-FJ: OK by FUJITSU ADVANCED ENGINEERING MailBarrier
Date: Fri, 24 Jun 2011 10:48:08 +0900
From: =?ISO-2022-JP?B?IkZKQ0wpIBskQjIuTG4bKEIgGyRCQmdKZRsoQg==?=
	 =?ISO-2022-JP?B?Ig==?= <ogino.daisuke@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Subject: [patch] procfs: returns ENOENT on opening the being-removed proc entry
Cc: linux-pci@vger.kernel.org, adobriyan@gmail.com
Message-Id: <20110624104509.6195.371AB99A@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daisuke Ohino <ogino.daisuke@jp.fujitsu.com>

opening the proc entry may return EINVAL if the entry is being removed, for
example open("/proc/bus/pci/XX/YY") during the corresponding device is being
hot-removed. The return value is inappropriate and should return ENOENT.

This return value comes from proc_reg_open().

fs/proc/inode.c:
-----------------------------------------------------------
static int proc_reg_open(struct inode *inode, struct file *file)
{
(snip)
        if (!pde->proc_fops) {
                spin_unlock(&pde->pde_unload_lock);
                kfree(pdeo);
                return -EINVAL;
        }
(snip)
-----------------------------------------------------------

pde->proc_fops is NULL iff the proc entry is being removed. It
is set by remove_proc_entry().

-----------------------------------------------------------
void remove_proc_entry(const char *name, struct proc_dir_entry*parent)
{
(snip)
        /*
         * Stop accepting new callers into module. If you're
         * dynamically allocating ->proc_fops, save a pointer somewhere.
         */
        de->proc_fops = NULL;
(snip)
-----------------------------------------------------------

But POSIX says:

-----------------------------------------------------------
[EINVAL]
    The implementation does not support synchronized I/O for this file.
-----------------------------------------------------------

Since removing proc entry is apparently not related to synchronized I/O,
this function should return ENOENT in this case.

Signed-off-by: Daisuke Ogino <ogino.daisuke@jp.fujitsu.com>
---
 fs/proc/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 74b48cf..7ed72d6 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -319,7 +319,7 @@ static int proc_reg_open(struct inode *inode, struct file *file)
 	if (!pde->proc_fops) {
 		spin_unlock(&pde->pde_unload_lock);
 		kfree(pdeo);
-		return -EINVAL;
+		return -ENOENT;
 	}
 	pde->pde_users++;
 	open = pde->proc_fops->open;
--

Since I don't subscribe LKML, please Cc me if you have any comment.

Thanks,
Daisuke


