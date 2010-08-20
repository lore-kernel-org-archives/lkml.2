Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab0HTIqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:46:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687Ab0HTIq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:46:29 -0400
From: =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-crypto@vger.kernel.org,
        Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
Subject: =?UTF-8?q?=5BPATCH=2001/19=5D=20User-space=20API=20definition?=
Date: Fri, 20 Aug 2010 10:45:44 +0200
Message-Id: <1282293963-27807-2-git-send-email-mitr@redhat.com>
In-Reply-To: <1282293963-27807-1-git-send-email-mitr@redhat.com>
References: <1282293963-27807-1-git-send-email-mitr@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the new user-space API, <ncr.h>.

Quick overview:

* open("/dev/crypto") to get a FD, which acts as a namespace for key and
  session identifiers.

* ioctl(NCRIO_KEY_INIT) to allocate a key object; then generate the key
  material inside the kernel, load a plaintext key, unwrap a key, or
  derive a key.  Similarly the key material can be copied out of the
  kernel or wrapped.

* ioctl(NCRIO_SESSION_INIT) to allocate a crypto session (to encrypt,
  decrypt, hash, sign, or verify signature), then
  ioctl(NCRIO_SESSION_UPDATE) to act on chunks of data.  Deallocate the
  session, and optionally retrieve session results (e.g. hash or
  signature), using ioctl(NCRIO_SESSION_FINAL).

  There is also NCRIO_SESSION_ONCE for an one-shot crypto operation
  using a single user->kernel context switch.

Full documentation of the interface is in
Documentation/crypto/userspace.txt .
---
 Documentation/crypto/userspace.txt |  510 ++++++++++++++++++++++++++++++++++++
 include/linux/Kbuild               |    1 +
 include/linux/ncr.h                |  273 +++++++++++++++++++
 3 files changed, 784 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/crypto/userspace.txt
 create mode 100644 include/linux/ncr.h

diff --git a/Documentation/crypto/userspace.txt b/Documentation/crypto/userspace.txt
new file mode 100644
index 0000000..5839fda
--- /dev/null
+++ b/Documentation/crypto/userspace.txt
@@ -0,0 +1,510 @@
+CRYPTO(4)                  Linux Programmer’s Manual                 CRYPTO(4)
+
+NAME
+       /dev/crypto - kernel cryptographic module interface
+
+SYNOPSIS
+       #include <ncr.h>
+       int fd = open("/dev/crypto", O_RDWR);
+       int res = ioctl(fd, NCRIO..., &data);
+
+DESCRIPTION
+       The  /dev/crypto device file provides an ioctl(2) interface to the ker-
+       nel-space crypto implementation.
+
+       Each open(2) of the /dev/crypto file establishes a  separate  namespace
+       within  which  crypto  operations  work.   The  namespace can be shared
+       across threads and processes by  sharing  the  open  file  description.
+       Last  close  of  the  open  file description automatically destroys all
+       objects allocated within the namespace.
+
+       All ioctl(2)s have the same form: The user sets  up  a  data  structure
+       with  input  data,  and  passes  a pointer to the data structure as the
+       third parameter to ioctl(2).  On success, output data is  available  in
+       the same structure.
+
+OPERATION ATTRIBUTES
+       In addition to the fixed members of data structures, a process can pass
+       additional attributes on input of most operations,  and  receive  addi-
+       tional attributes back from the kernel.  If this is supported by a spe-
+       cific operation, the fixed data structure members  for  this  operation
+       include input_size and output_size.
+
+       The  input  attributes immediately follow the fixed data structure as a
+       sequence of correctly aligned (struct nlattr,  attribute  data)  pairs,
+       using the same data layout and formatting rules as netlink(7) messages.
+       The input_size member must be initialized to the total length of  input
+       (including both the fixed data structure and the attributes).
+
+       There  is  an  (unspecified)  upper  limit  on  the  total  size of all
+       attributes, which should be large enough to accommodate any  reasonable
+       application.  If a larger input is provided nevertheless, the operation
+       will fail with EOVERFLOW.
+
+       Output attributes, if any, are written by the kernel in the same format
+       following  the  fixed  data structure (overwriting input attributes, if
+       any).  The output_size member must be initialized to  the  total  space
+       available  for output (including the fixed data structure and space for
+       attributes), and is updated by the kernel with the total space actually
+       used for attributes.
+
+       If  the  space available for output attributes is too small, the opera-
+       tion will fail with ERANGE.
+
+       As a special  case,  input_size  may  be  zero  to  indicate  no  input
+       attributes  are  supplied.  Similarly, output_size may be zero to indi-
+       cate no space for output attributes is  provided;  in  such  case  out-
+       put_size is not overwritten by the kernel with the total space actually
+       used (which is equal to size of the fixed data structure)  and  remains
+       zero when the operation finishes.
+
+       The kernel accepts and silently ignores unknown attributes.
+
+       The kernel will not add new output attributes to existing operations in
+       future  releases  unless  the  new  output  attribute  was   explicitly
+       requested  by  the  application.   (Therefore, the application does not
+       have to allocate any extra space for  output  attributes  it  does  not
+       expect.)
+
+       The following attributes are used in more than one operation:
+
+       NCR_ATTR_ALGORITHM
+              A  NUL-terminated  string specifying an algorithm (to be used in
+              an operation, or as a property of a key), using the Linux crypto
+              API algorithm names.
+
+              Three additional algorithm names are recognized: rsa, dsa, dh.
+
+       NCR_ATTR_IV
+              Unformatted binary data specifying an initialization vector,
+
+       NCR_ATTR_KEY_FLAGS
+              An  32-bit  unsigned integer in native byte order specifying key
+              flags, a combination of NCR_KEY_FLAG_EXPORTABLE (the  key  mate-
+              rial   can   be   exported  in  plaintext  to  user  space)  and
+              NCR_KEY_FLAG_WRAPPABLE (the key material can be wrapped and  the
+              result made available to user space).
+
+       NCR_ATTR_KEY_ID
+              Arbitrary  binary  data which can be used by the application for
+              key identification.
+
+       NCR_ATTR_KEY_TYPE
+              An 32-bit unsigned integer in native byte order  specifying  key
+              type,   one   of  NCR_KEY_TYPE_SECRET,  NCR_KEY_TYPE_PUBLIC  and
+              NCR_KEY_TYPE_PRIVATE.
+
+       NCR_ATTR_WRAPPING_ALGORITHM
+              A NUL-terminated string specifying  a  key  wrapping  algorithm.
+              The  values  walg-aes-rfc3394 and walg-aes-rfc5649 are currently
+              supported.
+
+OPERATIONS
+       The following operations are defined:
+
+       NCRIO_KEY_INIT
+              Allocate a kernel-space key object.  The third ioctl(s)  parame-
+              ter is ignored (key attributes are set later, when the key mate-
+              rial is initialized).  Returns an ncr_key_t descriptor  for  the
+              key  object  (valid within the current /dev/crypto namespace) on
+              success.
+
+              There is a per-process and per-user (not per-namespace) limit on
+              the number key objects that can be allocated.
+
+       NCRIO_KEY_DEINIT
+              Deallocate a kernel-space key object.  The parameter points to a
+              ncr_key_t descriptor of the key object.  After all other  opera-
+              tions using this key object (if any) terminate, the key material
+              will be cleared and the object will be freed.   Note  that  this
+              may  happen  both  before  this  operation returns, and after it
+              returns, depending on other references to this key object.
+
+       NCRIO_KEY_GENERATE
+              Clear existing key material in the  specified  key  object,  and
+              generate new key material.
+
+              The parameter points to struct ncr_key_generate, which specifies
+              the destination key object in its key member.
+
+              The following input attributes are recognized:
+
+              NCR_ATTR_ALGORITHM
+                     Mandatory.
+
+              NCR_ATTR_KEY_FLAGS
+                     Optional, flags are unchanged if not present.
+
+              NCR_ATTR_SECRET_KEY_BITS
+                     Mandatory for symmetric keys.  An 32-bit unsigned integer
+                     in native byte order specifying key length in bits.
+
+              Only symmetric keys can be currently generated using this opera-
+              tion.
+
+              In addition to generating the key material, the "persistent" key
+              ID is reset to a random value.
+
+       NCRIO_KEY_GENERATE_PAIR
+              Similar to NCRIO_KEY_GENERATE, except that a pair of public/pri-
+              vate keys is generated.
+
+              The parameter  points  to  struct  ncr_key_generate_pair,  which
+              specifies  the  destination  key  objects in its private_key and
+              public_key members.
+
+              The following input attributes are recognized:
+
+              NCR_ATTR_KEY_FLAGS
+                     Optional, flags are unchanged if not present.
+
+              NCR_ATTR_RSA_E
+                     For RSA keys, the public exponent as a big-endian  multi-
+                     ple-precision integer.  Optional, defaults to 65537.
+
+              NCR_ATTR_RSA_MODULUS_BITS
+                     Mandatory  for  RSA  keys.  An 32-bit unsigned integer in
+                     native byte order specifying modulus length in bits.
+
+              NCR_ATTR_DSA_P_BITS
+                     For DSA keys, length of the "p" key parameter in bits  as
+                     an   32-bit   unsigned  integer  in  native  byte  order.
+                     Optional, defaults to 1024.
+
+              NCR_ATTR_DSA_Q_BITS
+                     For DSA keys, length of the "q" key parameter in bits  as
+                     an   32-bit   unsigned  integer  in  native  byte  order.
+                     Optional, defaults to 160.
+
+              NCR_ATTR_DH_BASE
+                     Mandatory for D-H keys.  The prime modulus of a D-H group
+                     as a big-endian multiple-precision integer.
+
+              NCR_ATTR_DH_PRIME
+                     Mandatory  for D-H keys.  The generator of a D-H group as
+                     a big-endian multiple-precision integer.
+
+              The NCR_KEY_FLAG_EXPORTABLE and NCR_KEY_FLAG_WRAPPABLE flags are
+              automatically set on the public key.
+
+              In addition to generating the key material, the "persistent" key
+              ID of both keys is set to a same value derived from  the  public
+              key.
+
+       NCRIO_KEY_DERIVE
+              Derive a new key using one key and additional data.
+
+              The  parameter  points to struct ncr_key_derive, which specifies
+              the source and destination keys in  the  input_key  and  new_key
+              members.
+
+              The following input attributes are recognized:
+
+              NCR_ATTR_KEY_FLAGS
+                     Optional, flags are unchanged if not present.
+
+              NCR_ATTR_DERIVATION_ALGORITHM
+                     Mandatory.   A  NUL-terminated  string  specifying  a key
+                     derivation algorithm.  Only dh is currently supported.
+
+              NCR_ATTR_DH_PUBLIC
+                     Mandatory for D-H  derivation.   The  peer’s  public  D-H
+                     value as a big-endian multiple-precision integer.
+
+       NCRIO_KEY_EXPORT
+              Export  key  material in the specified key object to user space.
+              Only keys with the NCR_KEY_FLAG_EXPORTABLE flag can be  exported
+              using this operation.
+
+              The  parameter  points to struct ncr_key_export, which specifies
+              the key to export in the  key  member,  and  a  buffer  for  the
+              exported data in the buffer and buffer_size members.
+
+              On success, size of the exported key is returned.
+
+              Symmetric keys are written directly into the destination buffer.
+              Public and private keys are formatted using ASN.1, except for DH
+              public keys, which are written a raw binary number.
+
+       NCRIO_KEY_IMPORT
+              Clear  existing  key  material  in the specified key object, and
+              import key material from user space.
+
+              The parameter points to struct ncr_key_import,  which  specifies
+              the destination key in the key member, and the input data in the
+              data and data_size members.
+
+              The following input attributes are recognized:
+
+              NCR_ATTR_ALGORITHM
+                     Mandatory.
+
+              NCR_ATTR_KEY_FLAGS
+                     Optional, flags are unchanged if not present.
+
+              NCR_ATTR_KEY_ID
+                     Optional, the "persistent" key ID  is  unchanged  if  not
+                     present.
+
+              NCR_ATTR_KEY_TYPE
+                     Mandatory.
+
+              The  data  format  is the same as in the NCRIO_KEY_EXPORT opera-
+              tion.
+
+       NCRIO_KEY_GET_INFO
+              Get metadata of an existing key.
+
+              The parameter points to struct ncr_key_get_info, which specifies
+              key, the key descriptor.
+
+              The following input attributes are recognized:
+
+              NCR_ATTR_WANTED_ATTRS
+                     An  array  of  unsigned  16-bit  integers  in native byte
+                     order, specifying  the  set  of  output  attributes  that
+                     should       be       returned.       NCR_ATTR_ALGORITHM,
+                     NCR_ATTR_KEY_FLAGS and  NCR_ATTR_KEY_TYPE  are  currently
+                     supported.   Unsupported  attribute requests are silently
+                     ignored
+
+              The    output     attributes     explicitly     requested     in
+              NCR_ATTR_WANTED_ATTRS,  and  no  other  output  attributes,  are
+              returned.
+
+       NCRIO_KEY_WRAP
+              Wrap one key using another, and write the result to user  space.
+              Only  keys  with  the NCR_KEY_FLAG_WRAPPABLE flag can be wrapped
+              using this operation.
+
+              The parameter points to struct ncr_key_wrap, which specifies the
+              key  to  wrap  in the source_key member, the wrapping key in the
+              wrapping_key member, and a buffer for the wrapped  data  in  the
+              buffer and buffer_size members.
+
+              The following input attributes are recognized:
+
+              NCR_ATTR_IV
+                     Optional, an empty IV is used if not present.
+
+              NCR_ATTR_WRAPPING_ALGORITHM
+                     Mandatory.
+
+              Only secret keys can be currently wrapped.
+
+              On success, size of the wrapped key is returned.
+
+       NCRIO_KEY_UNWRAP
+              Unwrap  user-space  data  into  a kernel-space key using another
+              key.
+
+              The parameter points to struct ncr_key_unwrap,  which  specifies
+              the  destination key in the dest_key member, the wrapping key in
+              the wrapping_key member, and the wrapped data in  the  data  and
+              data_size members.
+
+              The following input attributes are recognized:
+
+              NCR_ATTR_IV
+                     Optional, an empty IV is used if not present.
+
+              NCR_ATTR_WRAPPING_ALGORITHM
+                     Mandatory.
+
+              The unwrapped key will have the NCR_KEY_FLAG_WRAPPABLE flag set,
+              and the NCR_KEY_FLAG_EXPORTABLE flag clear.
+
+       NCRIO_KEY_STORAGE_WRAP
+              Wrap a key object and associated metadata using the  system-wide
+              storage master key, and write the result to user space.
+
+              Only  keys  with  the NCR_KEY_FLAG_WRAPPABLE flag can be wrapped
+              using this operation.
+
+              The parameter points to struct ncr_key_storage_wrap, which spec-
+              ifies  the  key  to wrap in the key member, and a buffer for the
+              wrapped data in the buffer and buffer_size members.
+
+              On success, size of the wrapped key is returned.
+
+              Both symmetric and asymmetric keys can  be  wrapped  using  this
+              operation.   The  wrapped  data  includes data corresponding the
+              NCR_ATTR_ALGORITHM,  NCR_ATTR_KEY_FLAGS,  NCR_ATTR_KEY_TYPE  and
+              NCR_ATTR_KEY_ID attributes in addition to the raw key material:
+
+       NCRIO_KEY_STORAGE_UNWRAP
+              Unwrap key and associated metadata created using NCRIO_KEY_STOR-
+              AGE_WRAP, and restore  the  information  into  a  specified  key
+              object.
+
+              The  parameter  points  to  struct ncr_key_storage_unwrap, which
+              specifies the destination key in the key member and the  wrapped
+              data in the data and data_size members.
+
+              See NCRIO_KEY_STORAGE_WRAP above for the list of attributes that
+              will be restored.
+
+       NCRIO_SESSION_INIT
+              Allocate a session for performing crypto operations.
+
+              The parameter points to struct ncr_session_init, which specifies
+              the operation to perform, one of NCR_OP_ENCRYPT, NCR_OP_DECRYPT,
+              NCR_OP_SIGN  and  NCR_OP_VERIFY,  in   the   op   member.    Use
+              NCR_OP_SIGN  for  computing  an  unkeyed  hash  as well as keyed
+              hashes and signatures.
+
+              The following input attributes are recognized:
+
+              NCR_ATTR_ALGORITHM
+                     Mandatory.
+
+              NCR_ATTR_IV
+                     Mandatory for some operations and algorithms.
+
+              NCR_ATTR_KEY
+                     Mandatory for some operations and algorithms.  An  32-bit
+                     unsigned  integer in native byte order specifying the key
+                     to use for the operation.
+
+              NCR_ATTR_RSA_ENCODING_METHOD
+                     Mandatory for RSA.  An 32-bit unsigned integer in  native
+                     byte  order  specifying  a  RSA  encoding  method, one of
+                     RSA_PKCS1_V1_5, RSA_PKCS1_OAEP and RSA_PKCS1_PSS.
+
+              NCR_ATTR_RSA_OAEP_HASH_ALGORITHM
+                     Mandatory for RSA with RSA_PKCS1_OAEP.  A  NUL-terminated
+                     string  specifying  a  hash  algorithm  used  in the OAEP
+                     encoding method.
+
+              NCR_ATTR_RSA_PSS_SALT_LENGTH
+                     For RSA with RSA_PKCS1_PSS.  An 32-bit  unsigned  integer
+                     in  native  byte  order  specifying  the PSS salt length.
+                     Optional, defaults to 0.
+
+              NCR_ATTR_SIGNATURE_HASH_ALGORITHM
+                     Mandatory for some operations and algorithms.  A NUL-ter-
+                     minated  string  specifying a hash algorithm underlying a
+                     signature, using the same formats as  NCR_ATTR_ALGORITHM.
+
+              On success, an integer descriptor for the created session (valid
+              within the current /dev/crypto namespace) is returned.
+
+       NCRIO_SESSION_UPDATE
+              Update an existing crypto session with new data (for operations,
+              such  as  hashing, for which data can be supplied in pieces), or
+              perform a single operation using the session context (for opera-
+              tions,  such  as  public  key  encryption, that work on separate
+              units of data).
+
+              The parameter points to struct ncr_session_update, which  speci-
+              fies the descriptor of the session in the ses member.
+
+              The following input attributes are recognized:
+
+              NCR_ATTR_UPDATE_INPUT_DATA
+                     A  struct ncr_session_input_data specifying input for the
+                     operation in its data and data_size members.
+
+              NCR_ATTR_UPDATE_INPUT_KEY_AS_DATA
+                     An 32-bit unsigned integer in native byte order  specify-
+                     ing  the  key  descriptor serving as input for the opera-
+                     tion.  This can be currently used only to compute or ver-
+                     ify  a  signature  or hash of a symmetric key: the keying
+                     material is directly used as input data for the  underly-
+                     ing hash.
+
+              NCR_ATTR_UPDATE_OUTPUT_BUFFER
+                     Mandatory  for  some operations and algorithms.  A struct
+                     ncr_session_output_buffer specifying buffer for operation
+                     output in its buffer and buffer_size members.  On success
+                     the size of output is written to the variable pointed  to
+                     by the result_size_ptr member.
+
+              It is mandatory to include one of the NCR_ATTR_UPDATE_INPUT_DATA
+              and NCR_ATTR_UPDATE_INPUT_KEY_AS_DATA attributes.
+
+              For the NCR_OP_ENCRYPT and NCR_OP_DECRYPT operations using  sym-
+              metric  ciphers,  the  operation is performed on the input data,
+              resulting in an output data block of the same size;  for  opera-
+              tions  using public-key cryptography, a single operation is per-
+              formed on the input data, resulting in output data.
+
+              For the NCR_OP_SIGN and NCR_OP_VERIFY operations, the input data
+              is  supplied  to the underlying hash function; no output data is
+              produced.
+
+       NCRIO_SESSION_FINAL
+              Finalize an existing crypto session and deallocate it.
+
+              The parameter points to struct ncr_session_final,  which  speci-
+              fies the descriptor of the session in the ses member.
+
+              If     one     of     the     NCR_ATTR_UPDATE_INPUT_DATA     and
+              NCR_ATTR_UPDATE_INPUT_KEY_AS_DATA  attributes  is  present,  all
+              attributes are first processed as if using NCRIO_SESSION_UPDATE;
+              thus, the last update operation can be performed  together  with
+              the finalization in one step.
+
+              The following input attributes are recognized:
+
+              NCR_ATTR_FINAL_INPUT_DATA
+                     Mandatory  for  some operations and algorithms.  A struct
+                     ncr_session_input_data  as  described  above,  specifying
+                     input for the operation.
+
+              NCR_ATTR_FINAL_OUTPUT_BUFFER
+                     Mandatory  for  some operations and algorithms.  A struct
+                     ncr_session_output_buffer as described above,  specifying
+                     buffer for operation output.
+
+              There  is  no  specific  finalization  operation  performed  for
+              NCR_OP_ENCRYPT and NCR_OP_DECRYPT.
+
+              For the NCR_OP_SIGN operation,  the  signature  is  created  and
+              written as output data.
+
+              For  the NCR_OP_VERIFY operation, a signature specified as input
+              is verified and the result of this operation is  returned:  non-
+              zero for a valid signature, zero for an invalid signature.  Note
+              that the ioctl(2) operation return value will  be  non-negative,
+              i.e.  "success",  even  if  the signature verification fails, as
+              long all inputs were specified correctly.
+
+              The session will be deallocated even if the  NCRIO_SESSION_FINAL
+              operation  reports an error, as long as a valid session descrip-
+              tor was specified.
+
+       NCRIO_SESSION_ONCE
+              Perform an one-shot crypto  operation,  allocating  a  temporary
+              session, supplying a single instance of data, and finalizing the
+              session in one operation.
+
+              The parameter points to struct ncr_session_once, which specifies
+              the operation to perform in the op member.
+
+              The  attributes handled as if by passing to a NCRIO_SESSION_INIT
+              operation followed by a NCRIO_SESSION_FINAL operation,  and  the
+              return  value of the NCRIO_SESSION_FINAL is returned on success.
+
+       NCRIO_MASTER_KEY_SET
+              Set the system-wide storage master key.   Only  a  process  with
+              EUID  0  and  the CAP_SYS_ADMIN capability is allowed to perform
+              this operation.  Once a master key is set,  it  can  be  changed
+              only by rebooting the system and setting a different key.
+
+              The  parameter points to struct ncr_master_key_set, which speci-
+              fies the key material in user space using the key  and  key_size
+              members.
+
+              Only  an  AES  key  with  size  16, 24, or 32 bytes is currently
+              acceptable.
+
+CONFIGURATION
+       The NCRIO_KEY_STORAGE_WRAP and NCRIO_KEY_STORAGE_UNWRAP  ioctl()s  work
+       only after a storage master key is configured by the system administra-
+       tor.  See NCRIO_MASTER_KEY_SET above.
+
+FILES
+       /dev/crypto
+
+Linux                             2010-08-20                         CRYPTO(4)
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 756f831..41790cd 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -116,6 +116,7 @@ header-y += mmtimer.h
 header-y += mqueue.h
 header-y += mtio.h
 header-y += ncp_no.h
+header-y += ncr.h
 header-y += neighbour.h
 header-y += net_dropmon.h
 header-y += net_tstamp.h
diff --git a/include/linux/ncr.h b/include/linux/ncr.h
new file mode 100644
index 0000000..c288cb8
--- /dev/null
+++ b/include/linux/ncr.h
@@ -0,0 +1,273 @@
+#ifndef _LINUX_NCR_H
+#define _LINUX_NCR_H
+
+#include <linux/types.h>
+
+/* Serves to make sure the structure is suitably aligned to continue with
+   a struct nlattr without external padding.
+
+   4 is NLA_ALIGNTO from <linux/netlink.h>, but if we
+   included <linux/netlink.h>, the user would have to include <sys/socket.h>
+   as well for no obvious reason.  "4" is fixed by ABI. */
+#define __NL_ATTRIBUTES char __align[] __attribute__((aligned(4)))
+
+/* In all ioctls, input_size specifies size of the ncr_* structure and the
+   following attributes.
+
+   output_size specifies space available for returning output, including the
+   initial ncr_* structure, and is updated by the ioctl() with the space
+   actually used.
+
+   There are two special cases: input_size 0 means not attributes are supplied,
+   and is treated equivalent to sizeof(struct ncr_*).  output_size 0 means no
+   space for output attributes is available, and is not updated. */
+
+/* FIXME: better names for algorithm parameters? */
+/* FIXME: Split key generation/derivation attributes to decrease the number
+   of attributes used for the frequent operations? */
+enum {
+	NCR_ATTR_UNSPEC,	      /* 0 is special in lib/nlattr.c. */
+	NCR_ATTR_ALGORITHM,	      /* NLA_NUL_STRING */
+	NCR_ATTR_DERIVATION_ALGORITHM, /* NLA_NUL_STRING - NCR_DERIVE_* */
+	NCR_ATTR_SIGNATURE_HASH_ALGORITHM, /* NLA_NUL_STRING */
+	NCR_ATTR_WRAPPING_ALGORITHM,  /* NLA_NUL_STRING - NCR_WALG_* */
+	NCR_ATTR_UPDATE_INPUT_DATA,   /* NLA_BINARY - ncr_session_input_data */
+	/* NLA_BINARY - ncr_session_output_buffer */
+	NCR_ATTR_UPDATE_OUTPUT_BUFFER,
+	NCR_ATTR_UPDATE_INPUT_KEY_AS_DATA, /* NLA_U32 - ncr_key_t */
+	NCR_ATTR_FINAL_INPUT_DATA,    /* NLA_BINARY - ncr_session_input_data */
+	/* NLA_BINARY - ncr_session_output_buffer */
+	NCR_ATTR_FINAL_OUTPUT_BUFFER,
+	NCR_ATTR_KEY,	              /* NLA_U32 - ncr_key_t */
+	NCR_ATTR_KEY_FLAGS,	      /* NLA_U32 - NCR_KEY_FLAG_* */
+	NCR_ATTR_KEY_ID,	      /* NLA_BINARY */
+	NCR_ATTR_KEY_TYPE,	      /* NLA_U32 - ncr_key_type_t */
+	NCR_ATTR_IV,		      /* NLA_BINARY */
+	NCR_ATTR_SECRET_KEY_BITS,     /* NLA_U32 */
+	NCR_ATTR_RSA_MODULUS_BITS,    /* NLA_U32 */
+	NCR_ATTR_RSA_E,		      /* NLA_BINARY */
+	NCR_ATTR_RSA_ENCODING_METHOD, /* NLA_U32 - ncr_rsa_type_t */
+	NCR_ATTR_RSA_OAEP_HASH_ALGORITHM, /* NLA_NUL_STRING */
+	NCR_ATTR_RSA_PSS_SALT_LENGTH, /* NLA_U32 */
+	NCR_ATTR_DSA_P_BITS,	      /* NLA_U32 */
+	NCR_ATTR_DSA_Q_BITS,	      /* NLA_U32 */
+	NCR_ATTR_DH_PRIME,	      /* NLA_BINARY */
+	NCR_ATTR_DH_BASE,	      /* NLA_BINARY */
+	NCR_ATTR_DH_PUBLIC,	      /* NLA_BINARY */
+	NCR_ATTR_WANTED_ATTRS,	      /* NLA_BINARY - array of u16 IDs */
+
+	/* Add new attributes here */
+
+	NCR_ATTR_END__,
+	NCR_ATTR_MAX = NCR_ATTR_END__ - 1
+};
+
+#define NCR_CIPHER_MAX_BLOCK_LEN 32
+#define NCR_HASH_MAX_OUTPUT_SIZE  64
+
+#define NCR_WALG_AES_RFC3394 "walg-aes-rfc3394" /* for secret keys only */
+#define NCR_WALG_AES_RFC5649 "walg-aes-rfc5649" /* can wrap arbitrary key */
+
+typedef enum {
+	NCR_KEY_TYPE_INVALID,
+	NCR_KEY_TYPE_SECRET=1,
+	NCR_KEY_TYPE_PUBLIC=2,
+	NCR_KEY_TYPE_PRIVATE=3,
+} ncr_key_type_t;
+
+/* Key handling
+ */
+
+typedef __s32 ncr_key_t;
+
+#define NCR_KEY_INVALID ((ncr_key_t)-1)
+
+#define NCR_KEY_FLAG_EXPORTABLE 1
+#define NCR_KEY_FLAG_WRAPPABLE (1<<1)
+/* when generating a pair the flags correspond to private
+ * and public key usage is implicit. For example when private
+ * key can decrypt then public key can encrypt. If private key
+ * can sign then public key can verify.
+ */
+#define NCR_KEY_FLAG_DECRYPT (1<<2)
+#define NCR_KEY_FLAG_SIGN (1<<3)
+
+struct ncr_key_generate {
+	__u32 input_size, output_size;
+	ncr_key_t key;
+	__NL_ATTRIBUTES;
+};
+
+struct ncr_key_generate_pair {
+	__u32 input_size, output_size;
+	ncr_key_t private_key;
+	ncr_key_t public_key;
+	__NL_ATTRIBUTES;
+};
+
+typedef enum {
+	RSA_PKCS1_V1_5, /* both signatures and encryption */
+	RSA_PKCS1_OAEP, /* for encryption only */
+	RSA_PKCS1_PSS, /* for signatures only */
+} ncr_rsa_type_t;
+
+#define NCR_DERIVE_DH "dh"
+
+
+struct ncr_key_derive {
+	__u32 input_size, output_size;
+	ncr_key_t input_key;
+	ncr_key_t new_key;
+	__NL_ATTRIBUTES;
+};
+
+#define MAX_KEY_ID_SIZE 20
+
+struct ncr_key_get_info {
+	__u32 input_size, output_size;
+	ncr_key_t key;
+	__NL_ATTRIBUTES;
+};
+
+struct ncr_key_import {
+	__u32 input_size, output_size;
+	ncr_key_t key;
+	const void __user *data;
+	__u32 data_size;
+	__NL_ATTRIBUTES;
+};
+
+struct ncr_key_export {
+	__u32 input_size, output_size;
+	ncr_key_t key;
+	void __user *buffer;
+	int buffer_size;
+	__NL_ATTRIBUTES;
+};
+
+#define NCRIO_KEY_INIT			_IO('c', 204)
+/* generate a secret key */
+#define NCRIO_KEY_GENERATE     	_IOWR('c', 205, struct ncr_key_generate)
+/* generate a public key pair */
+#define NCRIO_KEY_GENERATE_PAIR _IOWR('c', 206, struct ncr_key_generate_pair)
+/* derive a new key from an old one */
+#define NCRIO_KEY_DERIVE        _IOWR('c', 207, struct ncr_key_derive)
+/* return information on a key */
+#define NCRIO_KEY_GET_INFO      _IOWR('c', 208, struct ncr_key_get_info)
+/* export a secret key */
+#define NCRIO_KEY_EXPORT       	_IOWR('c', 209, struct ncr_key_export)
+/* import a secret key */
+#define NCRIO_KEY_IMPORT       	_IOWR('c', 210, struct ncr_key_import)
+
+#define NCRIO_KEY_DEINIT       _IOR ('c', 215, ncr_key_t)
+
+/* Key wrap ioctls
+ */
+struct ncr_key_wrap {
+	__u32 input_size, output_size;
+	ncr_key_t wrapping_key;
+	ncr_key_t source_key;
+	void __user *buffer;
+	int buffer_size;
+	__NL_ATTRIBUTES;
+};
+
+struct ncr_key_unwrap {
+	__u32 input_size, output_size;
+	ncr_key_t wrapping_key;
+	ncr_key_t dest_key;
+	const void __user *data;
+	__u32 data_size;
+	__NL_ATTRIBUTES;
+};
+
+#define NCRIO_KEY_WRAP        _IOWR('c', 250, struct ncr_key_wrap)
+#define NCRIO_KEY_UNWRAP        _IOWR('c', 251, struct ncr_key_unwrap)
+
+/* Internal ops  */
+struct ncr_master_key_set {
+	__u32 input_size, output_size;
+	const void __user *key;
+	__u32 key_size;
+	__NL_ATTRIBUTES;
+};
+
+#define NCRIO_MASTER_KEY_SET        _IOWR('c', 260, struct ncr_master_key_set)
+
+/* These are similar to key_wrap and unwrap except that will store some extra
+ * fields to be able to recover a key */
+struct ncr_key_storage_wrap {
+	__u32 input_size, output_size;
+	ncr_key_t key;
+	void __user *buffer;
+	int buffer_size;
+	__NL_ATTRIBUTES;
+};
+
+struct ncr_key_storage_unwrap {
+	__u32 input_size, output_size;
+	ncr_key_t key;
+	const void __user *data;
+	__u32 data_size;
+	__NL_ATTRIBUTES;
+};
+
+#define NCRIO_KEY_STORAGE_WRAP        _IOWR('c', 261, struct ncr_key_storage_wrap)
+#define NCRIO_KEY_STORAGE_UNWRAP        _IOWR('c', 262, struct ncr_key_storage_wrap)
+
+/* Crypto Operations ioctls
+ */
+
+typedef enum {
+	NCR_OP_ENCRYPT=1,
+	NCR_OP_DECRYPT,
+	NCR_OP_SIGN,
+	NCR_OP_VERIFY,
+} ncr_crypto_op_t;
+
+typedef __s32 ncr_session_t;
+#define NCR_SESSION_INVALID ((ncr_session_t)-1)
+
+struct ncr_session_input_data {
+	const void __user *data;
+	__kernel_size_t data_size;
+};
+
+struct ncr_session_output_buffer {
+	void __user *buffer;
+	__kernel_size_t buffer_size;
+	__kernel_size_t __user *result_size_ptr;
+};
+
+struct ncr_session_init {
+	__u32 input_size, output_size;
+	__u32 op;		/* ncr_crypto_op_t */
+	__NL_ATTRIBUTES;
+};
+
+struct ncr_session_update {
+	__u32 input_size, output_size;
+	ncr_session_t ses;
+	__NL_ATTRIBUTES;
+};
+
+struct ncr_session_final {
+	__u32 input_size, output_size;
+	ncr_session_t ses;
+	__NL_ATTRIBUTES;
+};
+
+struct ncr_session_once {
+	__u32 input_size, output_size;
+	ncr_crypto_op_t op;
+	__NL_ATTRIBUTES;
+};
+
+#define NCRIO_SESSION_INIT        _IOWR('c', 300, struct ncr_session_init)
+#define NCRIO_SESSION_UPDATE        _IOWR('c', 301, struct ncr_session_update)
+#define NCRIO_SESSION_FINAL        _IOWR('c', 302, struct ncr_session_final)
+
+/* everything in one call */
+#define NCRIO_SESSION_ONCE        _IOWR('c', 303, struct ncr_session_once)
+
+#endif
-- 
1.7.2.1

