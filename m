Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab2JRFfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 01:35:01 -0400
Received: from ozlabs.org ([203.10.76.45]:60183 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951Ab2JRFe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 01:34:58 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: RFC: sign the modules at install time
In-Reply-To: <CA+55aFxZdtD51AVKLtKK95ooh8VB8-5Tt8nHsxSUT67CBRrp2g@mail.gmail.com>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com> <87txtso9xw.fsf@rustcorp.com.au> <CA+55aFxZdtD51AVKLtKK95ooh8VB8-5Tt8nHsxSUT67CBRrp2g@mail.gmail.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 18 Oct 2012 16:04:28 +1030
Message-ID: <871ugwny1n.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
> On Wed, Oct 17, 2012 at 6:17 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>
>> You cut too much: you need genkeyid.
>
> Yeah, I sent out a fixed version later, but I much prefer your version
> that generates those files earlier, not a "make modules_install".

Still committing a minor crime by lying to make about dependencies...

Hacking the keyid and signer-name to be extracted every time by
sign-file takes my modules_install time from 18.6 seconds to 19.1.  We'd
get that back easily by making sign-file a perl script anyway; it calls
out to perl 3 times already.

David, want to take that on?  My perl skills are lame, as shown below.

> [ Btw, your email "Date:" field is from 2+ hours ago, but it hit
> ozlabs and then arrived here only minutes ago. There's some delay in
> your mail delivery. Maybe it's something you know about, and you're
> batching emails over carrier pigeons, but I thought I'd mention it in
> case you weren't aware of some odd SMTP delay ]

I rsync mail to/from ozlabs.org.  Manually, to avoid the
distraction-trickle.  I could cron the outoing.

It's let me revoke unsent mail a few times.  But maybe it's time to
embrace my uncanny ability to make a fool of myself?  So many hackers
seem to revel in it, and they're nowhere as accomplished at it as I
am...

>> And in a moment of optimism I tried 'make modules_install MODLIB=.' to
>> sign modules in-place.  It deleted my kernel/ dir.  Don't recommend.
>
> Heh. I assume that's an old "feature", not something that has anything
> to do with the whole signing thing.

Exactly. But would have a been a nice hack for in-place signing.

A separate (optional) module_sign target seems easier.

Cheers,
Rusty.

diff --git a/kernel/Makefile b/kernel/Makefile
index f7abe6c..0bfd665 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -139,13 +139,7 @@ ifeq ($(CONFIG_MODULE_SIG),y)
 extra_certificates:
 	touch $@
 
-quiet_cmd_genkeyid = GENKEYID $@
-      cmd_genkeyid = $(PERL) $(src)/x509keyid.pl $< $<.signer $<.keyid
-
-%.signer %.keyid: %
-	$(call if_changed,genkeyid)
-
-kernel/modsign_pubkey.o: signing_key.x509 extra_certificates $(MODPUBKEY).signer $(MODPUBKEY).keyid
+kernel/modsign_pubkey.o: signing_key.x509 extra_certificates
 
 
 ###############################################################################
diff --git a/kernel/x509keyid.pl b/kernel/x509keyid.pl
index c8e91a4..4241ec6 100755
--- a/kernel/x509keyid.pl
+++ b/kernel/x509keyid.pl
@@ -22,7 +22,7 @@ use strict;
 
 my $raw_data;
 
-die "Need three filenames\n" if ($#ARGV != 2);
+die "Need a filename [keyid|signer-name]\n" if ($#ARGV != 1);
 
 my $src = $ARGV[0];
 
@@ -259,10 +259,10 @@ die $src, ": ", "X.509: Couldn't find the Subject Key Identifier extension\n"
 
 my $id_key_id = asn1_retrieve($subject_key_id->[1]);
 
-open(OUTFD, ">$ARGV[1]") || die $ARGV[1];
-print OUTFD $id_name;
-close OUTFD || die $ARGV[1];
-
-open(OUTFD, ">$ARGV[2]") || die $ARGV[2];
-print OUTFD $id_key_id;
-close OUTFD || die $ARGV[2];
+if ($ARGV[1] eq "signer-name") {
+    print $id_name;
+} elsif ($ARGV[1] eq "keyid") {
+    print $id_key_id;
+} else {
+    die "Unknown arg";
+}
diff --git a/scripts/sign-file b/scripts/sign-file
index 3084ba4..ea76f43 100644
--- a/scripts/sign-file
+++ b/scripts/sign-file
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 #
 # Sign a module file using the given key.
 #
@@ -29,16 +29,6 @@ then
     echo "Can't read X.509 certificate" >&2
     exit 2
 fi
-if [ ! -r "$x509.signer" ]
-then
-    echo "Can't read Signer name" >&2
-    exit 2;
-fi
-if [ ! -r "$x509.keyid" ]
-then
-    echo "Can't read Key identifier" >&2
-    exit 2;
-fi
 
 #
 # Signature parameters
@@ -91,9 +81,11 @@ openssl dgst $dgst -binary $src || exit $?
 # the signature with no metadata attached.
 #
 openssl rsautl -sign -inkey $key -keyform PEM -in $src.dig -out $src.sig || exit $?
-signerlen=`stat -c %s $x509.signer`
-keyidlen=`stat -c %s $x509.keyid`
-siglen=`stat -c %s $src.sig`
+
+SIGNER="`perl kernel/x509keyid.pl $x509 signer-name`"
+KEYID="`perl kernel/x509keyid.pl $x509 keyid`"
+keyidlen=${#KEYID}
+siglen=${#SIGNER}
 
 #
 # Build the signed binary
@@ -101,7 +93,8 @@ siglen=`stat -c %s $src.sig`
 (
     cat $src || exit $?
     echo '~Module signature appended~' || exit $?
-    cat $x509.signer $x509.keyid || exit $?
+    echo -n "$SIGNER" || exit $?
+    echo -n "$KEYID" || exit $?
 
     # Preface each signature integer with a 2-byte BE length
     perl -e "binmode STDOUT; print pack(\"n\", $siglen)" || exit $?
