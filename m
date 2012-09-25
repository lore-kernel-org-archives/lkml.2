Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab2IYV53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 17:57:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab2IYV5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 17:57:25 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120925170020.07cf0b26@pyramind.ukuu.org.uk>
References: <20120925170020.07cf0b26@pyramind.ukuu.org.uk> <20120925163037.20ba3f3c@pyramind.ukuu.org.uk> <5555.1348531649@warthog.procyon.org.uk> <21845.1348585794@warthog.procyon.org.uk> <30071.1348587320@warthog.procyon.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dhowells@redhat.com, rusty@rustcorp.com.au, herbert@gondor.hengli.com.au,
        pjones@redhat.com, jwboyer@redhat.com, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@linux-nfs.org
Subject: Re: Wrong system clock vs X.509 date specifiers
Date: Tue, 25 Sep 2012 22:57:06 +0100
Message-ID: <25870.1348610226@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


How about the attached?  I knew perl had to be good for something...

David
---
#!/usr/bin/perl -w
#
# Generate an X.509 certificate from a public key.
#
# Format:
#
#	gen-x509-cert <private-key> \
#	   [C=<country>] [O=<org>] [CN=<cn>] [Email=<email>] \
#	   [--from=<secs-before-now>] [--to=<secs-after-now] >output
#
use strict;
use POSIX qw(strftime);

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
my $GeneralizedTime = 0x18;

my %OIDs = (
    commonName			=> pack("CCC", 85, 4, 3),
    countryName			=> pack("CCC", 85, 4, 6),
    organizationName		=> pack("CCC", 85, 4, 10),
    organizationUnitName	=> pack("CCC", 85, 4, 11),
    rsaEncryption		=> pack("CCCCCCCCC", 42, 134, 72, 134, 247, 13, 1, 1, 1),
    sha1WithRSAEncryption	=> pack("CCCCCCCCC", 42, 134, 72, 134, 247, 13, 1, 1, 5),
    emailAddress		=> pack("CCCCCCCCC", 42, 134, 72, 134, 247, 13, 1, 9, 1),
    authorityKeyIdentifier	=> pack("CCC", 85, 29, 35),
    subjectKeyIdentifier	=> pack("CCC", 85, 29, 14),
    keyUsage			=> pack("CCC", 85, 29, 15),
    basicConstraints		=> pack("CCC", 85, 29, 19)
);


#
# Set up the X.509 params
#
die "Format: <private-key> [options]"
    if ($#ARGV == -1);

my $privfilename = shift @ARGV;

my %subject_name;

if ($#ARGV == -1) {
    # Make something up if they don't want to admit to it
    $subject_name{"C"}		= 'h2g2',
    $subject_name{"O"}		= 'Magrathea',
    $subject_name{"CN"}		= 'Glacier signing key',
    $subject_name{"Email"}	= 'slartibartfast@magrathea.h2g2'
}

my $from = 7 * 24 * 60 * 60;
my $to = 36500 * 24 * 60 * 60;
foreach my $_ (@ARGV) {
    if (/--from=(.*)/) {
	$from = $1;
    } elsif (/--to=(.*)/) {
	$to = $1;
    } elsif (/([A-Z][A-Za-z]*)=(.*)/) {
	$subject_name{$1} = $2;
    } else {
	last;
    }
}

my $now = time();
my $valid_from = strftime("%Y%m%d%H%M%SZ", gmtime($now - $from));
my $valid_to   = strftime("%Y%m%d%H%M%SZ", gmtime($now + $to));

#
# openssl can be used to give us the public key in exactly the form we need -
# including ASN.1 wrappings - for inclusion in the certificate.
#
open PUBKEYFD, "openssl rsa -in $privfilename -pubout -outform DER 2>/dev/null |" ||
    die "Unable to process $privfilename through openssl rsa: $!\n";
binmode PUBKEYFD;

my $pubkey = "";
my $tmp;
while (read(PUBKEYFD, $tmp, 512)) {
    $pubkey .= $tmp;
}
close PUBKEYFD ||
    die "Unable to close channel to openssl rsa: $!\n";

#
# Generate a serial number
#
my $serial = "";
for (my $i = int(rand(6)) + 6; $i > 0; $i--) {
    $serial .= pack("C", rand(256));
}
$serial = pack("x") . $serial
    if (unpack("C", substr($serial, 0, 1)) >= 0x80);

#
# Generate the SubjectKeyIdentifier.  This is the ASN.1 sum of the contents of
# the bit string element from the public key.
#
die "Can't disassemble RSA public key wrapping\n"
    if (substr($pubkey,  0, 2) ne pack("n", 0x3082) ||
	substr($pubkey,  4, 4) ne pack("N", 0x300d0609) ||
	substr($pubkey,  8, 9) ne $OIDs{"rsaEncryption"} ||
	substr($pubkey, 17, 2) ne pack("n", 0x0500) ||
	substr($pubkey, 19, 2) ne pack("n", 0x0382) ||
	substr($pubkey, 23, 1) ne pack("C", 0x00));

my $key_data = substr($pubkey, 24);

sub sha1sum($)
{
    my ($data) = @_;

    my ($TO_RD, $TO_WR, $FROM_RD, $FROM_WR);
    pipe $TO_RD, $TO_WR;
    pipe $FROM_RD, $FROM_WR;

    my $sha1output;
    my $child = fork();
    if ($child == 0) {
	close $TO_WR;
	close $FROM_RD;
	open(STDIN, ">&", $TO_RD) or die "Can't direct $TO_RD to STDIN: $!";
	open(STDOUT, ">&", $FROM_WR) or die "Can't direct $FROM_WR to STDOUT: $!";
	close $TO_RD;
	close $FROM_WR;
	exec("sha1sum");
    } elsif (!$child) {
	die;
    } else {
	close $TO_RD;
	close $FROM_WR;
	binmode $TO_WR;
	syswrite $TO_WR, $data || die;
	close $TO_WR || die;
	$sha1output = <$FROM_RD> || die;
	close $FROM_RD;
	die "sha1sum failed\n"
	    if (waitpid($child, 0) != $child);
    }

    return pack("H*", substr($sha1output, 0, 40));
}

my $keyid = sha1sum($key_data);

###############################################################################
#
# Generate a header
#
###############################################################################
sub emit_asn1_hdr($$)
{
    my ($tag, $len) = @_;

    if ($len < 0x80) {
	return pack("CC",   $tag, $len);
    } elsif ($len <= 0xff) {
	return pack("CCC",   $tag, 0x81, $len);
    } elsif ($len <= 0xffff) {
	return pack("CCn",  $tag, 0x82, $len);
    } elsif ($len <= 0xffffff) {
	return pack("CCCn", $tag, 0x83, $len >> 16, $len & 0xffff);
    } else {
	return pack("CCN",  $tag, 0x84, $len);
    }
}

###############################################################################
#
# Generate a primitive containing some data
#
###############################################################################
sub emit_asn1_prim(@)
{
    my ($class, $tag, $data) = @_;

    $data = ""
	if ($#_ == 1);

    $tag |= $class;
    return emit_asn1_hdr($tag, length($data)) . $data;
}

###############################################################################
#
# Generate an object identifier
#
###############################################################################
sub emit_asn1_OID($$$)
{
    my ($class, $tag, $oid_name) = @_;
    my $oid;

    if (!exists($OIDs{$oid_name})) {
	print STDERR "Unknown OID: $oid_name\n";
	exit(2);
    }

    $oid = $OIDs{$oid_name};
    return emit_asn1_hdr($class | $tag, length($oid)) . $oid;
}

###############################################################################
#
# Generate a bit string.  This has a leading byte indicating the number of
# trailing bits that should be ignored.
#
###############################################################################
sub emit_asn1_bts($$$)
{
    my ($class, $tag, $content) = @_;
    return emit_asn1_prim($class, $tag, pack("x") . $content);
}

###############################################################################
#
# Generate a construct
#
###############################################################################
sub emit_asn1_cons($$$)
{
    my ($class, $tag, $content) = @_;

    return emit_asn1_hdr($class | 0x20 | $tag, length($content)) . $content;
}

###############################################################################
#
# Generate a name
#
###############################################################################
sub emit_x509_AttributeValueAssertion($$$)
{
    my ($type, $name, $sym) = @_;
    my $output;
    my $data;

    return "" if (!exists($name->{$sym}));

    $data = $name->{$sym};
    $output  = emit_asn1_OID($UNIV, $OBJ_ID, $type);		# attributeType
    $output .= emit_asn1_prim($UNIV, $UTF8String, $data);	# attributeValue
    return emit_asn1_cons($UNIV, $SET,
			  emit_asn1_cons($UNIV, $SEQUENCE, $output));
}

sub emit_x509_RelativeDistinguishedName($)
{
    my ($name) = @_;
    my $output;

    # SET OF AttributeValueAssertion
    $output .= emit_x509_AttributeValueAssertion("countryName", $name, "C");
    $output .= emit_x509_AttributeValueAssertion("organizationName", $name, "O");
    $output .= emit_x509_AttributeValueAssertion("organizationUnitName", $name, "OU");
    $output .= emit_x509_AttributeValueAssertion("commonName", $name, "CN");
    $output .= emit_x509_AttributeValueAssertion("emailAddress", $name, "Email");
    return $output;
}

sub emit_x509_Name($)
{
    my ($name) = @_;
    my $output;

    # SEQUENCE OF RDN
    $output  = emit_x509_RelativeDistinguishedName($name);
    return emit_asn1_cons($UNIV, $SEQUENCE, $output);
}

###############################################################################
#
# Generate some X.509 extensions
#
###############################################################################
sub emit_x509_SubjectKeyIdentifier()
{
    return emit_asn1_prim($UNIV, $OCTET_STRING, $keyid);
}

sub emit_x509_AuthorityKeyIdentifier()
{
    my $content = emit_asn1_prim($CONT, 0, $keyid);
    return emit_asn1_cons($UNIV, $SEQUENCE, $content);
}

sub emit_x509_BasicConstraints()
{
    return pack("CC", 0x30, 0x00);
}

sub emit_x509_KeyUsage()
{
    return emit_asn1_prim($UNIV, $BIT_STRING, pack("CC", 0x07, 0x80));
}

sub emit_x509_Extension($@)
{
    my ($ext, $crit) = @_;
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
    } elsif ($ext eq "keyUsage") {
	$output = emit_asn1_OID($UNIV, $OBJ_ID, $ext);
	$value = emit_x509_KeyUsage();
    } else {
	die;
    }

    $output .= emit_asn1_prim($UNIV, $BOOLEAN, pack("C", 0x01))	# critical
	if ($crit);
    $output .= emit_asn1_hdr($UNIV | $OCTET_STRING, length($value)) . $value;

    return emit_asn1_cons($UNIV, $SEQUENCE, $output);
}

sub emit_x509_Extensions()
{
    my $output = "";

    # Probably do want a sequence of extensions here
    $output .= emit_x509_Extension("basicConstraints", 1);
    $output .= emit_x509_Extension("keyUsage");
    $output .= emit_x509_Extension("authorityKeyIdentifier");
    $output .= emit_x509_Extension("subjectKeyIdentifier");

    return emit_asn1_cons($CONT, 3, emit_asn1_cons($UNIV, $SEQUENCE, $output));
}

###############################################################################
#
# Sign a digest with an RSA key
#
###############################################################################
sub rsa_sign($)
{
    my ($digest) = @_;

    my ($TO_RD, $TO_WR, $FROM_RD, $FROM_WR);
    pipe $TO_RD, $TO_WR;
    pipe $FROM_RD, $FROM_WR;

    my $output;
    my $child = fork();
    if ($child == 0) {
	close $TO_WR;
	close $FROM_RD;
	open(STDIN, ">&", $TO_RD) or die "Can't direct $TO_RD to STDIN: $!";
	open(STDOUT, ">&", $FROM_WR) or die "Can't direct $FROM_WR to STDOUT: $!";
	close $TO_RD;
	close $FROM_WR;
	exec("openssl rsautl -sign -inkey $privfilename");
    } elsif (!$child) {
	die;
    } else {
	close $TO_RD;
	close $FROM_WR;
	binmode $TO_WR;
	syswrite $TO_WR, $digest || die;
	close $TO_WR || die;

	my $tmp;
	while (read($FROM_RD, $tmp, 512)) {
	    $output .= $tmp;
	}
	close $FROM_RD;
	die "openssl rsautl failed\n"
	    if (waitpid($child, 0) != $child);
    }

    return $output;
}

###############################################################################
#
# Generate an X.509 certificate
#
###############################################################################
sub emit_x509_Validity()
{
    my $output;
    $output  = emit_asn1_prim($UNIV, $GeneralizedTime, $valid_from);	# notBefore
    $output .= emit_asn1_prim($UNIV, $GeneralizedTime, $valid_to);	# notAfter
    return emit_asn1_cons($UNIV, $SEQUENCE, $output);
}

sub emit_x509_AlgorithmIdentifier($)
{
    my ($oid) = @_;
    my $output;

    $output  = emit_asn1_OID($UNIV, $OBJ_ID, $oid);	# algorithm
    $output .= emit_asn1_prim($UNIV, $NULL);		# parameters
    return emit_asn1_cons($UNIV, $SEQUENCE, $output);
}

sub emit_x509_Version()
{
    # Version 3
    my $output = emit_asn1_prim($UNIV, $INTEGER, pack("C", 3 - 1));
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
    $output .= emit_asn1_prim($UNIV, $INTEGER, $serial); # serialNumber
    $output .= emit_x509_AlgorithmIdentifier("sha1WithRSAEncryption");	# signature
    $output .= emit_x509_Name(\%subject_name);		# issuer
    $output .= emit_x509_Validity();			# validity
    $output .= emit_x509_Name(\%subject_name);		# subject
    #$output .= emit_x509_SubjectPublicKeyInfo();	# subjectPublicKeyInfo
    $output .= $pubkey;
    $output .= emit_x509_Extensions();			# extensions

    return emit_asn1_cons($UNIV, $SEQUENCE, $output);
}

sub emit_x509_Certificate()
{
    my $output;

    $output  = emit_x509_TBSCertificate();		# tbsCertificate

    # We digest the TBS and sign it.
    my $tbs_digest =
	pack("C*", 0x30, 0x21, 0x30, 0x09, 0x06, 0x05,
	     0x2B, 0x0E, 0x03, 0x02, 0x1A,
	     0x05, 0x00, 0x04, 0x14) .
	     sha1sum($output);

    my $sig = rsa_sign($tbs_digest);

    $output .= emit_x509_AlgorithmIdentifier("sha1WithRSAEncryption");	# signatureAlgorithm
    $output .= emit_asn1_bts($UNIV, $BIT_STRING, $sig);	# signature

    return emit_asn1_cons($UNIV, $SEQUENCE, $output);
}

print emit_x509_Certificate();
