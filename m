Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab2LEBrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 20:47:53 -0500
Received: from ozlabs.org ([203.10.76.45]:36376 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329Ab2LEBrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 20:47:43 -0500
From: Rusty Russell <rusty@ozlabs.org>
To: David Howells <dhowells@redhat.com>, Michal Marek <mmarek@suse.cz>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, James Hogan <james.hogan@imgtec.com>
Subject: Re: [PATCH 2/3] MODSIGN: Avoid using .incbin in C source
In-Reply-To: <22396.1354645048@warthog.procyon.org.uk>
References: <1354616321-13520-2-git-send-email-mmarek@suse.cz> <1354616321-13520-1-git-send-email-mmarek@suse.cz> <22396.1354645048@warthog.procyon.org.uk>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 05 Dec 2012 10:28:48 +1030
Message-ID: <87hao1gyiv.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> Michal Marek <mmarek@suse.cz> wrote:
>
>> Using the asm .incbin statement in C sources breaks any gcc wrapper which
>> assumes that preprocessed C source is self-contained. Use a separate .S
>> file to include the siging key and certificate.
>
> I was trying to avoid that as .S files generally don't crop up in generic
> code and the format of the assembly varies with the arch.  However, you don't
> seem to have anything that should cause a problem - so:
>
> Acked-by: David Howells <dhowells@redhat.com>

GLOBAL() is defined in x86 only, AFAICT.

Plus, we now have a patch from James (CC:d) to prepend
CONFIG_SYMBOL_PREFIX to these as requird.

I think this will have to be done more carefully...

Thanks,
Rusty.

From: Takashi Iwai <tiwai@suse.de>

Using the asm .incbin statement in C sources breaks any gcc wrapper which
assumes that preprocessed C source is self-contained. Use a separate .S
file to include the siging key and certificate.

Tested-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 kernel/Makefile              |    4 ++--
 kernel/modsign_certificate.S |    9 +++++++++
 kernel/modsign_pubkey.c      |    6 ------
 3 files changed, 11 insertions(+), 8 deletions(-)
 create mode 100644 kernel/modsign_certificate.S

diff --git a/kernel/Makefile b/kernel/Makefile
index 86e3285..0bd9d43 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -54,7 +54,7 @@ obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
 obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
 obj-$(CONFIG_UID16) += uid16.o
 obj-$(CONFIG_MODULES) += module.o
-obj-$(CONFIG_MODULE_SIG) += module_signing.o modsign_pubkey.o
+obj-$(CONFIG_MODULE_SIG) += module_signing.o modsign_pubkey.o modsign_certificate.o
 obj-$(CONFIG_KALLSYMS) += kallsyms.o
 obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
 obj-$(CONFIG_KEXEC) += kexec.o
@@ -139,7 +139,7 @@ ifeq ($(CONFIG_MODULE_SIG),y)
 extra_certificates:
 	touch $@
 
-kernel/modsign_pubkey.o: signing_key.x509 extra_certificates
+kernel/modsign_certificate.o: signing_key.x509 extra_certificates
 
 ###############################################################################
 #
diff --git a/kernel/modsign_certificate.S b/kernel/modsign_certificate.S
new file mode 100644
index 0000000..6bde029
--- /dev/null
+++ b/kernel/modsign_certificate.S
@@ -0,0 +1,9 @@
+#include <linux/linkage.h>
+
+	.section ".init.data","aw"
+
+GLOBAL(modsign_certificate_list)
+	.incbin "signing_key.x509"
+	.incbin "extra_certificates"
+END(modsign_certificate_list)
+GLOBAL(modsign_certificate_list_end)
diff --git a/kernel/modsign_pubkey.c b/kernel/modsign_pubkey.c
index 4646eb2..045504f 100644
--- a/kernel/modsign_pubkey.c
+++ b/kernel/modsign_pubkey.c
@@ -20,12 +20,6 @@ struct key *modsign_keyring;
 
 extern __initdata const u8 modsign_certificate_list[];
 extern __initdata const u8 modsign_certificate_list_end[];
-asm(".section .init.data,\"aw\"\n"
-    "modsign_certificate_list:\n"
-    ".incbin \"signing_key.x509\"\n"
-    ".incbin \"extra_certificates\"\n"
-    "modsign_certificate_list_end:"
-    );
 
 /*
  * We need to make sure ccache doesn't cache the .o file as it doesn't notice
-- 
1.7.10.4

