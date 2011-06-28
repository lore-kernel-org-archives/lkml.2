Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab1F1HMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 03:12:43 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50563 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728Ab1F1HKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 03:10:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XCehEYM3mKbPVblhrC6+JZtHdWM3Qt/3Adx+l8Uk5DRU6ysXeT2qihdhnfNHNbj/g7
         8LbDc3dZv7/7vCDOlBIYv/dGn9JI+er4tA1+zmKRsZDlkvjT1sL+EbdehJs8IjNCq6C1
         vAZOt9MChCOi8Ux79W66OdpZhlPqe3BcRzqYA=
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gnb@fmeh.org, jbaron@redhat.com, bvanassche@acm.org, gregkh@suse.de,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 11/11] dynamic_debug: document use of pendinq queries at boot-time
Date: Tue, 28 Jun 2011 01:09:52 -0600
Message-Id: <1309244992-2305-12-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add paragraph that pendinq-queries are checked when modules are loaded,
so debug statements can be used in module_init functions.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 Documentation/dynamic-debug-howto.txt |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/Documentation/dynamic-debug-howto.txt b/Documentation/dynamic-debug-howto.txt
index d0faf98..49b75b81 100644
--- a/Documentation/dynamic-debug-howto.txt
+++ b/Documentation/dynamic-debug-howto.txt
@@ -120,11 +120,12 @@ specifications, followed by a flags change specification.
 
 command ::= match-spec* flags-spec
 
-The match-spec's are used to choose a subset of the known dprintk()
+The match-specs are used to choose a subset of the known dprintk()
 callsites to which to apply the flags-spec.  Think of them as a query
-with implicit ANDs between each pair.  Note that an empty list of
-match-specs is possible, but is not very useful because it will not
-match any debug statement callsites.
+with implicit ANDs between each pair.  This means that multiple specs
+of a given type are nonsense; a module cannot match A and B
+simultaneously.  Note that an empty list of match-specs is legal but
+pointless, it will not match any debug statement callsites.
 
 A match specification comprises a keyword, which controls the attribute
 of the callsite to be compared, and a value to compare against.  Possible
@@ -242,13 +243,20 @@ QUERY follows the syntax described above, but must not exceed 1023
 characters. The enablement of debug messages is done as an arch_initcall.
 Thus you can enable debug messages in all code processed after this
 arch_initcall via this boot parameter.
-On an x86 system for example ACPI enablement is a subsys_initcall and
-ddebug_query="file ec.c +p"
+
+On an x86 system for example ACPI enablement is a subsys_initcall, so
+  ddebug_query="file ec.c +p"
 will show early Embedded Controller transactions during ACPI setup if
 your machine (typically a laptop) has an Embedded Controller.
 PCI (or other devices) initialization also is a hot candidate for using
 this boot parameter for debugging purposes.
 
+You can also give queries for modules which are not yet loaded, but
+will be, via udev or /etc/modules.  These queries are saved to a
+pending-queries list, and are applied when the module is loaded, and
+before the module's init function is invoked.  Note that modules which
+have no debug messages do not trigger this, so queries for them will
+remain on the pending-list until reboot.
 
 Examples
 ========
-- 
1.7.4.1

