Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab0HRPsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:48:03 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51931 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab0HRPrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:47:13 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 14/16] checkpatch: handle EXPORT_SYMBOL for DEVICE_ATTR and similar
Date: Wed, 18 Aug 2010 16:46:47 +0100
Message-Id: <1282146409-30544-15-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282146409-30544-1-git-send-email-apw@canonical.com>
References: <1282146409-30544-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handly definitions similar to below.  The definition macro spits out
a symbol with a prefix.  Add matching of any identifier prefix:

    DEVICE_ATTR(link_power_management_policy, S_IRUGO | S_IWUSR,
            ata_scsi_lpm_show, ata_scsi_lpm_put);
    EXPORT_SYMBOL_GPL(dev_attr_link_power_management_policy);

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d5361e4..8ab45b7 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1822,8 +1822,17 @@ sub process {
 		    !defined $suppress_export{$realline_next} &&
 		    ($lines[$realline_next - 1] =~ /EXPORT_SYMBOL.*\((.*)\)/ ||
 		     $lines[$realline_next - 1] =~ /EXPORT_UNUSED_SYMBOL.*\((.*)\)/)) {
+			# Handle definitions which produce identifiers with
+			# a prefix:
+			#   XXX(foo);
+			#   EXPORT_SYMBOL(something_foo);
 			my $name = $1;
-			if ($stat !~ /(?:
+			if ($stat =~ /^.([A-Z_]+)\s*\(\s*($Ident)/ &&
+			    $name =~ /^${Ident}_$2/) {
+#print "FOO C name<$name>\n";
+				$suppress_export{$realline_next} = 1;
+
+			} elsif ($stat !~ /(?:
 				\n.}\s*$|
 				^.DEFINE_$Ident\(\Q$name\E\)|
 				^.DECLARE_$Ident\(\Q$name\E\)|
-- 
1.7.0.4

