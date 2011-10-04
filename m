Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab1JDPAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 11:00:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63883 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932265Ab1JDPAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 11:00:53 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=Fub8P5reoGYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=P2TBXxMVSzhMEO8hDJUA:9 a=yyazrDHEZQlGnKH5R2kA:7 a=PUjeQqilurYA:10 a=U62fhAwekXMA:10 a=jeBq3FmKZ4MA:10 a=-B2hAejxOsXz-0iC:21 a=1_yF0QTQPC-cmulO:21 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: [RFC][PATCH][QUILT] Add gpg signing to quilt mail
From: Steven Rostedt <rostedt@goodmis.org>
To: quilt-dev <quilt-dev@nongnu.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Kacur <jkacur@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andreas Gruenbacher <agruen@suse.de>
Date: Tue, 04 Oct 2011 11:00:49 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317740452.18063.7.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

quilt mail: Add way to sign mail with GPG

After the attack of kernel.org, several kernel developers are getting
paranoid about who is really who. A lot of focus is on signing emails
that verify who people really are using GPG signatures.

Unfortunately, there's no way to sign quilt email as it goes out. This
patch fixes that.

Added the quilt mail option --pass to allow the user to enter a
passphrase and sign their email patches.

TODO: 

Find a better way to read the passphrase. Right now it is stored in
memory and if the program is swapped to disk, others may be able to gain
access to it.

Verify the passphrase before continuing. If you type the wrong
passphrase, the email will still go out with a bad signature.

These changes were done in /usr/share/quilt.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 mail               |   30 +++++++++++-
 scripts/gpgmail.pl |  127 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 154 insertions(+), 3 deletions(-)
 create mode 100755 scripts/gpgmail.pl

diff --git a/mail b/mail
index c3c8297..1691336 100755
--- a/mail
+++ b/mail
@@ -63,6 +63,11 @@ first, and a last patch name of \`-' denotes the last patch in the series.
 
 --reply-to message
 	Add the appropriate headers to reply to the specified message.
+
+--pass
+	Enter a passphrase and sign email with GPG signatures.
+	Note: Even though the passphrase is stored in memory, it may end up
+	  being swapped to disk. Becareful with this option.
 " "/usr/share/doc/quilt/README.MAIL"
 		exit 0
 	else
@@ -115,6 +120,15 @@ references_header() {
 	[ -n "$references" ] && echo "References: $references"
 }
 
+sign_mail()
+{
+	if [ -z "$opt_pass" ]; then
+		cat
+	else
+		$QUILT_DIR/scripts/gpgmail.pl --passwd "$opt_pass"
+	fi
+}
+	
 process_mail()
 {
 	local tmpfile=$(gen_tempfile)
@@ -132,12 +146,12 @@ process_mail()
 			${QUILT_SENDMAIL_ARGS--f "$opt_sender"} "$@"
 		$QUILT_DIR/scripts/edmail --charset $opt_charset \
 				 --remove-header Bcc "$@" < $tmpfile \
-		| ${QUILT_SENDMAIL:-sendmail} \
+		| sign_mail | ${QUILT_SENDMAIL:-sendmail} \
 			${QUILT_SENDMAIL_ARGS--f "$opt_sender"} "$@"
 	else
 		local from_date=$(LC_ALL=C date "+%a %b %e %H:%M:%S %Y")
 		echo "From $opt_sender_address $from_date"
-		sed -e 's/^From />From /' $tmpfile
+		sed -e 's/^From />From /' $tmpfile | sign_mail
 		echo
 	fi
 	rm -f $tmpfile
@@ -154,7 +168,7 @@ join_lines() {
 }
 
 options=`getopt -o m:h --long from:,to:,cc:,bcc:,subject: \
-		       --long send,mbox:,charset:,sender: \
+		       --long send,pass,mbox:,charset:,sender: \
 		       --long prefix:,reply-to:,signature: -- "$@"`
 
 if [ $? -ne 0 ]
@@ -212,6 +226,16 @@ do
 	--reply-to)
 		opt_reply_to=$2
 		shift 2 ;;
+	--pass)
+		# Yes this is very insecure :-(
+		# If this program gets swapped to disk, we just stored
+		# the passphrase to the hard drive.
+		# FIXME
+		echo -n "Enter passphrase: ";
+		stty -echo
+		read opt_pass;
+		stty echo
+		shift ;;
 	--signature)
 		if [ "$2" = - ]
 		then
diff --git a/scripts/gpgmail.pl b/scripts/gpgmail.pl
new file mode 100755
index 0000000..2af6703
--- /dev/null
+++ b/scripts/gpgmail.pl
@@ -0,0 +1,127 @@
+#!/usr/bin/perl
+
+use strict;
+
+use MIME::QuotedPrint;
+
+my $pass;
+
+while ($#ARGV >= 0) {
+    my $opt = $ARGV[0];
+
+    last if ($opt =~ /^--$/ || $opt !~ /^-/);
+
+    if ($opt eq "--passwd") {
+	shift @ARGV;
+	$pass = shift @ARGV;
+    } else {
+	die "undefined option $opt";
+    }
+}
+
+shift @ARGV if ($#ARGV >= 0 && $ARGV eq "--");
+
+if (defined($pass)) {
+    $pass = " --passphrase=\"$pass\" ";
+} else {
+    $pass = "";
+}
+
+if ($#ARGV >= 0) {
+    open(IN, $ARGV[0]) or die "can't read $ARGV[0]";
+} else {
+    *IN = *STDIN;
+}
+
+*OUT = *STDOUT;
+
+my $content;
+my $quot;
+my $quoted = 0;
+
+while (<IN>) {
+    if (/^Content-Type/) {
+	s/$/\r/;
+	$content = $_;
+
+    } elsif (/^Content-Transfer-Encoding/) {
+	s/$/\r/;
+	$quot = $_;
+	$quoted = 1;
+
+    } elsif (/^$/) {
+	last;
+    } else {
+	print OUT;
+    }
+}
+
+my $scissor = sprintf "%s", crypt( sprintf("%d", rand * 1000), sprintf("%d", rand * 100));
+
+print OUT "Content-Type: multipart/signed; micalg=\"pgp-sha1\"; protocol=\"application/pgp-signature\"; boundary=\"$scissor\"";
+
+print OUT "\n\n";
+
+my $convert = 0;
+
+if (!defined($content)) {
+    $content = "Content-Type: text/plain; charset=\"UTF-8\"\r\n";
+    $quot = "Content-Transfer-Encoding: quoted-printable\r\n";
+    $convert = 1;
+    $quoted = 1;
+}
+
+print OUT "--$scissor\n";
+
+my @lines;
+
+$lines[$#lines + 1] = $content;
+if ($quoted) {
+    $lines[$#lines + 1] = $quot;
+}
+$lines[$#lines + 1] = "\r\n";
+
+my @rest;
+
+my @rest = <IN>;
+
+if ($convert) {
+    foreach my $line (@rest) {
+	$line = encode_qp($line,"\r\n");
+    }
+}
+
+@lines = (@lines, @rest);
+
+close IN;
+
+my $tmpfile = "/tmp/gpgmail.$$";
+
+open(TMP, ">", $tmpfile) or die "Can't create a temporary file";
+
+print TMP @lines;
+
+close TMP;
+
+# put the lines back to unix
+foreach my $line (@lines) {
+    $line =~ s/\r//;
+}
+
+print OUT @lines;
+
+print OUT "\n";
+print OUT "--$scissor\n";
+
+my $pgp = `gpg --simple-sk-checksum -a --detach-sign $pass --output - < $tmpfile`;
+
+unlink $tmpfile;
+
+print OUT "Content-Type: application/pgp-signature; name=\"signature.asc\"\n";
+print OUT "Content-Description: This is a digitally signed message part\n";
+print OUT "\n";
+
+print OUT $pgp;
+
+print OUT "\n";
+print OUT "--$scissor--\n";
-- 
1.7.6.3



