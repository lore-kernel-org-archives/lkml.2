Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423818Ab2LGSVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 13:21:11 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:34042 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932284Ab2LGSVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 13:21:09 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        "Andrew G. Morgan" <morgan@kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: =?UTF-8?q?=5BPATCH=5D=20Document=20how=20capability=20bits=20work?=
Date: Fri,  7 Dec 2012 10:20:59 -0800
Message-Id: <3c3146b8bea5d8590ebc40ca1d22a562a5172873.1354904275.git.luto@amacapital.net>
X-Mailer: git-send-email 1.7.11.7
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 Documentation/security/capabilities.txt | 161 ++++++++++++++++++++++++++++++++
 1 file changed, 161 insertions(+)
 create mode 100644 Documentation/security/capabilities.txt

diff --git a/Documentation/security/capabilities.txt b/Documentation/security/capabilities.txt
new file mode 100644
index 0000000..dc7bc34
--- /dev/null
+++ b/Documentation/security/capabilities.txt
@@ -0,0 +1,161 @@
+			  Linux capabilities
+
+
+==== What are capabilities ====
+
+Various system calls check for appropriate privileges.  For example, a program
+may bypass normal file permission checking if it has the CAP_DAC_OVERRIDE
+capability.  There are a lot of capabilities; the complete list is in
+include/uapi/linux/capability.h.
+
+When reading this description, do not assume anything about the word
+"inheritable".  It probably does not do what you expect.
+
+Every task has the following pieces of capability-related state.
+
+ * Four capability bit masks:
+   * The effective set (pE).  Privileged operations check this set.
+   * The permitted set (pP).  Tasks may set these bits in pE.
+   * The inheritable set (pI).  This set is complicated.
+   * The bounding set (pB).  This partially limits new permitted capabilities.
+
+ * Secure bits.  Each bit has a corresponding "lock" bit.
+   * SECURE_NONROOT: Makes uid==0 and euid==0 less special at exec time.
+   * SECURE_KEEP_CAPS: Prevents setresuid() from removing permitted caps.
+   * SECURE_NO_SETUID_FIXUP: Makes setresuid() entirely nonmagical.
+
+ * no_new_privs: See Documentation/prctl/no_new_privs.txt
+
+There is one invariant: pE ⊆ pP.
+
+In addition, files can have capabilities.  If a file has capabilities, it
+specifies two masks and one bit:
+ * fP: The permitted or forced set.
+ * fI: The inheritable set.
+ * fE (a single bit): Supposedly true for "legacy" programs.
+
+libcap's setcap tool pretends that fE is a bitmask.  It's not.
+
+At the most basic level, only pE matters.  All of the complexity is in how
+pE and the other masks can change.  (This is a slight lie -- user namespaces
+change this.)
+
+==== System calls ====
+
+Capabilities and related state are affected by these syscalls:
+ * capset: Change capabilities directly.
+ * set[res]uid: Sometimes changes capabilities for legacy compatibility.
+ * prctl(PR_SET_KEEPCAPS): Used to twiddle SECURE_KEEP_CAPS.
+ * prctl(PR_SET_SECUREBITS): Used to twiddle securebits in general.
+ * prctl(PR_SET_NO_NEW_PRIVS): Used to set no_new_privs.
+ * prctl(PR_CAPBSET_DROP): Used to remove bits from pB.
+ * execve: Does all kinds of magic.
+
+==== capset ====
+
+capset changes pI, pP, and pE as requested, subject to:
+
+ - (CAP_SETPCAP ∈ pE or euid is namespace owner) or pI' ⊆ pI | pP
+ - pI' ⊆ pI | pB
+ - pP' ⊆ pP
+ - pE' ⊆ pE
+
+In the event that pI ⊆ pB, the first two conditions simplify to pI' ⊆ pI | pP.
+
+==== set*uid ====
+
+After set[res]uid, if !SECURE_NO_SETUID_FIXUP, a fixup happens.  This fixup
+does two things:
+
+ - If !SECURE_KEEP_CAPS and some old uid was 0 and no new uid is 0, then
+   pP and pE are cleared.
+ - If euid becomes zero, the pE = pP.  Conversely, if euid becomes nonzero,
+   then pE' = 0.  (Note that this is independent of SECURE_KEEP_CAPS.)
+
+setfsuid has similar logic to tweak the fs-related pE bits.
+
+====  prctl ====
+
+---- PR_SET_KEEPCAPS ----
+
+This changes SECURE_KEEP_CAPS as long as !SECURE_KEEP_CAPS_LOCKED.
+CAP_SETPCAP is not required.
+
+---- PR_SET_SECUREBITS ----
+
+This changes securebits, subject to:
+ - The caller must have CAP_SETPCAP.
+ - The *_LOCKED bits can be set but not cleared.
+ - A locked bit cannot be changed.
+
+Note that an unprivileged process can change SECURE_KEEP_CAPS via
+PR_SET_KEEPCAPS but not via PR_SET_SECUREBITS.
+
+---- PR_SET_NO_NEW_PRIVS ----
+
+Sets the no_new_privs bit.  No privilege is required.  It is impossible
+to clear the no_new_privs bit.
+
+---- PR_CAPBSET_DROP ----
+
+Clears a single bit of pB.  Doing this requires CAP_SETPCAP.  There is no
+way to set a cleared bit of pB.
+
+==== execve ====
+
+execve's behavior is rather complicated.  It does this:
+
+Step 1: Load fI, fP, and fE.  If the file has no capabilities (the xattr
+is malformed or absent), then set fI = 0, fP = 0, and fE = false.  (In theory,
+fE is set on "legacy" binaries that don't know how to check their own
+capability sets.)
+
+Step 2: Apply the basic pP update rule:
+
+   pP' = (pB & fP) | (pI & fI)
+
+Step 3: If fE and pP ⊈ fP, then abort.  (This prevents legacy binaries from
+malfunctioning dangerously if pB is missing important bits.)
+
+Step 4: Apply a fixup for root if !SECURE_NOROOT.  The fixup is:
+
+ - If vfs caps were present, uid != 0, and euid == 0, then warn once per boot.
+ - Otherwise:
+   - If euid == 0 or uid == 0, then pP' = pB | pI.
+   - If euid == 0, then set fE = true.  (This does not affect the check
+      in step 2.)
+
+Step 5: Apply no_new_privs
+
+If no_new_privs is set (or if new euid != old uid or new egit != old gid and
+an unprivileged ptracer is attached), then set euid = uid, egid = gid,
+and set pP' = pP' & pP.  (Note: If CAP_SETUID is effective (in the old context)
+and no_new_privs is not set, then the euid and egid changes are skipped.)
+
+Step 6: Compute pE
+
+If fE, then pE' = pP'.  Else pE' = 0.
+
+Step 7: Clear SECURE_KEEP_CAPS.
+
+This happens regardless of the setting of SECURE_KEEP_CAPS_LOCKED.  Setting
+SECURE_KEEP_CAPS_LOCKED is therefore probably a mistake unless
+SECURE_NO_SETUID_FIXUP is set.
+
+
+In the absence of something like no_new_privs, then either
+
+pP' = (pB & fP) | (pI & fI)  (the normal case)
+
+or
+
+pP' = pB | pI (if euid or uid == 0)
+
+The latter condition means that, if euid or uid is zero, then execve acts
+(in part) as though fP = fI = <all bits set>.
+
+
+The upshot: pI bits can result in actual (pP or pE) privilege if you exec a
+program that has that fI bit set *or* you have !issecure(SECURE_NOROOT) and
+(euid == 0 || uid == 0).  (That latter case is possibly better understood
+as promoting pB bits to pP.)
-- 
1.7.11.7

