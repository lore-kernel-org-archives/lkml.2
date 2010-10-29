Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934301Ab0J2R6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 13:58:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:56298 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934286Ab0J2R6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 13:58:42 -0400
Date: Fri, 29 Oct 2010 10:56:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH] scripts/kernel-doc: escape special characters for xml
 struct output
Message-Id: <20101029105624.541f8828.randy.dunlap@oracle.com>
In-Reply-To: <20101026114555.4b79977d.rdunlap@xenotime.net>
References: <20101026114555.4b79977d.rdunlap@xenotime.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

--- linux-2.6.36-git13.orig/scripts/kernel-doc
+++ linux-2.6.36-git13/scripts/kernel-doc
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
