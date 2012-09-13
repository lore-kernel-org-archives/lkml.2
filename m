Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216Ab2IMXuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 19:50:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759209Ab2IMXtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 19:49:51 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 11/16] X.509: Implement simple static OID registry
To: herbert@gondor.hengli.com.au, rusty@rustcorp.com.au
Cc: linux-crypto@vger.kernel.org, zohar@us.ibm.com, dmitry.kasatkin@intel.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 14 Sep 2012 00:49:39 +0100
Message-ID: <20120913234939.3575.90622.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120913234802.3575.77103.stgit@warthog.procyon.org.uk>
References: <20120913234802.3575.77103.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement a simple static OID registry that allows the mapping of an encoded
OID to an enum value for ease of use.

The OID registry index enum appears in the:

	linux/oid_registry.h

header file.  A script generates the registry from lines in the header file
that look like:

	<sp*>OID_foo,<sp*>/*<sp*>1.2.3.4<sp*>*/

The actual OID is taken to be represented by the numbers with interpolated
dots in the comment.

All other lines in the header are ignored.

The registry is queries by calling:

	OID look_up_oid(const void *data, size_t datasize);

This returns a number from the registry enum representing the OID if found or
OID__NR if not.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/oid_registry.h |   90 ++++++++++++++++++
 lib/.gitignore               |    2 
 lib/Kconfig                  |    5 +
 lib/Makefile                 |   16 +++
 lib/build_OID_registry       |  209 ++++++++++++++++++++++++++++++++++++++++++
 lib/oid_registry.c           |   89 ++++++++++++++++++
 6 files changed, 410 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/oid_registry.h
 create mode 100755 lib/build_OID_registry
 create mode 100644 lib/oid_registry.c


diff --git a/include/linux/oid_registry.h b/include/linux/oid_registry.h
new file mode 100644
index 0000000..5928546
--- /dev/null
+++ b/include/linux/oid_registry.h
@@ -0,0 +1,90 @@
+/* ASN.1 Object identifier (OID) registry
+ *
+ * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _LINUX_OID_REGISTRY_H
+#define _LINUX_OID_REGISTRY_H
+
+#include <linux/types.h>
+
+/*
+ * OIDs are turned into these values if possible, or OID__NR if not held here.
+ *
+ * NOTE!  Do not mess with the format of each line as this is read by
+ *	  build_OID_registry.pl to generate the data for look_up_OID().
+ */
+enum OID {
+	OID_id_dsa_with_sha1,		/* 1.2.840.10030.4.3 */
+	OID_id_dsa,			/* 1.2.840.10040.4.1 */
+	OID_id_ecdsa_with_sha1,		/* 1.2.840.10045.4.1 */
+	OID_id_ecPublicKey,		/* 1.2.840.10045.2.1 */
+
+	/* PKCS#1 {iso(1) member-body(2) us(840) rsadsi(113549) pkcs(1) pkcs-1(1)} */
+	OID_rsaEncryption,		/* 1.2.840.113549.1.1.1 */
+	OID_md2WithRSAEncryption,	/* 1.2.840.113549.1.1.2 */
+	OID_md3WithRSAEncryption,	/* 1.2.840.113549.1.1.3 */
+	OID_md4WithRSAEncryption,	/* 1.2.840.113549.1.1.4 */
+	OID_sha1WithRSAEncryption,	/* 1.2.840.113549.1.1.5 */
+	OID_sha256WithRSAEncryption,	/* 1.2.840.113549.1.1.11 */
+	OID_sha384WithRSAEncryption,	/* 1.2.840.113549.1.1.12 */
+	OID_sha512WithRSAEncryption,	/* 1.2.840.113549.1.1.13 */
+	OID_sha224WithRSAEncryption,	/* 1.2.840.113549.1.1.14 */
+	/* PKCS#7 {iso(1) member-body(2) us(840) rsadsi(113549) pkcs(1) pkcs-7(7)} */
+	OID_data,			/* 1.2.840.113549.1.7.1 */
+	OID_signed_data,		/* 1.2.840.113549.1.7.2 */
+	/* PKCS#9 {iso(1) member-body(2) us(840) rsadsi(113549) pkcs(1) pkcs-9(9)} */
+	OID_email_address,		/* 1.2.840.113549.1.9.1 */
+	OID_content_type,		/* 1.2.840.113549.1.9.3 */
+	OID_messageDigest,		/* 1.2.840.113549.1.9.4 */
+	OID_signingTime,		/* 1.2.840.113549.1.9.5 */
+	OID_smimeCapabilites,		/* 1.2.840.113549.1.9.15 */
+	OID_smimeAuthenticatedAttrs,	/* 1.2.840.113549.1.9.16.2.11 */
+
+	/* {iso(1) member-body(2) us(840) rsadsi(113549) digestAlgorithm(2)} */
+	OID_md2,			/* 1.2.840.113549.2.2 */
+	OID_md4,			/* 1.2.840.113549.2.4 */
+	OID_md5,			/* 1.2.840.113549.2.5 */
+
+	OID_certAuthInfoAccess,		/* 1.3.6.1.5.5.7.1.1 */
+	OID_msOutlookExpress,		/* 1.3.6.1.4.1.311.16.4 */
+	OID_sha1,			/* 1.3.14.3.2.26 */
+
+	/* Distinguished Name attribute IDs [RFC 2256] */
+	OID_commonName,			/* 2.5.4.3 */
+	OID_surname,			/* 2.5.4.4 */
+	OID_countryName,		/* 2.5.4.6 */
+	OID_locality,			/* 2.5.4.7 */
+	OID_stateOrProvinceName,	/* 2.5.4.8 */
+	OID_organizationName,		/* 2.5.4.10 */
+	OID_organizationUnitName,	/* 2.5.4.11 */
+	OID_title,			/* 2.5.4.12 */
+	OID_description,		/* 2.5.4.13 */
+	OID_name,			/* 2.5.4.41 */
+	OID_givenName,			/* 2.5.4.42 */
+	OID_initials,			/* 2.5.4.43 */
+	OID_generationalQualifier,	/* 2.5.4.44 */
+
+	/* Certificate extension IDs */
+	OID_subjectKeyIdentifier,	/* 2.5.29.14 */
+	OID_keyUsage,			/* 2.5.29.15 */
+	OID_subjectAltName,		/* 2.5.29.17 */
+	OID_issuerAltName,		/* 2.5.29.18 */
+	OID_basicConstraints,		/* 2.5.29.19 */
+	OID_crlDistributionPoints,	/* 2.5.29.31 */
+	OID_certPolicies,		/* 2.5.29.32 */
+	OID_authorityKeyIdentifier,	/* 2.5.29.35 */
+	OID_extKeyUsage,		/* 2.5.29.37 */
+
+	OID__NR
+};
+
+extern enum OID look_up_OID(const void *data, size_t datasize);
+
+#endif /* _LINUX_OID_REGISTRY_H */
diff --git a/lib/.gitignore b/lib/.gitignore
index 3bef1ea..09aae85 100644
--- a/lib/.gitignore
+++ b/lib/.gitignore
@@ -3,4 +3,4 @@
 #
 gen_crc32table
 crc32table.h
-
+oid_registry_data.c
diff --git a/lib/Kconfig b/lib/Kconfig
index bb94c1b..a4009c2 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -396,4 +396,9 @@ config SIGNATURE
 config LIBFDT
 	bool
 
+config OID_REGISTRY
+	tristate "Fast OID registry"
+	help
+	  Enable fast lookup object identifier registry.
+
 endmenu
diff --git a/lib/Makefile b/lib/Makefile
index 42d283e..b042896 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -150,3 +150,19 @@ quiet_cmd_crc32 = GEN     $@
 
 $(obj)/crc32table.h: $(obj)/gen_crc32table
 	$(call cmd,crc32)
+
+#
+# Build a fast OID lookip registry from include/linux/oid_registry.h
+#
+obj-$(CONFIG_OID_REGISTRY) += oid_registry.o
+
+$(obj)/oid_registry.c: $(obj)/oid_registry_data.c
+
+$(obj)/oid_registry_data.c: $(srctree)/include/linux/oid_registry.h \
+			    $(src)/build_OID_registry
+	$(call cmd,build_OID_registry)
+
+quiet_cmd_build_OID_registry = GEN     $@
+      cmd_build_OID_registry = perl $(srctree)/$(src)/build_OID_registry $< $@
+
+clean-files	+= oid_registry_data.c
diff --git a/lib/build_OID_registry b/lib/build_OID_registry
new file mode 100755
index 0000000..dfbdaab
--- /dev/null
+++ b/lib/build_OID_registry
@@ -0,0 +1,209 @@
+#!/usr/bin/perl -w
+#
+# Build a static ASN.1 Object Identified (OID) registry
+#
+# Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
+# Written by David Howells (dhowells@redhat.com)
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public Licence
+# as published by the Free Software Foundation; either version
+# 2 of the Licence, or (at your option) any later version.
+#
+
+use strict;
+
+my @names = ();
+my @oids = ();
+
+if ($#ARGV != 1) {
+    print STDERR "Format: ", $0, " <in-h-file> <out-c-file>\n";
+    exit(2);
+}
+
+#
+# Open the file to read from
+#
+open IN_FILE, "<$ARGV[0]" || die;
+while (<IN_FILE>) {
+    chomp;
+    if (m!\s+OID_([a-zA-z][a-zA-Z0-9_]+),\s+/[*]\s+([012][.0-9]*)\s+[*]/!) {
+	push @names, $1;
+	push @oids, $2;
+    }
+}
+close IN_FILE || die;
+
+#
+# Open the files to write into
+#
+open C_FILE, ">$ARGV[1]" or die;
+print C_FILE "/*\n";
+print C_FILE " * Automatically generated by ", $0, ".  Do not edit\n";
+print C_FILE " */\n";
+
+#
+# Split the data up into separate lists and also determine the lengths of the
+# encoded data arrays.
+#
+my @indices = ();
+my @lengths = ();
+my $total_length = 0;
+
+print "Compiling ", $#names + 1, " OIDs\n";
+
+for (my $i = 0; $i <= $#names; $i++) {
+    my $name = $names[$i];
+    my $oid = $oids[$i];
+
+    my @components = split(/[.]/, $oid);
+
+    # Determine the encoded length of this OID
+    my $size = $#components;
+    for (my $loop = 2; $loop <= $#components; $loop++) {
+	my $c = $components[$loop];
+
+	# We will base128 encode the number
+	my $tmp = ($c == 0) ? 0 : int(log($c)/log(2));
+	$tmp = int($tmp / 7);
+	$size += $tmp;
+    }
+    push @lengths, $size;
+    push @indices, $total_length;
+    $total_length += $size;
+}
+
+#
+# Emit the look-up-by-OID index table
+#
+print C_FILE "\n";
+if ($total_length <= 255) {
+    print C_FILE "static const unsigned char oid_index[OID__NR + 1] = {\n";
+} else {
+    print C_FILE "static const unsigned short oid_index[OID__NR + 1] = {\n";
+}
+for (my $i = 0; $i <= $#names; $i++) {
+    print C_FILE "\t[OID_", $names[$i], "] = ", $indices[$i], ",\n"
+}
+print C_FILE "\t[OID__NR] = ", $total_length, "\n";
+print C_FILE "};\n";
+
+#
+# Encode the OIDs
+#
+my @encoded_oids = ();
+
+for (my $i = 0; $i <= $#names; $i++) {
+    my @octets = ();
+
+    my @components = split(/[.]/, $oids[$i]);
+
+    push @octets, $components[0] * 40 + $components[1];
+
+    for (my $loop = 2; $loop <= $#components; $loop++) {
+	my $c = $components[$loop];
+
+	# Base128 encode the number
+	my $tmp = ($c == 0) ? 0 : int(log($c)/log(2));
+	$tmp = int($tmp / 7);
+
+	for (; $tmp > 0; $tmp--) {
+	    push @octets, (($c >> $tmp * 7) & 0x7f) | 0x80;
+	}
+	push @octets, $c & 0x7f;
+    }
+
+    push @encoded_oids, \@octets;
+}
+
+#
+# Create a hash value for each OID
+#
+my @hash_values = ();
+for (my $i = 0; $i <= $#names; $i++) {
+    my @octets = @{$encoded_oids[$i]};
+
+    my $hash = $#octets;
+    foreach (@octets) {
+	$hash += $_ * 33;
+    }
+
+    $hash = ($hash >> 24) ^ ($hash >> 16) ^ ($hash >> 8) ^ ($hash);
+
+    push @hash_values, $hash & 0xff;
+}
+
+#
+# Emit the OID data
+#
+print C_FILE "\n";
+print C_FILE "static const unsigned char oid_data[", $total_length, "] = {\n";
+for (my $i = 0; $i <= $#names; $i++) {
+    my @octets = @{$encoded_oids[$i]};
+    print C_FILE "\t";
+    print C_FILE $_, ", " foreach (@octets);
+    print C_FILE "\t// ", $names[$i];
+    print C_FILE "\n";
+}
+print C_FILE "};\n";
+
+#
+# Build the search index table (ordered by length then hash then content)
+#
+my @index_table = ( 0 .. $#names );
+
+@index_table = sort {
+    my @octets_a = @{$encoded_oids[$a]};
+    my @octets_b = @{$encoded_oids[$b]};
+
+    return $hash_values[$a] <=> $hash_values[$b]
+	if ($hash_values[$a] != $hash_values[$b]);
+    return $#octets_a <=> $#octets_b
+	if ($#octets_a != $#octets_b);
+    for (my $i = $#octets_a; $i >= 0; $i--) {
+	return $octets_a[$i] <=> $octets_b[$i]
+	    if ($octets_a[$i] != $octets_b[$i]);
+    }
+    return 0;
+
+} @index_table;
+
+#
+# Emit the search index and hash value table
+#
+print C_FILE "\n";
+print C_FILE "static const struct {\n";
+print C_FILE "\tunsigned char hash;\n";
+if ($#names <= 255) {
+    print C_FILE "\tenum OID oid : 8;\n";
+} else {
+    print C_FILE "\tenum OID oid : 16;\n";
+}
+print C_FILE "} oid_search_table[OID__NR] = {\n";
+for (my $i = 0; $i <= $#names; $i++) {
+    my @octets = @{$encoded_oids[$index_table[$i]]};
+    printf(C_FILE "\t[%3u] = { %3u, OID_%-35s }, // ",
+	   $i,
+	   $hash_values[$index_table[$i]],
+	   $names[$index_table[$i]]);
+    printf C_FILE "%02x", $_ foreach (@octets);
+    print C_FILE "\n";
+}
+print C_FILE "};\n";
+
+#
+# Emit the OID debugging name table
+#
+#print C_FILE "\n";
+#print C_FILE "const char *const oid_name_table[OID__NR + 1] = {\n";
+#
+#for (my $i = 0; $i <= $#names; $i++) {
+#    print C_FILE "\t\"", $names[$i], "\",\n"
+#}
+#print C_FILE "\t\"Unknown-OID\"\n";
+#print C_FILE "};\n";
+
+#
+# Polish off
+#
+close C_FILE or die;
diff --git a/lib/oid_registry.c b/lib/oid_registry.c
new file mode 100644
index 0000000..33cfd17
--- /dev/null
+++ b/lib/oid_registry.c
@@ -0,0 +1,89 @@
+/* ASN.1 Object identifier (OID) registry
+ *
+ * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/export.h>
+#include <linux/oid_registry.h>
+#include "oid_registry_data.c"
+
+/**
+ * look_up_OID - Find an OID registration for the specified data
+ * @data: Binary representation of the OID
+ * @datasize: Size of the binary representation
+ */
+enum OID look_up_OID(const void *data, size_t datasize)
+{
+	const unsigned char *octets = data;
+	enum OID oid;
+	unsigned char xhash;
+	unsigned i, j, k, hash;
+	size_t len;
+
+	/* Hash the OID data */
+	hash = datasize - 1;
+
+	for (i = 0; i < datasize; i++)
+		hash += octets[i] * 33;
+	hash = (hash >> 24) ^ (hash >> 16) ^ (hash >> 8) ^ hash;
+	hash &= 0xff;
+
+	/* Binary search the OID registry.  OIDs are stored in ascending order
+	 * of hash value then ascending order of size and then in ascending
+	 * order of reverse value.
+	 */
+	i = 0;
+	k = OID__NR;
+	while (i < k) {
+		j = (i + k) / 2;
+
+		xhash = oid_search_table[j].hash;
+		if (xhash > hash) {
+			k = j;
+			continue;
+		}
+		if (xhash < hash) {
+			i = j + 1;
+			continue;
+		}
+
+		oid = oid_search_table[j].oid;
+		len = oid_index[oid + 1] - oid_index[oid];
+		if (len > datasize) {
+			k = j;
+			continue;
+		}
+		if (len < datasize) {
+			i = j + 1;
+			continue;
+		}
+
+		/* Variation is most likely to be at the tail end of the
+		 * OID, so do the comparison in reverse.
+		 */
+		while (len > 0) {
+			unsigned char a = oid_data[oid_index[oid] + --len];
+			unsigned char b = octets[len];
+			if (a > b) {
+				k = j;
+				goto next;
+			}
+			if (a < b) {
+				i = j + 1;
+				goto next;
+			}
+		}
+		return oid;
+	next:
+		;
+	}
+
+	return OID__NR;
+}
+EXPORT_SYMBOL_GPL(look_up_OID);

