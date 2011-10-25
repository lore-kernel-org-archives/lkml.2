Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461Ab1JYNsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 09:48:46 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31462 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933347Ab1JYNsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 09:48:45 -0400
Date: Tue, 25 Oct 2011 16:49:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: linux-kernel@vger.kernel.org
Subject: rename_rev.pl (script for reviewing refactoring patches)
Message-ID: <20111025134906.GD9887@mwanda>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3XA6nns4nE4KvaS/"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4EA6BE3C.0169:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3XA6nns4nE4KvaS/
Content-Type: multipart/mixed; boundary="IMjqdzrDRly81ofr"
Content-Disposition: inline


--IMjqdzrDRly81ofr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This is a script for reviewing refactorying patches.  It the goal is
to remove all the non-code changes and leave the interesting bits.

It has options to modify all the new lines or all the lines in the
diff.  For example, if someone sends a patch to make functions static
then you can do:
	cat patch.txt | rename_rev.pl -ea 's/static //'
and hopefully it looks like the patch doesn't do anything.

This version fixes a bug where if you reordered a line of code but
don't make any other changes, it was ignored.  Obviously that should
show up as an interesting change.

regards,
dan carpenter


--IMjqdzrDRly81ofr
Content-Type: text/x-perl; charset=us-ascii
Content-Disposition: attachment; filename="rename_rev.pl"

#!/usr/bin/perl

# This is a tool to help review variable rename patches. The goal is
# to strip out the automatic sed renames and the white space changes
# and leaves the interesting code changes.
#
# Example 1: A patch renames openInfo to open_info:
#     cat diff | rename_review.pl openInfo open_info
#
# Example 2: A patch swaps the first two arguments to some_func():
#     cat diff | rename_review.pl \
#                    -e 's/some_func\((.*?),(.*?)/some_func\($2, $1/'
#
# Example 3: A patch removes the xkcd_ prefix from some but not all the
# variables.  Instead of trying to figure out which variables were renamed
# just remove the prefix from them all:
#     cat diff | rename_review.pl -ea 's/xkcd_//g'
#
# Example 4: A patch renames 20 CamelCase variables.  To review this let's
# just ignore all case changes and all '_' chars.
#     cat diff | rename_review -ea 'tr/[A-Z]/[a-z]/' -ea 's/_//g'
#
# The other arguments are:
# -nc removes comments
# -ns removes '\' chars if they are at the end of the line.

use strict;
use File::Temp qw/ :mktemp  /;

sub usage() {
    print "usage: cat diff | $0 old new old new old new...\n";
    print "   or: cat diff | $0 -e 's/old/new/g'\n";
    print " -e : execute on old lines\n";
    print " -ea: execute on all lines\n";
    print " -nc: strip one line comments\n";
    print " -ns: no slashes at the end of a line\n";
    exit(1);
}
my @subs;
my @cmds;
my $strip_comments;
my $strip_slashes;

sub filter($) {
    my $_ = shift();
    my $old = 0;
    if ($_ =~ /^-/) {
        $old = 1;
    }
    # remove the first char
    s/^[ +-]//;
    if ($strip_comments) {
        s/\/\*.*?\*\///g;
        s/\/\/.*//;
    }
    foreach my $cmd (@cmds) {
        if ($old || $cmd->[0] =~ /^-ea$/) {
		eval $cmd->[1];
	}
    }
    foreach my $sub (@subs) {
	if ($old) {
		s/$sub->[0]/$sub->[1]/g;
	}
    }
    return $_;
}

while (my $param1 = shift()) {
    if ($param1 =~ /^-nc$/) {
        $strip_comments = 1;
        next;
    }
    if ($param1 =~ /^-ns$/) {
        $strip_slashes = 1;
        next;
    }
    my $param2 = shift();
    if ($param2 =~ /^$/) {
	usage();
    }
    if ($param1 =~ /^-e(a|)$/) {
        push @cmds, [$param1, $param2];
	next;
    }
    push @subs, [$param1, $param2];
}

my ($oldfh, $oldfile) = mkstemp("/tmp/oldXXXXX");
my ($newfh, $newfile) = mkstemp("/tmp/newXXXXX");

while (<>) {
    if ($_ =~ /^(---|\+\+\+)/) {
	next;
    }
    my $output = filter($_);
    if ($_ =~ /^-/) {
	print $oldfh $output;
	next;
    }
    if ($_ =~ /^\+/) {
	print $newfh $output;
	next;
    }
    print $oldfh $output;
    print $newfh $output;
}

my $hunk;
my $old_txt;
my $new_txt;

open diff, "diff -uw $oldfile $newfile |";
while (<diff>) {
    if ($_ =~ /^(---|\+\+\+)/) {
	next;
    }

    if ($_ =~ /^@/) {
	if ($old_txt ne $new_txt) {
 	    print $hunk;
	    print $_;
	}
	$hunk = "";
	$old_txt = "";
	$new_txt = "";
	next;
    }

    $hunk = $hunk . $_;

    if ($strip_slashes) {
	s/\\$//;
    }

    if ($_ =~ /^-/) {
	s/-//;
	s/[ \t\n]//g;
	$old_txt = $old_txt . $_;
	next;
    }
    if ($_ =~ /^\+/) {
	s/\+//;
	s/[ \t\n]//g;
	$new_txt = $new_txt . $_;
	next;
    }
    $old_txt = $old_txt . $_;
    $new_txt = $new_txt . $_;
}
if ($old_txt ne $new_txt) {
    print $hunk;
}

unlink($oldfile);
unlink($newfile);

--IMjqdzrDRly81ofr--

--3XA6nns4nE4KvaS/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOpr5SAAoJEOnZkXI/YHqRLh0P/R4p0Oy4zOayrYnswTt9xJt8
31ECehhiSNzNkwpzGeA28Io109Y258CFcZhSEobBMXz4F5g1fhf3dxdJw3ydBZ5g
xWnCxDpzVBk/8Qo5In6htNBsXVwkBCcfnEVdnLhOVVpP/z+Mt4ol5QWSBGflAoLr
Q6MOV9iZsFCe5QRlhl0Jug1J3aM3jaBvJ74YPF7De2YpfwfBH2K10OYnxjut0cmh
lMd2iVQ1hhynNc75T36iGA0wGOBm27wBkK/dsX6hAk4HfUTUAdZVFbXYpbBr9MPC
MocZN/vl/AyEWVP1G6STht1X3gfIrjkvo4Uq47W2v8mFw7J0Edvld2qhK7JKwqfF
zLSzs6kOv51RchiK2oonFummzqHWwg+bmODZmk75YIcfo/Cx3q+WtXl3p7zU7vEU
d0B6KwYq904LWBlLe619KUFfKVnqUrAS8l0swbeNbW09TmvamxZYePBuIu029nXv
pzeJvlnEZm+wQSksKfQR8vJ3IXf0Pu0gFSeQGVTqeV+vbtAPDpMdsib9reX1MoTR
nYMxZtFczgjwAnML/Cuud80Ei+cSZuog95x6vI1Umby7uNPkSmBEcQhYOcv92kTh
zo80Ut29zC0IYfHL7a5IIby+jRwJgeOz1D8iTvZg4Jg4m7JwsHml0Fn5aiXrvBpD
FHvIDVnun9Ii7P9wQB2s
=Qm38
-----END PGP SIGNATURE-----

--3XA6nns4nE4KvaS/--
