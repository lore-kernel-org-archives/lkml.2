Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab2JRT6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 15:58:17 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:34060 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab2JRT6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 15:58:15 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwTz6xadNL37H6Qb8+rWNefn0cQ0URFPfD=Ea=J54xzGg@mail.gmail.com>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com>
	<87txtso9xw.fsf@rustcorp.com.au>
	<CA+55aFxZdtD51AVKLtKK95ooh8VB8-5Tt8nHsxSUT67CBRrp2g@mail.gmail.com>
	<871ugwny1n.fsf@rustcorp.com.au>
	<CA+55aFwTz6xadNL37H6Qb8+rWNefn0cQ0URFPfD=Ea=J54xzGg@mail.gmail.com>
Date: Thu, 18 Oct 2012 15:58:14 -0400
Message-ID: <CA+5PVA4fE7uaxNobBMtUs7QUWA2XfM_2oKtLhb7DFRisJLy+4Q@mail.gmail.com>
Subject: Re: RFC: sign the modules at install time
From: Josh Boyer <jwboyer@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, David Miller <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 2:46 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Oct 17, 2012 at 10:34 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>
>> Hacking the keyid and signer-name to be extracted every time by
>> sign-file takes my modules_install time from 18.6 seconds to 19.1.  We'd
>> get that back easily by making sign-file a perl script anyway; it calls
>> out to perl 3 times already.
>
> Ok, that tiny slowdown seems worth the cleanup, especially if we'd get
> it back from somebody re-writing it in perl.
>
> Want to sign off on the two patches, or put them in your git tree?

I tested Rusty's version of the 'sign modules at module_install time'
patch in a Fedora kernel build today.  It seems to work well enough,
even if we wind up signing things twice.  A brief cleanup of my patch
to add a modules_sign target on top of that is below.

It might even be able to be moved entirely into scripts/Makefile.modinst
but I haven't gotten that far yet.

josh

---

>From d83055aec38e5717957e621d94fff67241ef803d Mon Sep 17 00:00:00 2001
From: Josh Boyer <jwboyer@redhat.com>
Date: Mon, 24 Sep 2012 10:46:36 -0400
Subject: [PATCH] MODSIGN: Add modules_sign make target

If CONFIG_MODULE_SIG is set, and 'make modules_sign' is called then this
patch will cause the modules to get a signature appended.  The make target
is intended to be run after 'make modules_install', and will modify the
modules in-place in the installed location.  It can be used to produce
signed modules after they have been processed by distribution build
scripts.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 Makefile                 |  6 ++++++
 scripts/Makefile.modsign | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)
 create mode 100644 scripts/Makefile.modsign

diff --git a/Makefile b/Makefile
index 89a2e2c..ac04c11 100644
--- a/Makefile
+++ b/Makefile
@@ -981,6 +981,12 @@ _modinst_post: _modinst_
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.fwinst obj=firmware __fw_modinst
 	$(call cmd,depmod)

+ifeq ($(CONFIG_MODULE_SIG), y)
+PHONY += modules_sign
+modules_sign:
+	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modsign
+endif
+
 else # CONFIG_MODULES

 # Modules not configured
diff --git a/scripts/Makefile.modsign b/scripts/Makefile.modsign
new file mode 100644
index 0000000..670d5dc
--- /dev/null
+++ b/scripts/Makefile.modsign
@@ -0,0 +1,32 @@
+# ==========================================================================
+# Signing modules
+# ==========================================================================
+
+PHONY := __modsign
+__modsign:
+
+include scripts/Kbuild.include
+
+__modules := $(sort $(shell grep -h '\.ko' /dev/null $(wildcard
$(MODVERDIR)/*.mod)))
+modules := $(patsubst %.o,%.ko,$(wildcard $(__modules:.ko=.o)))
+
+PHONY += $(modules)
+__modsign: $(modules)
+	@:
+
+quiet_cmd_sign_ko = SIGN [M] $(2)/$(notdir $@)
+        cmd_sign_ko = $(mod_sign_cmd) $(2)/$(notdir $@)
+
+# Modules built outside the kernel source tree go into extra by default
+INSTALL_MOD_DIR ?= extra
+ext-mod-dir = $(INSTALL_MOD_DIR)$(subst $(patsubst
%/,%,$(KBUILD_EXTMOD)),,$(@D))
+
+modinst_dir = $(if $(KBUILD_EXTMOD),$(ext-mod-dir),kernel/$(@D))
+
+$(modules):
+	$(call cmd,sign_ko,$(MODLIB)/$(modinst_dir))
+
+# Declare the contents of the .PHONY variable as phony.  We keep that
+# # information in a variable se we can use it in if_changed and friends.
+
+.PHONY: $(PHONY)
-- 
1.7.12.1
