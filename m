Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab2IRWEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 18:04:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755559Ab2IRWEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 18:04:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <13189.1347989652@warthog.procyon.org.uk>
References: <13189.1347989652@warthog.procyon.org.uk> <20120914103930.1e16ad8b@pyramind.ukuu.org.uk> <20120913234802.3575.77103.stgit@warthog.procyon.org.uk> <20120913235005.3575.46218.stgit@warthog.procyon.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dhowells@redhat.com, herbert@gondor.hengli.com.au, pjones@redhat.com,
        rusty@rustcorp.com.au, linux-crypto@vger.kernel.org, zohar@us.ibm.com,
        dmitry.kasatkin@intel.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/16] X.509: Add an ASN.1 decoder
Date: Tue, 18 Sep 2012 23:03:49 +0100
Message-ID: <16779.1348005829@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> > has it been fuzz tested extensively ?

Also, here's a generator of random binary ASN.1.  I think it should mostly
produce valid X.509, but invalid ASN.1 is okay too.

Run with something like:

	while :; do ./asn1random.pl | keyctl padd asymmetric vlad @s; done

David
---
#!/usr/bin/perl -w
use strict;

my $depth = 0;
my $maxdepth = 12;
my $num_elements = 0;
my $total_elements = 30 + int(rand(400));

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

    $len = 4; #####################

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
