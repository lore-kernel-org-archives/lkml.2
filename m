Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab0ELVMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:12:51 -0400
Received: from ist.d-labs.de ([213.239.218.44]:39525 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194Ab0ELVMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:12:50 -0400
From: florian@mickler.org
To: akpm@linux-foundation.org
Cc: Florian Mickler <florian@mickler.org>, Joe Perches <joe@perches.com>,
       Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] get_maintainer.pl: improve config-file support
Date: Wed, 12 May 2010 23:12:00 +0200
Message-Id: <1273698720-4010-1-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes the syntax of the config-file introduced in the commit
"scripts/get_maintainer.pl: add .get_maintainer.conf default options
file".

Entries are now of the more commonly found form:

	key = value

where keys are cmd-line arguments without the "--" prefixed.

An config file would look like this:

      ### comments and blank lines are allowed, spaces ignored ###
      git-all-signature-types = 1 #use all tags
      git-min-signatures = 2
      git-max-maintainers = 6
      names = 0 # no-names

This approach uses a hash to store references to the config-variables as
this makes it easier to implement default/override semantics for the
config file and cmdline, as well as warn if unrecognized options are
specified.

Signed-off-by: Florian Mickler <florian@mickler.org>
---

Hi Andrew!

This is on top of your queued patch from Joe Perches:
"scripts-get_maintainerpl-add-get_maintainerconf-default-options-file.patch"

I can regenerate against linux-next or mainline, as this replaces Joe's patch more or less. 
Nevertheless it wouldn't exist if it weren't for that initial patch, so i decided to do it
on top. 


Cheers,
Flo

p.s.: I'm offline until monday.
 
scripts/get_maintainer.pl |  174 ++++++++++++++++++++++++++++----------------
 1 files changed, 111 insertions(+), 63 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index b228198..4cc9407 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -48,6 +48,58 @@ my $from_filename = 0;
 my $pattern_depth = 0;
 my $version = 0;
 my $help = 0;
+my %prefs = (
+		'email' => \$email,
+		'git' => \$email_git,
+		'git-all-signature-types' => \$email_git_all_signature_types,
+		'git-blame' => \$email_git_blame,
+		'git-chief-penguins' => \$email_git_penguin_chiefs,
+		'git-min-signatures' => \$email_git_min_signatures,
+		'git-max-maintainers' => \$email_git_max_maintainers,
+		'git-min-percent' => \$email_git_min_percent,
+		'git-since' => \$email_git_since,
+		'hg-since' => \$email_hg_since,
+		'remove-duplicates' => \$email_remove_duplicates,
+		'maintainer' => \$email_maintainer,
+		'names' => \$email_usename,
+		'list' => \$email_list,
+		'subscribers' => \$email_subscriber_list,
+		'multiline' => \$output_multiline,
+		'roles' => \$output_roles,
+		'rolestats' => \$output_rolestats,
+		'separator' => \$output_separator,
+		'subsystem' => \$subsystem,
+		'status' => \$status,
+		'scm' => \$scm,
+		'web' => \$web,
+		'pattern-depth' => \$pattern_depth,
+		'keywords' => \$keywords,
+		'sections' => \$sections,
+		'file-emails' => \$file_emails,
+		'file' => \$from_filename,
+		'version' => \$version,
+		'help' => \$help,
+);
+
+my $confpath =  "${lk_path}.get_maintainer.conf";
+if (-f $confpath) {
+    open(my $conffile, '<', $confpath)
+	or warn "$P: Can't open $confpath: $!\n";
+    while (<$conffile>) {
+	chomp;                  # no newline
+	s/#.*//;                # no comments
+	s/^\s+//;               # no leading white
+	s/\s+$//;               # no trailing white
+	next unless length;     # anything left?
+	my ($key, $val) = split(/\s*=\s*/, $_, 2);
+	if (exists($prefs{$key})) {
+		${$prefs{$key}} = $val;
+	} else {
+		warn "$confpath: unrecognized option (\"$key\").\n";
+	}
+    }
+    close($conffile);
+}
 
 my $exit = 0;
 
@@ -107,61 +159,37 @@ my %VCS_cmds_hg = (
     "blame_commit_pattern" => "^([0-9a-f]+):"
 );
 
-if (-f "${lk_path}.get_maintainer.conf") {
-    my @conf_args;
-    open(my $conffile, '<', "${lk_path}.get_maintainer.conf")
-	or warn "$P: Can't open .get_maintainer.conf: $!\n";
-    while (<$conffile>) {
-	my $line = $_;
-
-	$line =~ s/\s*\n?$//g;
-	$line =~ s/^\s*//g;
-	$line =~ s/\s+/ /g;
-
-	next if ($line =~ m/^\s*#/);
-	next if ($line =~ m/^\s*$/);
-
-	my @words = split(" ", $line);
-	foreach my $word (@words) {
-	    last if ($word =~ m/^#/);
-	    push (@conf_args, $word);
-	}
-    }
-    close($conffile);
-    unshift(@ARGV, @conf_args) if @conf_args;
-}
-
-if (!GetOptions(
-		'email!' => \$email,
-		'git!' => \$email_git,
-		'git-all-signature-types!' => \$email_git_all_signature_types,
-		'git-blame!' => \$email_git_blame,
-		'git-chief-penguins!' => \$email_git_penguin_chiefs,
-		'git-min-signatures=i' => \$email_git_min_signatures,
-		'git-max-maintainers=i' => \$email_git_max_maintainers,
-		'git-min-percent=i' => \$email_git_min_percent,
-		'git-since=s' => \$email_git_since,
-		'hg-since=s' => \$email_hg_since,
-		'remove-duplicates!' => \$email_remove_duplicates,
-		'm!' => \$email_maintainer,
-		'n!' => \$email_usename,
-		'l!' => \$email_list,
-		's!' => \$email_subscriber_list,
-		'multiline!' => \$output_multiline,
-		'roles!' => \$output_roles,
-		'rolestats!' => \$output_rolestats,
-		'separator=s' => \$output_separator,
-		'subsystem!' => \$subsystem,
-		'status!' => \$status,
-		'scm!' => \$scm,
-		'web!' => \$web,
-		'pattern-depth=i' => \$pattern_depth,
-		'k|keywords!' => \$keywords,
-		'sections!' => \$sections,
-		'fe|file-emails!' => \$file_emails,
-		'f|file' => \$from_filename,
-		'v|version' => \$version,
-		'h|help|usage' => \$help,
+if (!GetOptions( \%prefs,
+		'email!',
+		'git!',
+		'git-all-signature-types!',
+		'git-blame!',
+		'git-chief-penguins!',
+		'git-min-signatures=i',
+		'git-max-maintainers=i',
+		'git-min-percent=i',
+		'git-since=s',
+		'hg-since=s',
+		'remove-duplicates!',
+		'maintainer|m!',
+		'names|n!',
+		'list|l!',
+		'subscribers|s!',
+		'multiline!',
+		'roles!',
+		'rolestats!',
+		'separator=s',
+		'subsystem!',
+		'status!',
+		'scm!',
+		'web!',
+		'pattern-depth=i',
+		'keywords|k!',
+		'sections!',
+		'file-emails|fe!',
+		'file|f',
+		'version|v',
+		'help|h|usage',
 		)) {
     die "$P: invalid argument - use --help if necessary\n";
 }
@@ -545,10 +573,10 @@ MAINTAINER field selection options:
     --git-blame => use git blame to find modified commits for patch or file
     --git-since => git history to use (default: $email_git_since)
     --hg-since => hg history to use (default: $email_hg_since)
-    --m => include maintainer(s) if any
-    --n => include name 'Full Name <addr\@domain.tld>'
-    --l => include list(s) if any
-    --s => include subscriber only list(s) if any
+    --maintainer | --m  => include maintainer(s) if any
+    --names | --n => include name 'Full Name <addr\@domain.tld>'
+    --list | --l  => include list(s) if any
+    --subscribers | --s => include subscriber only list(s) if any
     --remove-duplicates => minimize duplicate email names/addresses
     --roles => show roles (status:subsystem, git-signer, list, etc...)
     --rolestats => show roles and statistics (commits/total_commits, %)
@@ -582,26 +610,46 @@ Notes:
           no individual file within the directory or subdirectory
           is matched.
       Used with "--git-blame", does not iterate all files in directory
+
   Using "--git-blame" is slow and may add old committers and authors
       that are no longer active maintainers to the output.
+
   Using "--roles" or "--rolestats" with git send-email --cc-cmd or any
       other automated tools that expect only ["name"] <email address>
       may not work because of additional output after <email address>.
+
   Using "--rolestats" and "--git-blame" shows the #/total=% commits,
       not the percentage of the entire file authored.  # of commits is
       not a good measure of amount of code authored.  1 major commit may
       contain a thousand lines, 5 trivial commits may modify a single line.
+
   If git is not installed, but mercurial (hg) is installed and an .hg
       repository exists, the following options apply to mercurial:
           --git,
           --git-min-signatures, --git-max-maintainers, --git-min-percent, and
           --git-blame
       Use --hg-since not --git-since to control date selection
-  File ".get_maintainer.conf", if it exists in the linux kernel source root
+
+  The file ".get_maintainer.conf", if it exists in the linux kernel source root
       directory, can change whatever get_maintainer defaults are desired.
-      Entries in this file can be any command line argument.
-      This file is prepended to any additional command line arguments.
-      Multiple lines and # comments are allowed.
+      Entries in this file can be any command line argument without the
+      preceding "--" followed by an equal sign ('=') and a value.
+      Use 0 for disabled and 1 for enabled.
+      This makes it easy to use it with non-default options via
+      'git send-email --cc-cmd'.
+
+      An example file would look like this:
+      -------------------------------------------------------------------------
+
+      ### comments and blank lines are allowed. ###
+      git-all-signature-types = 1 #use all tags
+      git-min-signatures = 2
+      git-max-maintainers = 6
+      names = 0 # no names
+
+      -------------------------------------------------------------------------
+
+
 EOT
 }
 
-- 
1.7.0.4

