Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933994Ab3AIVJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:09:50 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:60625 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933713Ab3AIVJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 16:09:45 -0500
MIME-Version: 1.0
In-Reply-To: <24937.1357218319@warthog.procyon.org.uk>
References: <24937.1357218319@warthog.procyon.org.uk>
Date: Wed, 9 Jan 2013 13:09:44 -0800
X-Google-Sender-Auth: e932kElgwLpfJQsWWRbbOxcFYRA
Message-ID: <CAGXu5jJtuorV9GcetPA+v9K4p-jX4oacaDPrJ3j+RTM+eK5kFA@mail.gmail.com>
Subject: Re: Pull "Load keys from signed PE binaries" branch into linux-next
From: Kees Cook <keescook@chromium.org>
To: David Howells <dhowells@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a quick review of the devel-pekeys tree...

On Thu, Jan 3, 2013 at 5:05 AM, David Howells <dhowells@redhat.com> wrote:
>
> Hi Stephen,
>
> Could you pull my branch to load module signing keys from signed PE binaries
> into linux-next please?
>
> Thanks,
> David
> ---
>
> The following changes since commit d1c3ed669a2d452cacfb48c2d171a1f364dae2ed:
>
>   Linux 3.8-rc2 (2013-01-02 18:13:21 -0800)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-modsign.git devel-pekey
>
> for you to fetch changes up to cb37a0303559a414aa74f43ae3c8c60f01555b7a:
>
>   KEYS: Add a 'trusted' flag and a 'trusted only' flag (2013-01-03 12:06:48 +0000)
>
> ----------------------------------------------------------------
> (from the branch description for devel-pekey local branch)
>
> clone of "master"
> ----------------------------------------------------------------
> David Howells (23):
>       KEYS: Rename public key parameter name arrays
>       KEYS: Move the algorithm pointer array from x509 to public_key.c
>       KEYS: Store public key algo ID in public_key struct
>       KEYS: Split public_key_verify_signature() and make available

--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -86,21 +86,43 @@ EXPORT_SYMBOL_GPL(public_key_destroy);
[...]
+       if (!algo) {
+               algo = pkey_algo[pk->pkey_algo];

pkey_algo should be bounds-checked against pkey_algo size.

+static int public_key_verify_signature_2(const struct key *key,

Maybe name this "key_verify_signature" instead of using the trailing _2?

>       KEYS: Store public key algo ID in public_key_signature struct
>       X.509: struct x509_certificate needs struct tm declaring
>       X.509: Add bits needed for PKCS#7
>       X.509: Embed public_key_signature struct and create filler function

--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -24,72 +24,83 @@
[...]
-       tfm = crypto_alloc_shash(pkey_hash_algo_name[cert->sig_hash_algo],
0, 0);
+       tfm = crypto_alloc_shash(pkey_hash_algo_name[cert->sig.pkey_hash_algo],
0, 0);

I think, even if it wasn't done before, it's worth bounds-checking the
array access here too.

>       X.509: Handle certificates that lack an authorityKeyIdentifier field
>       X.509: Export certificate parse and free functions
>       PKCS#7: Implement a parser [RFC 2315]

--- /dev/null
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -0,0 +1,326 @@
[...]
+               while (pkcs7->crl) {
+                       cert = pkcs7->certs;
+                       pkcs7->certs = cert->next;
+                       x509_free_certificate(cert);
+               }

cut/paste-o? Shouldn't this while operate on pkcs7->crl instead of
pkcs7->certs? Looks like a deadlock if pkcs7->crl is !NULL.

>       PKCS#7: Digest the data in a signed-data message

--- /dev/null
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -0,0 +1,130 @@
[...]
+       tfm = crypto_alloc_shash(pkey_hash_algo_name[pkcs7->sig.pkey_hash_algo],
+                                0, 0);

More of my paranoia for array access here. :)

>       PKCS#7: Find the right key in the PKCS#7 key list and verify the signature
>       PKCS#7: Verify internal certificate chain
>       Provide PE binary definitions
>       pefile: Parse a PE binary to find a key and a signature contained therein
>       pefile: Strip the wrapper off of the cert data block
>       pefile: Parse the presumed PKCS#7 content of the certificate blob
>       pefile: Parse the "Microsoft individual code signing" data blob
>       pefile: Digest the PE binary and compare to the PKCS#7 data
>       PKCS#7: Find intersection between PKCS#7 message and known, trusted keys

--- /dev/null
+++ b/crypto/asymmetric_keys/pkcs7_trust.c
@@ -0,0 +1,145 @@
[...]
+       id[signer_len + 0] = ':';
+       id[signer_len + 1] = ' ';

the key matching routing seems to not expect this trailing space
character? Also, is there some risk here that a requested signer
string could include a ":" character to confuse things?

>       PEFILE: Load the contained key if we consider the container to be validly signed
>       KEYS: Add a 'trusted' flag and a 'trusted only' flag

Otherwise, looks good. Thanks for cleaning up the pefile parser stuff
I pointed out in the earlier review! :)

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

--
Kees Cook
Chrome OS Security
