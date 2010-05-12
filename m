Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab0ELJZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 05:25:58 -0400
Received: from ist.d-labs.de ([213.239.218.44]:37688 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab0ELJZ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 05:25:57 -0400
Date: Wed, 12 May 2010 11:25:49 +0200
From: Florian Mickler <florian@mickler.org>
To: =?ISO-8859-15?B?QW3pcmljbw==?= Wang <xiyou.wangcong@gmail.com>,
       Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] scripts/get_maintainer.pl: add .get_maintainer.conf
 default options file
Message-ID: <20100512112549.650b321c@schatten.dmk.lab>
In-Reply-To: <20100512063042.GB5718@cr0.nay.redhat.com>
References: <cover.1273466698.git.joe@perches.com>
	<61106722b46cbf707d3e2641765aae2db93b6ea7.1273466698.git.joe@perches.com>
	<20100512063042.GB5718@cr0.nay.redhat.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.7; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010 14:30:42 +0800
Américo Wang <xiyou.wangcong@gmail.com> wrote:

> On Sun, May 09, 2010 at 09:56:03PM -0700, Joe Perches wrote:
> >Allow the use of a .get_maintainer.conf file to control the
> >default options applied when scripts/get_maintainer.pl is run.
> >
> >.get_maintainer.conf can contain any valid command-line argument.
> >
> >File contents are prepended to any additional command line arguments.
> >
> >Multiple lines may be used, blank lines ignored, # is a comment.
> 
> Do we really have to do this? This looks odd to me.

it's a little hackish, but the code impact is small. if you prefer
standard config-file syntax (i.e. "bla=" ) check the patch below. 

joe, what do you think?

> If the user of get_maintainer.pl uses some long command line
> arguments, to save his input, he should use bash aliases, not
> configure files. I never see configure files used like this.

bash aliases don't work (at least here) with "git send-email --cc-cmd="

> 
> Also, it doesn't worthy a configure file for such a script like
> get_maintainer.pl.

hm.. the only other way to use it via git send-email would be a wrapper
script? 

cheers,
Flo

>From 4f81b09c346075a062c868c59b724442c382b690 Mon Sep 17 00:00:00 2001
From: Florian Mickler <florian@mickler.org>
Date: Wed, 12 May 2010 10:57:24 +0200
Subject: [PATCH] get_maintainer.pl: change config file to use key=value pairs.

the solution to prepend the contents of the config file to the arguments
is unexpected for most people.

so we change it to be key = value syntax.

this approach uses a hash to store references to the config variables as
this makes it easier to implement default/override semantics for the
config file and cmdline.

Signed-off-by: Florian Mickler <florian@mickler.org>
---
 scripts/get_maintainer.pl |  169 ++++++++++++++++++++++++++++-----------------
 1 files changed, 106 insertions(+), 63 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index b228198..e8aad5c 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -48,6 +48,54 @@ my $from_filename = 0;
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
+my $conffile =  "${lk_path}.get_maintainer.conf";
+if (-f $conffile) {
+    open(my $conffile, '<', "${lk_path}.get_maintainer.conf")
+	or warn "$P: Can't open .get_maintainer.conf: $!\n";
+    while (<$conffile>) {
+	chomp;                  # no newline
+	s/#.*//;                # no comments
+	s/^\s+//;               # no leading white
+	s/\s+$//;               # no trailing white
+	next unless length;     # anything left?
+	my ($key, $val) = split(/\s*=\s*/, $_, 2);
+	${$prefs{$key}} = $val;
+    }
+    close($conffile);
+}
 
 my $exit = 0;
 
@@ -107,61 +155,37 @@ my %VCS_cmds_hg = (
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
@@ -545,10 +569,10 @@ MAINTAINER field selection options:
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
@@ -582,26 +606,45 @@ Notes:
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
+      preceding "--" followed by an equal sign ('=') and a 0 for disabled
+      or a 1 for enabled. 
+      This makes it easy to use it with non-default options via 
+      'git send-email --cc-cmd'.
+
+      An example file would look like this:
+      -------------------------------------------------------------------------
+      
+      ### comments and blank lines are allowed. ###
+      git-all-signature-types=1
+      lists=0 # don't include mailinglists
+      names=0 # no names
+
+      -------------------------------------------------------------------------
+
+  
 EOT
 }
 
-- 
1.7.0.4



