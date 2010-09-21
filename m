Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab0IUGag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 02:30:36 -0400
Received: from ist.d-labs.de ([213.239.218.44]:56896 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205Ab0IUGaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 02:30:35 -0400
From: florian@mickler.org
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, greg@kroah.com, stefanr@s5r6.in-berlin.de,
        broonie@opensource.wolfsonmicro.com,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH v2] scripts/get_maintainer.pl: fix mailmap handling
Date: Tue, 21 Sep 2010 08:30:25 +0200
Message-Id: <1285050625-15716-1-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285049533.25988.173.camel@Joe-Laptop>
References: <1285049533.25988.173.camel@Joe-Laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement it, like it is described in git-shortlog.

Signed-off-by: Florian Mickler <florian@mickler.org>
---

change: Removed superfluous comment.

 scripts/get_maintainer.pl |  147 +++++++++++++++++++++++++++++++++------------
 1 files changed, 109 insertions(+), 38 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index a91ae63..4219078 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -255,31 +255,76 @@ while (<$maint>) {
 }
 close($maint);
 
-my %mailmap;
 
-if ($email_remove_duplicates) {
-    open(my $mailmap, '<', "${lk_path}.mailmap")
+#
+# Read mail address map
+#
+
+my $mailmap = read_mailmap();
+
+sub read_mailmap {
+    my $mailmap = {
+	names => {},
+	addresses => {}
+   };
+
+    if (!$email_remove_duplicates) {
+	return $mailmap;
+    }
+
+    open(my $mailmap_file, '<', "${lk_path}.mailmap")
 	or warn "$P: Can't open .mailmap: $!\n";
-    while (<$mailmap>) {
-	my $line = $_;
 
-	next if ($line =~ m/^\s*#/);
-	next if ($line =~ m/^\s*$/);
+    while (<$mailmap_file>) {
+	s/#.*$//; #strip comments
+	s/^\s+|\s+$//g; #trim
 
-	my ($name, $address) = parse_email($line);
-	$line = format_email($name, $address, $email_usename);
+	next if (/^\s*$/); #skip empty lines
+	#entries have one of the following formats:
+	# name1 <mail1>
+	# <mail1> <mail2>
+	# name1 <mail1> <mail2>
+	# name1 <mail1> name2 <mail2>
+	# (see man git-shortlog)
+	if (/^(.+)<(.+)>$/) {
+		my $real_name = $1;
+		my $address = $2;
 
-	next if ($line =~ m/^\s*$/);
+		$real_name =~ s/\s+$//;
+		$mailmap->{names}->{$address} = $real_name;
 
-	if (exists($mailmap{$name})) {
-	    my $obj = $mailmap{$name};
-	    push(@$obj, $address);
-	} else {
-	    my @arr = ($address);
-	    $mailmap{$name} = \@arr;
+	} elsif (/^<([^\s]+)>\s*<([^\s]+)>$/) {
+		my $real_address = $1;
+		my $wrong_address = $2;
+
+		$mailmap->{addresses}->{$wrong_address} = $real_address;
+
+	} elsif (/^(.+)<([^\s]+)>\s*<([^\s]+)>$/) {
+		my $real_name= $1;
+		my $real_address = $2;
+		my $wrong_address = $3;
+
+		$real_name =~ s/\s+$//;
+
+		$mailmap->{names}->{$wrong_address} = $real_name;
+		$mailmap->{addresses}->{$wrong_address} = $real_address;
+
+	} elsif (/^(.+)<([^\s]+)>\s*([^\s].*)<([^\s]+)>$/) {
+		my $real_name = $1;
+		my $real_address = $2;
+		my $wrong_name = $3;
+		my $wrong_address = $4;
+
+		$real_name =~ s/\s+$//;
+		$wrong_name =~ s/\s+$//;
+
+		$mailmap->{names}->{format_email($wrong_name,$wrong_address,1)} = $real_name;
+		$mailmap->{addresses}->{format_email($wrong_name,$wrong_address,1)} = $real_address;
 	}
     }
-    close($mailmap);
+    close($mailmap_file);
+
+    return $mailmap;
 }
 
 ## use the filenames on the command line or find the filenames in the patchfiles
@@ -954,30 +999,58 @@ sub which {
     return "";
 }
 
-sub mailmap {
-    my (@lines) = @_;
-    my %hash;
+sub mailmap_email {
+	my $line = shift;
 
-    foreach my $line (@lines) {
 	my ($name, $address) = parse_email($line);
-	if (!exists($hash{$name})) {
-	    $hash{$name} = $address;
-	} elsif ($address ne $hash{$name}) {
-	    $address = $hash{$name};
-	    $line = format_email($name, $address, $email_usename);
-	}
-	if (exists($mailmap{$name})) {
-	    my $obj = $mailmap{$name};
-	    foreach my $map_address (@$obj) {
-		if (($map_address eq $address) &&
-		    ($map_address ne $hash{$name})) {
-		    $line = format_email($name, $hash{$name}, $email_usename);
+	my $email = format_email($name, $address, 1);
+	my $real_name = $name;
+	my $real_address = $address;
+
+	if (exists $mailmap->{names}->{$email} || exists $mailmap->{addresses}->{$email}) {
+		if (exists $mailmap->{names}->{$email}) {
+			$real_name = $mailmap->{names}->{$email};
+		}
+		if (exists $mailmap->{addresses}->{$email}) {
+			$real_address = $mailmap->{addresses}->{$email};
+		}
+	} else {
+		if (exists $mailmap->{names}->{$address}) {
+			$real_name = $mailmap->{names}->{$address};
+		}
+		if (exists $mailmap->{addresses}->{$address}) {
+			$real_address = $mailmap->{addresses}->{$address};
 		}
-	    }
 	}
+	return format_email($real_name, $real_address, 1);
+}
+
+sub mailmap {
+    my (@addresses) = @_;
+
+    my @ret = ();
+    foreach my $line (@addresses) {
+	push(@ret, mailmap_email($line), 1);
     }
 
-    return @lines;
+    merge_by_realname(@ret) if $email_remove_duplicates;
+
+    return @ret;
+}
+
+sub merge_by_realname {
+	my %address_map;
+	my (@emails) = @_;
+	foreach my $email (@emails) {
+		my ($name, $address) = parse_email($email);
+		if (!exists $address_map{$name}) {
+			$address_map{$name} = $address;
+		} else {
+			$address = $address_map{$name};
+			$email = format_email($name,$address,1);
+		}
+	}
+
 }
 
 sub git_execute_cmd {
@@ -1148,9 +1221,7 @@ sub vcs_assign {
 	$divisor = 1;
     }
 
-    if ($email_remove_duplicates) {
-	@lines = mailmap(@lines);
-    }
+    @lines = mailmap(@lines);
 
     return if (@lines <= 0);
 
-- 
1.7.3

