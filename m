Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652Ab1HKRTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 13:19:14 -0400
Received: from mga07.intel.com ([143.182.124.22]:34679 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751091Ab1HKRTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 13:19:13 -0400
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: linux-security-module@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        zohar@linux.vnet.ibm.com
Subject: [RFC v1.1 0/5]  evm: digital signature extension
Date: Thu, 11 Aug 2011 20:20:03 +0300
Message-Id: <cover.1313082284.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

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
http://meego.gitorious.org/meego-platform-security/ima-ksign

Supporting utility for key handling and signing is available here:
http://meego.gitorious.org/meego-platform-security/evm-utils

Regards,
Dmitry

Dmitry Kasatkin (5):
  crypto: GnuPG based MPI lib
  crypto: ksign - digital signature verification support
  evm: digital signature support
  ksign: provides keyring to search in for the key
  evm: creates dedicated evm keyring to store public keys

 crypto/Kconfig                      |   19 +
 crypto/Makefile                     |    4 +
 crypto/ksign.c                      |  270 +++++++
 crypto/mpi/Makefile                 |   30 +
 crypto/mpi/generic_mpi-asm-defs.h   |   10 +
 crypto/mpi/generic_mpih-add1.c      |   62 ++
 crypto/mpi/generic_mpih-lshift.c    |   66 ++
 crypto/mpi/generic_mpih-mul1.c      |   58 ++
 crypto/mpi/generic_mpih-mul2.c      |   63 ++
 crypto/mpi/generic_mpih-mul3.c      |   64 ++
 crypto/mpi/generic_mpih-rshift.c    |   65 ++
 crypto/mpi/generic_mpih-sub1.c      |   62 ++
 crypto/mpi/generic_udiv-w-sdiv.c    |  130 +++
 crypto/mpi/longlong.h               | 1502 +++++++++++++++++++++++++++++++++++
 crypto/mpi/mpi-add.c                |  258 ++++++
 crypto/mpi/mpi-bit.c                |  245 ++++++
 crypto/mpi/mpi-cmp.c                |   71 ++
 crypto/mpi/mpi-div.c                |  345 ++++++++
 crypto/mpi/mpi-gcd.c                |   60 ++
 crypto/mpi/mpi-inline.c             |   33 +
 crypto/mpi/mpi-inline.h             |  128 +++
 crypto/mpi/mpi-internal.h           |  265 ++++++
 crypto/mpi/mpi-inv.c                |  148 ++++
 crypto/mpi/mpi-mpow.c               |  113 +++
 crypto/mpi/mpi-mul.c                |  202 +++++
 crypto/mpi/mpi-pow.c                |  312 ++++++++
 crypto/mpi/mpi-scan.c               |  129 +++
 crypto/mpi/mpicoder.c               |  359 +++++++++
 crypto/mpi/mpih-cmp.c               |   58 ++
 crypto/mpi/mpih-div.c               |  534 +++++++++++++
 crypto/mpi/mpih-mul.c               |  546 +++++++++++++
 crypto/mpi/mpiutil.c                |  213 +++++
 include/linux/crypto/ksign.h        |   48 ++
 include/linux/crypto/mpi.h          |  147 ++++
 security/integrity/evm/Kconfig      |   14 +
 security/integrity/evm/evm.h        |   33 +
 security/integrity/evm/evm_crypto.c |   66 ++-
 security/integrity/evm/evm_main.c   |   83 ++-
 38 files changed, 6783 insertions(+), 32 deletions(-)
 create mode 100644 crypto/ksign.c
 create mode 100644 crypto/mpi/Makefile
 create mode 100644 crypto/mpi/generic_mpi-asm-defs.h
 create mode 100644 crypto/mpi/generic_mpih-add1.c
 create mode 100644 crypto/mpi/generic_mpih-lshift.c
 create mode 100644 crypto/mpi/generic_mpih-mul1.c
 create mode 100644 crypto/mpi/generic_mpih-mul2.c
 create mode 100644 crypto/mpi/generic_mpih-mul3.c
 create mode 100644 crypto/mpi/generic_mpih-rshift.c
 create mode 100644 crypto/mpi/generic_mpih-sub1.c
 create mode 100644 crypto/mpi/generic_udiv-w-sdiv.c
 create mode 100644 crypto/mpi/longlong.h
 create mode 100644 crypto/mpi/mpi-add.c
 create mode 100644 crypto/mpi/mpi-bit.c
 create mode 100644 crypto/mpi/mpi-cmp.c
 create mode 100644 crypto/mpi/mpi-div.c
 create mode 100644 crypto/mpi/mpi-gcd.c
 create mode 100644 crypto/mpi/mpi-inline.c
 create mode 100644 crypto/mpi/mpi-inline.h
 create mode 100644 crypto/mpi/mpi-internal.h
 create mode 100644 crypto/mpi/mpi-inv.c
 create mode 100644 crypto/mpi/mpi-mpow.c
 create mode 100644 crypto/mpi/mpi-mul.c
 create mode 100644 crypto/mpi/mpi-pow.c
 create mode 100644 crypto/mpi/mpi-scan.c
 create mode 100644 crypto/mpi/mpicoder.c
 create mode 100644 crypto/mpi/mpih-cmp.c
 create mode 100644 crypto/mpi/mpih-div.c
 create mode 100644 crypto/mpi/mpih-mul.c
 create mode 100644 crypto/mpi/mpiutil.c
 create mode 100644 include/linux/crypto/ksign.h
 create mode 100644 include/linux/crypto/mpi.h

-- 
1.7.4.1

