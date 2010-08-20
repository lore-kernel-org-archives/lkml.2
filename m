Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab0HTIq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:46:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab0HTIqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:46:21 -0400
From: =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-crypto@vger.kernel.org,
        Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
Subject: [PATCH 00/19] RFC, v2: "New" /dev/crypto user-space interface
Date: Fri, 20 Aug 2010 10:45:43 +0200
Message-Id: <1282293963-27807-1-git-send-email-mitr@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
following is a patchset providing an user-space interface to the kernel crypto
API.  It is based on the older, BSD-compatible, implementation, but the
user-space interface is different.

Major changes since the previous post:
* "struct nlattr"-based extensible attributes used for extensibility
  of most operations, both for input and output attributes
* algorithms (ciphers, key wrapping, key derivation) are identified using
  strings in the userspace API
* Full compat_ioctl implementation
* Version number added to the data format used when wrapping keys for storage
* Patch set split into smaller parts, reordered to keep the tree buildable.
  (If you want to review primarily the user-space API, see patches
  1,14,15,17,18.)

  The libtom* patches will probably still be too large for the mailing list;
  the whole patch set is also available at
  http://people.redhat.com/mitr/cryptodev-ncr/v2/ .

Original patch set description follows.

These are the major differences compared to the BSD-like interface:

* The API supports key storage and management inside the kernel.
  An application can thus ask the kernel to generate a key; the key is
  then referenced via an integer identifier, and the application can be
  prevented from accessing the raw key data.  Such a key can, if so configured,
  still be wrapped for key transport to the recipient of the message, and
  unwrapped by the recipient.

  The kernel key storage does not span system reboots, but applications can
  also wrap the keys for persistent storage, receiving an encrypted blob that
  does not reveal the raw key data, but can be later loaded back into the
  kernel.

* More algorithms and mechanisms are supported by the API, including public key
  algorithms (RSA/DSA encryption and signing, D-H key derivation, key wrapping).

Motivations for the extensions: governments are asking for more security
features in the operating systems they procure, which make user-space
implementations impractical.  A few examples:

* Advanced crypto module for OSPP for Common Criteria requires OS services
  implementing several low-level crypto algorithms (e.g. AES, RSA).  This
  requires the separation of crypto services from the consumer of those
  services. (The threat model is that apps tend to have more vulnerabilities
  than libraries and compromise of the app will lead to the ability to access
  key material.) An user-space library is not separated, options are a) root
  running daemon that does crypto, but this would be slow due to context
  switches, scheduler mismatching and all the IPC overhead and b) use crypto
  that is in the kernel.

* FIPS-140-3 calls out for cryptographic functions to be non-debuggable (ptrace)
  meaning that you cannot get to the key material. The solution is the same as
  above.

* GPOSPP requires auditing for crypto events (so does FIPS-140 level 2 cert).
  To do this you need any crypto to have CAP_AUDIT_WRITE permissions which
  means making everything that links to openssl, libgcrypt, or nss setuid
  root. Making firefox and 400 other applications setuid root is a non-starter.
  So, the solution is again to use crypto in the kernel where auditing needs no
  special permissions.

Other advantages to having kernel crypto available to user space:

* User space will be able to take advantage of kernel drivers for hardware
  crypto accelerators.

* glibc, which in some configurations links to libfreebl3.so for hashes
  necessary for crypt(), will be able to use the kernel implementation; this
  means one less library to load and dynamically link for each such process.

The code is derived from the original cryptodev-linux patch set; most of the
new implementation was written by Nikos Mavrogiannopoulos
<n.mavrogiannopoulos@gmail.com>.  Attributions are included in the respective
source files.
