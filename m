Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965487Ab2J3TTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:19:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934273Ab2J3TTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:19:46 -0400
From: David Howells <dhowells@redhat.com>
Subject: [RFC][PATCH 00/23] Load keys from signed PE binaries
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, pjones@redhat.com, jwboyer@redhat.com, mjg@redhat.com,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        keescook@chromium.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Date: Tue, 30 Oct 2012 19:19:28 +0000
Message-ID: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Rusty,

Here's a set of patches to load a key out of a signed PE format binary:

	http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=shortlog;h=refs/heads/devel-pekey

The problem (as I understand it) these patches aim to solve is that Microsoft
will only sign PE binaries (driver DLLs, application EXEs) and not keys.
However, under some circumstances, we need to add a new key to the system.  We
could require that the user reboot into the BIOS, add the key, and then switch
back, but under some circumstances we want to be able to do this whilst the
kernel is running.

Unfortunately, if the kernel is running in secure-boot mode, we can't load a
new key if it isn't signed by a key we already have (and trust).

The way we get around this is to embed an X.509 certificate containing the key
in a section called ".keylist" in a PE binary and then get the binary signed by
Microsoft or whoever.  The key can then be passed to the kernel by:

	keyctl padd asymmetric "" {ID of .modsign_keyring} <key_carrying.dll

This command executes the following steps:

 (1) Parse the PE binary to locate the signature and the new key.

 (2) Parse the PKCS#7 message in the PE binary.

 (3) Parse the content of the PKCS#7 message which is in "Microsoft individual
     code signing form" (the mscode bits in my patches).  This contains the PE
     binary digest type and the expected resultant digest value.

 (4) Digest the signed parts of the PE binary according to step (3) and compare
     the digest obtained to the digest expected.

 (5) Digest the signed parts of the PKCS#7 message (which covers the content
     data used in step (3)).

 (6) Verify the signature on the PKCS#7 message against one of the X.509
     certificates it contains.

 (7) Check the signatures on the chain of X.509 certificates in the PKCS#7
     message as far as possible.

 (8) Cross-reference the chain of X.509 certificates against the known keys the
     kernel already possesses, and if one is found, verify the signature of the
     nearest object to the PKCS#7 message that we can (or the PKCS#7 message
     itself) against the trusted key.

 (9) Pass the X.509 certificate embedded in the message to the X.509 parser to
     be turned into a key.

To make this work, step (8) requires access to the .module_sign keyring -
something that could be made cleaner.


Since this requires the ability to add to the .module_sign keyring, I have
turned on WRITE permission for root - but so that _only_ trusted keys can be
added, I've added two more flags in key->flags:

	KEY_FLAG_TRUSTED - this key is trusted.

	KEY_FLAG_TRUSTED_ONLY - only links to trusted keys can be made to this
				keyring.

A trusted key appears with a 'T' flag in /proc/keys:

	0616778d I------T     2 perm 1f010000     0     0 asymmetri Magrathea: Glacier signing key: b0d8dceca6af6da583cfcd6ab84f113d8a3b7e44: X509.RSA 8a3b7e44 []

I'm not sure that this is the best mechanism by which to filter keyring
additions.


What these patches then do is allow you to add new keys by signing them with a
key a user will already have.  There can be more than one source for these
keys: firstly, there is a key built into the kernel for module signing
purposes, and secondly, we have patches under development for extracting keys
from the UEFI signature database.


One further note: Though we don't actually execute the PE binary container to
get at the key, there's no reason that the PE binary couldn't be executable.
For instance, it could be an EFI binary that can be run under the BIOS to add
the key.

The test wrapper I'm using is this:

	#include <efi.h>
	#include <efilib.h>

	EFI_STATUS
	efi_main (EFI_HANDLE image_handle, EFI_SYSTEM_TABLE *systab)
	{
		InitializeLib(image_handle, systab);
		Print(L"This program contains a list of public keys.\n");
		return EFI_SUCCESS;
	}

	extern __attribute__((section(".keylist"))) const uint8_t certificate_list[];
	extern __attribute__((section(".keylist"))) const uint8_t certificate_list_end[];
	asm(".section .keylist,\"a\"\n"
	    "certificate_list:\n"
	    ".incbin \"signing_key.x509\"\n"
	    "certificate_list_end:"
	    );

and is built something like this:

	CPPFLAGS := -nostdinc -I /usr/include/efi -I /usr/include/efi/x86_64

	CFLAGS := -O2 -fpic \
		-Wall -fshort-wchar -fno-strict-aliasing \
		-fno-merge-constants -mno-red-zone

	LDSCRIPT := /usr/lib64/gnuefi/elf_x86_64_efi.lds
	CRT0	:= /usr/lib64/gnuefi/crt0-efi-x86_64.o
	X509	:= magrathea
	KEY	:= /data/modsign/linux-modsign/signing_key.priv

	pekey.efi.signed: pekey.efi
		pesign -i $< -o $@ \
			-c $(X509) \
			-p $(KEY) \
			-s -f

	pekey.efi: pekey.so
		objcopy \
			-j .text -j .sdata -j .data -j .dynamic -j .dynsym -j .rel \
			-j .rela -j .reloc -j .keylist --target=efi-app-x86_64 $< $@

	pekey.so: pekey.o
		$(LD) -nostdlib -T $(LDSCRIPT) -shared -Bsymbolic $(CRT0) $< -o $@ \
			-L /usr/lib64 -lefi -lgnuefi \
			-L /usr/lib/gcc/x86_64-redhat-linux/4.7.2 -lgcc

	pekey.o: pekey.c Makefile
		$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

David
---
David Howells (23):
      KEYS: Add a 'trusted' flag and a 'trusted only' flag
      PEFILE: Load the contained key if we consider the container to be validly signed
      PKCS#7: Find intersection between PKCS#7 message and known, trusted keys
      pefile: Digest the PE binary and compare to the PKCS#7 data
      pefile: Parse the "Microsoft individual code signing" data blob
      pefile: Parse the presumed PKCS#7 content of the certificate blob
      pefile: Strip the wrapper off of the cert data block
      pefile: Parse a PE binary to find a key and a signature contained therein
      Provide PE binary definitions
      PKCS#7: Verify internal certificate chain
      PKCS#7: Find the right key in the PKCS#7 key list and verify the signature
      PKCS#7: Digest the data in a signed-data message
      PKCS#7: Implement a parser [RFC 2315]
      X.509: Export certificate parse and free functions
      X.509: Handle certificates that lack an authorityKeyIdentifier field
      X.509: Embed public_key_signature struct and create filler function
      X.509: Add bits needed for PKCS#7
      x509: struct x509_certificate needs struct tm declaring
      KEYS: Store public key algo ID in public_key_signature struct
      KEYS: Split public_key_verify_signature() and make available
      KEYS: Store public key algo ID in public_key struct
      KEYS: Move the algorithm pointer array from x509 to public_key.c
      KEYS: Rename public key parameter name arrays


 crypto/asymmetric_keys/Kconfig            |   19 +
 crypto/asymmetric_keys/Makefile           |   30 ++
 crypto/asymmetric_keys/mscode.asn1        |   28 ++
 crypto/asymmetric_keys/mscode_parser.c    |  110 +++++++
 crypto/asymmetric_keys/pefile_parser.c    |  473 +++++++++++++++++++++++++++++
 crypto/asymmetric_keys/pefile_parser.h    |   36 ++
 crypto/asymmetric_keys/pkcs7.asn1         |  127 ++++++++
 crypto/asymmetric_keys/pkcs7_parser.c     |  326 ++++++++++++++++++++
 crypto/asymmetric_keys/pkcs7_parser.h     |   72 ++++
 crypto/asymmetric_keys/pkcs7_trust.c      |  149 +++++++++
 crypto/asymmetric_keys/pkcs7_verify.c     |  256 ++++++++++++++++
 crypto/asymmetric_keys/public_key.c       |   58 +++-
 crypto/asymmetric_keys/public_key.h       |    6 
 crypto/asymmetric_keys/x509.asn1          |    2 
 crypto/asymmetric_keys/x509_cert_parser.c |   55 ++-
 crypto/asymmetric_keys/x509_parser.h      |   28 +-
 crypto/asymmetric_keys/x509_public_key.c  |  107 +++----
 include/crypto/public_key.h               |    9 -
 include/linux/key-type.h                  |    1 
 include/linux/key.h                       |    3 
 include/linux/oid_registry.h              |    7 
 include/linux/pe.h                        |  448 +++++++++++++++++++++++++++
 kernel/modsign_pubkey.c                   |    7 
 kernel/module_signing.c                   |    4 
 security/keys/key.c                       |    8 
 security/keys/keyring.c                   |    4 
 security/keys/proc.c                      |    3 
 27 files changed, 2277 insertions(+), 99 deletions(-)
 create mode 100644 crypto/asymmetric_keys/mscode.asn1
 create mode 100644 crypto/asymmetric_keys/mscode_parser.c
 create mode 100644 crypto/asymmetric_keys/pefile_parser.c
 create mode 100644 crypto/asymmetric_keys/pefile_parser.h
 create mode 100644 crypto/asymmetric_keys/pkcs7.asn1
 create mode 100644 crypto/asymmetric_keys/pkcs7_parser.c
 create mode 100644 crypto/asymmetric_keys/pkcs7_parser.h
 create mode 100644 crypto/asymmetric_keys/pkcs7_trust.c
 create mode 100644 crypto/asymmetric_keys/pkcs7_verify.c
 create mode 100644 include/linux/pe.h

