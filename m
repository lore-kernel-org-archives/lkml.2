Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab2IYXiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 19:38:24 -0400
Received: from nm40-vm5.bullet.mail.bf1.yahoo.com ([72.30.239.213]:23180 "HELO
	nm40-vm5.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754408Ab2IYXiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 19:38:20 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Sep 2012 19:38:20 EDT
X-Yahoo-Newman-Id: 453433.71430.bm@smtp103.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: .w4cS0cVM1k7rnogjD2hRLwL3Hm1px8951jLTKTVqilds9O
 o.sD.x7q36gyNQsNcFR4QZ0K4bMcGQ8mHXIgTZvOb.S0rNhFOF17kgf65hPv
 CzKO.qM5Okj5.TWXLQsPLiYBlKbE1rmb7LjfDT5NS3ivvgjR1Jt8egCGmqux
 NX21LoBXTgQu752zzTidXMLn.l5epOYa755aYKpD36kR3h3eT9g2x6rY46F7
 VkL12ynqeIsxJh2WoRpTLxT3nykPU53ZIE0ImsgPpms2oysExBmB5L7JnF42
 JJIlrfweI0Zn4RuVKjgDar0XyMXJy.ArGDi2cbBXgh9YDne3GysgLKrraLOW
 nuHA4vUAN08429bpnNZwnO390G0vJKHsc2gIFQ229MQF8ibQJNxGZtlMk6GI
 wmtc2LLwBaeWN_zHYNBTsgZANDj6ox.woRRQIHVdFzQn3IjQrQKC0
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: Randy Dunlap <rdunlap@xenotime.net>, Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Richard Weinberger <richard@nod.at>,
        LKML <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Cc: Daniel Santos <daniel.santos@pobox.com>
Subject: [PATCH v5 16/25] kernel-doc: bugfix - empty line in Example section
Date: Tue, 25 Sep 2012 18:31:40 -0500
Message-Id: <1348615900-10490-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
References: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you have a section named "Example" that contains an empty line,
attempting to generate htmldocs give you the error:

/path/Documentation/DocBook/kernel-api.xml:3455: parser error : Opening and ending tag mismatch: programlisting line 3449 and para
   </para><para>
          ^
/path/Documentation/DocBook/kernel-api.xml:3473: parser error : Opening and ending tag mismatch: para line 3467 and programlisting
</programlisting></informalexample>
                 ^
/path/Documentation/DocBook/kernel-api.xml:3678: parser error : Opening and ending tag mismatch: programlisting line 3672 and para
   </para><para>
          ^
/path/Documentation/DocBook/kernel-api.xml:3701: parser error : Opening and ending tag mismatch: para line 3690 and programlisting
</programlisting></informalexample>
                 ^
unable to parse
/path/Documentation/DocBook/kernel-api.xml

Essentially, the script attempts to close a <programlisting> with a
closing tag for a <para> block.  This patch corrects the problem by
simply not outputting anything extra when we're dumping pre-formatted
text, since the empty line will be rendered correctly anyway.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 scripts/kernel-doc |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 55ab5e4..69efb2f 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -230,6 +230,7 @@ my $dohighlight = "";
 
 my $verbose = 0;
 my $output_mode = "man";
+my $output_preformatted = 0;
 my $no_doc_sections = 0;
 my %highlights = %highlights_man;
 my $blankline = $blankline_man;
@@ -460,7 +461,9 @@ sub output_highlight {
 
     foreach $line (split "\n", $contents) {
 	if ($line eq ""){
-	    print $lineprefix, local_unescape($blankline);
+	    if (! $output_preformatted) {
+		print $lineprefix, local_unescape($blankline);
+	    }
 	} else {
 	    $line =~ s/\\\\\\/\&/g;
 	    if ($output_mode eq "man" && substr($line, 0, 1) eq ".") {
@@ -643,10 +646,12 @@ sub output_section_xml(%) {
 	print "<title>$section</title>\n";
 	if ($section =~ m/EXAMPLE/i) {
 	    print "<informalexample><programlisting>\n";
+	    $output_preformatted = 1;
 	} else {
 	    print "<para>\n";
 	}
 	output_highlight($args{'sections'}{$section});
+	$output_preformatted = 0;
 	if ($section =~ m/EXAMPLE/i) {
 	    print "</programlisting></informalexample>\n";
 	} else {
@@ -949,10 +954,12 @@ sub output_blockhead_xml(%) {
 	}
 	if ($section =~ m/EXAMPLE/i) {
 	    print "<example><para>\n";
+	    $output_preformatted = 1;
 	} else {
 	    print "<para>\n";
 	}
 	output_highlight($args{'sections'}{$section});
+	$output_preformatted = 0;
 	if ($section =~ m/EXAMPLE/i) {
 	    print "</para></example>\n";
 	} else {
@@ -1028,10 +1035,12 @@ sub output_function_gnome {
 	print "<simplesect>\n <title>$section</title>\n";
 	if ($section =~ m/EXAMPLE/i) {
 	    print "<example><programlisting>\n";
+	    $output_preformatted = 1;
 	} else {
 	}
 	print "<para>\n";
 	output_highlight($args{'sections'}{$section});
+	$output_preformatted = 0;
 	print "</para>\n";
 	if ($section =~ m/EXAMPLE/i) {
 	    print "</programlisting></example>\n";
-- 
1.7.3.4

