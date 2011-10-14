Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659Ab1JNNnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 09:43:12 -0400
Received: from mga10.intel.com ([192.55.52.92]:43315 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753528Ab1JNNnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 09:43:09 -0400
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: linux-security-module@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        zohar@linux.vnet.ibm.com, dhowells@redhat.com,
        herbert@gondor.hengli.com.au
Subject: [PATCH v2.1 0/7] evm: digital signature verification extension
Date: Fri, 14 Oct 2011 16:45:18 +0300
Message-Id: <cover.1318598705.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Changes to version 2.1:
* MPI lib moved to /lib directory.
* added configuration option CONFIG_MPILIB_EXTRA to exclude building
  a part of MPI library, which is not used in RSA impelementation.
* added API documentation
* added Documentation for digsig
* splitted evm digital signature verification patch into 2.
  Common code will be used by IMA digital singnature verification.

Changes to version 2.0:
* MPI patch has been split to smaller in order to go to mailing lists.
  First 2 patches include only source and header files which are needed
  to build ksign verification. Headers and sources are split just to
  meet 100k kernel.org limit.
  Last patch adds all rest soures from original ported MPI library.
  
Changes to version 1.1:
* GnuPG MPI library has been refactored with lindent and checkpatch errors
  and warnings has been fixed.
* creation of evm keyring has been remove. It is done now in user space.
* related ksign and evm patches has been squashed.
* patch descriptions has been updated.
 
As EVM patches were recently merged to security-testing-2.6#next,
it is a good time to resend evm signature verification patches for active
discussion. Last time I forgot --cc linux-crypto. Here it is.

This patchset introduces digital signature extensions for the IMA/EVM kernel
integrity subsystem and is applied on the top of the EVM patches posted to
LSM mailing list earlier.

Currently EVM stores the HMAC in security.evm to verify integrity of the
file's metadata. This is quite sufficient for individually installed systems,
where a system unique HMAC key can be provisioned and the initial filesystem
labeling can be done.

Software installation for consumer electronics or embedded devices is usually
done via flashing a filesystem image. Initial filesystem image labeling is done
during image creation process. It either has to be done (1) using a system
unique HMAC key or (2) using an image specific HMAC key. In first case, those
keys are either unknown, or a unique image has to be created for thousand or
millions of devices, which is not feasible. The second case, using an image
specific HMAC key, would require (2.1) provisioning of the key to millions of
devices, which is not easily feasible or (2.1) encrypting the key with a shared
symmetric key which is not a strong security measure.

Digital signature extension for EVM provides a solution to perform labeling of
the image using a single digital private key and use a known public key to
verify the signature. For performance reasons, after verification, signature is
replaced with local HMAC.

Digital signature verification uses RSA algorithm, implemented using cut-down
port of multi-precision integers (MPI) library from GnuPG and has been taken
from RedHat Enterprise Linux kernel (MODSIGN patches). Decision to use this
library was made, because its performance was 2 times better than other ports
such as libtommath library.

The GnuPG MPI library patch was posted here on linux-crypto back in
http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg05613.html.
Reason for upstreaming was that it to be a solid in-kernel user of the API.
Now with the recent merging of the EVM patches in linux-next via
security-testing-2.6/#next, MPI library is required for EVM digital signature
verification extension.

The motivation for integrity protection, in general, is to protect against
offline modifications. The runtime protection is ensured via access control
mechanisms.  Of particular importance is protecting users or owners from being
sold or given tampered devices, which can do nasty things such as spying or
stealing personal data. Integrity protection ensures that modifications of the
system will not remain undetected. The EVM digital signature extension makes
this feasible for consumerelectronics/embedded devices.

There is also a second patchset which implements digital signature support for
IMA-appraisal patchset, which is planned to be reviewed right after the
IMA-appaisal review.

All patches on the top of ima-2.6 (3.x.x) kernel are available here:
git://git.kernel.org/pub/scm/linux/kernel/git/kasatkin/ima-ksign.git
http://meego.gitorious.org/meego-platform-security/ima-ksign

Supporting utility for key handling and signing is available here:
http://meego.gitorious.org/meego-platform-security/evm-utils

Regards,
Dmitry

Dmitry Kasatkin (7):
  crypto: GnuPG based MPI lib - source files (part 1)
  crypto: GnuPG based MPI lib - header files (part 2)
  crypto: GnuPG based MPI lib - make files (part 3)
  crypto: GnuPG based MPI lib - additional sources (part 4)
  crypto: digital signature verification support
  integrity: digital signature verification using multiple keyrings
  evm: digital signature verification support

 Documentation/digsig.txt            |   97 +++
 include/linux/digsig.h              |   64 ++
 include/linux/mpi.h                 |  146 ++++
 lib/Kconfig                         |   25 +
 lib/Makefile                        |    3 +
 lib/digsig.c                        |  283 +++++++
 lib/mpi/Makefile                    |   34 +
 lib/mpi/generic_mpi-asm-defs.h      |    4 +
 lib/mpi/generic_mpih-add1.c         |   61 ++
 lib/mpi/generic_mpih-lshift.c       |   63 ++
 lib/mpi/generic_mpih-mul1.c         |   57 ++
 lib/mpi/generic_mpih-mul2.c         |   60 ++
 lib/mpi/generic_mpih-mul3.c         |   61 ++
 lib/mpi/generic_mpih-rshift.c       |   63 ++
 lib/mpi/generic_mpih-sub1.c         |   60 ++
 lib/mpi/generic_udiv-w-sdiv.c       |  106 +++
 lib/mpi/longlong.h                  | 1478 +++++++++++++++++++++++++++++++++++
 lib/mpi/mpi-add.c                   |  234 ++++++
 lib/mpi/mpi-bit.c                   |  236 ++++++
 lib/mpi/mpi-cmp.c                   |   68 ++
 lib/mpi/mpi-div.c                   |  333 ++++++++
 lib/mpi/mpi-gcd.c                   |   59 ++
 lib/mpi/mpi-inline.c                |   31 +
 lib/mpi/mpi-inline.h                |  122 +++
 lib/mpi/mpi-internal.h              |  261 ++++++
 lib/mpi/mpi-inv.c                   |  187 +++++
 lib/mpi/mpi-mpow.c                  |  133 ++++
 lib/mpi/mpi-mul.c                   |  194 +++++
 lib/mpi/mpi-pow.c                   |  323 ++++++++
 lib/mpi/mpi-scan.c                  |  136 ++++
 lib/mpi/mpicoder.c                  |  365 +++++++++
 lib/mpi/mpih-cmp.c                  |   56 ++
 lib/mpi/mpih-div.c                  |  541 +++++++++++++
 lib/mpi/mpih-mul.c                  |  527 +++++++++++++
 lib/mpi/mpiutil.c                   |  208 +++++
 security/integrity/Kconfig          |   14 +
 security/integrity/Makefile         |    1 +
 security/integrity/digsig.c         |   48 ++
 security/integrity/evm/evm.h        |   12 +
 security/integrity/evm/evm_crypto.c |   66 ++-
 security/integrity/evm/evm_main.c   |   94 ++-
 security/integrity/integrity.h      |   20 +
 42 files changed, 6904 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/digsig.txt
 create mode 100644 include/linux/digsig.h
 create mode 100644 include/linux/mpi.h
 create mode 100644 lib/digsig.c
 create mode 100644 lib/mpi/Makefile
 create mode 100644 lib/mpi/generic_mpi-asm-defs.h
 create mode 100644 lib/mpi/generic_mpih-add1.c
 create mode 100644 lib/mpi/generic_mpih-lshift.c
 create mode 100644 lib/mpi/generic_mpih-mul1.c
 create mode 100644 lib/mpi/generic_mpih-mul2.c
 create mode 100644 lib/mpi/generic_mpih-mul3.c
 create mode 100644 lib/mpi/generic_mpih-rshift.c
 create mode 100644 lib/mpi/generic_mpih-sub1.c
 create mode 100644 lib/mpi/generic_udiv-w-sdiv.c
 create mode 100644 lib/mpi/longlong.h
 create mode 100644 lib/mpi/mpi-add.c
 create mode 100644 lib/mpi/mpi-bit.c
 create mode 100644 lib/mpi/mpi-cmp.c
 create mode 100644 lib/mpi/mpi-div.c
 create mode 100644 lib/mpi/mpi-gcd.c
 create mode 100644 lib/mpi/mpi-inline.c
 create mode 100644 lib/mpi/mpi-inline.h
 create mode 100644 lib/mpi/mpi-internal.h
 create mode 100644 lib/mpi/mpi-inv.c
 create mode 100644 lib/mpi/mpi-mpow.c
 create mode 100644 lib/mpi/mpi-mul.c
 create mode 100644 lib/mpi/mpi-pow.c
 create mode 100644 lib/mpi/mpi-scan.c
 create mode 100644 lib/mpi/mpicoder.c
 create mode 100644 lib/mpi/mpih-cmp.c
 create mode 100644 lib/mpi/mpih-div.c
 create mode 100644 lib/mpi/mpih-mul.c
 create mode 100644 lib/mpi/mpiutil.c
 create mode 100644 security/integrity/digsig.c

-- 
1.7.4.1

