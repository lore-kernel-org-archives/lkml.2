Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab2KLNOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 08:14:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555Ab2KLNOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 08:14:10 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <50A0D634.20005@synopsys.com>
References: <50A0D634.20005@synopsys.com> <C2D7FE5348E1B147BCA15975FBA230750D9832@in01wembx1.internal.synopsys.com> <509251CA.8050008@synopsys.com> <18137.1349203013@warthog.procyon.org.uk> <CAAG0J9_gYLn5+4j9WUnPmxWyJfQK_b8e5xjxZdRPG21euXoCFg@mail.gmail.com> <CAAG0J9_LZ5Q1fNdcbSOyieesabkqcTMT0ueEDLXmemV2C_+F=g@mail.gmail.com>,<8419.1352387261@warthog.procyon.org.uk> <14356.1352416788@warthog.procyon.org.uk>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: dhowells@redhat.com, arc-linux-dev@synopsys.com,
        "arnd\@arndb.de" <arnd@arndb.de>,
        "linux-arch\@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [arc-linux-dev] Re: UAPI for new arches (was Re: [GIT PULL] User API Disintegrate: Preparatory patches)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Date: Mon, 12 Nov 2012 13:14:00 +0000
Message-ID: <9377.1352726040@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain

Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:

> >> Per you email from last week, When I ran the disintergrate-one.pl script
> >> myself I saw a whole bunch of empty UAPI files being generated with
> >> references in orig header.  I'm not sure what I'm doing wrong.
> > Can you give an example of such a header?
> 
> tlb.h - despite having __KERNEL__ guard in orig file. Here's how I did it.
> 
> 1. In my orig tree, I created arch/arc/include/uapi/asm/Kbuild, with
> following 2 lines
> 
> # UAPI Header export list
> include include/uapi/asm-generic/Kbuild.asm
> 
> 2.  ./disintegrate-one.pl arch/arc/include/asm/tlb.h
> arch/arc/include/uapi/asm/tlb.h
> 
> This generates a empty uapi/asm/tlb.h, a reference to it in asm/tlb.h
> and is also exported from Kbuild.asm - all 3 of which are wrong.

Actually, this is the correct operation - it's just that there's nothing in
tlb.h to export.  (Note that Kbuild.asm is not modified, but rather
uapi/asm/Kbuild.  asm/Kbuild would too, but there's no export line there to be
removed.)

However... tlb.h isn't exported in Kbuild.asm - nor is it exported in arc's
asm/Kbuild, so the script shouldn't be run on that.

> But now that I think about it - I was wrong to call this script for
> all/any arch headers. It should be done only for the ones in
> include/uapi/asm-generic/Kbuild.asm or any specific ones that arch wants
> to export (cachectl.h for our case).

Exactly so.  I should probably have mentioned that, but I've had it automated
for so long, that I don't think about it any more.  You should only call it
for arch headers

I've attached a script that I use to work out which files need disintegration
in a directory.  Run as:

	genfilelist.pl arch/arc/include/asm/

I get:

	byteorder.h
	cachectl.h
	page.h
	ptrace.h
	setup.h
	sigcontext.h
	signal.h
	swab.h
	unistd.h

as being all that you need to disintegrate.  Almost everything seems to be
generic.

David


--=-=-=
Content-Type: text/x-perl
Content-Disposition: attachment; filename=genfilelist.pl

#!/usr/bin/perl -w
#
# Find all the UAPI files in the nominated directory
#

die "Need directory argument\n"
    if ($#ARGV == -1);

my $dir = $ARGV[0];
my $kbuild = $dir . "/Kbuild";

die "$kbuild not present"
    unless (-r "$dir/Kbuild");

#
# We assume that only Kbuild files in include directories are pertinent to
# determining which headers are UAPI headers.
#
my %headers = ();

opendir my $dh, $dir or die;
foreach $_ (readdir($dh)) {
    $headers{$_} = 1
	if ($_ =~ /[.]h$/ || $_ =~ /[.]agh$/ || $_ =~ /[.]inc$/);
}
closedir($dh) or die;

# Read the common arch list
open FD, '<include/uapi/asm-generic/Kbuild.asm' or die "open Kbuild.asm: $!\n";
my @kbuild_asm = <FD>;
close FD or die;

my %uapihdrs = ();

open FD, '<', $kbuild or die "open $kbuild: $!\n";
my @lines = <FD>;
close FD or die;

for (my $l = 0; $l <= $#lines; $l++) {
    my $line = $lines[$l];

    # parse out the blocks
    # - this may be split over multiple lines using backslashes
    my $block = $line;
  restart:
    $block =~ s@#.*$@@;
    $block =~ s@\s+$@@g;
    $block =~ s@\s+@ @g;

    if ($block =~ /^(.*)[\\]$/) {
	$l++;
	$block = $1 . $lines[$l];
	goto restart;
    }

    $block =~ s@\s+$@@g;
    $block =~ s@\s\s+@ @g;

    if ($block =~ m@^include include/asm-generic/Kbuild.asm@) {
	push @lines, @kbuild_asm;
    }

    if ($block =~ m@^header-y\s*[+:]?=\s*(.*)@ ||
	$block =~ m@^opt-header\s*[+:]?=\s*(.*)@ ||
	$block =~ m@^asm-headers\s*[+:]?=\s*(.*)@
	) {
	my $files = $1;
	next if ($block =~ m@[$][(]foreach@);
	foreach $h (grep m@[^/]$@, split /\s+/, $files) {
	    if (exists $headers{"$h"}) {
		$uapihdrs{"$h"} = 1;
	    }
	}
    }
}

print map { $_ . "\n"; } sort keys %uapihdrs;

--=-=-=--
