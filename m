Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab1BFMZ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 07:25:57 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52513 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab1BFMZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 07:25:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=K17lUTEcj8fhOrL8pLAPhTZ6UUHSIr08gkpvP23+Bt4/TyzBt3FzdQEeOKwPFWlBDl
         kkLoSw84NeGd24tOO6IVbmu9A5azgzYebc+lEBaRUc8m+njzw2BsNQyelxhRaAxk3fyi
         36dLsCyXJ2HEZElA0EW7yg7VlIB6tKgHkpFeE=
Date: Sun, 6 Feb 2011 15:25:39 +0300
From: Dan Carpenter <error27@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: rename_rev.pl script for reviewing renames
Message-ID: <20110206122539.GB4384@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
	devel@driverdev.osuosl.org
References: <20110203100828.GO20606@bicker>
 <20110203102219.GB6508@pengutronix.de>
 <20110203105048.GR20606@bicker>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <20110203105048.GR20606@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I've added the some flags:
	-e : gets executed on old lines
	-ea: executed on everything
	-nc: strips one line comments

So say you have a patch that adds parenthesis around a bunch of macros
like this:
http://marc.info/?l=linux-kernel&m=129685142419550&w=2

Then you can just type:
cat /home/dcarpenter/tmp/html23/parens.patch | \
	./rename_rev.pl -e 's/(define \w+) (.*)/$1 ($2)/'

Or if you have a camel case script that changes "ThisVariable" to
"this_variable".  Then the command would be:
git show c659c38 | ./rename_rev.pl -ea '$_ = lc' -ea 's/_//g'
Which changes everything to lower case and strips out all the
underscores.  You might want to combine it with some other flags:
git show c659c38 | ./rename_rev.pl -nc \
	-e 's/TLanPrivateInfo/struct tlan_priv/' \
	-e 's/TLanList/struct tlan_list/' \
	-ea '$_ = lc' -ea 's/_//g'

What I would like is if there was some way to ignore changes which just
introduced new lines, but didn't affect runtime behavior.  I'm not sure
how to do that.

regards,
dan carpenter

--envbJBWh7q8WU6mo
Content-Type: text/x-perl; charset=us-ascii
Content-Disposition: attachment; filename="rename_rev.pl"

#!/usr/bin/perl

use strict;
use File::Temp qw/ :mktemp  /;

sub usage() {
    print "usage: cat diff | $0 old new old new old new...\n";
    print "   or: cat diff | $0 -e 's/old/new/g'\n"; 
    print " -e : execute on old lines\n";
    print " -ea: execute on all lines\n";
    print " -nc: strip one line comments\n"; 
    exit(1);
}

my @subs;
my @cmds;
my $strip_comments;

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


my ($oldfh, $oldfile) = mkstemp("/tmp/oldXXXXX");
my ($newfh, $newfile) = mkstemp("/tmp/newXXXXX");

while (my $param1 = shift()) {
    if ($param1 =~ /^-nc$/) {
        $strip_comments = 1;
        next;
    }

    my $param2 = shift;
    if ($param2 =~ /^$/) {
	usage();
    }

    if ($param1 =~ /^-e(a|)$/) {
        push @cmds, [$param1, $param2];
	next;
    }
    push @subs, [$param1, $param2];
}

while (<>) {
    my $line = $_;

    if ($line =~ /^(---|\+\+\+)/) {
	next;
    }

    my $output = filter($line);
    if ($line =~ /^-/) {
	print $oldfh $output;
	next;
    }
    if ($line =~ /^\+/) {
	print $newfh $output;
	next;
    }
    print $oldfh $output;
    print $newfh $output;
}

system("diff -uw $oldfile $newfile");

unlink($oldfile);
unlink($newfile);

--envbJBWh7q8WU6mo--
