Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab0KJWom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 17:44:42 -0500
Received: from xenotime.net ([72.52.115.56]:47323 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757301Ab0KJWnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 17:43:25 -0500
Date: Wed, 10 Nov 2010 11:53:50 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Subject: [for review: PATCH 1/8] kernel-doc: escape xml for structs
Message-ID: <1289418830794@xenotime.net>
In-Reply-To: 
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

scripts/kernel-doc was leaving unescaped '<', '>', and '&' in
generated xml output for structs.  This causes xml parser errors.
Convert these characters to "&lt;", "&gt;", and "&amp;" as needed
to prevent errors.
Most of the conversion was already done; complete it just before
output.

Documentation/DocBook/device-drivers.xml:41883: parser error : StartTag: invalid element name
#define INPUT_KEYMAP_BY_INDEX	(1 << 0)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- linux-2.6.37-rc1-git8.orig/scripts/kernel-doc
+++ linux-2.6.37-rc1-git8/scripts/kernel-doc
@@ -5,7 +5,7 @@ use strict;
 ## Copyright (c) 1998 Michael Zucchi, All Rights Reserved        ##
 ## Copyright (C) 2000, 1  Tim Waugh <twaugh@redhat.com>          ##
 ## Copyright (C) 2001  Simon Huggins                             ##
-## Copyright (C) 2005-2009  Randy Dunlap                         ##
+## Copyright (C) 2005-2010  Randy Dunlap                         ##
 ## 								 ##
 ## #define enhancements by Armin Kuster <akuster@mvista.com>	 ##
 ## Copyright (c) 2000 MontaVista Software, Inc.			 ##
@@ -453,7 +453,7 @@ sub output_highlight {
     if ($output_mode eq "html" || $output_mode eq "xml") {
 	$contents = local_unescape($contents);
 	# convert data read & converted thru xml_escape() into &xyz; format:
-	$contents =~ s/\\\\\\/&/g;
+	$contents =~ s/\\\\\\/\&/g;
     }
 #   print STDERR "contents b4:$contents\n";
     eval $dohighlight;
@@ -770,7 +770,11 @@ sub output_struct_xml(%) {
     print $args{'type'} . " " . $args{'struct'} . " {\n";
     foreach $parameter (@{$args{'parameterlist'}}) {
 	if ($parameter =~ /^#/) {
-	    print "$parameter\n";
+	    my $prm = $parameter;
+	    # convert data read & converted thru xml_escape() into &xyz; format:
+	    # This allows us to have #define macros interspersed in a struct.
+	    $prm =~ s/\\\\\\/\&/g;
+	    print "$prm\n";
 	    next;
 	}
 
@@ -1701,6 +1705,8 @@ sub push_parameter($$$) {
 	}
 	}
 
+	$param = xml_escape($param);
+
 	# strip spaces from $param so that it is one continous string
 	# on @parameterlist;
 	# this fixes a problem where check_sections() cannot find


-- 

