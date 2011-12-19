Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab1LSQbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 11:31:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497Ab1LSQbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 11:31:35 -0500
Message-ID: <4EEF66E4.7070408@redhat.com>
Date: Mon, 19 Dec 2011 17:31:32 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC] Script to spot functions that should be in .{init,exit}.text
 section
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

A while ago, I noticed a few functions that should have been marked
__init or __exit but wasn't and I wondered how many of such offenders
are they. I wrote a short perl script that looks for functions that
*possibly* should be in init or exit sections. It searches functions
that are only called from .init.text section (resp. .exit.text), that
are not already marked __init (resp. __exit) and that are not exported
either. It takes vmlinux and Module.symvers files as arguments. It
then displays a list of functions, their size and the possibly missing
marker.

I'd like to make a few preliminary comments about this script. It
should work on x86 (both 32 and 64 bits). It may possibly work on
other archs, but I would count on it since it uses objdump, whose
output is arch-dependent. However it should be easy to port it to
other archs.

*It does report false positives*. For instance: functions that are
marked __{dev,cpu,mem}{init,exit} likely are. Some other functions may
also be called through a pointer. Or they might be called from an
other section on a kernel build with different options or on a
different arch. Moreover, a lot of the functions reported by this tool
are quite small. In short, check twice before you add an __init/__exit
marker: don't break a build to save a few dozen bytes!

I haven't investigated, but it is likely that some data similarly end
up in the wrong section (i.e. missing __initdata or __initconst). I
have no idea so far how to catch them (I haven't given it too much
thought either).

To give you a better idea, here the list of the 25 biggest reported
functions on 3.2.0-rc3+ (x86_64, allyesconfig):

# Section Name Size
__init ata_attach_transport 906
__init perf_pmu_register 910
__init init_se_kmem_caches 946
__init opl3_detect 952
__init dsp_audio_generate_volume_changes 964
__init txInit 994
__init panel_init 1005
__init floppy_grab_irq_and_dma 1060
__init pcibios_setup 1065
__init aic7xxx_setup 1082
__init ips_order_controllers 1084
__init acpi_ns_root_initialize 1130
__init init_r_port 1140
__init tp3780I_EnableDSP 1140
__init ns558_isa_probe 1183
__init amd76xrom_init_one 1479
__init isdn_tty_modem_init 1514
__init ali_ircc_open 1539
__init init_nandsim 1597
__init rcu_torture_cleanup 1604
__init ck804xrom_init_one 1762
__init ichxrom_init_one 1921
__init esb2rom_init_one 1962
__init fixup_pmc551 2575
__init locking_selftest 10049

In total, about 700 functions are reported for a total size of 175 kB
(false positives included).

I hope this can be useful,
Jerome

---
#! /usr/bin/env perl
#
# Look for functions that possibly should be in __init or __exit section
# 
# It searches functions that are only called from __init section (resp. __exit)
# that are not already in __init (resp. __exit) section and that are not
# exported either.
#
# NOTES:
#  - Run it on an allyesconfig kernel to catch as many offender as possible.
#  - Possibles false positives:
#     a) The function can be accessed through a pointer (for instance, a
#        function marked __(dev/cpu/mem)(init/exit))
#     b) The function can be called from an other section when compiled with
#        other config options, on other archs
#     c) Others...
#  Don't rush to add __init/__exit if a function is spoted by this tool.
#
# Copyright (C) 2011 Red Hat, Inc., Jerome Marchand <jmarchan@redhat.com>
#
# This program is free software;  you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it would be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
# the GNU General Public License for more details.

#
# USAGE: checksections.pl vmlinux Module.symvers [outputfile]
#

use strict;
use warnings;


# takes two sorted list as arguments
# remove elt of first list that are also in second list
sub remove_duplicates {
    my $list1 = shift;
    my $list2 = shift;
    my $i = 0;
    my $j = 0;

    while ( ($i <= $#{$list1}) && ($j <= $#{$list2}) ) {
	my $x = $list1->[$i];
	my $y = $list2->[$j];

	splice(@{$list1}, $i, 1) if ($x eq $y);

	$i++ if ($x lt $y);
	$j++ if ($x ge $y);
    }
}

# characters of hexadecimal number
my $hexnum = "[a-f0-9]";
my $cvar = "[a-zA-Z0-9_]";


my $infile = $ARGV[0];
my $outfile;
my $symversfile = $ARGV[1];
if ($#ARGV >= 2) {
    $outfile = $ARGV[2];
} else {
    $outfile = "./checksections.out";
}

my %secnumber = ( "text", 0, "init", 1, "exit", 2);
my @sections = (".text", ".init.text", ".exit.text");


# list of functions called from section X
my @called;
# list of functions in section X
my @syms;
# list of exported functions
my @exported;
# list of function and sizes
my %funcsize;


# get functions called from each section
foreach my $secname (@sections) {
    print "Disassemble section $secname\n";
    my @asm = `objdump -j $secname -d $infile|grep call`;
    my @calls;
    my @uniqcalls;

    for ( @asm ) {
	# format: " xxxxxxx:	xx xx xx callX xxxxxxx <function_name>"
	if ( / ?$hexnum+\:\t($hexnum{2} )+ *\tcall[a-z]? +$hexnum+ <($cvar+)>.*/ ) {
	    push(@calls, "$2");
	}
    }
    @calls = sort @calls;

    my $last = "";
    for ( @calls ) {
	push(@uniqcalls, $_) if($_ ne $last);
	$last = $_;
    }

    undef @calls;

    push(@called, [@uniqcalls]);
}

# get the symbol list of each section
foreach my $secname (@sections) {
    print "Extract table of section $secname\n";
    my @table = `objdump -j $secname -t $infile`;
    my @funcs;

    for ( @table ) {
	# format: " xxxxxxx flags F .section\tsize function_name"
	if ( /$hexnum+ .*F $secname\t($hexnum+) ($cvar+)/ ) {
	    $funcsize{"$2"} = hex $1;
	    push(@funcs, "$2");
	}
    }

    @funcs = sort @funcs;
    push(@syms, [@funcs]);
}


# get the list of exported functions
open(my $in, "<", $symversfile) or die "Can't open $outfile: $!";
while ( <$in> ) {
    # format:0xa4d58669	math_state_restore	vmlinux	EXPORT_SYMBOL_GPL
    if ( /0x$hexnum+\t(.+)\tvmlinux\tEXPORT_SYMBOL.*/ ) {
	    push(@exported, "$1");
    }
}
@exported = sort @exported;
close $in;

#
# Look for functions that possibly should be in .init.text section
#
my @initcalls = @{$called[$secnumber{"init"}]};
my @initfuncs = @{$syms[$secnumber{"init"}]};

printf "%i functions called from .init section\n", $#initcalls+1 ;
print "removing __init functions\n";
remove_duplicates(\@initcalls, \@initfuncs);
printf "%i functions left\n", $#initcalls+1;


for my $section ("text", "exit") {
    my @othercalls = @{$called[$secnumber{$section}]};

    print "Removing function also called from $section section\n";
    remove_duplicates(\@initcalls, \@othercalls);
    printf "%i functions left\n", $#initcalls+1;
}

print "Removing exported functions\n";
remove_duplicates(\@initcalls, \@exported);
printf "%i functions left\n", $#initcalls+1;

open(my $out, ">", $outfile) or die "Can't open $outfile: $!";

my $saved_size = 0;

foreach my $initcall ( @initcalls ) {
    printf("Should be __init?: %-25s (%s bytes)\n",
	   $initcall, $funcsize{$initcall});
    print $out "__init $initcall $funcsize{$initcall}\n";
    $saved_size += $funcsize{$initcall};
}

printf "%i functions could possibly be put in __init section\n", $#initcalls+1;
print "Their total size is $saved_size bytes\n";

#
# Look for functions that possibly should be in .exit.text section
#
my @exitcalls = @{$called[$secnumber{"exit"}]};
my @exitfuncs = @{$syms[$secnumber{"exit"}]};

printf "%i functions called from .exit section\n", $#exitcalls+1;
print "removing __exit functions\n";
remove_duplicates(\@exitcalls, \@exitfuncs);
printf "%i functions left\n", $#exitcalls+1;

for my $section ("text", "init") {
    my @othercalls = @{$called[$secnumber{$section}]};

    print "Removing function also called from $section section\n";
    remove_duplicates(\@exitcalls, \@othercalls);
    printf "%i functions left\n", $#exitcalls+1;
}

print "Removing exported functions\n";
remove_duplicates(\@exitcalls, \@exported);
printf "%i functions left\n", $#exitcalls+1;

$saved_size = 0;
foreach my $exitcall ( @exitcalls ) {
    printf("Should be __exit?: %-25s (%s bytes)\n",
	   $exitcall, $funcsize{$exitcall});
    print $out "__exit $exitcall $funcsize{$exitcall}\n";
    $saved_size += $funcsize{$exitcall};
}

printf "%i functions could possibly be put in __exit section\n", $#exitcalls+1;
print "Their total size is $saved_size bytes\n";
