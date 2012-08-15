Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab2HOSvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 14:51:32 -0400
Received: from mga07.intel.com ([143.182.124.22]:64880 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751288Ab2HOSvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 14:51:31 -0400
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: zohar@linux.vnet.ibm.com, jmorris@namei.org, rusty@rustcorp.com.au,
        dhowells@redhat.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC v2 7/7] modsig: build rules and scripts to generate keys and sign modules
Date: Wed, 15 Aug 2012 21:43:12 +0300
Message-Id: <2114492cd221edc44622e528d66feeed342d2d34.1345055639.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1345055638.git.dmitry.kasatkin@intel.com>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
In-Reply-To: <cover.1345055638.git.dmitry.kasatkin@intel.com>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds build rules and scripts to generate keys and sign modules.

Two scripts has been added. genkey.sh is used to generate private and
public keys. ksign.sh is used to sign kernel modules. Both scripts
use only standard utilites from coreutils and additionally requires
openssl tool for RSA keys creation and signing.

The patch modifies 'modules_install' target and adds two new targets to
the main kernel Makefile.

1. signed_modules_install
This target creates an ephemeral key pair, signs the kernel modules with
the private key, destroys the private key, and embeds the public key in
the kernel. (Thanks to Dave Hansen for the target name.)

2. modules_install
When CONFIG_INTEGRITY_MODULES is anabled, this target uses an existing
private key to sign kernel modules.

3. genkey
This target is automatically called for signed_modules_install to generate
ephemeral key pair, or can be called manually to generate new private and
public keypair for using with modules_install.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
---
 Makefile                 |   38 +++++++++++++
 scripts/Makefile.modinst |    1 +
 scripts/genkey.sh        |  135 ++++++++++++++++++++++++++++++++++++++++++++++
 scripts/ksign.sh         |   64 ++++++++++++++++++++++
 4 files changed, 238 insertions(+)
 create mode 100755 scripts/genkey.sh
 create mode 100755 scripts/ksign.sh

diff --git a/Makefile b/Makefile
index d845c2a..fe693b3 100644
--- a/Makefile
+++ b/Makefile
@@ -939,10 +939,31 @@ modules.builtin: $(vmlinux-dirs:%=%/modules.builtin)
 PHONY += modules_prepare
 modules_prepare: prepare scripts
 
+privkey = privkey.pem
+pubkeybin = pubkey.bin
+
+ifeq ($(CONFIG_INTEGRITY_MODULES),y)
+# command to sign modules
+export quiet_cmd_sign_module = SIGN	$$(@)
+export cmd_sign_module = $(srctree)/scripts/ksign.sh $$(2)
+endif
+
 # Target to install modules
 PHONY += modules_install
+ifeq ($(CONFIG_INTEGRITY_MODULES),y)
+modules_install: _checkkey_
+endif
 modules_install: _modinst_ _modinst_post
 
+PHONY += _checkkey_
+_checkkey_:
+	@if [ ! -f $(privkey) -o ! -f $(pubkeybin) ]; then \
+		echo "Keys are missing. Run 'make genkey' first."; exit 1; \
+	fi; \
+	if [ $(pubkeybin) -nt vmlinux ]; then \
+		echo "$(pubkeybin) is newer than vmlinux. Run 'make bzImage' again."; exit 1; \
+	fi
+
 PHONY += _modinst_
 _modinst_:
 	@rm -rf $(MODLIB)/kernel
@@ -957,6 +978,23 @@ _modinst_:
 	@cp -f $(objtree)/modules.builtin $(MODLIB)/
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modinst
 
+# Target to install signed modules using new ephemeral key
+# It will force to generate new key pair and re-generate bzImage
+# Private key is removed after installing modules 
+PHONY += signed_modules_install
+signed_modules_install: genkey _modinst_ _modinst_post _rmprivkey_ bzImage
+
+PHONY += genkey
+genkey: $(privkey) $(pubkeybin)
+
+$(privkey): FORCE
+	@if [ -f $(privkey) ]; then echo "$(privkey) already exists. Remove it first."; exit 1; fi
+	@$(srctree)/scripts/genkey.sh
+
+PHONY += _rmprivkey_
+_rmprivkey_:
+	@rm $(privkey)
+
 # This depmod is only for convenience to give the initial
 # boot a modules.dep even before / is mounted read-write.  However the
 # boot script depmod is the master version.
diff --git a/scripts/Makefile.modinst b/scripts/Makefile.modinst
index efa5d94..b0a2e5e 100644
--- a/scripts/Makefile.modinst
+++ b/scripts/Makefile.modinst
@@ -27,6 +27,7 @@ modinst_dir = $(if $(KBUILD_EXTMOD),$(ext-mod-dir),kernel/$(@D))
 
 $(modules):
 	$(call cmd,modules_install,$(MODLIB)/$(modinst_dir))
+	$(call cmd,sign_module,$(MODLIB)/$(modinst_dir)/$(notdir $@))
 
 
 # Declare the contents of the .PHONY variable as phony.  We keep that
diff --git a/scripts/genkey.sh b/scripts/genkey.sh
new file mode 100755
index 0000000..9a4be9c
--- /dev/null
+++ b/scripts/genkey.sh
@@ -0,0 +1,135 @@
+#!/bin/bash
+
+set -e
+
+function error_exit() {
+	PROGNAME=$(basename $0)
+	echo "${PROGNAME}: ${1:-"Unknown Error"}" 1>&2
+	exit 1
+}
+
+trap "error_exit" ERR
+
+privkey=privkey.pem
+pubkey=pubkey.der
+pubkeybin=pubkey.bin
+
+if [ -f $privkey ]; then echo "$privkey already exists. Remove it first."; exit 1; fi
+
+rm -f $pubkeybin $pubkey
+
+hex2bin() {
+	src=$1
+	file=$2
+	while test -n "$src"; do
+		byte=${src:0:2}
+		src=${src:2}
+		printf "%b" \\x$byte >>$file;
+	done
+}
+
+hex2dec()
+{
+	printf "%d" 0x$1
+}
+
+dec2hex()
+{
+	printf "%0$2x" $1
+}
+
+der_get_length()
+{
+	local hex="$1"
+	local n=0
+	local l
+	#echo $hex
+	l=`hex2dec ${hex:2:2}`
+	if [ "$l" -ge 128 ]; then
+		n=$(( ($l - 128) * 2 ))
+		l=`hex2dec ${hex:4:$n}`
+	fi
+	eval $2=$(( 4 + $n ))
+	eval $3=$(( $l * 2 ))
+	eval $4=$l
+}
+
+count_bits()
+{
+	local bytes=$1
+	local msb=$2
+	bits=$(( ($bytes - 1) * 8 ))
+	local dec=`hex2dec $msb`
+	#echo "MSB: $msb $dec"
+	for (( ; $dec != 0 ; dec=($dec >> 1) )) ; do
+		bits=$(( $bits + 1 ))
+	done
+	eval $3=`dec2hex $bits 4`
+}
+# function to parse openssl public key in DER format
+der_parse()
+{
+	local hex="$1"
+	local tag
+	local pos=0
+	local len=0
+	local next=0
+	while test -n "$hex"; do
+		tag=${hex:0:2}
+		der_get_length "$hex" pos len bytelen
+		#echo "$tag: $pos $len $bytelen"
+		case $tag in
+			30|03)
+				# sequence of elements
+				der_parse ${hex:$pos:$len}
+				;;
+			02)
+				# integer elements: modulus and exponent
+				if [ ${hex:$pos:2} = "00" ]; then
+					pos=$(( $pos + 2 ))
+					len=$(( $len - 2 ))
+					bytelen=$(( $bytelen - 1 ))
+				fi
+				#echo "value: ${hex:$pos:$len}"
+				count_bits $bytelen ${hex:$pos:2} bitlen
+				hex2bin $bitlen $pubkeybin
+				hex2bin ${hex:$pos:$len} $pubkeybin
+				;;
+			06|05)
+				# skip OID and NULL
+				#echo "skip, tag: $tag:$pos:$len"
+				;;
+			00)
+				# skip octet
+				pos=2
+				len=0
+				;;
+			*)
+				echo "Must not happen... May be DER output format has changed"
+				echo "tag: $tag:$pos:$len"
+				#echo ${hex:$pos:$len}
+				exit 1
+				;;
+		esac
+		next=$(( $pos + $len ))
+		hex=${hex:$next}
+	done
+}
+
+# pkh->version = 1;
+# pkh->timestamp = 0;	/* PEM has no timestamp */
+# pkh->algo = PUBKEY_ALGO_RSA;
+# pkh->nmpi = 2;
+pkh="01000000000002"
+hex2bin $pkh $pubkeybin
+
+openssl genrsa -out $privkey 2048
+openssl rsa -in $privkey -pubout -outform der -out $pubkey
+
+size=`stat --printf %s $pubkey`
+key=`od -v -t x1 --width=$size pubkey.der | cut -c 9- | tr -d " "`
+
+der_parse $key
+
+rm -f $pubkey
+
diff --git a/scripts/ksign.sh b/scripts/ksign.sh
new file mode 100755
index 0000000..c3b4d4b
--- /dev/null
+++ b/scripts/ksign.sh
@@ -0,0 +1,64 @@
+#!/bin/bash
+
+module=$1
+sigfile=$module.sig
+sigout=$module.sigout
+sigdata=$module.sigdata
+sighash=$module.sighash
+
+pubkey=pubkey.bin
+
+rm -f $sigfile $sighash $sigdata $sigout
+
+hex2bin() {
+	read src
+	while test -n "$src"; do
+		byte=${src:0:2}
+		src=${src:2}
+		printf "%b" \\x$byte >>$1;
+	done
+}
+
+dec2hex()
+{
+	printf "%0$2x" $1
+}
+
+# version 1
+printf "%b" \\x1 >>$sigfile
+# timestamp - big endian
+stamp=`date +%s`
+dec2hex $stamp 8 | hex2bin $sigfile
+# rsa, sha1
+printf "%b%b" \\x0 \\x0 >>$sigfile
+#key id
+sha1sum pubkey.bin | cut -b 25-40 | hex2bin $sigfile
+# number of MPI
+printf "%b" \\x1 >>$sigfile
+
+# construct data for signature hash
+sha1sum $module | cut -b 1-40 | hex2bin $sigdata
+# add header
+cat $sigfile >> $sigdata
+
+# calculate hash to sign
+sha1sum $sigdata | cut -b 1-40 | hex2bin $sighash
+
+# sign final hash
+openssl rsautl -in $sighash -out $sigout -inkey privkey.pem -pkcs -sign
+
+# add MPI length - in big endian
+dec2hex $(( $(stat --printf %s $sigout) * 8 )) 4 | hex2bin $sigfile
+# add signature
+cat $sigout >> $sigfile
+
+# add kernel parameters
+# add signature length - big endian
+dec2hex $(stat --printf %s $sigfile) 4 | hex2bin $sigfile
+echo -n "This Is A Crypto Signed Module" >>$sigfile
+
+# add signature to a module
+cat $sigfile >> $module
+
+rm -f $sighash $sigdata $sigout $sigfile
+
-- 
1.7.9.5

