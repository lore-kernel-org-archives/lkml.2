Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab1EUIWN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 04:22:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38472 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab1EUIWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 04:22:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=N49/Ynw9GYsFvuk1Pax7GtH6uWCOQgXVa14VVcrg5U2sUejH3HVauc1y+MkW6Qjiej
         2ZJGCDlmK7lndFiZJNIm4LR1YjCXQuqiwB3/G61WbMBgAi7VnTpRhZgpjb0DlNBDoO+G
         kdH6KJF5cOwtX6nTWsvZ+9tyDkVsn+XYKpkdE=
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 1/3] do collectcfiles work in perl itself, eschew shell pipeline
Date: Sat, 21 May 2011 02:21:46 -0600
Message-Id: <1305966108-13399-2-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305966108-13399-1-git-send-email-jim.cromie@gmail.com>
References: <1305966108-13399-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

avoid spawning a shell pipeline doing cat, grep, sed,
and do it all inside perl.  The <*.c> construct works
at least as far back as 5.8.9

Note that this is not just an optimization; the sed command
in the pipeline was unterminated, due to lack of escape on the
end-of-line (\$) in the regex, resulting in this:

    $ perl ../linux-2.6/scripts/export_report.pl  > /dev/null
    sed: -e expression #1, char 5: unterminated `s' command
    sh: .mod.c/: not found

Comments on an earlier patch sought an all-perl implementation.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
cc: Michal Marek <mmarek@suse.cz>,
cc: linux-kbuild@vger.kernel.org
cc: Arnaud Lacombe lacombar@gmail.com
cc: Stephen Hemminger shemminger@vyatta.com
---
 scripts/export_report.pl |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/scripts/export_report.pl b/scripts/export_report.pl
index 04dce7c..5499ff0 100644
--- a/scripts/export_report.pl
+++ b/scripts/export_report.pl
@@ -49,8 +49,14 @@ sub usage {
 }
 
 sub collectcfiles {
-    my @file
-	= `cat .tmp_versions/*.mod | grep '.*\.ko\$' | sed s/\.ko$/.mod.c/`;
+    my @file;
+    while (<.tmp_versions/*.mod>) {
+	open my $fh, '<', $_ or die "cant open $_: $!\n";
+	push (@file,
+	      grep s/\.ko/.mod.c/,	# change the suffix
+	      grep m/.+\.ko/,		# find the .ko path
+	      <$fh>);			# lines in opened file
+    }
     chomp @file;
     return @file;
 }
-- 
1.7.4.1

