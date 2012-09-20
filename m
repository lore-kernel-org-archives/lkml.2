Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab2ITJp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 05:45:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708Ab2ITJpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 05:45:55 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1209191416060.29525@tundra.namei.org>
References: <alpine.LRH.2.02.1209191416060.29525@tundra.namei.org> <20120914103930.1e16ad8b@pyramind.ukuu.org.uk> <20120913234802.3575.77103.stgit@warthog.procyon.org.uk> <20120913235005.3575.46218.stgit@warthog.procyon.org.uk> <13189.1347989652@warthog.procyon.org.uk> <20120918195115.6ddcf5fc@pyramind.ukuu.org.uk>
To: James Morris <jmorris@namei.org>
Cc: dhowells@redhat.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        herbert@gondor.hengli.com.au, pjones@redhat.com, rusty@rustcorp.com.au,
        linux-crypto@vger.kernel.org, zohar@us.ibm.com,
        dmitry.kasatkin@intel.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/16] X.509: Add an ASN.1 decoder
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Date: Thu, 20 Sep 2012 10:45:17 +0100
Message-ID: <27143.1348134317@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain

James Morris <jmorris@namei.org> wrote:

> I'd like to see some serious effort at code review and testing before this 
> code is merged.

With regard to testing, I've run multiple simultaneous instances of a number
of test scripts against it continuously for the best part of a day:

 (1) A script to generate completely random data and attempt to stuff that
     into a key.  The completely random data blob is fed wholly and then
     partially in decreasing amounts to keyctl padd.  Then the script loops
     and starts again.

	./fuzz-x509.sh /tmp/data1

 (2) A script to generate random valid ASN.1:

	while :; do ./asn1random.pl | keyctl padd asymmetric vlad @s; done

 (3) A script to generate correctly formatted X.509 certificates filled with
     random data, including for the RSA key and signature fields.

	while :; do ./x509random.pl | keyctl padd asymmetric vlad @s; done

 (4) A variant of (3) that injects random bytes into the structure, whilst
     correctly maintaining the length counts outside of those.

	while :; do ./x509random.pl -i | keyctl padd asymmetric vlad @s; done

 (5) A script to repeatedly generate valid X.509 certificates and stuff those
     in, and then generate valid PKCS#7 signatures over random data and try to
     stuff those in too (which should fail).

	./x509-stuffer.sh

David


--=-=-=
Content-Type: text/x-shellscript
Content-Disposition: attachment; filename=fuzz-x509.sh
Content-Description: Random data stuffer script

#!/bin/sh
#
# Generate completely random data and attempt to stuff that into a key.
#
# Format:
#
#	fuzz-x509.sh [<tmpfile-prefix>]
#
file=/tmp/data
if [ "$1" != "" ]
then
    file=$1
fi

cd /tmp
sync

declare -i n i j k

while true
do
    n=$RANDOM
    j=$RANDOM
    j=j%10
    k=0
    echo $n $j

    dd if=/dev/urandom of=$file bs=$n count=1
    for ((i=1; i<n; i=i+k))
    do
	dd if=$file bs=$i count=1 2>/dev/null |
	keyctl padd asymmetric foo @s 2>/dev/null
	k=k+1
	if [ $k -eq 10 ]
	    then
	    echo -n .
	    k=0
	fi
    done
    echo
done

--=-=-=
Content-Type: text/x-perl
Content-Disposition: attachment; filename=asn1random.pl
Content-Description: Valid random ASN.1 generator script

#!/usr/bin/perl -w
#
# Generate random but valid ASN.1 data.
#
# Format:
#
#	asn1random.pl >output
#
use strict;

my $depth = 0;
my $maxdepth = 12;

print STDERR "SEED: ", srand(), "\n";

###############################################################################
#
# Generate a header
#
###############################################################################
sub emit_asn1_hdr($$)
{
    my ($tag, $len) = @_;
    my $output = "";
    my $l;

    if ($len < 0x80) {
	$l = $len;
    } elsif ($len <= 0xff) {
	$l = 0x81;
    } elsif ($len <= 0xffff) {
	$l = 0x82;
    } elsif ($len <= 0xffffff) {
	$l = 0x83;
    } else {
	$l = 0x84;
    }

    $output .= pack("CC", $tag == -1 ? int(rand(255)) & ~0x20 : $tag, $l);
    if ($len < 0x80) {
    } elsif ($len <= 0xff) {
	$output .= pack("C", $len);
    } elsif ($len <= 0xffff) {
	$output .= pack("n", $len);
    } elsif ($len <= 0xffffff) {
	$output .= pack("Cn", $len >> 16, $len & 0xffff);
    } else {
	$output .= pack("N", $len);
    }

    return $output;
}

###############################################################################
#
# Generate a random primitive
#
###############################################################################
sub emit_asn1_prim($)
{
    my ($tag) = @_;
    my $output;
    my $len = int(rand(255));

    $tag = int(rand(255)) & ~0x20
	if ($tag == -1);

    $output = emit_asn1_hdr($tag, $len);

    my $i = $len;
    while ($i > 16) {
	$output .= "abcdefghijklmnop";
	$i -= 16;
    }

    $output .= substr("abcdefghijklmnop", 0, $i);
    return $output;
}

###############################################################################
#
# Generate a random construct
#
###############################################################################
sub emit_asn1_cons($);
sub emit_asn1_cons($)
{
    my $output = "";
    my $count = int(rand(20));
    my ($tag) = @_;

    if ($depth >= $maxdepth) {
	return emit_asn1_prim($tag);
    }

    if ($tag == -1) {
	$tag = int(rand(255)) & ~0x20;
	if ($tag < 0x40 && $tag != 0x11) {
	    $tag = 0x10;
	}
	$tag |= 0x20;
    }

    $depth++;
    while ($count > 0) {
	if (int(rand(4 + $depth)) == 1) {
	    $output .= emit_asn1_cons(-1);
	} else {
	    $output .= emit_asn1_prim(-1);
	}
	$count--;
    }
    $depth--;

    return emit_asn1_hdr($tag, length($output)) . $output;
}

print emit_asn1_cons(-1);

--=-=-=
Content-Type: text/x-perl
Content-Disposition: attachment; filename=x509random.pl
Content-Description: Validly formatted random X.509 generator script

#!/usr/bin/perl -w
#
# Generate validly formatted X.509 certificates filled with mostly random data,
# including for the RSA key and signature fields (so it is extremely improbable
# that key will be useful and the signature will verify).
#
# If an argument of any sort is passed this will cause random bytes to be
# inserted into the ASN.1 structure (whilst keeping the lengths of the wrapping
# constructed elements correct).
#
# Format:
#
#	x509random.pl [-i] >output
#
use strict;

print STDERR "SEED: ", srand(), "\n";

my $do_inject = ($#ARGV == 0);

my $UNIV = 0 << 6;
my $APPL = 1 << 6;
my $CONT = 2 << 6;
my $PRIV = 3 << 6;

my $BOOLEAN	= 0x01;
my $INTEGER	= 0x02;
my $BIT_STRING	= 0x03;
my $OCTET_STRING = 0x04;
my $NULL	= 0x05;
my $OBJ_ID	= 0x06;
my $UTF8String	= 0x0c;
my $SEQUENCE	= 0x10;
my $SET		= 0x11;
my $UTCTime	= 0x17;
my $GeneralizedTime = 0x18;

sub maybe($)
{
    return (int(rand(6)) == 0) ? '' : $_[0];
}

###############################################################################
#
# Generate a header
#
###############################################################################
sub emit_asn1_hdr($$)
{
    my ($tag, $len) = @_;
    my $output = "";
    my $l;

    if ($len < 0x80) {
	$l = $len;
    } elsif ($len <= 0xff) {
	$l = 0x81;
    } elsif ($len <= 0xffff) {
	$l = 0x82;
    } elsif ($len <= 0xffffff) {
	$l = 0x83;
    } else {
	$l = 0x84;
    }

    $output .= pack("CC", $tag == -1 ? int(rand(255)) & ~0x20 : $tag, $l);
    if ($len < 0x80) {
    } elsif ($len <= 0xff) {
	$output .= pack("C", $len);
    } elsif ($len <= 0xffff) {
	$output .= pack("n", $len);
    } elsif ($len <= 0xffffff) {
	$output .= pack("Cn", $len >> 16, $len & 0xffff);
    } else {
	$output .= pack("N", $len);
    }

    return $output;
}

###############################################################################
#
# Generate random data
#
###############################################################################
sub emit_random_data($$)
{
    my ($minlen, $maxlen) = @_;
    my $output = '';

    my $len = $minlen + int(rand($maxlen - $minlen));

    my $i = $len;
    while ($i > 16) {
	$output .= "abcdefghijklmnop";
	$i -= 16;
    }

    $output .= substr("abcdefghijklmnop", 0, $i);
    return $output;
}

###############################################################################
#
# Generate a primitive containing some random data
#
###############################################################################
sub emit_asn1_prim(@)
{
    my ($class, $tag, $minlen, $maxlen) = @_;
    my $content;

    $minlen = 0 if (!$minlen);
    $maxlen = 255 if (!$maxlen);
    $content = ($tag == $NULL) ? '' : emit_random_data($minlen, $maxlen);

    $tag |= $class;
    return emit_asn1_hdr($tag, length($content)) . $content;
}

###############################################################################
#
# Generate an object identifier
#
###############################################################################
my %OIDs = (
    commonName => pack("CCC", 85, 4, 3),
    countryName => pack("CCC", 85, 4, 6),
    organizationName => pack("CCC", 85, 4, 10),
    organizationUnitName => pack("CCC", 85, 4, 11),
    rsaEncryption => pack("CCCCCCCCC", 42, 134, 72, 134, 247, 13, 1, 1, 1),
    sha1WithRSAEncryption => pack("CCCCCCCCC", 42, 134, 72, 134, 247, 13, 1, 1, 5),
    authorityKeyIdentifier => pack("CCC", 85, 29, 35),
    subjectKeyIdentifier => pack("CCC", 85, 29, 14),
    basicConstraints => pack("CCC", 85, 29, 19)
);

sub emit_asn1_OID($$$)
{
    my ($class, $tag, $oid_name) = @_;
    my $oid;
    my $len;

    if (!exists($OIDs{$oid_name})) {
	print STDERR "Unknown OID: $oid_name\n";
	exit(2);
    }

    $oid = $OIDs{$oid_name};
    $len = length($oid);

    $tag |= $class;

    return emit_asn1_hdr($tag, $len) . $oid;
}

###############################################################################
#
# Generate a UTC time
#
###############################################################################
sub emit_asn1_utctime($$)
{
    my ($class, $tag) = @_;
    my $output = "";
    my $len;

    for (my $i = 0; $i < 12; $i++) {
	$output .= pack("C", int(rand(9)) + 0x30);
    }
    $output .= 'Z';

    $len = length($output);

    $tag |= $class;

    return emit_asn1_hdr($tag, $len) . $output;
}

###############################################################################
#
# Generate a generalized time
#
###############################################################################
sub emit_asn1_gentime($$)
{
    my ($class, $tag) = @_;
    my $output = "";
    my $len;

    for (my $i = 0; $i < 14; $i++) {
	$output .= pack("C", int(rand(9)) + 0x30);
    }
    $output .= 'Z';

    $len = length($output);

    $tag |= $class;

    return emit_asn1_hdr($tag, $len) . $output;
}

###############################################################################
#
# Generate a construct
#
###############################################################################
sub emit_asn1_cons($$$)
{
    my ($class, $tag, $content) = @_;
    my $inject = '';

    if ($do_inject) {
	if (int(rand(20)) == 0) {
	    $inject = pack("C", int(rand(255)));
	}
    }

    $tag |= $class | 0x20;
    return emit_asn1_hdr($tag, length($content)) . $content . $inject;
}

###############################################################################
#
# Generate a name
#
###############################################################################
sub emit_x509_AttributeValueAssertion($@)
{
    my ($type, $min, $max) = @_;
    my $output;
    $output  = emit_asn1_OID($UNIV, $OBJ_ID, $type);	# attributeType
    $output .= emit_asn1_prim($UNIV, $UTF8String, $min, $max);	# attributeValue
    return emit_asn1_cons($UNIV, $SEQUENCE, $output);
}

sub emit_x509_RelativeDistinguishedName()
{
    my $output;
    # Set of AttributeValueAssertion
    $output  = emit_x509_AttributeValueAssertion("countryName", 2, 2);
    $output .= emit_x509_AttributeValueAssertion("organizationName", 3, 10);
    $output .= emit_x509_AttributeValueAssertion("organizationUnitName", 3, 10);
    $output .= emit_x509_AttributeValueAssertion("commonName", 4, 16);
    return emit_asn1_cons($UNIV, $SET, $output);
}

sub emit_x509_Name()
{
    my $output;
    # Sequence of RDN
    $output  = emit_x509_RelativeDistinguishedName();
    return emit_asn1_cons($UNIV, $SEQUENCE, $output);
}

###############################################################################
#
# Generate some X.509 extensions
#
###############################################################################
sub emit_x509_SubjectKeyIdentifier()
{
    my $content = emit_asn1_prim($UNIV, $OCTET_STRING, 10, 20);
    return $content;
}

sub emit_x509_AuthorityKeyIdentifier()
{
    my $content = emit_asn1_prim($CONT, 0, 10, 20);
    my $wrapper = emit_asn1_cons($UNIV, $SEQUENCE, $content);
    return $wrapper;
}

sub emit_x509_BasicConstraints()
{
    my $content = emit_asn1_prim($UNIV, $BIT_STRING, 1, 7);
    return $content;
}

sub emit_x509_Extension($)
{
    my ($ext) = @_;
    my $output;
    my $value = "";

    if ($ext eq "authorityKeyIdentifier") {
	$output = emit_asn1_OID($UNIV, $OBJ_ID, $ext);
	$value = emit_x509_AuthorityKeyIdentifier();
    } elsif ($ext eq "subjectKeyIdentifier") {
	$output = emit_asn1_OID($UNIV, $OBJ_ID, $ext);
	$value = emit_x509_SubjectKeyIdentifier();
    } elsif ($ext eq "basicConstraints") {
	$output = emit_asn1_OID($UNIV, $OBJ_ID, $ext);
	$value = emit_x509_BasicConstraints();
    } else {
	$output = emit_asn1_prim($UNIV, $OBJ_ID, 3, 10);
	$value = emit_random_data(10, 20);
    }

    $output .= maybe emit_asn1_prim($UNIV, $BOOLEAN, 1, 1);	# critical
    $output .= emit_asn1_hdr($UNIV | $OCTET_STRING, length($value)) . $value;

    return emit_asn1_cons($UNIV, $SEQUENCE, $output);
}

sub emit_x509_Extensions()
{
    my $output = "";

    # Probably do want a sequence of extensions here
    $output .= maybe emit_x509_Extension("authorityKeyIdentifier");
    $output .= maybe emit_x509_Extension("subjectKeyIdentifier");
    $output .= maybe emit_x509_Extension("basicConstraints");
    $output .= maybe emit_x509_Extension("");
    $output .= maybe emit_x509_Extension("");
    $output .= maybe emit_x509_Extension("");
    $output .= maybe emit_x509_Extension("");

    return emit_asn1_cons($CONT, 3, emit_asn1_cons($UNIV, $SEQUENCE, $output));
}

###############################################################################
#
# Generate an X.509 certificate
#
###############################################################################
sub emit_x509_Time()
{
    # UTCTime or GeneralizedTime
    if (int(rand(2)) == 0) {
	return emit_asn1_utctime($UNIV, $UTCTime);
    } else {
	return emit_asn1_gentime($UNIV, $GeneralizedTime);
    }
}

sub emit_x509_Validity()
{
    my $output;
    $output  = emit_x509_Time();			# notBefore
    $output .= emit_x509_Time();			# notAfter
    return emit_asn1_cons($UNIV, $SEQUENCE, $output);
}

sub emit_x509_AlgorithmIdentifier($)
{
    my ($oid) = @_;
    my $output;
 
    #$output  = emit_asn1_prim($UNIV, $OBJ_ID);		# algorithm
    $output  = emit_asn1_OID($UNIV, $OBJ_ID, $oid); # algorithm
    $output .= emit_asn1_prim($UNIV, $NULL);		# parameters
    return emit_asn1_cons($UNIV, $SEQUENCE, $output);
}

sub emit_x509_Version()
{
    my $output = emit_asn1_prim($UNIV, $INTEGER, 0, 3);
    return emit_asn1_cons($CONT, 0, $output);
}

sub emit_x509_SubjectPublicKeyInfo()
{
    my $output;
    $output  = emit_x509_AlgorithmIdentifier("rsaEncryption");	# algorithm
    $output .= emit_asn1_prim($UNIV, $BIT_STRING);	# subjectPublicKey
    return emit_asn1_cons($UNIV, $SEQUENCE, $output);
}

sub emit_x509_TBSCertificate()
{
    my $output;

    $output  = emit_x509_Version;			# version
    $output .= emit_asn1_prim($UNIV, $INTEGER);		# serialNumber
    $output .= emit_x509_AlgorithmIdentifier("sha1WithRSAEncryption");	# signature
    $output .= emit_x509_Name();			# issuer
    $output .= emit_x509_Validity();			# validity
    $output .= emit_x509_Name();			# subject
    $output .= emit_x509_SubjectPublicKeyInfo();	# subjectPublicKeyInfo
    $output .= maybe emit_asn1_prim($CONT, 1);		# issuerUniqueID
    $output .= maybe emit_asn1_prim($CONT, 2);		# subjectUniqueID
    $output .= emit_x509_Extensions();			# extensions

    return emit_asn1_cons($UNIV, $SEQUENCE, $output);
}

sub emit_x509_Certificate()
{
    my $output;

    $output  = emit_x509_TBSCertificate();		# tbsCertificate
    $output .= emit_x509_AlgorithmIdentifier("sha1WithRSAEncryption");	# signatureAlgorithm
    $output .= emit_asn1_prim($UNIV, $BIT_STRING);	# signature

    return emit_asn1_cons($UNIV, $SEQUENCE, $output);
}

print emit_x509_Certificate();

--=-=-=
Content-Type: text/x-shellscript
Content-Disposition: inline; filename=x509-stuffer.sh
Content-Description: Valid X.509 and PKCS7 stuffer script

#!/bin/sh
#
# Generate an X.509 certificate and stuff that into a key, then generate a
# PKCS#7 cert from that over some random data and stuff that into a key.
#
# Format:
#
#	x509-stuffer.sh [<tmpfile-prefix>]
#
file=/tmp/x509cert
if [ "$1" != "" ]
then
    file=$1
fi

cd /tmp
sync

while true
do
    openssl req -new -x509 -outform PEM -keyout $file.pem -nodes -subj "/CN=GB/O=Red Hat/OU=Magrathea/CN=Slartibartfast" -out $file.x509 || exit $?

    openssl x509 -in $file.x509 -inform PEM -outform DER >$file.x509.asn1 || exit $?
    keyctl padd asymmetric bar @s <$file.x509.asn1 || exit $?

    n=$RANDOM
    if [ $n -lt 10 ]; then n=10; fi
    dd if=/dev/urandom of=$file.stuff bs=$n count=1

    openssl smime -sign -inkey $file.pem -signer $file.x509 -keyform PEM \
	-in $file.stuff -out $file.pkcs7 -binary -outform DER || exit $?

    keyctl padd asymmetric baz @s <$file.pkcs7
done

--=-=-=--
