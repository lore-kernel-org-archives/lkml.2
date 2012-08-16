Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655Ab2HPBib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 21:38:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757636Ab2HPBiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 21:38:23 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 22/25] MODSIGN: Automatically generate module signing keys if
 missing
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        jmorris@namei.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 16 Aug 2012 02:38:13 +0100
Message-ID: <20120816013813.872.52922.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120816013405.872.42381.stgit@warthog.procyon.org.uk>
References: <20120816013405.872.42381.stgit@warthog.procyon.org.uk>
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

 kernel/Makefile |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)


diff --git a/kernel/Makefile b/kernel/Makefile
index 895bef0..f612ed0 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -133,4 +133,43 @@ targets += timeconst.h
 $(obj)/timeconst.h: $(src)/timeconst.pl FORCE
 	$(call if_changed,timeconst)
 
+###############################################################################
+#
+# If module signing is requested, say by allyesconfig, but a key has not been
+# supplied, then one will need to be generated to make sure the build does not
+# fail and that the kernel may be used afterwards.
+#
+###############################################################################
+ifeq ($(CONFIG_MODULE_SIG),y)
 kernel/modsign-pubkey.o: modsign.pub
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

