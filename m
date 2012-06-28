Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab2F1ONf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 10:13:35 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:50333 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab2F1ONe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 10:13:34 -0400
Date: Thu, 28 Jun 2012 17:13:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
Subject: move_rev.pl: tool for reviewing patches that move functions
Message-ID: <20120628141310.GL5333@mwanda>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

We get a lot of patches in staging that move shift functions around
without changing the code.  For example:
http://marc.info/?l=linux-driver-devel&m=134075825327894&q=raw

I've written a perl script to help review them.  If you take that
example diff then it looks like this:

$ cat patch.txt | diffstat
 cb_pcidas.c |  494 ++++++++++++++++++++++++++----------------------------------
  1 file changed, 219 insertions(+), 275 deletions(-)
$ cat patch.txt | ./move_rev.pl | diffstat
 cb_pcidas.c |   63 ------------------------------------------------------------
  1 file changed, 63 deletions(-)
$

63 lines of deleted code is much quicker to review.  :)

The script is attached.

regards,
dan carpenter

--qDbXVdCdHGoSgWSk
Content-Type: text/x-perl; charset=us-ascii
Content-Disposition: attachment; filename="move_rev.pl"

#!/usr/bin/perl

use strict;
use File::Temp qw/ tempdir /;
use File::Path qw/ rmtree /;
use File::Compare qw/ compare /;

sub print_file($$)
{
    my $prefix = shift;
    my $file = shift;

    open FILE, "<", $file;
    while (<FILE>) {
        print $prefix . $_;
    }
    close FILE;
}

my $olddir = tempdir();
my $newdir = tempdir();

my @input;
while (<>) {
   push @input, $_;
}

my ($nr_old, $nr_new);

#
# Break out the blocks into separate files
#
my $block;
my ($old, $new);
foreach (@input) {
    my $line = $_;

    if ($line =~ /^(---|\+\+\+)/ ||
       !($line =~ /^[+-]/) ||
       ($old && $line =~ /^[+]/) ||
       ($new && $line =~ /^[-]/)) {
        $block = "";
        $old = 0;
        $new = 0;
        next;
    }

    if ($line =~ /^[-]{$/) {
        $block = "{";
        $old = 1;
        next;
    }
    if ($line =~ /^[+]{$/) {
        $block = "{";
        $new = 1;
        next;
    }

    $line =~ s/^[+-]//;

    $block = $block . $line;

    if ($line =~ /^}$/) {
        if ($old) {
            $nr_old++;
            open OUT, ">", "$olddir/$nr_old";
            print OUT "$block";
            close OUT;
        } else {
            $nr_new++;
            open OUT, ">", "$newdir/$nr_new";
            print OUT "$block";
            close OUT;
        }
        $block = "";
        $old = 0;
        $new = 0;
        next;
    }
}

#
# Find any blocks which are exactly the same
#
for (my $i = 1; $i <= $nr_old; $i++) {
    for (my $j = 1; $j <= $nr_new; $j++) {
        if (compare("$olddir/$i", "$newdir/$j") == 0) {
            open OUT, ">", "$olddir/$i";
            print OUT "- MOVED {$i}\n";
            close OUT;

            open OUT, ">", "$newdir/$j";
            print OUT "+ MOVED {$j}\n";
            close OUT;
        }
    }
}

#
# Find any blocks which are partly the same
#
for (my $i = 1; $i <= $nr_old; $i++) {
    for (my $j = 1; $j <= $nr_new; $j++) {
        my $lines = `cat $olddir/$i | wc -l`;
        my $after = `diff $olddir/$i $newdir/$j | grep '^<' | wc -l`;
        my $percent;

        $lines =~ s/\n//;
        $after =~ s/\n//;
        $percent = $after/$lines;

        if ($percent >= .7) {
            next;
        }

        my $diff = `diff -u $olddir/$i $newdir/$j | tail -n +3`;

        open OUT, ">", "$olddir/$i";
        print OUT "- MOVED {$i}\n";
        close OUT;

        open OUT, ">", "$newdir/$j";
        print OUT "+ MOVED {$j} <- begin\n";
        print OUT $diff;
        print OUT "+ MOVED {$j} -> end\n";
        close OUT;
    }
}

#
# Print out the diff...
#
$nr_old = $nr_new = 0;
$old = $new = 0;
foreach (@input) {
    my $line = $_;

    if ($line =~ /^(---|\+\+\+)/ ||
       !($line =~ /^[+-]/) ||
       ($old && $line =~ /^[+]/) ||
       ($new && $line =~ /^[-]/)) {
        print $block;
        print $line;
        $block = "";
        $old = 0;
        $new = 0;
        next;
    }

    if ($line =~ /^[-]{$/) {
        print $block;
        $block = $line;
        $old = 1;
        next;
    }
    if ($line =~ /^[+]{$/) {
        print $block;
        $block = $line;
        $new = 1;
        next;
    }

    $block = $block . $line;

    if ($line =~ /^[+-]}$/) {
        if ($old) {
            $nr_old++;
            print_file("-", "$olddir/$nr_old");
        } else {
            $nr_new++;
            print_file("+", "$newdir/$nr_new");
        }
        $block = "";
        $old = 0;
        $new = 0;
        next;
    }
}

rmtree($olddir);
rmtree($newdir);

--qDbXVdCdHGoSgWSk--
