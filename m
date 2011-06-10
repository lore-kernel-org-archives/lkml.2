Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab1FJKh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 06:37:26 -0400
Received: from mail.perches.com ([173.55.12.10]:2788 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab1FJKhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 06:37:25 -0400
Subject: [PATCH] get_maintainers.pl: Improve .mailmap parsing
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Florian Mickler <florian@mickler.org>
Cc: Ryan Mallon <rmallon@gmail.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1307679288.20439.15.camel@Joe-Laptop>
References: <1307661170-9325-1-git-send-email-rmallon@gmail.com>
	 <20110610025532.GE26006@linux-sh.org> <4DF189F2.3040009@gmail.com>
	 <1307675512.20439.2.camel@Joe-Laptop> <4DF18BDC.8010306@gmail.com>
	 <1307676240.20439.9.camel@Joe-Laptop> <4DF1902A.1040305@gmail.com>
	 <20110610035115.GF26006@linux-sh.org>  <4DF19565.9070601@gmail.com>
	 <1307679288.20439.15.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Jun 2011 03:37:23 -0700
Message-ID: <1307702243.20439.31.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Entries that used formats other than "Proper Name <commit@email.xx>"
were not parsed properly.

Try to improve the parsing so that the entries in the forms of:
    Proper Name <proper@email.xx> <commit@email.xx>
and
    Proper Name <proper@email.xx> Commit Name <commit@email.xx>
are transformed correctly.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index d29a8d7..eb2f1e6 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -328,7 +328,8 @@ sub read_mailmap {
 	# name1 <mail1> <mail2>
 	# name1 <mail1> name2 <mail2>
 	# (see man git-shortlog)
-	if (/^(.+)<(.+)>$/) {
+
+	if (/^([^<]+)<([^>]+)>$/) {
 	    my $real_name = $1;
 	    my $address = $2;
 
@@ -336,13 +337,13 @@ sub read_mailmap {
 	    ($real_name, $address) = parse_email("$real_name <$address>");
 	    $mailmap->{names}->{$address} = $real_name;
 
-	} elsif (/^<([^\s]+)>\s*<([^\s]+)>$/) {
+	} elsif (/^<([^>]+)>\s*<([^>]+)>$/) {
 	    my $real_address = $1;
 	    my $wrong_address = $2;
 
 	    $mailmap->{addresses}->{$wrong_address} = $real_address;
 
-	} elsif (/^(.+)<([^\s]+)>\s*<([^\s]+)>$/) {
+	} elsif (/^(.+)<([^>]+)>\s*<([^>]+)>$/) {
 	    my $real_name = $1;
 	    my $real_address = $2;
 	    my $wrong_address = $3;
@@ -353,7 +354,7 @@ sub read_mailmap {
 	    $mailmap->{names}->{$wrong_address} = $real_name;
 	    $mailmap->{addresses}->{$wrong_address} = $real_address;
 
-	} elsif (/^(.+)<([^\s]+)>\s*([^\s].*)<([^\s]+)>$/) {
+	} elsif (/^(.+)<([^>]+)>\s*(.+)\s*<([^>]+)>$/) {
 	    my $real_name = $1;
 	    my $real_address = $2;
 	    my $wrong_name = $3;
-- 
1.7.5.rc3.dirty



