Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964873Ab2EJXo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:44:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933007Ab2EJXoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:44:21 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 28/29] MODSIGN: Automatically generate module signing keys if
 missing [ver #4]
To: rusty@rustcorp.com.au
Cc: kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        David Howells <dhowells@redhat.com>
Date: Fri, 11 May 2012 00:44:11 +0100
Message-ID: <20120510234411.4137.88410.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
References: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Automatically generate keys for module signing if they're absent so that
allyesconfig doesn't break.  The builder should consider generating their own
keyrings, however, so that the keys are appropriately named and any extra keys
required get imported.

Also change the names of the keyring files to modsign.pub and modsign.sec so
that they are then a more obvious what they're about and add a dependency for
the signing rules on the keyring files so that the signatures get regenerated
if the keyrings change.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/Makefile |   42 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 41 insertions(+), 1 deletions(-)


diff --git a/kernel/Makefile b/kernel/Makefile
index 986ed7f..d8139bb 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -52,7 +52,6 @@ obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
 obj-$(CONFIG_UID16) += uid16.o
 obj-$(CONFIG_MODULES) += module.o
 obj-$(CONFIG_MODULE_SIG) += module-verify.o modsign-pubkey.o
-kernel/modsign-pubkey.o: modsign.pub
 obj-$(CONFIG_KALLSYMS) += kallsyms.o
 obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
 obj-$(CONFIG_KEXEC) += kexec.o
@@ -129,3 +128,44 @@ quiet_cmd_timeconst  = TIMEC   $@
 targets += timeconst.h
 $(obj)/timeconst.h: $(src)/timeconst.pl FORCE
 	$(call if_changed,timeconst)
+
+###############################################################################
+#
+# If module signing is requested, say by allyesconfig, but a key has not been
+# supplied, then one will need to be generated to make sure the build does not
+# fail and that the kernel may be used afterwards.
+#
+###############################################################################
+ifeq ($(CONFIG_MODULE_SIG),y)
+kernel/modsign-pubkey.o: modsign.pub
+
+modsign.pub modsign.sec: genkey
+	@echo "###"
+	@echo "### Now generating a PGP key pair to be used for signing modules."
+	@echo "###"
+	@echo "### If this takes a long time, you might wish to run rngd in the"
+	@echo "### background to keep the supply of entropy topped up.  It"
+	@echo "### needs to be run as root, and should use a hardware random"
+	@echo "### number generator if one is available, eg:"
+	@echo "###"
+	@echo "###     rngd -r /dev/hwrandom"
+	@echo "###"
+	gpg --homedir . --batch --gen-key genkey
+	@echo "###"
+	@echo "### Key pair generated."
+	@echo "###"
+	rm -f pubring.gpg secring.gpg trustdb.gpg
+
+genkey:
+	echo "%pubring modsign.pub" >genkey
+	echo "%secring modsign.sec" >>genkey
+	echo "%no-protection: yes" >> genkey
+	echo "%transient-key: yes" >>genkey
+	echo "Key-Type: RSA" >>genkey
+	echo "Key-Length: 4096" >>genkey
+	echo "Name-Real: Sample kernel key" >>genkey
+	echo "Name-Comment: Sample kernel module signing key" >>genkey
+	echo "%commit" >>genkey
+
+endif
+CLEAN_FILES += modsign.pub modsign.sec genkey random_seed

