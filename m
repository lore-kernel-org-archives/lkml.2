Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab2IYPop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 11:44:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:48931 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757170Ab2IYPoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 11:44:39 -0400
MIME-Version: 1.0
In-Reply-To: <5555.1348531649@warthog.procyon.org.uk>
References: <5555.1348531649@warthog.procyon.org.uk>
Date: Tue, 25 Sep 2012 18:44:35 +0300
Message-ID: <CALLzPKaMV=te6XWS5zi43RYa4uJ9sADDizcsM_3=sOa9wayGCQ@mail.gmail.com>
Subject: Re: [GIT PULL] Asymmetric keys and module signing
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: David Howells <dhowells@redhat.com>
Cc: herbert@gondor.hengli.com.au, rusty@rustcorp.com.au, pjones@redhat.com,
        jwboyer@redhat.com, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@linux-nfs.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David,

As I can see API has changed towards our discussion on KS.
Now digest can be supplied to the verify_signature in a
public_key_signature argument.
It looks that in such away we can use this API for IMA/EVM as well.

Just one question about key description...
request_asymmetric_key uses format for key  description: "<signer>: <key-id>".
Preparsing code creates description from those values.
I see that key id is not 8 bytes anymore but full hash size of 20 bytes.

For practical reasons for IMA it might be nice to save some space in
xattrs and use shorter key id/description.
As I understand from implementation, if key name is provided with
"keyctl add", it will not be replaced with
preparsed value.

Right?
And we can actually use any keyid we want?

- Dmitry


On Tue, Sep 25, 2012 at 3:07 AM, David Howells <dhowells@redhat.com> wrote:
>
> Hi Herbert, Rusty,
>
> Here are my latest module signing patches on top of the asymmetric key crypto
> patches, which I hope Herbert will consider taking, at least from the
> crypto-keys-post-KS branch:
>
>         http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=shortlog;h=refs/heads/crypto-keys-post-KS
>
> The module signing patches go on top of those, and the set can be found here:
>
>         http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=shortlog;h=refs/heads/modsign-post-KS
>
> Do you want the patches posting to the lists?  I've tried posting the series
> as one, but there seems to be a problem posting the merge commit in the middle
> because it has two parents:-/
>
> Anyway...
>
>
> The module signing patches provide:
>
>  - Some fixes to Rusty's patch.  Also an additional patch to extend the policy
>    handling for modules signed with an unknown key and to handle FIPS mode.
>
>  - Module signature generation and checking.  The signature format is:
>
>         <signer-id-string>
>         <binary-key-id>
>         <binary-signature>
>         <sig-information-block>
>
>    The fixed-length sig-information-block indicates the crypto algorithm (RSA
>    only for the moment), the hash type (SHA512 for example) and the identifier
>    scope (X.509 in this case), plus the lengths of the other three parts.
>
>    The binary-key-id could be rendered as hex and pasted onto the end of the
>    signer-id-string so that the kernel doesn't have to do the conversion.
>
>    A script is provided in one of the patches to generate the signer name and
>    key ID parts from the X.509 cert for later inclusion in module signatures
>    during the build.
>
>  - A transient X.509 cert will be automatically generated if one is not given
>    and will be used to automatically sign the modules after they've been
>    thoroughly stripped.
>
>    Note that this may prove not to be the best way for distributions to do
>    things.  We're currently looking at the best way being to do the stripping
>    and signing manually from the RPM spec file after the make modules_install
>    step and after the debuginfo has been extracted, so automatic signing may
>    need to go away, or at least become optional.
>
>    To make this easier, a script is provided to sign a module and this can be
>    called either from the Makefile or the spec file.
>
>  - An 'extra_certificates' file can be placed in the root of the kernel build
>    containing a number of supplementary X.509 certs just cat'd together.  These
>    will get added to the internal keyring and can then be used to check module
>    signatures also.
>
>
> I have also fixed a number of things in the crypto patches:
>
>  - GeneralizedTime and GeneralString were transposed in the ASN.1 compiler
>    directive table and enum token_type ('S' comes before 'i' to strcmp()),
>    resulting in it not being possible to use either.
>
>  - I had made it a requirement that the X.509 certificate subjectKeyIdentifier
>    and authorityKeyIdentifier extensions exist so that we can validate the
>    X.509 signature if possible, but I hadn't put in any checks that they'd been
>    found before using the values extracted, leading to a crash.
>
>  - I fixed header length computation in ASN.1 decoder resulting making it
>    possible to discard one of the x509.asn1 callback actions (we can locate the
>    start of the TBS container directly now by subtraction).
>
>  - I got rid of the fingerprint bit at the end of the public_key struct as it's
>    superfluous (the asymmetric key type stores the fingerprint attached to
>    key->type_data.p[1]).
>
>  - I made the X.509 parser render the key description in a more compact manner:
>
>    The description is split into two parts: "<signer>: <key-id>".
>
>    The <key-id> is a hex rendering of the key identifier - in the case of X.509
>    that would be the contents of the subjectKeyIdentifier extension field with
>    the ASN.1 OctetString wrapper removed.
>
>    The <signer> is (in order) one of:
>
>         - The O and CN attributes as "<O-attr>: <CN-attr>" if the CN attribute
>           isn't prefixed with the O attribute, and, if longer, doesn't share
>           the same first seven chars (say a company name such as Red Hat Inc.).
>           I admit this is entirely arbitrary and biased towards companies with
>           7 chars or more in there name, but it does remove duplication of the
>           organisation's name if it's in both the O and the CN.  Can anyone
>           suggest a better heuristic?
>
>         - The CN attribute.
>
>         - The O attribute.
>
>         - The email address.
>
>         - Omitted (with ": " omitted too).
>
>    As an example:
>
>         Magrathea: Glacier signing key: 5dd0839552bd6af498253f8af1e65da3472941c6
>
>    which is "<O-attr>: <CN-attr>: <key-id>" in form, or:
>
>         Red Hat Test Certificate: 3580cf35d76b3b667a40df66691cbcf87353b23c
>
>    which is just "<CN-attr>: <key-id>" in form.
>
>  - I no longer extract the bits of the X.509 certificate I don't currently use
>    (such as the version number).
>
> Note, this implementation of the X.509 certificate parser uses a couple of
> patterns to drive a reusable ASN.1 decoder.  I do, however, have a direct
> in-line decoder implementation also that can only decode X.509 certs.  The
> stack space usage is greater, but the code size is simpler and slightly smaller
> and the code is less capable (it can't handle indefinite-length elements for
> example), and it can't be reused for anything else (such as CIFS, netfilter,
> PKCS#7, Kerberos tickets), whereas the pattern-based decoder can.  I'll post
> this separately to see what people think.
>
> As far as testing goes, I have posted a number of testing scripts that I have
> used to punish the crypto keys side of things.  The "keyctl padd" command makes
> this straightforward.
>
> Hopefully, later this week the patches will appear in the Fedora 18 kernel.
>
> David
> ---
> The following changes since commit eeea3ac912207dcf759b95b2b4c36f96bce583bf:
>
>   Merge tag 'fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc (2012-09-06 10:23:58 -0700)
>
> are available in the git repository at:
>
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-modsign.git modsign-post-KS
>
> for you to fetch changes up to 8d4f62638e9aae069d1145dfeb7300c58077be49:
>
>   MODSIGN: Extend the policy on signature check failure (2012-09-24 20:51:59 +0100)
>
> ----------------------------------------------------------------
> (from the branch description for modsign-post-KS local branch)
>
> post Kernel-Summit module signing
> ----------------------------------------------------------------
> David Howells (26):
>       KEYS: Add payload preparsing opportunity prior to key instantiate or update
>       MPILIB: Provide count_leading/trailing_zeros() based on arch functions
>       KEYS: Document asymmetric key type
>       KEYS: Implement asymmetric key type
>       KEYS: Asymmetric key pluggable data parsers
>       KEYS: Asymmetric public-key algorithm crypto key subtype
>       KEYS: Provide signature verification with an asymmetric key
>       MPILIB: Reinstate mpi_cmp[_ui]() and export for RSA signature verification
>       RSA: Implement signature verification algorithm [PKCS#1 / RFC3447]
>       RSA: Fix signature verification for shorter signatures
>       X.509: Implement simple static OID registry
>       X.509: Add utility functions to render OIDs as strings
>       X.509: Add simple ASN.1 grammar compiler
>       X.509: Add an ASN.1 decoder
>       MPILIB: Provide a function to read raw data into an MPI
>       X.509: Add a crypto key parser for binary (DER) X.509 certificates
>       Merge Rusty's module signature checking hook into modsign-post-KS
>       MOD: Fix Rusty's module_sig_check()
>       MODSIGN: Provide gitignore and make clean rules for extra files
>       MODSIGN: Provide Kconfig options
>       MODSIGN: Automatically generate module signing keys if missing
>       MODSIGN: Provide module signing public keys to the kernel
>       MODSIGN: Implement module signature checking
>       MODSIGN: Provide a script for generating a key ID from an X.509 cert
>       MODSIGN: Sign modules during the build process
>       MODSIGN: Extend the policy on signature check failure
>
> Rusty Russell (1):
>       module: signature checking hook
>
>  .gitignore                                |   13 +
>  Documentation/crypto/asymmetric-keys.txt  |  312 ++++++
>  Documentation/kernel-parameters.txt       |    6 +
>  Documentation/security/keys.txt           |   50 +-
>  Makefile                                  |    1 +
>  crypto/Kconfig                            |    1 +
>  crypto/Makefile                           |    1 +
>  crypto/asymmetric_keys/.gitignore         |    1 +
>  crypto/asymmetric_keys/Kconfig            |   38 +
>  crypto/asymmetric_keys/Makefile           |   27 +
>  crypto/asymmetric_keys/asymmetric_keys.h  |   15 +
>  crypto/asymmetric_keys/asymmetric_type.c  |  274 +++++
>  crypto/asymmetric_keys/public_key.c       |  108 ++
>  crypto/asymmetric_keys/public_key.h       |   30 +
>  crypto/asymmetric_keys/rsa.c              |  277 ++++++
>  crypto/asymmetric_keys/signature.c        |   49 +
>  crypto/asymmetric_keys/x509.asn1          |   60 ++
>  crypto/asymmetric_keys/x509_cert_parser.c |  497 ++++++++++
>  crypto/asymmetric_keys/x509_parser.h      |   36 +
>  crypto/asymmetric_keys/x509_public_key.c  |  207 ++++
>  crypto/asymmetric_keys/x509_rsakey.asn1   |    4 +
>  fs/cifs/cifs_spnego.c                     |    6 +-
>  fs/cifs/cifsacl.c                         |    8 +-
>  include/asm-generic/bitops/count_zeros.h  |   57 ++
>  include/crypto/public_key.h               |  108 ++
>  include/keys/asymmetric-parser.h          |   37 +
>  include/keys/asymmetric-subtype.h         |   55 +
>  include/keys/asymmetric-type.h            |   25 +
>  include/keys/user-type.h                  |    6 +-
>  include/linux/asn1.h                      |   67 ++
>  include/linux/asn1_ber_bytecode.h         |   87 ++
>  include/linux/asn1_decoder.h              |   24 +
>  include/linux/key-type.h                  |   35 +-
>  include/linux/module.h                    |    8 +
>  include/linux/mpi.h                       |    1 +
>  include/linux/oid_registry.h              |   92 ++
>  init/Kconfig                              |   68 ++
>  kernel/Makefile                           |   57 ++
>  kernel/modsign_pubkey.c                   |  112 +++
>  kernel/module-internal.h                  |   16 +
>  kernel/module.c                           |  100 +-
>  kernel/module_signing.c                   |  247 +++++
>  lib/.gitignore                            |    2 +-
>  lib/Kconfig                               |    5 +
>  lib/Makefile                              |   18 +
>  lib/asn1_decoder.c                        |  477 +++++++++
>  lib/build_OID_registry                    |  209 ++++
>  lib/mpi/Makefile                          |    1 +
>  lib/mpi/longlong.h                        |  138 +--
>  lib/mpi/mpi-bit.c                         |    2 +-
>  lib/mpi/mpi-cmp.c                         |   70 ++
>  lib/mpi/mpi-pow.c                         |    4 +-
>  lib/mpi/mpicoder.c                        |   55 +
>  lib/oid_registry.c                        |  170 ++++
>  net/ceph/crypto.c                         |    9 +-
>  net/dns_resolver/dns_key.c                |    6 +-
>  net/rxrpc/ar-key.c                        |   40 +-
>  scripts/.gitignore                        |    1 +
>  scripts/Makefile                          |    2 +
>  scripts/Makefile.build                    |   11 +
>  scripts/Makefile.modpost                  |   75 +-
>  scripts/asn1_compiler.c                   | 1545 +++++++++++++++++++++++++++++
>  scripts/sign-file                         |  115 +++
>  scripts/x509keyid                         |  268 +++++
>  security/keys/encrypted-keys/encrypted.c  |   16 +-
>  security/keys/key.c                       |  114 ++-
>  security/keys/keyctl.c                    |   18 +-
>  security/keys/keyring.c                   |    6 +-
>  security/keys/request_key_auth.c          |    8 +-
>  security/keys/trusted.c                   |   16 +-
>  security/keys/user_defined.c              |   14 +-
>  71 files changed, 6394 insertions(+), 244 deletions(-)
>  create mode 100644 Documentation/crypto/asymmetric-keys.txt
>  create mode 100644 crypto/asymmetric_keys/.gitignore
>  create mode 100644 crypto/asymmetric_keys/Kconfig
>  create mode 100644 crypto/asymmetric_keys/Makefile
>  create mode 100644 crypto/asymmetric_keys/asymmetric_keys.h
>  create mode 100644 crypto/asymmetric_keys/asymmetric_type.c
>  create mode 100644 crypto/asymmetric_keys/public_key.c
>  create mode 100644 crypto/asymmetric_keys/public_key.h
>  create mode 100644 crypto/asymmetric_keys/rsa.c
>  create mode 100644 crypto/asymmetric_keys/signature.c
>  create mode 100644 crypto/asymmetric_keys/x509.asn1
>  create mode 100644 crypto/asymmetric_keys/x509_cert_parser.c
>  create mode 100644 crypto/asymmetric_keys/x509_parser.h
>  create mode 100644 crypto/asymmetric_keys/x509_public_key.c
>  create mode 100644 crypto/asymmetric_keys/x509_rsakey.asn1
>  create mode 100644 include/asm-generic/bitops/count_zeros.h
>  create mode 100644 include/crypto/public_key.h
>  create mode 100644 include/keys/asymmetric-parser.h
>  create mode 100644 include/keys/asymmetric-subtype.h
>  create mode 100644 include/keys/asymmetric-type.h
>  create mode 100644 include/linux/asn1.h
>  create mode 100644 include/linux/asn1_ber_bytecode.h
>  create mode 100644 include/linux/asn1_decoder.h
>  create mode 100644 include/linux/oid_registry.h
>  create mode 100644 kernel/modsign_pubkey.c
>  create mode 100644 kernel/module-internal.h
>  create mode 100644 kernel/module_signing.c
>  create mode 100644 lib/asn1_decoder.c
>  create mode 100755 lib/build_OID_registry
>  create mode 100644 lib/mpi/mpi-cmp.c
>  create mode 100644 lib/oid_registry.c
>  create mode 100644 scripts/asn1_compiler.c
>  create mode 100644 scripts/sign-file
>  create mode 100755 scripts/x509keyid
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
