Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab0HTIrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:47:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973Ab0HTIqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:46:36 -0400
From: =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-crypto@vger.kernel.org,
        Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
Subject: [PATCH 04/19] Add libtomcrypt headers
Date: Fri, 20 Aug 2010 10:45:47 +0200
Message-Id: <1282293963-27807-5-git-send-email-mitr@redhat.com>
In-Reply-To: <1282293963-27807-1-git-send-email-mitr@redhat.com>
References: <1282293963-27807-1-git-send-email-mitr@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same as the previous patch - the header file dependencies do not allow
otherwise.

(Reviewing this in detail is probably premature, we are considering
replacing the implementation by something based on libgcrypt, which is
more actively maintained and has been probably more thorouhgly examined
for vulnerabilities.)
---
 crypto/userspace/libtomcrypt/headers/tomcrypt.h    |   82 ++++
 .../libtomcrypt/headers/tomcrypt_argchk.h          |   36 ++
 .../userspace/libtomcrypt/headers/tomcrypt_cfg.h   |  135 +++++++
 .../libtomcrypt/headers/tomcrypt_custom.h          |  408 +++++++++++++++++++
 .../userspace/libtomcrypt/headers/tomcrypt_hash.h  |   14 +
 .../libtomcrypt/headers/tomcrypt_macros.h          |  424 ++++++++++++++++++++
 .../userspace/libtomcrypt/headers/tomcrypt_math.h  |   13 +
 .../userspace/libtomcrypt/headers/tomcrypt_misc.h  |   23 +
 crypto/userspace/libtomcrypt/headers/tomcrypt_pk.h |  359 +++++++++++++++++
 .../userspace/libtomcrypt/headers/tomcrypt_pkcs.h  |   67 +++
 10 files changed, 1561 insertions(+), 0 deletions(-)
 create mode 100644 crypto/userspace/libtomcrypt/headers/tomcrypt.h
 create mode 100644 crypto/userspace/libtomcrypt/headers/tomcrypt_argchk.h
 create mode 100644 crypto/userspace/libtomcrypt/headers/tomcrypt_cfg.h
 create mode 100644 crypto/userspace/libtomcrypt/headers/tomcrypt_custom.h
 create mode 100644 crypto/userspace/libtomcrypt/headers/tomcrypt_hash.h
 create mode 100644 crypto/userspace/libtomcrypt/headers/tomcrypt_macros.h
 create mode 100644 crypto/userspace/libtomcrypt/headers/tomcrypt_math.h
 create mode 100644 crypto/userspace/libtomcrypt/headers/tomcrypt_misc.h
 create mode 100644 crypto/userspace/libtomcrypt/headers/tomcrypt_pk.h
 create mode 100644 crypto/userspace/libtomcrypt/headers/tomcrypt_pkcs.h

diff --git a/crypto/userspace/libtomcrypt/headers/tomcrypt.h b/crypto/userspace/libtomcrypt/headers/tomcrypt.h
new file mode 100644
index 0000000..51fe804
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/headers/tomcrypt.h
@@ -0,0 +1,82 @@
+#ifndef TOMCRYPT_H_
+#define TOMCRYPT_H_
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/string.h>
+#include <linux/ctype.h>
+#include <linux/nls.h>
+
+/* use configuration data */
+#include <tomcrypt_custom.h>
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+/* version */
+#define CRYPT   0x0117
+#define SCRYPT  "1.17"
+
+/* max size of either a cipher/hash block or symmetric key [largest of the two] */
+#define MAXBLOCKSIZE  128
+
+/* descriptor table size */
+#define TAB_SIZE      32
+
+/* error codes [will be expanded in future releases] */
+enum {
+   CRYPT_OK=0,             /* Result OK */
+   CRYPT_ERROR,            /* Generic Error */
+   CRYPT_NOP,              /* Not a failure but no operation was performed */
+
+   CRYPT_INVALID_KEYSIZE,  /* Invalid key size given */
+   CRYPT_INVALID_ROUNDS,   /* Invalid number of rounds */
+   CRYPT_FAIL_TESTVECTOR,  /* Algorithm failed test vectors */
+
+   CRYPT_BUFFER_OVERFLOW,  /* Not enough space for output */
+   CRYPT_INVALID_PACKET,   /* Invalid input packet given */
+
+   CRYPT_INVALID_PRNGSIZE, /* Invalid number of bits for a PRNG */
+   CRYPT_ERROR_READPRNG,   /* Could not read enough from PRNG */
+
+   CRYPT_INVALID_CIPHER,   /* Invalid cipher specified */
+   CRYPT_INVALID_HASH,     /* Invalid hash specified */
+   CRYPT_INVALID_PRNG,     /* Invalid PRNG specified */
+
+   CRYPT_MEM,              /* Out of memory */
+
+   CRYPT_PK_TYPE_MISMATCH, /* Not equivalent types of PK keys */
+   CRYPT_PK_NOT_PRIVATE,   /* Requires a private PK key */
+
+   CRYPT_INVALID_ARG,      /* Generic invalid argument */
+   CRYPT_FILE_NOTFOUND,    /* File Not Found */
+
+   CRYPT_PK_INVALID_TYPE,  /* Invalid type of PK key */
+   CRYPT_PK_INVALID_SYSTEM,/* Invalid PK system specified */
+   CRYPT_PK_DUP,           /* Duplicate key already in key ring */
+   CRYPT_PK_NOT_FOUND,     /* Key not found in keyring */
+   CRYPT_PK_INVALID_SIZE,  /* Invalid size input for PK parameters */
+
+   CRYPT_INVALID_PRIME_SIZE,/* Invalid size of prime requested */
+   CRYPT_PK_INVALID_PADDING /* Invalid padding on input */
+};
+
+#include <tomcrypt_cfg.h>
+#include <tomcrypt_macros.h>
+#include <tomcrypt_math.h>
+#include <tomcrypt_pk.h>
+#include <tomcrypt_hash.h>
+#include <tomcrypt_misc.h>
+#include <tomcrypt_argchk.h>
+#include <tomcrypt_pkcs.h>
+
+#ifdef __cplusplus
+   }
+#endif
+
+#endif /* TOMCRYPT_H_ */
+
+
+/* $Source: /cvs/libtom/libtomcrypt/src/headers/tomcrypt.h,v $ */
+/* $Revision: 1.21 $ */
+/* $Date: 2006/12/16 19:34:05 $ */
diff --git a/crypto/userspace/libtomcrypt/headers/tomcrypt_argchk.h b/crypto/userspace/libtomcrypt/headers/tomcrypt_argchk.h
new file mode 100644
index 0000000..1b94434
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/headers/tomcrypt_argchk.h
@@ -0,0 +1,36 @@
+/* Defines the LTC_ARGCHK macro used within the library */
+/* ARGTYPE is defined in mycrypt_cfg.h */
+#if ARGTYPE == 0
+
+/* this is the default LibTomCrypt macro  */
+void crypt_argchk(char *v, char *s, int d);
+#define LTC_ARGCHK(x) if (!(x)) { crypt_argchk(#x, __FILE__, __LINE__); }
+#define LTC_ARGCHKVD(x) LTC_ARGCHK(x)
+
+#elif ARGTYPE == 1
+
+/* fatal type of error */
+#define LTC_ARGCHK(x) assert((x))
+#define LTC_ARGCHKVD(x) LTC_ARGCHK(x)
+
+#elif ARGTYPE == 2
+
+#define LTC_ARGCHK(x) if (!(x)) { fprintf(stderr, "\nwarning: ARGCHK failed at %s:%d\n", __FILE__, __LINE__); }
+#define LTC_ARGCHKVD(x) LTC_ARGCHK(x)
+
+#elif ARGTYPE == 3
+
+#define LTC_ARGCHK(x) 
+#define LTC_ARGCHKVD(x) LTC_ARGCHK(x)
+
+#elif ARGTYPE == 4
+
+#define LTC_ARGCHK(x)   if (!(x)) return CRYPT_INVALID_ARG;
+#define LTC_ARGCHKVD(x) if (!(x)) return;
+
+#endif
+
+
+/* $Source: /cvs/libtom/libtomcrypt/src/headers/tomcrypt_argchk.h,v $ */
+/* $Revision: 1.5 $ */
+/* $Date: 2006/08/27 20:50:21 $ */
diff --git a/crypto/userspace/libtomcrypt/headers/tomcrypt_cfg.h b/crypto/userspace/libtomcrypt/headers/tomcrypt_cfg.h
new file mode 100644
index 0000000..b750c8b
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/headers/tomcrypt_cfg.h
@@ -0,0 +1,135 @@
+/* This is the build config file.
+ *
+ * With this you can setup what to inlcude/exclude automatically during any build.  Just comment
+ * out the line that #define's the word for the thing you want to remove.  phew!
+ */
+
+#ifndef TOMCRYPT_CFG_H
+#define TOMCRYPT_CFG_H
+
+#if defined(_WIN32) || defined(_MSC_VER)
+#define LTC_CALL __cdecl
+#else
+#ifndef LTC_CALL
+   #define LTC_CALL
+#endif
+#endif
+
+#ifndef LTC_EXPORT
+#define LTC_EXPORT
+#endif
+
+LTC_EXPORT void LTC_CALL XQSORT(void *base, size_t nmemb, size_t size, int(*compar)(const void *, const void *));
+
+/* certain platforms use macros for these, making the prototypes broken */
+#ifndef LTC_NO_PROTOTYPES
+
+/* you can change how memory allocation works ... */
+LTC_EXPORT void * LTC_CALL XMALLOC(size_t n);
+LTC_EXPORT void * LTC_CALL XREALLOC(void *p, size_t n);
+LTC_EXPORT void * LTC_CALL XCALLOC(size_t n, size_t s);
+LTC_EXPORT void LTC_CALL XFREE(void *p);
+
+/* change the clock function too */
+LTC_EXPORT clock_t LTC_CALL XCLOCK(void);
+
+/* various other functions */
+LTC_EXPORT void * LTC_CALL XMEMCPY(void *dest, const void *src, size_t n);
+LTC_EXPORT int   LTC_CALL XMEMCMP(const void *s1, const void *s2, size_t n);
+LTC_EXPORT void * LTC_CALL XMEMSET(void *s, int c, size_t n);
+
+LTC_EXPORT int   LTC_CALL XSTRCMP(const char *s1, const char *s2);
+
+#endif
+
+/* type of argument checking, 0=default, 1=fatal and 2=error+continue, 3=nothing */
+#ifndef ARGTYPE
+   #define ARGTYPE  0
+#endif
+
+/* Controls endianess and size of registers.  Leave uncommented to get platform neutral [slower] code 
+ * 
+ * Note: in order to use the optimized macros your platform must support unaligned 32 and 64 bit read/writes.
+ * The x86 platforms allow this but some others [ARM for instance] do not.  On those platforms you **MUST**
+ * use the portable [slower] macros.
+ */
+
+/* detect x86-32 machines somewhat */
+#if !defined(__STRICT_ANSI__) && (defined(INTEL_CC) || (defined(_MSC_VER) && defined(WIN32)) || (defined(__GNUC__) && (defined(__DJGPP__) || defined(__CYGWIN__) || defined(__MINGW32__) || defined(__i386__))))
+   #define ENDIAN_LITTLE
+   #define ENDIAN_32BITWORD
+   #define LTC_FAST
+   #define LTC_FAST_TYPE    unsigned long
+#endif
+
+/* detects MIPS R5900 processors (PS2) */
+#if (defined(__R5900) || defined(R5900) || defined(__R5900__)) && (defined(_mips) || defined(__mips__) || defined(mips))
+   #define ENDIAN_LITTLE
+   #define ENDIAN_64BITWORD
+#endif
+
+/* detect amd64 */
+#if !defined(__STRICT_ANSI__) && defined(__x86_64__)
+   #define ENDIAN_LITTLE
+   #define ENDIAN_64BITWORD
+   #define LTC_FAST
+   #define LTC_FAST_TYPE    unsigned long
+#endif
+
+/* detect PPC32 */
+#if !defined(__STRICT_ANSI__) && defined(LTC_PPC32)
+   #define ENDIAN_BIG
+   #define ENDIAN_32BITWORD
+   #define LTC_FAST
+   #define LTC_FAST_TYPE    unsigned long
+#endif   
+
+/* detect sparc and sparc64 */
+#if defined(__sparc__)
+  #define ENDIAN_BIG
+  #if defined(__arch64__)
+    #define ENDIAN_64BITWORD
+  #else
+    #define ENDIAN_32BITWORD
+  #endif
+#endif
+
+
+#ifdef LTC_NO_FAST
+   #ifdef LTC_FAST
+      #undef LTC_FAST
+   #endif
+#endif
+
+/* No asm is a quick way to disable anything "not portable" */
+#ifdef LTC_NO_ASM
+   #undef ENDIAN_LITTLE
+   #undef ENDIAN_BIG
+   #undef ENDIAN_32BITWORD
+   #undef ENDIAN_64BITWORD
+   #undef LTC_FAST
+   #undef LTC_FAST_TYPE
+   #define LTC_NO_ROLC
+	#define LTC_NO_BSWAP
+#endif
+
+/* #define ENDIAN_LITTLE */
+/* #define ENDIAN_BIG */
+
+/* #define ENDIAN_32BITWORD */
+/* #define ENDIAN_64BITWORD */
+
+#if (defined(ENDIAN_BIG) || defined(ENDIAN_LITTLE)) && !(defined(ENDIAN_32BITWORD) || defined(ENDIAN_64BITWORD))
+    #error You must specify a word size as well as endianess in tomcrypt_cfg.h
+#endif
+
+#if !(defined(ENDIAN_BIG) || defined(ENDIAN_LITTLE))
+   #define ENDIAN_NEUTRAL
+#endif
+
+#endif
+
+
+/* $Source: /cvs/libtom/libtomcrypt/src/headers/tomcrypt_cfg.h,v $ */
+/* $Revision: 1.19 $ */
+/* $Date: 2006/12/04 02:19:48 $ */
diff --git a/crypto/userspace/libtomcrypt/headers/tomcrypt_custom.h b/crypto/userspace/libtomcrypt/headers/tomcrypt_custom.h
new file mode 100644
index 0000000..c537dc7
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/headers/tomcrypt_custom.h
@@ -0,0 +1,408 @@
+#ifndef TOMCRYPT_CUSTOM_H_
+#define TOMCRYPT_CUSTOM_H_
+
+#define LTC_NO_PROTOTYPES
+
+/* macros for various libc functions you can change for embedded targets */
+#ifndef XMALLOC
+   #ifdef malloc 
+   #define LTC_NO_PROTOTYPES
+   #endif
+#define XMALLOC(x)  kmalloc(x, GFP_KERNEL)
+#endif
+#ifndef XREALLOC
+   #ifdef realloc 
+   #define LTC_NO_PROTOTYPES
+   #endif
+#define XREALLOC(x,y) krealloc(x,y,GFP_KERNEL)
+#endif
+#ifndef XCALLOC
+   #ifdef calloc 
+   #define LTC_NO_PROTOTYPES
+   #endif
+#define XCALLOC(x,y)  kcalloc(x, y, GFP_KERNEL)
+#endif
+#ifndef XFREE
+   #ifdef free
+   #define LTC_NO_PROTOTYPES
+   #endif
+#define XFREE    kfree
+#endif
+
+#ifndef XMEMSET
+   #ifdef memset
+   #define LTC_NO_PROTOTYPES
+   #endif
+#define XMEMSET  memset
+#endif
+#ifndef XMEMCPY
+   #ifdef memcpy
+   #define LTC_NO_PROTOTYPES
+   #endif
+#define XMEMCPY  memcpy
+#endif
+#ifndef XMEMCMP
+   #ifdef memcmp 
+   #define LTC_NO_PROTOTYPES
+   #endif
+#define XMEMCMP  memcmp
+#endif
+#ifndef XSTRCMP
+   #ifdef strcmp
+   #define LTC_NO_PROTOTYPES
+   #endif
+#define XSTRCMP strcmp
+#endif
+
+#ifndef XCLOCK
+#define XCLOCK   clock
+#endif
+#ifndef XCLOCKS_PER_SEC
+#define XCLOCKS_PER_SEC CLOCKS_PER_SEC
+#endif
+
+#ifndef XQSORT
+   #ifdef qsort
+   #define LTC_NO_PROTOTYPES
+   #endif
+#define XQSORT qsort
+#endif
+
+/* Easy button? */
+#ifdef LTC_EASY
+   #define LTC_NO_CIPHERS
+   #define LTC_RIJNDAEL
+   #define LTC_BLOWFISH
+   #define LTC_DES
+   #define LTC_CAST5
+   
+   #define LTC_NO_MODES
+   #define LTC_ECB_MODE
+   #define LTC_CBC_MODE
+   #define LTC_CTR_MODE
+   
+   #define LTC_NO_HASHES
+   #define LTC_SHA1
+   #define LTC_SHA512
+   #define LTC_SHA384
+   #define LTC_SHA256
+   #define LTC_SHA224
+   
+   #define LTC_NO_MACS
+   #define LTC_HMAC
+   #define LTC_OMAC
+   #define LTC_CCM_MODE
+
+   #define LTC_NO_PRNGS
+   #define LTC_SPRNG
+   #define LTC_YARROW
+   #define LTC_DEVRANDOM
+   #define TRY_URANDOM_FIRST
+      
+   #define LTC_NO_PK
+   #define LTC_MRSA
+   #define LTC_MECC
+#endif   
+
+/* Use small code where possible */
+/* #define LTC_SMALL_CODE */
+
+/* Enable self-test test vector checking */
+#ifndef LTC_NO_TEST
+   #define LTC_TEST
+#endif
+
+/* clean the stack of functions which put private information on stack */
+/* #define LTC_CLEAN_STACK */
+
+/* disable all file related functions */
+/* #define LTC_NO_FILE */
+
+/* disable all forms of ASM */
+/* #define LTC_NO_ASM */
+
+/* disable FAST mode */
+/* #define LTC_NO_FAST */
+
+/* disable BSWAP on x86 */
+/* #define LTC_NO_BSWAP */
+
+/* ---> Symmetric Block Ciphers <--- */
+#ifndef LTC_NO_CIPHERS
+
+#define LTC_BLOWFISH
+#define LTC_RC2
+#define LTC_RC5
+#define LTC_RC6
+#define LTC_SAFERP
+#define LTC_RIJNDAEL
+#define LTC_XTEA
+/* _TABLES tells it to use tables during setup, _SMALL means to use the smaller scheduled key format
+ * (saves 4KB of ram), _ALL_TABLES enables all tables during setup */
+#define LTC_TWOFISH
+#ifndef LTC_NO_TABLES
+   #define LTC_TWOFISH_TABLES
+   /* #define LTC_TWOFISH_ALL_TABLES */
+#else
+   #define LTC_TWOFISH_SMALL
+#endif
+/* #define LTC_TWOFISH_SMALL */
+/* LTC_DES includes EDE triple-LTC_DES */
+#define LTC_DES
+#define LTC_CAST5
+#define LTC_NOEKEON
+#define LTC_SKIPJACK
+#define LTC_SAFER
+#define LTC_KHAZAD
+#define LTC_ANUBIS
+#define LTC_ANUBIS_TWEAK
+#define LTC_KSEED
+#define LTC_KASUMI
+
+#endif /* LTC_NO_CIPHERS */
+
+
+/* ---> Block Cipher Modes of Operation <--- */
+#ifndef LTC_NO_MODES
+
+#define LTC_CFB_MODE
+#define LTC_OFB_MODE
+#define LTC_ECB_MODE
+#define LTC_CBC_MODE
+#define LTC_CTR_MODE
+
+/* F8 chaining mode */
+#define LTC_F8_MODE
+
+/* LRW mode */
+#define LTC_LRW_MODE
+#ifndef LTC_NO_TABLES
+   /* like GCM mode this will enable 16 8x128 tables [64KB] that make
+    * seeking very fast.  
+    */
+   #define LRW_TABLES
+#endif
+
+/* XTS mode */
+#define LTC_XTS_MODE
+
+#endif /* LTC_NO_MODES */
+
+/* ---> One-Way Hash Functions <--- */
+#ifndef LTC_NO_HASHES 
+
+#define LTC_CHC_HASH
+#define LTC_WHIRLPOOL
+#define LTC_SHA512
+#define LTC_SHA384
+#define LTC_SHA256
+#define LTC_SHA224
+#define LTC_TIGER
+#define LTC_SHA1
+#define LTC_MD5
+#define LTC_MD4
+#define LTC_MD2
+#define LTC_RIPEMD128
+#define LTC_RIPEMD160
+#define LTC_RIPEMD256
+#define LTC_RIPEMD320
+
+#endif /* LTC_NO_HASHES */
+
+/* ---> MAC functions <--- */
+#ifndef LTC_NO_MACS
+
+#define LTC_HMAC
+#define LTC_OMAC
+#define LTC_PMAC
+#define LTC_XCBC
+#define LTC_F9_MODE
+#define LTC_PELICAN
+
+#if defined(LTC_PELICAN) && !defined(LTC_RIJNDAEL)
+   #error Pelican-MAC requires LTC_RIJNDAEL
+#endif
+
+/* ---> Encrypt + Authenticate Modes <--- */
+
+#define LTC_EAX_MODE
+#if defined(LTC_EAX_MODE) && !(defined(LTC_CTR_MODE) && defined(LTC_OMAC))
+   #error LTC_EAX_MODE requires CTR and LTC_OMAC mode
+#endif
+
+#define LTC_OCB_MODE
+#define LTC_CCM_MODE
+#define LTC_GCM_MODE
+
+/* Use 64KiB tables */
+#ifndef LTC_NO_TABLES
+   #define LTC_GCM_TABLES 
+#endif
+
+/* USE SSE2? requires GCC works on x86_32 and x86_64*/
+#ifdef LTC_GCM_TABLES
+/* #define LTC_GCM_TABLES_SSE2 */
+#endif
+
+#endif /* LTC_NO_MACS */
+
+/* Various tidbits of modern neatoness */
+#define LTC_BASE64
+
+/* --> Pseudo Random Number Generators <--- */
+#ifndef LTC_NO_PRNGS
+
+/* Yarrow */
+#define LTC_YARROW
+/* which descriptor of AES to use?  */
+/* 0 = rijndael_enc 1 = aes_enc, 2 = rijndael [full], 3 = aes [full] */
+#define LTC_YARROW_AES 0
+
+#if defined(LTC_YARROW) && !defined(LTC_CTR_MODE)
+   #error LTC_YARROW requires LTC_CTR_MODE chaining mode to be defined!
+#endif
+
+/* a PRNG that simply reads from an available system source */
+#define LTC_SPRNG
+
+/* The LTC_RC4 stream cipher */
+#define LTC_RC4
+
+/* Fortuna PRNG */
+#define LTC_FORTUNA
+/* reseed every N calls to the read function */
+#define LTC_FORTUNA_WD    10
+/* number of pools (4..32) can save a bit of ram by lowering the count */
+#define LTC_FORTUNA_POOLS 32
+
+/* Greg's LTC_SOBER128 PRNG ;-0 */
+#define LTC_SOBER128
+
+/* the *nix style /dev/random device */
+#define LTC_DEVRANDOM
+/* try /dev/urandom before trying /dev/random */
+#define TRY_URANDOM_FIRST
+
+#endif /* LTC_NO_PRNGS */
+
+/* ---> math provider? <--- */
+#ifndef LTC_NO_MATH
+
+/* LibTomMath */
+#define LTM_LTC_DESC
+
+/* TomsFastMath */
+/* #define TFM_LTC_DESC */
+
+#endif /* LTC_NO_MATH */
+
+/* ---> Public Key Crypto <--- */
+#ifndef LTC_NO_PK
+
+/* Include RSA support */
+#define LTC_MRSA
+
+/* Include Katja (a Rabin variant like RSA) */
+/* #define MKAT */ 
+
+/* Digital Signature Algorithm */
+#define LTC_MDSA
+
+/* ECC */
+#define LTC_MECC
+
+/* use Shamir's trick for point mul (speeds up signature verification) */
+#define LTC_ECC_SHAMIR
+
+#if defined(TFM_LTC_DESC) && defined(LTC_MECC)
+   #define LTC_MECC_ACCEL
+#endif   
+
+/* do we want fixed point ECC */
+/* #define LTC_MECC_FP */
+
+/* Timing Resistant? */
+/* #define LTC_ECC_TIMING_RESISTANT */
+
+#endif /* LTC_NO_PK */
+
+/* LTC_PKCS #1 (RSA) and #5 (Password Handling) stuff */
+#ifndef LTC_NO_PKCS
+
+#define LTC_PKCS_1
+#define LTC_PKCS_5
+
+/* Include ASN.1 DER (required by DSA/RSA) */
+#define LTC_DER
+
+#endif /* LTC_NO_PKCS */
+
+/* cleanup */
+
+#ifdef LTC_MECC
+/* Supported ECC Key Sizes */
+#ifndef LTC_NO_CURVES
+   #define ECC112
+   #define ECC128
+   #define ECC160
+   #define ECC192
+   #define ECC224
+   #define ECC256
+   #define ECC384
+   #define ECC521
+#endif
+#endif
+
+#if defined(LTC_MECC) || defined(LTC_MRSA) || defined(LTC_MDSA) || defined(MKATJA)
+   /* Include the MPI functionality?  (required by the PK algorithms) */
+   #define MPI
+#endif
+
+#ifdef LTC_MRSA
+   #define LTC_PKCS_1
+#endif   
+
+#if defined(LTC_DER) && !defined(MPI) 
+   #error ASN.1 DER requires MPI functionality
+#endif
+
+#if (defined(LTC_MDSA) || defined(LTC_MRSA) || defined(LTC_MECC) || defined(MKATJA)) && !defined(LTC_DER)
+   #error PK requires ASN.1 DER functionality, make sure LTC_DER is enabled
+#endif
+
+/* THREAD management */
+#ifdef LTC_PTHREAD
+
+#include <pthread.h>
+
+#define LTC_MUTEX_GLOBAL(x)   pthread_mutex_t x = PTHREAD_MUTEX_INITIALIZER;
+#define LTC_MUTEX_PROTO(x)    extern pthread_mutex_t x;
+#define LTC_MUTEX_TYPE(x)     pthread_mutex_t x;
+#define LTC_MUTEX_INIT(x)     pthread_mutex_init(x, NULL);
+#define LTC_MUTEX_LOCK(x)     pthread_mutex_lock(x);
+#define LTC_MUTEX_UNLOCK(x)   pthread_mutex_unlock(x);
+
+#else
+
+/* default no functions */
+#define LTC_MUTEX_GLOBAL(x)
+#define LTC_MUTEX_PROTO(x)
+#define LTC_MUTEX_TYPE(x)
+#define LTC_MUTEX_INIT(x)
+#define LTC_MUTEX_LOCK(x)
+#define LTC_MUTEX_UNLOCK(x)
+
+#endif
+
+/* Debuggers */
+
+/* define this if you use Valgrind, note: it CHANGES the way SOBER-128 and LTC_RC4 work (see the code) */
+/* #define LTC_VALGRIND */
+
+#endif
+
+
+
+/* $Source: /cvs/libtom/libtomcrypt/src/headers/tomcrypt_custom.h,v $ */
+/* $Revision: 1.73 $ */
+/* $Date: 2007/05/12 14:37:41 $ */
diff --git a/crypto/userspace/libtomcrypt/headers/tomcrypt_hash.h b/crypto/userspace/libtomcrypt/headers/tomcrypt_hash.h
new file mode 100644
index 0000000..e4e84e4
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/headers/tomcrypt_hash.h
@@ -0,0 +1,14 @@
+/* ---- HASH FUNCTIONS ---- */
+
+struct algo_properties_st;
+
+int hash_is_valid(const struct algo_properties_st *hash);
+
+int hash_memory(const struct algo_properties_st *hash,
+                const unsigned char *in,  unsigned long inlen, 
+                      unsigned char *out, unsigned long *outlen);
+int hash_memory_multi(const struct algo_properties_st *hash, unsigned char *out, unsigned long *outlen,
+                      const unsigned char *in, unsigned long inlen, ...);
+
+int hash_get_oid(const struct algo_properties_st *hash, oid_st* st);
+
diff --git a/crypto/userspace/libtomcrypt/headers/tomcrypt_macros.h b/crypto/userspace/libtomcrypt/headers/tomcrypt_macros.h
new file mode 100644
index 0000000..53bda9b
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/headers/tomcrypt_macros.h
@@ -0,0 +1,424 @@
+/* fix for MSVC ...evil! */
+#ifdef _MSC_VER
+   #define CONST64(n) n ## ui64
+   typedef unsigned __int64 ulong64;
+#else
+   #define CONST64(n) n ## ULL
+   typedef unsigned long long ulong64;
+#endif
+
+/* this is the "32-bit at least" data type 
+ * Re-define it to suit your platform but it must be at least 32-bits 
+ */
+#if defined(__x86_64__) || (defined(__sparc__) && defined(__arch64__))
+   typedef unsigned ulong32;
+#else
+   typedef unsigned long ulong32;
+#endif
+
+/* ---- HELPER MACROS ---- */
+#ifdef ENDIAN_NEUTRAL
+
+#define STORE32L(x, y)                                                                     \
+     { (y)[3] = (unsigned char)(((x)>>24)&255); (y)[2] = (unsigned char)(((x)>>16)&255);   \
+       (y)[1] = (unsigned char)(((x)>>8)&255); (y)[0] = (unsigned char)((x)&255); }
+
+#define LOAD32L(x, y)                            \
+     { x = ((unsigned long)((y)[3] & 255)<<24) | \
+           ((unsigned long)((y)[2] & 255)<<16) | \
+           ((unsigned long)((y)[1] & 255)<<8)  | \
+           ((unsigned long)((y)[0] & 255)); }
+
+#define STORE64L(x, y)                                                                     \
+     { (y)[7] = (unsigned char)(((x)>>56)&255); (y)[6] = (unsigned char)(((x)>>48)&255);   \
+       (y)[5] = (unsigned char)(((x)>>40)&255); (y)[4] = (unsigned char)(((x)>>32)&255);   \
+       (y)[3] = (unsigned char)(((x)>>24)&255); (y)[2] = (unsigned char)(((x)>>16)&255);   \
+       (y)[1] = (unsigned char)(((x)>>8)&255); (y)[0] = (unsigned char)((x)&255); }
+
+#define LOAD64L(x, y)                                                       \
+     { x = (((ulong64)((y)[7] & 255))<<56)|(((ulong64)((y)[6] & 255))<<48)| \
+           (((ulong64)((y)[5] & 255))<<40)|(((ulong64)((y)[4] & 255))<<32)| \
+           (((ulong64)((y)[3] & 255))<<24)|(((ulong64)((y)[2] & 255))<<16)| \
+           (((ulong64)((y)[1] & 255))<<8)|(((ulong64)((y)[0] & 255))); }
+
+#define STORE32H(x, y)                                                                     \
+     { (y)[0] = (unsigned char)(((x)>>24)&255); (y)[1] = (unsigned char)(((x)>>16)&255);   \
+       (y)[2] = (unsigned char)(((x)>>8)&255); (y)[3] = (unsigned char)((x)&255); }
+
+#define LOAD32H(x, y)                            \
+     { x = ((unsigned long)((y)[0] & 255)<<24) | \
+           ((unsigned long)((y)[1] & 255)<<16) | \
+           ((unsigned long)((y)[2] & 255)<<8)  | \
+           ((unsigned long)((y)[3] & 255)); }
+
+#define STORE64H(x, y)                                                                     \
+   { (y)[0] = (unsigned char)(((x)>>56)&255); (y)[1] = (unsigned char)(((x)>>48)&255);     \
+     (y)[2] = (unsigned char)(((x)>>40)&255); (y)[3] = (unsigned char)(((x)>>32)&255);     \
+     (y)[4] = (unsigned char)(((x)>>24)&255); (y)[5] = (unsigned char)(((x)>>16)&255);     \
+     (y)[6] = (unsigned char)(((x)>>8)&255); (y)[7] = (unsigned char)((x)&255); }
+
+#define LOAD64H(x, y)                                                      \
+   { x = (((ulong64)((y)[0] & 255))<<56)|(((ulong64)((y)[1] & 255))<<48) | \
+         (((ulong64)((y)[2] & 255))<<40)|(((ulong64)((y)[3] & 255))<<32) | \
+         (((ulong64)((y)[4] & 255))<<24)|(((ulong64)((y)[5] & 255))<<16) | \
+         (((ulong64)((y)[6] & 255))<<8)|(((ulong64)((y)[7] & 255))); }
+
+#endif /* ENDIAN_NEUTRAL */
+
+#ifdef ENDIAN_LITTLE
+
+#if !defined(LTC_NO_BSWAP) && (defined(INTEL_CC) || (defined(__GNUC__) && (defined(__DJGPP__) || defined(__CYGWIN__) || defined(__MINGW32__) || defined(__i386__) || defined(__x86_64__))))
+
+#define STORE32H(x, y)           \
+asm __volatile__ (               \
+   "bswapl %0     \n\t"          \
+   "movl   %0,(%1)\n\t"          \
+   "bswapl %0     \n\t"          \
+      ::"r"(x), "r"(y));
+
+#define LOAD32H(x, y)          \
+asm __volatile__ (             \
+   "movl (%1),%0\n\t"          \
+   "bswapl %0\n\t"             \
+   :"=r"(x): "r"(y));
+
+#else
+
+#define STORE32H(x, y)                                                                     \
+     { (y)[0] = (unsigned char)(((x)>>24)&255); (y)[1] = (unsigned char)(((x)>>16)&255);   \
+       (y)[2] = (unsigned char)(((x)>>8)&255); (y)[3] = (unsigned char)((x)&255); }
+
+#define LOAD32H(x, y)                            \
+     { x = ((unsigned long)((y)[0] & 255)<<24) | \
+           ((unsigned long)((y)[1] & 255)<<16) | \
+           ((unsigned long)((y)[2] & 255)<<8)  | \
+           ((unsigned long)((y)[3] & 255)); }
+
+#endif
+
+
+/* x86_64 processor */
+#if !defined(LTC_NO_BSWAP) && (defined(__GNUC__) && defined(__x86_64__))
+
+#define STORE64H(x, y)           \
+asm __volatile__ (               \
+   "bswapq %0     \n\t"          \
+   "movq   %0,(%1)\n\t"          \
+   "bswapq %0     \n\t"          \
+      ::"r"(x), "r"(y));
+
+#define LOAD64H(x, y)          \
+asm __volatile__ (             \
+   "movq (%1),%0\n\t"          \
+   "bswapq %0\n\t"             \
+   :"=r"(x): "r"(y));
+
+#else
+
+#define STORE64H(x, y)                                                                     \
+   { (y)[0] = (unsigned char)(((x)>>56)&255); (y)[1] = (unsigned char)(((x)>>48)&255);     \
+     (y)[2] = (unsigned char)(((x)>>40)&255); (y)[3] = (unsigned char)(((x)>>32)&255);     \
+     (y)[4] = (unsigned char)(((x)>>24)&255); (y)[5] = (unsigned char)(((x)>>16)&255);     \
+     (y)[6] = (unsigned char)(((x)>>8)&255); (y)[7] = (unsigned char)((x)&255); }
+
+#define LOAD64H(x, y)                                                      \
+   { x = (((ulong64)((y)[0] & 255))<<56)|(((ulong64)((y)[1] & 255))<<48) | \
+         (((ulong64)((y)[2] & 255))<<40)|(((ulong64)((y)[3] & 255))<<32) | \
+         (((ulong64)((y)[4] & 255))<<24)|(((ulong64)((y)[5] & 255))<<16) | \
+         (((ulong64)((y)[6] & 255))<<8)|(((ulong64)((y)[7] & 255))); }
+
+#endif
+
+#ifdef ENDIAN_32BITWORD 
+
+#define STORE32L(x, y)        \
+     { ulong32  __t = (x); XMEMCPY(y, &__t, 4); }
+
+#define LOAD32L(x, y)         \
+     XMEMCPY(&(x), y, 4);
+
+#define STORE64L(x, y)                                                                     \
+     { (y)[7] = (unsigned char)(((x)>>56)&255); (y)[6] = (unsigned char)(((x)>>48)&255);   \
+       (y)[5] = (unsigned char)(((x)>>40)&255); (y)[4] = (unsigned char)(((x)>>32)&255);   \
+       (y)[3] = (unsigned char)(((x)>>24)&255); (y)[2] = (unsigned char)(((x)>>16)&255);   \
+       (y)[1] = (unsigned char)(((x)>>8)&255); (y)[0] = (unsigned char)((x)&255); }
+
+#define LOAD64L(x, y)                                                       \
+     { x = (((ulong64)((y)[7] & 255))<<56)|(((ulong64)((y)[6] & 255))<<48)| \
+           (((ulong64)((y)[5] & 255))<<40)|(((ulong64)((y)[4] & 255))<<32)| \
+           (((ulong64)((y)[3] & 255))<<24)|(((ulong64)((y)[2] & 255))<<16)| \
+           (((ulong64)((y)[1] & 255))<<8)|(((ulong64)((y)[0] & 255))); }
+
+#else /* 64-bit words then  */
+
+#define STORE32L(x, y)        \
+     { ulong32 __t = (x); XMEMCPY(y, &__t, 4); }
+
+#define LOAD32L(x, y)         \
+     { XMEMCPY(&(x), y, 4); x &= 0xFFFFFFFF; }
+
+#define STORE64L(x, y)        \
+     { ulong64 __t = (x); XMEMCPY(y, &__t, 8); }
+
+#define LOAD64L(x, y)         \
+    { XMEMCPY(&(x), y, 8); }
+
+#endif /* ENDIAN_64BITWORD */
+
+#endif /* ENDIAN_LITTLE */
+
+#ifdef ENDIAN_BIG
+#define STORE32L(x, y)                                                                     \
+     { (y)[3] = (unsigned char)(((x)>>24)&255); (y)[2] = (unsigned char)(((x)>>16)&255);   \
+       (y)[1] = (unsigned char)(((x)>>8)&255); (y)[0] = (unsigned char)((x)&255); }
+
+#define LOAD32L(x, y)                            \
+     { x = ((unsigned long)((y)[3] & 255)<<24) | \
+           ((unsigned long)((y)[2] & 255)<<16) | \
+           ((unsigned long)((y)[1] & 255)<<8)  | \
+           ((unsigned long)((y)[0] & 255)); }
+
+#define STORE64L(x, y)                                                                     \
+   { (y)[7] = (unsigned char)(((x)>>56)&255); (y)[6] = (unsigned char)(((x)>>48)&255);     \
+     (y)[5] = (unsigned char)(((x)>>40)&255); (y)[4] = (unsigned char)(((x)>>32)&255);     \
+     (y)[3] = (unsigned char)(((x)>>24)&255); (y)[2] = (unsigned char)(((x)>>16)&255);     \
+     (y)[1] = (unsigned char)(((x)>>8)&255); (y)[0] = (unsigned char)((x)&255); }
+
+#define LOAD64L(x, y)                                                      \
+   { x = (((ulong64)((y)[7] & 255))<<56)|(((ulong64)((y)[6] & 255))<<48) | \
+         (((ulong64)((y)[5] & 255))<<40)|(((ulong64)((y)[4] & 255))<<32) | \
+         (((ulong64)((y)[3] & 255))<<24)|(((ulong64)((y)[2] & 255))<<16) | \
+         (((ulong64)((y)[1] & 255))<<8)|(((ulong64)((y)[0] & 255))); }
+
+#ifdef ENDIAN_32BITWORD 
+
+#define STORE32H(x, y)        \
+     { ulong32 __t = (x); XMEMCPY(y, &__t, 4); }
+
+#define LOAD32H(x, y)         \
+     XMEMCPY(&(x), y, 4);
+
+#define STORE64H(x, y)                                                                     \
+     { (y)[0] = (unsigned char)(((x)>>56)&255); (y)[1] = (unsigned char)(((x)>>48)&255);   \
+       (y)[2] = (unsigned char)(((x)>>40)&255); (y)[3] = (unsigned char)(((x)>>32)&255);   \
+       (y)[4] = (unsigned char)(((x)>>24)&255); (y)[5] = (unsigned char)(((x)>>16)&255);   \
+       (y)[6] = (unsigned char)(((x)>>8)&255);  (y)[7] = (unsigned char)((x)&255); }
+
+#define LOAD64H(x, y)                                                       \
+     { x = (((ulong64)((y)[0] & 255))<<56)|(((ulong64)((y)[1] & 255))<<48)| \
+           (((ulong64)((y)[2] & 255))<<40)|(((ulong64)((y)[3] & 255))<<32)| \
+           (((ulong64)((y)[4] & 255))<<24)|(((ulong64)((y)[5] & 255))<<16)| \
+           (((ulong64)((y)[6] & 255))<<8)| (((ulong64)((y)[7] & 255))); }
+
+#else /* 64-bit words then  */
+
+#define STORE32H(x, y)        \
+     { ulong32 __t = (x); XMEMCPY(y, &__t, 4); }
+
+#define LOAD32H(x, y)         \
+     { XMEMCPY(&(x), y, 4); x &= 0xFFFFFFFF; }
+
+#define STORE64H(x, y)        \
+     { ulong64 __t = (x); XMEMCPY(y, &__t, 8); }
+
+#define LOAD64H(x, y)         \
+    { XMEMCPY(&(x), y, 8); }
+
+#endif /* ENDIAN_64BITWORD */
+#endif /* ENDIAN_BIG */
+
+#define BSWAP(x)  ( ((x>>24)&0x000000FFUL) | ((x<<24)&0xFF000000UL)  | \
+                    ((x>>8)&0x0000FF00UL)  | ((x<<8)&0x00FF0000UL) )
+
+
+/* 32-bit Rotates */
+#if defined(_MSC_VER)
+
+/* instrinsic rotate */
+#include <stdlib.h>
+#pragma intrinsic(_lrotr,_lrotl)
+#define ROR(x,n) _lrotr(x,n)
+#define ROL(x,n) _lrotl(x,n)
+#define RORc(x,n) _lrotr(x,n)
+#define ROLc(x,n) _lrotl(x,n)
+
+#elif !defined(__STRICT_ANSI__) && defined(__GNUC__) && (defined(__i386__) || defined(__x86_64__)) && !defined(INTEL_CC) && !defined(LTC_NO_ASM)
+
+static inline unsigned ROL(unsigned word, int i)
+{
+   asm ("roll %%cl,%0"
+      :"=r" (word)
+      :"0" (word),"c" (i));
+   return word;
+}
+
+static inline unsigned ROR(unsigned word, int i)
+{
+   asm ("rorl %%cl,%0"
+      :"=r" (word)
+      :"0" (word),"c" (i));
+   return word;
+}
+
+#ifndef LTC_NO_ROLC
+
+static inline unsigned ROLc(unsigned word, const int i)
+{
+   asm ("roll %2,%0"
+      :"=r" (word)
+      :"0" (word),"I" (i));
+   return word;
+}
+
+static inline unsigned RORc(unsigned word, const int i)
+{
+   asm ("rorl %2,%0"
+      :"=r" (word)
+      :"0" (word),"I" (i));
+   return word;
+}
+
+#else
+
+#define ROLc ROL
+#define RORc ROR
+
+#endif
+
+#elif !defined(__STRICT_ANSI__) && defined(LTC_PPC32)
+
+static inline unsigned ROL(unsigned word, int i)
+{
+   asm ("rotlw %0,%0,%2"
+      :"=r" (word)
+      :"0" (word),"r" (i));
+   return word;
+}
+
+static inline unsigned ROR(unsigned word, int i)
+{
+   asm ("rotlw %0,%0,%2"
+      :"=r" (word)
+      :"0" (word),"r" (32-i));
+   return word;
+}
+
+#ifndef LTC_NO_ROLC
+
+static inline unsigned ROLc(unsigned word, const int i)
+{
+   asm ("rotlwi %0,%0,%2"
+      :"=r" (word)
+      :"0" (word),"I" (i));
+   return word;
+}
+
+static inline unsigned RORc(unsigned word, const int i)
+{
+   asm ("rotrwi %0,%0,%2"
+      :"=r" (word)
+      :"0" (word),"I" (i));
+   return word;
+}
+
+#else
+
+#define ROLc ROL
+#define RORc ROR
+
+#endif
+
+
+#else
+
+/* rotates the hard way */
+#define ROL(x, y) ( (((unsigned long)(x)<<(unsigned long)((y)&31)) | (((unsigned long)(x)&0xFFFFFFFFUL)>>(unsigned long)(32-((y)&31)))) & 0xFFFFFFFFUL)
+#define ROR(x, y) ( ((((unsigned long)(x)&0xFFFFFFFFUL)>>(unsigned long)((y)&31)) | ((unsigned long)(x)<<(unsigned long)(32-((y)&31)))) & 0xFFFFFFFFUL)
+#define ROLc(x, y) ( (((unsigned long)(x)<<(unsigned long)((y)&31)) | (((unsigned long)(x)&0xFFFFFFFFUL)>>(unsigned long)(32-((y)&31)))) & 0xFFFFFFFFUL)
+#define RORc(x, y) ( ((((unsigned long)(x)&0xFFFFFFFFUL)>>(unsigned long)((y)&31)) | ((unsigned long)(x)<<(unsigned long)(32-((y)&31)))) & 0xFFFFFFFFUL)
+
+#endif
+
+
+/* 64-bit Rotates */
+#if !defined(__STRICT_ANSI__) && defined(__GNUC__) && defined(__x86_64__) && !defined(LTC_NO_ASM)
+
+static inline unsigned long ROL64(unsigned long word, int i)
+{
+   asm("rolq %%cl,%0"
+      :"=r" (word)
+      :"0" (word),"c" (i));
+   return word;
+}
+
+static inline unsigned long ROR64(unsigned long word, int i)
+{
+   asm("rorq %%cl,%0"
+      :"=r" (word)
+      :"0" (word),"c" (i));
+   return word;
+}
+
+#ifndef LTC_NO_ROLC
+
+static inline unsigned long ROL64c(unsigned long word, const int i)
+{
+   asm("rolq %2,%0"
+      :"=r" (word)
+      :"0" (word),"J" (i));
+   return word;
+}
+
+static inline unsigned long ROR64c(unsigned long word, const int i)
+{
+   asm("rorq %2,%0"
+      :"=r" (word)
+      :"0" (word),"J" (i));
+   return word;
+}
+
+#else /* LTC_NO_ROLC */
+
+#define ROL64c ROL64
+#define ROR64c ROR64
+
+#endif
+
+#else /* Not x86_64  */
+
+#define ROL64(x, y) \
+    ( (((x)<<((ulong64)(y)&63)) | \
+      (((x)&CONST64(0xFFFFFFFFFFFFFFFF))>>((ulong64)64-((y)&63)))) & CONST64(0xFFFFFFFFFFFFFFFF))
+
+#define ROR64(x, y) \
+    ( ((((x)&CONST64(0xFFFFFFFFFFFFFFFF))>>((ulong64)(y)&CONST64(63))) | \
+      ((x)<<((ulong64)(64-((y)&CONST64(63)))))) & CONST64(0xFFFFFFFFFFFFFFFF))
+
+#define ROL64c(x, y) \
+    ( (((x)<<((ulong64)(y)&63)) | \
+      (((x)&CONST64(0xFFFFFFFFFFFFFFFF))>>((ulong64)64-((y)&63)))) & CONST64(0xFFFFFFFFFFFFFFFF))
+
+#define ROR64c(x, y) \
+    ( ((((x)&CONST64(0xFFFFFFFFFFFFFFFF))>>((ulong64)(y)&CONST64(63))) | \
+      ((x)<<((ulong64)(64-((y)&CONST64(63)))))) & CONST64(0xFFFFFFFFFFFFFFFF))
+
+#endif
+
+#ifndef MAX
+   #define MAX(x, y) ( ((x)>(y))?(x):(y) )
+#endif
+
+#ifndef MIN
+   #define MIN(x, y) ( ((x)<(y))?(x):(y) )
+#endif
+
+/* extract a byte portably */
+#ifdef _MSC_VER
+   #define byte(x, n) ((unsigned char)((x) >> (8 * (n))))
+#else
+   #define byte(x, n) (((x) >> (8 * (n))) & 255)
+#endif   
+
+/* $Source: /cvs/libtom/libtomcrypt/src/headers/tomcrypt_macros.h,v $ */
+/* $Revision: 1.15 $ */
+/* $Date: 2006/11/29 23:43:57 $ */
diff --git a/crypto/userspace/libtomcrypt/headers/tomcrypt_math.h b/crypto/userspace/libtomcrypt/headers/tomcrypt_math.h
new file mode 100644
index 0000000..6c0e6c5
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/headers/tomcrypt_math.h
@@ -0,0 +1,13 @@
+/** math functions **/
+
+#define LTC_MP_LT   -1
+#define LTC_MP_EQ    0
+#define LTC_MP_GT    1
+
+#define LTC_MP_NO    0
+#define LTC_MP_YES   1
+
+#include <tommath.h>
+
+typedef mp_int* mp_int_t;
+
diff --git a/crypto/userspace/libtomcrypt/headers/tomcrypt_misc.h b/crypto/userspace/libtomcrypt/headers/tomcrypt_misc.h
new file mode 100644
index 0000000..f5384ca
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/headers/tomcrypt_misc.h
@@ -0,0 +1,23 @@
+/* ---- LTC_BASE64 Routines ---- */
+#ifdef LTC_BASE64
+int base64_encode(const unsigned char *in,  unsigned long len, 
+                        unsigned char *out, unsigned long *outlen);
+
+int base64_decode(const unsigned char *in,  unsigned long len, 
+                        unsigned char *out, unsigned long *outlen);
+#endif
+
+/* ---- MEM routines ---- */
+void zeromem(void *dst, size_t len);
+void burn_stack(unsigned long len);
+
+const char *error_to_string(int err);
+
+extern const char *crypt_build_settings;
+
+/* ---- HMM ---- */
+int crypt_fsa(void *mp, ...);
+
+/* $Source: /cvs/libtom/libtomcrypt/src/headers/tomcrypt_misc.h,v $ */
+/* $Revision: 1.5 $ */
+/* $Date: 2007/05/12 14:32:35 $ */
diff --git a/crypto/userspace/libtomcrypt/headers/tomcrypt_pk.h b/crypto/userspace/libtomcrypt/headers/tomcrypt_pk.h
new file mode 100644
index 0000000..145165e
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/headers/tomcrypt_pk.h
@@ -0,0 +1,359 @@
+/* ---- NUMBER THEORY ---- */
+
+struct algo_properties_st;
+
+enum {
+   PK_PUBLIC=0,
+   PK_PRIVATE=1
+};
+
+enum {
+   PKA_RSA,
+   PKA_DSA
+};
+
+typedef struct Oid {
+    unsigned long OID[16];
+    /** Length of DER encoding */
+    unsigned long OIDlen;
+} oid_st;
+
+int pk_get_oid(int pk, oid_st *st);
+int rand_prime(mp_int *N, long len);
+
+/* ---- RSA ---- */
+#ifdef LTC_MRSA
+
+/* Min and Max RSA key sizes (in bits) */
+#define MIN_RSA_SIZE 1024
+#define MAX_RSA_SIZE 4096
+
+/** RSA LTC_PKCS style key */
+typedef struct Rsa_key {
+    /** Type of key, PK_PRIVATE or PK_PUBLIC */
+    int type;
+    /** The public exponent */
+    mp_int e; 
+    /** The private exponent */
+    mp_int d; 
+    /** The modulus */
+    mp_int N; 
+    /** The p factor of N */
+    mp_int p; 
+    /** The q factor of N */
+    mp_int q; 
+    /** The 1/q mod p CRT param */
+    mp_int qP; 
+    /** The d mod (p - 1) CRT param */
+    mp_int dP; 
+    /** The d mod (q - 1) CRT param */
+    mp_int dQ;
+} rsa_key;
+
+int rsa_make_key(int size, long e, rsa_key *key);
+
+int rsa_exptmod(const unsigned char *in,   unsigned long inlen,
+                      unsigned char *out,  unsigned long *outlen, int which,
+                      rsa_key *key);
+
+void rsa_free(rsa_key *key);
+
+/* These use LTC_PKCS #1 v2.0 padding */
+#define rsa_encrypt_key(_in, _inlen, _out, _outlen, _lparam, _lparamlen, _hash, _key) \
+  rsa_encrypt_key_ex(_in, _inlen, _out, _outlen, _lparam, _lparamlen, _hash, LTC_LTC_PKCS_1_OAEP, _key)
+
+#define rsa_decrypt_key(_in, _inlen, _out, _outlen, _lparam, _lparamlen, _hash, _stat, _key) \
+  rsa_decrypt_key_ex(_in, _inlen, _out, _outlen, _lparam, _lparamlen, _hash, LTC_LTC_PKCS_1_OAEP, _stat, _key)
+
+#define rsa_sign_hash(_in, _inlen, _out, _outlen, _hash, _saltlen, _key) \
+  rsa_sign_hash_ex(_in, _inlen, _out, _outlen, LTC_LTC_PKCS_1_PSS, _hash, _saltlen, _key)
+
+#define rsa_verify_hash(_sig, _siglen, _hash, _hashlen, _hash_algo, _saltlen, _stat, _key) \
+  rsa_verify_hash_ex(_sig, _siglen, _hash, _hashlen, LTC_LTC_PKCS_1_PSS, _hash_algo, _saltlen, _stat, _key)
+
+/* These can be switched between LTC_PKCS #1 v2.x and LTC_PKCS #1 v1.5 paddings */
+int rsa_encrypt_key_ex(const unsigned char *in,     unsigned long inlen,
+                             unsigned char *out,    unsigned long *outlen,
+                       const unsigned char *lparam, unsigned long lparamlen,
+                       const struct algo_properties_st *hash, int padding, rsa_key *key);
+
+int rsa_decrypt_key_ex(const unsigned char *in,       unsigned long  inlen,
+                             unsigned char *out,      unsigned long *outlen,
+                       const unsigned char *lparam,   unsigned long  lparamlen,
+                       const struct algo_properties_st *hash, int padding,
+                             int           *stat,     rsa_key       *key);
+
+int rsa_sign_hash_ex(const unsigned char *in,       unsigned long  inlen,
+                           unsigned char *out,      unsigned long *outlen,
+                           int            padding,
+                     const struct algo_properties_st *hash, unsigned long saltlen,
+                           rsa_key *key);
+
+int rsa_verify_hash_ex(const unsigned char *sig,      unsigned long siglen,
+                       const unsigned char *hash,     unsigned long hashlen,
+                             int            padding,
+                       const struct algo_properties_st *hash_algo, unsigned long saltlen,
+                             int           *stat,     rsa_key      *key);
+
+/* LTC_PKCS #1 import/export */
+int rsa_export(unsigned char *out, unsigned long *outlen, int type, rsa_key *key);
+int rsa_import(const unsigned char *in, unsigned long inlen, rsa_key *key);
+                        
+#endif
+
+
+#ifdef LTC_MDSA
+
+/* Max diff between group and modulus size in bytes */
+#define LTC_MDSA_DELTA     512
+
+/* Max DSA group size in bytes (default allows 4k-bit groups) */
+#define LTC_MDSA_MAX_GROUP 512
+
+/** DSA key structure */
+typedef struct {
+   /** The key type, PK_PRIVATE or PK_PUBLIC */
+   int type; 
+
+   /** The order of the sub-group used in octets */
+   int qord;
+
+   /** The generator  */
+   mp_int g;
+
+   /** The prime used to generate the sub-group */
+   mp_int q;
+
+   /** The large prime that generats the field the contains the sub-group */
+   mp_int p;
+
+   /** The private key */
+   mp_int x;
+
+   /** The public key */
+   mp_int y;
+} dsa_key;
+
+int dsa_make_key(int group_size, int modulus_size, dsa_key *key);
+void dsa_free(dsa_key *key);
+
+int dsa_sign_hash_raw(const unsigned char *in,  unsigned long inlen,
+                                   mp_int_t r,   mp_int_t s,
+                               dsa_key *key);
+
+int dsa_sign_hash(const unsigned char *in,  unsigned long inlen,
+                        unsigned char *out, unsigned long *outlen,
+                        dsa_key *key);
+
+int dsa_verify_hash_raw(         mp_int_t r,          mp_int_t s,
+                    const unsigned char *hash, unsigned long hashlen, 
+                                    int *stat,      dsa_key *key);
+
+int dsa_verify_hash(const unsigned char *sig,  unsigned long siglen,
+                    const unsigned char *hash, unsigned long hashlen, 
+                          int           *stat, dsa_key       *key);
+
+int dsa_encrypt_key(const unsigned char *in,   unsigned long inlen,
+                          unsigned char *out,  unsigned long *outlen, 
+                          int hash, dsa_key *key);
+                      
+int dsa_decrypt_key(const unsigned char *in,  unsigned long  inlen,
+                          unsigned char *out, unsigned long *outlen, 
+                          dsa_key *key);
+                          
+int dsa_import(const unsigned char *in, unsigned long inlen, dsa_key *key);
+int dsa_export(unsigned char *out, unsigned long *outlen, int type, dsa_key *key);
+int dsa_verify_key(dsa_key *key, int *stat);
+
+int dsa_shared_secret(void          *private_key, mp_int_t base,
+                      dsa_key       *public_key,
+                      unsigned char *out,         unsigned long *outlen);
+#endif
+
+#ifdef LTC_DER
+/* DER handling */
+
+enum {
+ LTC_ASN1_EOL,
+ LTC_ASN1_BOOLEAN,
+ LTC_ASN1_INTEGER,
+ LTC_ASN1_SHORT_INTEGER,
+ LTC_ASN1_BIT_STRING,
+ LTC_ASN1_OCTET_STRING,
+ LTC_ASN1_NULL,
+ LTC_ASN1_OBJECT_IDENTIFIER,
+ LTC_ASN1_IA5_STRING,
+ LTC_ASN1_PRINTABLE_STRING,
+ LTC_ASN1_UTF8_STRING,
+ LTC_ASN1_UTCTIME,
+ LTC_ASN1_CHOICE,
+ LTC_ASN1_SEQUENCE,
+ LTC_ASN1_SET,
+ LTC_ASN1_SETOF
+};
+
+/** A LTC ASN.1 list type */
+typedef struct ltc_asn1_list_ {
+   /** The LTC ASN.1 enumerated type identifier */
+   int           type;
+   /** The data to encode or place for decoding */
+   void         *data;
+   /** The size of the input or resulting output */
+   unsigned long size;
+   /** The used flag, this is used by the CHOICE ASN.1 type to indicate which choice was made */
+   int           used;
+   /** prev/next entry in the list */
+   struct ltc_asn1_list_ *prev, *next, *child, *parent;
+} ltc_asn1_list;
+
+#define LTC_SET_ASN1(list, index, Type, Data, Size)  \
+   do {                                              \
+      int LTC_MACRO_temp            = (index);       \
+      ltc_asn1_list *LTC_MACRO_list = (list);        \
+      LTC_MACRO_list[LTC_MACRO_temp].type = (Type);  \
+      LTC_MACRO_list[LTC_MACRO_temp].data = (void*)(Data);  \
+      LTC_MACRO_list[LTC_MACRO_temp].size = (Size);  \
+      LTC_MACRO_list[LTC_MACRO_temp].used = 0;       \
+   } while (0);
+
+/* SEQUENCE */
+int der_encode_sequence_ex(ltc_asn1_list *list, unsigned long inlen,
+                           unsigned char *out,  unsigned long *outlen, int type_of);
+                          
+#define der_encode_sequence(list, inlen, out, outlen) der_encode_sequence_ex(list, inlen, out, outlen, LTC_ASN1_SEQUENCE)                        
+
+int der_decode_sequence_ex(const unsigned char *in, unsigned long  inlen,
+                           ltc_asn1_list *list,     unsigned long  outlen, int ordered);
+
+#define der_decode_sequence(in, inlen, list, outlen) der_decode_sequence_ex(in, inlen, list, outlen, 1)
+
+int der_length_sequence(ltc_asn1_list *list, unsigned long inlen,
+                        unsigned long *outlen);
+
+/* SUBJECT PUBLIC KEY INFO */
+int der_encode_subject_public_key_info(unsigned char *out, unsigned long *outlen, 
+        unsigned int algorithm, void* public_key, unsigned long public_key_len, 
+        unsigned long parameters_type, void* parameters, unsigned long parameters_len);
+
+int der_decode_subject_public_key_info(const unsigned char *in, unsigned long inlen,
+        unsigned int algorithm, void* public_key, unsigned long* public_key_len,
+        unsigned long parameters_type, ltc_asn1_list* parameters, unsigned long parameters_len);
+
+/* SET */
+#define der_decode_set(in, inlen, list, outlen) der_decode_sequence_ex(in, inlen, list, outlen, 0)
+#define der_length_set der_length_sequence
+int der_encode_set(ltc_asn1_list *list, unsigned long inlen,
+                   unsigned char *out,  unsigned long *outlen);
+
+int der_encode_setof(ltc_asn1_list *list, unsigned long inlen,
+                     unsigned char *out,  unsigned long *outlen);
+                        
+/* VA list handy helpers with triplets of <type, size, data> */
+int der_encode_sequence_multi(unsigned char *out, unsigned long *outlen, ...);
+int der_decode_sequence_multi(const unsigned char *in, unsigned long inlen, ...);
+
+/* FLEXI DECODER handle unknown list decoder */
+int  der_decode_sequence_flexi(const unsigned char *in, unsigned long *inlen, ltc_asn1_list **out);
+void der_free_sequence_flexi(ltc_asn1_list *list);
+void der_sequence_free(ltc_asn1_list *in);
+
+/* BOOLEAN */
+int der_length_boolean(unsigned long *outlen);
+int der_encode_boolean(int in, 
+                       unsigned char *out, unsigned long *outlen);
+int der_decode_boolean(const unsigned char *in, unsigned long inlen,
+                                       int *out);		       
+/* INTEGER */
+int der_encode_integer(mp_int_t num, unsigned char *out, unsigned long *outlen);
+int der_decode_integer(const unsigned char *in, unsigned long inlen, mp_int_t num);
+int der_length_integer(mp_int_t num, unsigned long *len);
+
+/* INTEGER -- handy for 0..2^32-1 values */
+int der_decode_short_integer(const unsigned char *in, unsigned long inlen, unsigned long *num);
+int der_encode_short_integer(unsigned long num, unsigned char *out, unsigned long *outlen);
+int der_length_short_integer(unsigned long num, unsigned long *outlen);
+
+/* BIT STRING */
+int der_encode_bit_string(const unsigned char *in, unsigned long inlen,
+                                unsigned char *out, unsigned long *outlen);
+int der_decode_bit_string(const unsigned char *in, unsigned long inlen,
+                                unsigned char *out, unsigned long *outlen);
+int der_length_bit_string(unsigned long nbits, unsigned long *outlen);
+
+/* OCTET STRING */
+int der_encode_octet_string(const unsigned char *in, unsigned long inlen,
+                                  unsigned char *out, unsigned long *outlen);
+int der_decode_octet_string(const unsigned char *in, unsigned long inlen,
+                                  unsigned char *out, unsigned long *outlen);
+int der_length_octet_string(unsigned long noctets, unsigned long *outlen);
+
+/* OBJECT IDENTIFIER */
+int der_encode_object_identifier(unsigned long *words, unsigned long  nwords,
+                                 unsigned char *out,   unsigned long *outlen);
+int der_decode_object_identifier(const unsigned char *in,    unsigned long  inlen,
+                                       unsigned long *words, unsigned long *outlen);
+int der_length_object_identifier(unsigned long *words, unsigned long nwords, unsigned long *outlen);
+unsigned long der_object_identifier_bits(unsigned long x);
+
+/* IA5 STRING */
+int der_encode_ia5_string(const unsigned char *in, unsigned long inlen,
+                                unsigned char *out, unsigned long *outlen);
+int der_decode_ia5_string(const unsigned char *in, unsigned long inlen,
+                                unsigned char *out, unsigned long *outlen);
+int der_length_ia5_string(const unsigned char *octets, unsigned long noctets, unsigned long *outlen);
+
+int der_ia5_char_encode(int c);
+int der_ia5_value_decode(int v);
+
+/* Printable STRING */
+int der_encode_printable_string(const unsigned char *in, unsigned long inlen,
+                                unsigned char *out, unsigned long *outlen);
+int der_decode_printable_string(const unsigned char *in, unsigned long inlen,
+                                unsigned char *out, unsigned long *outlen);
+int der_length_printable_string(const unsigned char *octets, unsigned long noctets, unsigned long *outlen);
+
+int der_printable_char_encode(int c);
+int der_printable_value_decode(int v);
+
+/* UTF-8 */
+
+int der_encode_utf8_string(const wchar_t *in,  unsigned long inlen,
+                           unsigned char *out, unsigned long *outlen);
+
+int der_decode_utf8_string(const unsigned char *in,  unsigned long inlen,
+                                       wchar_t *out, unsigned long *outlen);
+unsigned long der_utf8_charsize(const wchar_t c);
+int der_length_utf8_string(const wchar_t *in, unsigned long noctets, unsigned long *outlen);
+
+
+/* CHOICE */
+int der_decode_choice(const unsigned char *in,   unsigned long *inlen,
+                            ltc_asn1_list *list, unsigned long  outlen);
+
+/* UTCTime */
+typedef struct {
+   unsigned YY, /* year */
+            MM, /* month */
+            DD, /* day */
+            hh, /* hour */
+            mm, /* minute */
+            ss, /* second */
+            off_dir, /* timezone offset direction 0 == +, 1 == - */
+            off_hh, /* timezone offset hours */
+            off_mm; /* timezone offset minutes */
+} ltc_utctime;
+
+int der_encode_utctime(ltc_utctime *utctime, 
+                       unsigned char *out,   unsigned long *outlen);
+
+int der_decode_utctime(const unsigned char *in, unsigned long *inlen,
+                             ltc_utctime   *out);
+
+int der_length_utctime(ltc_utctime *utctime, unsigned long *outlen);
+
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/headers/tomcrypt_pk.h,v $ */
+/* $Revision: 1.81 $ */
+/* $Date: 2007/05/12 14:32:35 $ */
diff --git a/crypto/userspace/libtomcrypt/headers/tomcrypt_pkcs.h b/crypto/userspace/libtomcrypt/headers/tomcrypt_pkcs.h
new file mode 100644
index 0000000..be0d7f6
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/headers/tomcrypt_pkcs.h
@@ -0,0 +1,67 @@
+/* LTC_PKCS Header Info */
+
+/* ===> LTC_PKCS #1 -- RSA Cryptography <=== */
+#ifdef LTC_PKCS_1
+
+struct algo_properties_st;
+
+enum ltc_pkcs_1_v1_5_blocks
+{
+  LTC_LTC_PKCS_1_EMSA   = 1,        /* Block type 1 (LTC_PKCS #1 v1.5 signature padding) */
+  LTC_LTC_PKCS_1_EME    = 2         /* Block type 2 (LTC_PKCS #1 v1.5 encryption padding) */
+};
+
+enum ltc_pkcs_1_paddings
+{
+  LTC_LTC_PKCS_1_V1_5   = 1,        /* LTC_PKCS #1 v1.5 padding (\sa ltc_pkcs_1_v1_5_blocks) */
+  LTC_LTC_PKCS_1_OAEP   = 2,        /* LTC_PKCS #1 v2.0 encryption padding */
+  LTC_LTC_PKCS_1_PSS    = 3         /* LTC_PKCS #1 v2.1 signature padding */
+};
+
+int pkcs_1_mgf1(const struct algo_properties_st *hash,
+                const unsigned char *seed, unsigned long seedlen,
+                      unsigned char *mask, unsigned long masklen);
+
+int pkcs_1_i2osp(void *n, unsigned long modulus_len, unsigned char *out);
+int pkcs_1_os2ip(void *n, unsigned char *in, unsigned long inlen);
+
+/* *** v1.5 padding */
+int pkcs_1_v1_5_encode(const unsigned char *msg, 
+                             unsigned long  msglen,
+                             int            block_type,
+                             unsigned long  modulus_bitlen,
+                             unsigned char *out, 
+                             unsigned long *outlen);
+
+int pkcs_1_v1_5_decode(const unsigned char *msg, 
+                             unsigned long  msglen,
+                                       int  block_type,
+                             unsigned long  modulus_bitlen,
+                             unsigned char *out, 
+                             unsigned long *outlen,
+                                       int *is_valid);
+
+/* *** v2.1 padding */
+int pkcs_1_oaep_encode(const unsigned char *msg,    unsigned long msglen,
+                       const unsigned char *lparam, unsigned long lparamlen,
+                             unsigned long modulus_bitlen, const struct algo_properties_st *hash,
+                             unsigned char *out,    unsigned long *outlen);
+
+int pkcs_1_oaep_decode(const unsigned char *msg,    unsigned long msglen,
+                       const unsigned char *lparam, unsigned long lparamlen,
+                             unsigned long modulus_bitlen, const struct algo_properties_st *hash,
+                             unsigned char *out,    unsigned long *outlen,
+                             int           *res);
+
+int pkcs_1_pss_encode(const unsigned char *msghash, unsigned long msghashlen,
+                            unsigned long saltlen, const struct algo_properties_st *hash,
+                            unsigned long modulus_bitlen,
+                            unsigned char *out,     unsigned long *outlen);
+
+int pkcs_1_pss_decode(const unsigned char *msghash, unsigned long msghashlen,
+                      const unsigned char *sig,     unsigned long siglen,
+                            unsigned long saltlen, const struct algo_properties_st *hash,
+                            unsigned long modulus_bitlen, int    *res);
+
+#endif /* LTC_PKCS_1 */
+
-- 
1.7.2.1

