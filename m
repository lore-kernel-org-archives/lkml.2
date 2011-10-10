Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab1JJQIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:08:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48933 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab1JJQIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:08:31 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=sxOau6DlW24A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=tAtwRuLxtXw7vNmdP1EA:9 a=v41GswIqBgQgVtWdyw4A:7 a=PUjeQqilurYA:10 a=U62fhAwekXMA:10 a=jeBq3FmKZ4MA:10 a=Qh45eCkgrEZAXy1X:21 a=VciAjCYG3FiEsltU:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: [PATCH v3] quilt mail: Add way to sign mail with GPG
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, quilt-dev <quilt-dev@nongnu.org>
Cc: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Date: Mon, 10 Oct 2011 12:08:28 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1318262910.7904.94.camel@gandalf.stny.rr.com>
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

Added the quilt mail option --gpg that will sign the prologue and
patches with the users default key.

-u can be used to pick a key different than the default.

Thanks to Peter Zijlstra for recommending --use-agent to solve the
issues of both the passphrase in unlocked memory, and typing something
wrong.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/Makefile.in b/Makefile.in
index bdf015d..e509a55 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -83,7 +83,7 @@ SRC +=		$(QUILT_SRC:%=quilt/%)
 DIRT +=		$(QUILT_IN:%=quilt/%)
 
 SCRIPTS_IN :=	patchfns parse-patch inspect dependency-graph edmail	\
-		remove-trailing-ws
+		remove-trailing-ws gpgmail gpgvmail
 
 SCRIPTS_SRC :=	$(SCRIPTS_IN:%=%.in)
 SCRIPTS :=	$(SCRIPTS_IN)
@@ -397,6 +397,8 @@ test/.depend : Makefile $(TESTS)
 	    -e 's:quilt/mail:quilt/mail quilt/scripts/edmail:' \
 	    -e 's:quilt/refresh:quilt/refresh quilt/scripts/remove-trailing-ws:' \
 	    -e 's:quilt/setup:quilt/setup quilt/scripts/inspect:' \
+	    -e 's:quilt/setup:quilt/setup quilt/scripts/gpgmail:' \
+	    -e 's:quilt/setup:quilt/setup quilt/scripts/gpgvmail:' \
 	  > $@
 
 ifneq ($(shell . $(QUILTRC) ;  echo $$QUILT_PATCHES_PREFIX),)
diff --git a/quilt/mail.in b/quilt/mail.in
index 5752542..ba35114 100644
--- a/quilt/mail.in
+++ b/quilt/mail.in
@@ -21,7 +21,7 @@ fi
 
 usage()
 {
-	printf $"Usage: quilt mail {--mbox file|--send} [-m text] [--prefix prefix] [--sender ...] [--from ...] [--to ...] [--cc ...] [--bcc ...] [--subject ...] [--reply-to message] [first_patch [last_patch]]\n"
+	printf $"Usage: quilt mail {--mbox file|--send} [-m text] [--prefix prefix] [--sender ...] [--from ...] [--to ...] [--cc ...] [--bcc ...] [--subject ...] [--reply-to message][--gpg [-u ID]] [first_patch [last_patch]]\n"
 	if [ x$1 = x-h ]
 	then
 		printf $"
@@ -65,6 +65,12 @@ first, and a last patch name of \`-' denotes the last patch in the series.
 
 --reply-to message
 	Add the appropriate headers to reply to the specified message.
+
+--gpg
+	Sign email with GPG signatures.
+
+-u ID
+	Use ID as the GPG key id.
 " "@DOCSUBDIR@/README.MAIL"
 		exit 0
 	else
@@ -121,6 +127,20 @@ references_header() {
 	[ -n "$references" ] && echo "References: $references"
 }
 
+sign_mail()
+{
+	if [ -z "$opt_gpg" ]; then
+		cat
+	else
+		local tmpfile=$(gen_tempfile)
+
+		$QUILT_DIR/scripts/gpgmail.pl --agent $opt_gpgid > $tmpfile || exit 1
+		$QUILT_DIR/scripts/gpgvmail.pl $opt_gpgid $tmpfile || exit 1
+		cat $tmpfile;
+		rm -r $tmpfile;
+	fi
+}
+	
 process_mail()
 {
 	local tmpfile=$(gen_tempfile)
@@ -138,12 +158,12 @@ process_mail()
 			${QUILT_SENDMAIL_ARGS--f "$opt_sender"} "$@"
 		$QUILT_DIR/scripts/edmail --charset $opt_charset \
 				 --remove-header Bcc "$@" < $tmpfile \
-		| ${QUILT_SENDMAIL:-sendmail} \
+		| sign_mail | ${QUILT_SENDMAIL:-sendmail} \
 			${QUILT_SENDMAIL_ARGS--f "$opt_sender"} "$@"
 	else
 		local from_date=$(date "+%a %b %e %H:%M:%S %Y")
 		echo "From $opt_sender_address $from_date"
-		sed -e 's/^From />From /' $tmpfile
+		sed -e 's/^From />From /' $tmpfile | sign_mail
 		echo
 	fi
 	rm -f $tmpfile
@@ -159,8 +179,8 @@ join_lines() {
 	'
 }
 
-options=`getopt -o m:h --long from:,to:,cc:,bcc:,subject: \
-		       --long send,mbox:,charset:,sender: \
+options=`getopt -o m:u:h --long from:,to:,cc:,bcc:,subject: \
+		       --long send,gpg,mbox:,charset:,sender: \
 		       --long prefix:,reply-to:,signature: -- "$@"`
 
 if [ $? -ne 0 ]
@@ -215,6 +235,12 @@ do
 	--reply-to)
 		opt_reply_to=$2
 		shift 2 ;;
+	--gpg)
+		opt_gpg=1
+		shift ;;
+	-u)
+		opt_gpgid="-u $2"
+		shift 2;;
 	--signature)
 		if [ "$2" = - ]
 		then
diff --git a/quilt/scripts/gpgmail.in b/quilt/scripts/gpgmail.in
new file mode 100644
index 0000000..57151af
--- /dev/null
+++ b/quilt/scripts/gpgmail.in
@@ -0,0 +1,144 @@
+#! @PERL@ -w
+
+use strict;
+
+use MIME::QuotedPrint;
+use Getopt::Long;
+
+my $agent = 0;
+my $pass = "";
+my $gpgid = "";
+
+my $result = GetOptions(
+    "passwd=s"	=>	\$pass,
+    "u=s"	=>	\$gpgid,
+    "agent"	=>	\$agent,
+    );
+
+if (length($gpgid) > 0) {
+    $gpgid = "-u $gpgid";
+}
+
+if ($agent) {
+    $pass = " --use-agent ";
+} elsif (length($pass)) {
+    $pass = " --passphrase $pass ";
+}
+
+if ($#ARGV >= 0) {
+    open(IN, $ARGV[0]) or die "can't read $ARGV[0]";
+} else {
+    *IN = *STDIN;
+}
+
+my $debug = 0;
+my $debugfile = "/tmp/debug-gpgmail.pl";
+if ($debug) {
+    open (OUT, ">", $debugfile) or die "Can't open debug file $debugfile";
+} else {
+    *OUT = *STDOUT;
+}
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
+    
+if ($convert) {
+    foreach my $line (@rest) {
+	$line = encode_qp($line,"\r\n");
+	$line =~ s/^From />From /;
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
+    $line =~ s/\r//g;
+}
+
+print OUT @lines;
+
+print OUT "\n";
+print OUT "--$scissor\n";
+
+my $pgp = `gpg --simple-sk-checksum -a --detach-sign $gpgid $pass --output - < $tmpfile`;
+my $ret = $?;
+
+unlink $tmpfile;
+
+$ret == 0 or die "Error processing gpg signature.";
+
+print OUT "Content-Type: application/pgp-signature; name=\"signature.asc\"\n";
+print OUT "Content-Description: This is a digitally signed message part\n";
+print OUT "\n";
+
+print OUT $pgp;
+
+print OUT "\n";
+print OUT "--$scissor--\n";
+
+if ($debug) {
+    close OUT;
+    open (DEBUG, $debugfile) or die "Can not reopen debug file $debug";
+    print <DEBUG>;
+    close DEBUG;
+}
+exit 0;
diff --git a/quilt/scripts/gpgvmail.in b/quilt/scripts/gpgvmail.in
new file mode 100644
index 0000000..ffe2c6f
--- /dev/null
+++ b/quilt/scripts/gpgvmail.in
@@ -0,0 +1,121 @@
+#! @PERL@ -w
+
+use strict;
+
+use Getopt::Long;
+
+my $gpgid = "";
+my $quiet = 0;
+
+my $result = GetOptions(
+    "u=s"	=>	\$gpgid,
+    "q"		=>	\$quiet,
+    );
+
+if (length($gpgid) > 0) {
+    $gpgid = "-u $gpgid";
+}
+
+sub report {
+    my @args = @_;
+
+    if (!$quiet) {
+	print @args;
+    }
+}
+
+if ($#ARGV >= 0) {
+    open(IN, $ARGV[0]) or die "can't read $ARGV[0]";
+} else {
+    *IN = *STDIN;
+}
+
+my $pgp_found = 0;
+my $scissor;
+
+while (<IN>) {
+    if (m,^Content-Type.*application/pgp-signature,) {
+	if (/boundary="(.*?)"/) {
+	    $scissor = $1;
+	} else {
+	    report "can only verify MIME encoded PGP signatures\n";
+	    exit 1;
+	}
+	
+	$pgp_found = 1;
+
+    } elsif (m,^Content-Type.*application/pgp-signature,) {
+	$pgp_found = 1;
+
+    } elsif (/^$/) {
+	last;
+    }
+}
+
+if (!$pgp_found) {
+    report "Not a PGP signature email\n";
+    exit 1;
+}
+
+my $mime = 0;
+my @data;
+my @pgp;
+
+while (<IN>) {
+
+    # clean all CR/LF endings
+    s/\r$//;
+
+    if ($mime == 1) {
+	my $line = $_;
+	$line =~ s/$/\r/;
+	$data[$#data + 1] = $line;
+
+    } elsif ($mime == 2) {
+	$pgp[$#pgp + 1] = $_;
+    }
+
+    if (/^--$scissor(--)?$/) {
+	if ($mime == 1) {
+	    # need to remove this and the last line
+	    pop @data;
+	    pop @data;
+	}
+	$mime++;
+    }
+}
+
+if ($#data < 0) {
+    report "No data found\n";
+    exit 1;
+}
+
+if ($#pgp < 0) {
+    report "No PGP signature found\n";
+    exit 1;
+}
+
+my $stmpfile = "/tmp/gpgvmail-s.$$";
+my $dtmpfile = "/tmp/gpgvmail-d.$$";
+
+open (OUT, ">", $stmpfile) or die "Can not create $stmpfile";
+print OUT @pgp;
+close OUT;
+
+open (OUT, ">", $dtmpfile) or die "Can not create $dtmpfile";
+print OUT @data;
+close OUT;
+
+my $q = "";
+
+if ($quiet) {
+    $q = " -q ";
+}
+
+`gpg --verify $gpgid $q $stmpfile $dtmpfile`;
+my $ret = $?;
+
+unlink $stmpfile;
+unlink $dtmpfile;
+
+exit $?;


