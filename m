Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab2HOSnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 14:43:24 -0400
Received: from mga07.intel.com ([143.182.124.22]:26891 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752645Ab2HOSnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 14:43:23 -0400
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: zohar@linux.vnet.ibm.com, jmorris@namei.org, rusty@rustcorp.com.au,
        dhowells@redhat.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC v2 0/7] modsig: signature based kernel module integrity verfication
Date: Wed, 15 Aug 2012 21:43:05 +0300
Message-Id: <cover.1345055638.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

IMA measures/appraises modules when modprobe or insmod opens and reads them.
Unfortunately, there are no guarantees between what is read by userspace and
what is passed to the kernel via load_module system call. This patch adds
support for digital signature verification of kernel modules.

It uses the upstreamed digital signature verification support, which is also
used by IMA/EVM. There is no dependency on IMA/EVM, but both use the same
signature and key formats, defined by digital signature verification support.

These patches are intended to support the different use cases, from an
individual developer creating ephemeral keys, to the distro having an
existing signing mechanism in place.

For the distro, a well known public key can simply be embedded in the
kernel during the 'make' process.

For the developer, these patches create an ephemeral key during module
install, in order to limit the duration of the private key's existence.
Unfortunately, this necessitates embedding the public key in the kernel,
after the kernel has already been built.  A new make target called
'signed_modules_install', creates the keypair, signs the modules,
removes the private key, and then, for now, recompiles the kernel using
'make bzImage'.  For the developer, instead of doing 'make
modules_install', the new build process would be 'make', followed by
'make signed_modules_install' and 'make install'.

Scripts:
- new scripts/ksign.sh and scripts/genkey.sh scripts
- new targets signed_module_install and genkey for the top Makefile
- scripts/Makefile.modinst changes

Changelog v2:
- Replaces passing the signature as a separate argument, with appending
  the signature to the kernel module during module install, as suggested
  by Rusty Russell. (No module-init-tools changes required.)
- The signature is created during module install, after the module was
  possibly stripped.
- Added support for using a builtin public key. (No requirement for an
  initramfs to load the public key.)
- Added key creation and signing support to kernel Makefiles.
- Permits developers to conveniently sign their own modules with an
  ephemeral key using "make signed_modules_install".

- Dmitry & Mimi

Dmitry Kasatkin (4):
  integrity: added digest calculation function
  modsig: add integrity_module_check hook
  modsig: verify module integrity based on signature
  modsig: build rules and scripts to generate keys and sign modules

Mimi Zohar (3):
  keys: initialize root uid and session keyrings early
  integrity: create and inititialize a keyring with builtin public key
  modsig: initialize the _module public key keyring

 Makefile                           |   38 ++++++++++
 include/linux/integrity.h          |   10 +++
 kernel/module.c                    |    9 +++
 scripts/Makefile.modinst           |    1 +
 scripts/genkey.sh                  |  135 ++++++++++++++++++++++++++++++++++++
 scripts/ksign.sh                   |   64 +++++++++++++++++
 security/integrity/Kconfig         |   21 ++++++
 security/integrity/Makefile        |   18 +++++
 security/integrity/digsig.c        |   31 ++++++++-
 security/integrity/digsig_pubkey.c |   96 +++++++++++++++++++++++++
 security/integrity/integrity.h     |   13 ++++
 security/integrity/module.c        |   91 ++++++++++++++++++++++++
 security/keys/Makefile             |    1 +
 security/keys/root_keyring.c       |   18 +++++
 14 files changed, 544 insertions(+), 2 deletions(-)
 create mode 100755 scripts/genkey.sh
 create mode 100755 scripts/ksign.sh
 create mode 100644 security/integrity/digsig_pubkey.c
 create mode 100644 security/integrity/module.c
 create mode 100644 security/keys/root_keyring.c

-- 
1.7.9.5

