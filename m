Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab1IMOSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 10:18:41 -0400
Received: from mga12.intel.com ([143.182.124.36]:37413 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752937Ab1IMOSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 10:18:39 -0400
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: linux-security-module@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        zohar@linux.vnet.ibm.com, dhowells@redhat.com,
        herbert@gondor.hengli.com.au
Subject: [RFC v2.1 0/6] evm: digital signature verification extension
Date: Tue, 13 Sep 2011 17:20:07 +0300
Message-Id: <cover.1315921427.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Changes to version 2.0:
- MPI patch has been split to smaller in order to go to mailing lists.
  First 2 patches include only source and header files which are needed
  to build ksign verification. Headers and sources are split just to
  meet 100k kernel.org limit.
  Last patch adds all rest soures from original ported MPI library.
  
Changes to version 1.1:
- GnuPG MPI library has been refactored with lindent and checkpatch errors
  and warnings has been fixed.
- creation of evm keyring has been remove. It is done now in user space.
- related ksign and evm patches has been squashed.
- patch descriptions has been updated.
 
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

Dmitry Kasatkin (6):
  crypto: GnuPG based MPI lib - source files needed for ksign
  crypto: GnuPG based MPI lib - header files needed for ksign
  crypto: GnuPG based MPI lib - make files needed for ksign
  crypto: GnuPG based MPI lib - extra MPI sources
  crypto: ksign - digital signature verification support
  evm: digital signature verification support

 crypto/Kconfig                      |   19 +
 crypto/Makefile                     |    4 +
 crypto/ksign.c                      |  269 +++++++
 crypto/mpi/Makefile                 |   30 +
 crypto/mpi/generic_mpi-asm-defs.h   |    4 +
 crypto/mpi/generic_mpih-add1.c      |   61 ++
 crypto/mpi/generic_mpih-lshift.c    |   63 ++
 crypto/mpi/generic_mpih-mul1.c      |   57 ++
 crypto/mpi/generic_mpih-mul2.c      |   60 ++
 crypto/mpi/generic_mpih-mul3.c      |   61 ++
 crypto/mpi/generic_mpih-rshift.c    |   63 ++
 crypto/mpi/generic_mpih-sub1.c      |   60 ++
 crypto/mpi/generic_udiv-w-sdiv.c    |  106 +++
 crypto/mpi/longlong.h               | 1478 +++++++++++++++++++++++++++++++++++
 crypto/mpi/mpi-add.c                |  234 ++++++
 crypto/mpi/mpi-bit.c                |  235 ++++++
 crypto/mpi/mpi-cmp.c                |   68 ++
 crypto/mpi/mpi-div.c                |  333 ++++++++
 crypto/mpi/mpi-gcd.c                |   59 ++
 crypto/mpi/mpi-inline.c             |   31 +
 crypto/mpi/mpi-inline.h             |  122 +++
 crypto/mpi/mpi-internal.h           |  260 ++++++
 crypto/mpi/mpi-inv.c                |  187 +++++
 crypto/mpi/mpi-mpow.c               |  133 ++++
 crypto/mpi/mpi-mul.c                |  194 +++++
 crypto/mpi/mpi-pow.c                |  322 ++++++++
 crypto/mpi/mpi-scan.c               |  136 ++++
 crypto/mpi/mpicoder.c               |  361 +++++++++
 crypto/mpi/mpih-cmp.c               |   56 ++
 crypto/mpi/mpih-div.c               |  541 +++++++++++++
 crypto/mpi/mpih-mul.c               |  527 +++++++++++++
 crypto/mpi/mpiutil.c                |  206 +++++
 include/linux/crypto/ksign.h        |   67 ++
 include/linux/crypto/mpi.h          |  146 ++++
 security/integrity/evm/Kconfig      |   15 +
 security/integrity/evm/evm.h        |   12 +
 security/integrity/evm/evm_crypto.c |   66 ++-
 security/integrity/evm/evm_main.c   |  125 +++-
 38 files changed, 6741 insertions(+), 30 deletions(-)
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

