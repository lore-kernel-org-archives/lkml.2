Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab2JEMnE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 08:43:04 -0400
Received: from tundra.namei.org ([65.99.196.166]:36971 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572Ab2JEMnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 08:43:02 -0400
Date: Fri, 5 Oct 2012 22:43:43 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] Security subsystem: IMA bugfix
Message-ID: <alpine.LRH.2.02.1210052242520.18216@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PLease pull this bugfix for the Integrity code.

The following changes since commit ecefbd94b834fa32559d854646d777c56749ef1c:
  Linus Torvalds (1):
        Merge tag 'kvm-3.7-1' of git://git.kernel.org/pub/scm/virt/kvm/kvm

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Dmitry Kasatkin (1):
      ima: fix bug in argument order

 security/integrity/ima/ima.h          |    6 +++---
 security/integrity/ima/ima_appraise.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

commit d26e1936227b538a1691b978566ef269aef10853
Author: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Date:   Thu Sep 27 18:26:53 2012 +0300

    ima: fix bug in argument order
    
    mask argument goes first, then func, like ima_must_measure
    and ima_get_action. ima_inode_post_setattr() assumes that.
    
    Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
    Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
    Signed-off-by: James Morris <james.l.morris@oracle.com>

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 8180add..6ee8826 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -143,7 +143,7 @@ void ima_delete_rules(void);
 #ifdef CONFIG_IMA_APPRAISE
 int ima_appraise_measurement(struct integrity_iint_cache *iint,
 			     struct file *file, const unsigned char *filename);
-int ima_must_appraise(struct inode *inode, enum ima_hooks func, int mask);
+int ima_must_appraise(struct inode *inode, int mask, enum ima_hooks func);
 void ima_update_xattr(struct integrity_iint_cache *iint, struct file *file);
 
 #else
@@ -154,8 +154,8 @@ static inline int ima_appraise_measurement(struct integrity_iint_cache *iint,
 	return INTEGRITY_UNKNOWN;
 }
 
-static inline int ima_must_appraise(struct inode *inode,
-				    enum ima_hooks func, int mask)
+static inline int ima_must_appraise(struct inode *inode, int mask,
+				    enum ima_hooks func)
 {
 	return 0;
 }
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 0aa43bd..bdc8ba1 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -34,7 +34,7 @@ __setup("ima_appraise=", default_appraise_setup);
  *
  * Return 1 to appraise
  */
-int ima_must_appraise(struct inode *inode, enum ima_hooks func, int mask)
+int ima_must_appraise(struct inode *inode, int mask, enum ima_hooks func)
 {
 	if (!ima_appraise)
 		return 0;
