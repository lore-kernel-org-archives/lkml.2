Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab0IJJeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 05:34:16 -0400
Received: from ist.d-labs.de ([213.239.218.44]:37534 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab0IJJeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 05:34:15 -0400
From: florian@mickler.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Florian Mickler <florian@mickler.org>,
        "Andrew Morton (role:commit_signer)" <akpm@linux-foundation.org>,
        "Joe Perches (role:commit_signer)" <joe@perches.com>,
        "Stephen Hemminger (role:commit_signer)" <shemminger@vyatta.com>,
        "Wolfram Sang (role:commit_signer)" <w.sang@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] get_maintainer.pl: append reason for cc to the name by default
Date: Fri, 10 Sep 2010 11:33:31 +0200
Message-Id: <1284111212-10659-1-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The script get_maintainer.pl is a very useful tool for deploying changes
made to the kernel. Among others it searches not only the MAINTAINERS
file but also the git history for people to send patches to.

This can be unexpected for the receiving side and can and does provoke
sometimes anger because it is not easy to determine if the sender did
explicitly put the receiving side on the cc list, or if they just
trolled the tree. The receiving side, if not used to be cc'd on many
things will check the patch, spend time investigating what the heck they
were cc'd just to realize, that there was no special reason.

As get_maintainer.pl is frequently used by kernel newcommers who _can_
not know whom to cc by themself, this anger then comes as a surprise for them
and definitely puts them in an awkward position.

By appending a  a note of the reason for the cc in the name, the reason
becomes clear and the receiving side is relieved from feeling obliged to
check the patch  while the sending side has a chance to adapt the
cc'list to their liking.

But the most useful aspect of this is, IMHO, that it makes it transparent who
just used get_maintainer.pl as a shortcut to increase his own
patch-throughput or who really put an effort in finding or editing the
cc'list to their likings.

Signed-off-by: Florian Mickler <florian@mickler.org>
---
 scripts/get_maintainer.pl |   77 ++++++++++++++++++++++++--------------------
 1 files changed, 42 insertions(+), 35 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index b228198..0cdc66a 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -255,6 +255,9 @@ close($maint);
 
 my %mailmap;
 
+#
+# read in a name->address lookup table
+#
 if ($email_remove_duplicates) {
     open(my $mailmap, '<', "${lk_path}.mailmap")
 	or warn "$P: Can't open .mailmap: $!\n";
@@ -265,10 +268,11 @@ if ($email_remove_duplicates) {
 	next if ($line =~ m/^\s*$/);
 
 	my ($name, $address) = parse_email($line);
-	$line = format_email($name, $address, $email_usename);
+	$line = format_email($name, $address, "", $email_usename);
 
 	next if ($line =~ m/^\s*$/);
 
+	#append address to name 
 	if (exists($mailmap{$name})) {
 	    my $obj = $mailmap{$name};
 	    push(@$obj, $address);
@@ -457,11 +461,11 @@ if ($email) {
     foreach my $chief (@penguin_chief) {
 	if ($chief =~ m/^(.*):(.*)/) {
 	    my $email_address;
-
-	    $email_address = format_email($1, $2, $email_usename);
+	    $email_address = format_email($1, $2, 'chief penguin', $email_usename);
 	    if ($email_git_penguin_chiefs) {
 		push(@email_to, [$email_address, 'chief penguin']);
 	    } else {
+		$email_address = format_email($1, $2, "", 0);
 		@email_to = grep($_->[0] !~ /${email_address}/, @email_to);
 	    }
 	}
@@ -469,10 +473,9 @@ if ($email) {
 
     foreach my $email (@file_emails) {
 	my ($name, $address) = parse_email($email);
-
-	my $tmp_email = format_email($name, $address, $email_usename);
-	push_email_address($tmp_email, '');
-	add_role($tmp_email, 'in file');
+	my $tmp_email = format_email($name, $address, "", $email_usename);
+	push_email_address($tmp_email, 'explicit cc', 'in file');
+	add_role($tmp_email, 'explicit cc', 'in file');
     }
 }
 
@@ -660,10 +663,13 @@ sub parse_email {
 }
 
 sub format_email {
-    my ($name, $address, $usename) = @_;
-
+    my ($name, $address, $simple_role, $usename) = @_;
     my $formatted_email;
 
+    my $role_display = "";
+    if($simple_role){
+    	$role_display = "(role:$simple_role) ";
+    }
     $name =~ s/^\s+|\s+$//g;
     $name =~ s/^\"|\"$//g;
     $address =~ s/^\s+|\s+$//g;
@@ -675,9 +681,9 @@ sub format_email {
 
     if ($usename) {
 	if ("$name" eq "") {
-	    $formatted_email = "$address";
+	    $formatted_email = "$role_display<$address>";
 	} else {
-	    $formatted_email = "$name <$address>";
+	    $formatted_email = "$name $role_display<$address>";
 	}
     } else {
 	$formatted_email = $address;
@@ -769,7 +775,7 @@ sub get_maintainer_role {
 	$role = "chief penguin";
     }
 
-    return $role . ":" . $subsystem;
+    return ($role, $role . ":" . $subsystem);
 }
 
 sub get_list_role {
@@ -836,14 +842,14 @@ sub add_categories {
 			if ($tv =~ m/^(\C):\s*(.*)/) {
 			    if ($1 eq "P") {
 				$name = $2;
-				$pvalue = format_email($name, $address, $email_usename);
+				$pvalue = format_email($name, $address, "maintainer", $email_usename);
 			    }
 			}
 		    }
 		}
 		if ($email_maintainer) {
-		    my $role = get_maintainer_role($i);
-		    push_email_addresses($pvalue, $role);
+		    my ($role, $debug_role) = get_maintainer_role($i);
+		    push_email_addresses($pvalue, $role, $debug_role);
 		}
 	    } elsif ($ptype eq "T") {
 		push(@scm, $pvalue);
@@ -870,7 +876,7 @@ sub email_inuse {
 }
 
 sub push_email_address {
-    my ($line, $role) = @_;
+    my ($line, $display_role, $debug_role) = @_;
 
     my ($name, $address) = parse_email($line);
 
@@ -879,9 +885,9 @@ sub push_email_address {
     }
 
     if (!$email_remove_duplicates) {
-	push(@email_to, [format_email($name, $address, $email_usename), $role]);
+	push(@email_to, [format_email($name, $address, $display_role, $email_usename), $debug_role]);
     } elsif (!email_inuse($name, $address)) {
-	push(@email_to, [format_email($name, $address, $email_usename), $role]);
+	push(@email_to, [format_email($name, $address, $display_role, $email_usename), $debug_role]);
 	$email_hash_name{$name}++;
 	$email_hash_address{$address}++;
     }
@@ -890,29 +896,29 @@ sub push_email_address {
 }
 
 sub push_email_addresses {
-    my ($address, $role) = @_;
+    my ($address, $display_role, $debug_role) = @_;
 
     my @address_list = ();
 
     if (rfc822_valid($address)) {
-	push_email_address($address, $role);
+	push_email_address($address, $display_role, $debug_role);
     } elsif (@address_list = rfc822_validlist($address)) {
 	my $array_count = shift(@address_list);
 	while (my $entry = shift(@address_list)) {
-	    push_email_address($entry, $role);
+	    push_email_address($entry, $display_role, $debug_role);
 	}
     } else {
-	if (!push_email_address($address, $role)) {
+	if (!push_email_address($address, $display_role, $debug_role)) {
 	    warn("Invalid MAINTAINERS address: '" . $address . "'\n");
 	}
     }
 }
 
 sub add_role {
-    my ($line, $role) = @_;
+    my ($line, $display_role, $role) = @_;
 
     my ($name, $address) = parse_email($line);
-    my $email = format_email($name, $address, $email_usename);
+    my $email = format_email($name, $address, $display_role, $email_usename);
 
     foreach my $entry (@email_to) {
 	if ($email_remove_duplicates) {
@@ -920,6 +926,7 @@ sub add_role {
 	    if (($name eq $entry_name || $address eq $entry_address)
 		&& ($role eq "" || !($entry->[1] =~ m/$role/))
 	    ) {
+		#append role
 		if ($entry->[1] eq "") {
 		    $entry->[1] = "$role";
 		} else {
@@ -930,6 +937,7 @@ sub add_role {
 	    if ($email eq $entry->[0]
 		&& ($role eq "" || !($entry->[1] =~ m/$role/))
 	    ) {
+		#append role
 		if ($entry->[1] eq "") {
 		    $entry->[1] = "$role";
 		} else {
@@ -958,18 +966,20 @@ sub mailmap {
 
     foreach my $line (@lines) {
 	my ($name, $address) = parse_email($line);
+
 	if (!exists($hash{$name})) {
 	    $hash{$name} = $address;
 	} elsif ($address ne $hash{$name}) {
 	    $address = $hash{$name};
-	    $line = format_email($name, $address, $email_usename);
+	    $line = format_email($name, $address, "", $email_usename);
 	}
+	
 	if (exists($mailmap{$name})) {
 	    my $obj = $mailmap{$name};
 	    foreach my $map_address (@$obj) {
 		if (($map_address eq $address) &&
 		    ($map_address ne $hash{$name})) {
-		    $line = format_email($name, $hash{$name}, $email_usename);
+		    $line = format_email($name, $hash{$name}, "", $email_usename);
 		}
 	    }
 	}
@@ -1021,7 +1031,7 @@ sub vcs_find_signers {
 
     foreach my $line (@lines) {
 	my ($name, $address) = parse_email($line);
-	$line = format_email($name, $address, 1);
+	$line = format_email($name, $address, "", 1);
     }
 
     return ($commits, @lines);
@@ -1136,13 +1146,10 @@ sub vcs_assign {
 	last if ($sign_offs < $email_git_min_signatures ||
 		 $count > $email_git_max_maintainers ||
 		 $percent < $email_git_min_percent);
-	push_email_address($line, '');
-	if ($output_rolestats) {
-	    my $fmt_percent = sprintf("%.0f", $percent);
-	    add_role($line, "$role:$sign_offs/$divisor=$fmt_percent%");
-	} else {
-	    add_role($line, $role);
-	}
+	my $fmt_percent = sprintf("%.0f", $percent);
+	my $debug_role = "$role:$sign_offs/$divisor=$fmt_percent%";
+	push_email_address($line, $role, $debug_role);
+	add_role($line, $role, $debug_role);
     }
 }
 
@@ -1248,7 +1255,7 @@ sub clean_file_emails {
 	    $name = '"' . substr($name, 2, length($name) - 2);
 	}
 
-	my $fmt_email = format_email($name, $address, $email_usename);
+	my $fmt_email = format_email($name, $address, "", $email_usename);
 	push(@fmt_emails, $fmt_email);
     }
     return @fmt_emails;
-- 
1.7.2

