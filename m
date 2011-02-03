Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab1BCKIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 05:08:45 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51962 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397Ab1BCKIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 05:08:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=Lk05BCcv2uctr0B84CMkfUPiDr4rMBZtL3e2JjBD5k6DH5o9EFOG4O77j8djcFJOq3
         DzqlKxFtljBKGC0NkcSwSCrRdgAh9AvtYXNd1uI2SY3LfnIKTBGQ9n4pDtRlXAkOW71i
         PsxpLZq+j3ofciiGtesSavzVQSWAjynI9MpFA=
Date: Thu, 3 Feb 2011 13:08:28 +0300
From: Dan Carpenter <error27@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Subject: rename_rev.pl script for reviewing renames
Message-ID: <20110203100828.GO20606@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="WhfpMioaduB5tiZL"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WhfpMioaduB5tiZL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

There are a lot of refactoring patches where people change camel case
names to kernel style names etc.  I've written a script to make it
easier to review them.  It's attached.

For example the linked patch is about 7900 lines long.  It renames
A_BOOL to bool, TRUE to true and FALSE to false.
http://driverdev.linuxdriverproject.org/pipermail/devel/2011-February/011810.html

cat email.txt | ./rename_rev.pl A_BOOL bool TRUE true FALSE false | less

The resulting diff is 78 lines long (99% reduced).  Woohoo!

regards,
dan carpenter


--WhfpMioaduB5tiZL
Content-Type: text/x-perl; charset=us-ascii
Content-Disposition: attachment; filename="rename_rev.pl"

#!/usr/bin/perl

use File::Temp qw/ :mktemp  /;

sub usage() {
    print "cat diff | transform.pl old new old new old new...\n";
    die;
}

my @subs;

sub filter($) {
    my $line = shift();

    foreach my $sub (@subs) {
	$line =~ s/$sub->[0]/$sub->[1]/g;
    }

    # white space at the end of lines
    $line =~ s/ *$//g;
    $line =~ s/\t*$//g;

    # remove the first char
    $line =~ s/^[ +-]//;

    # tabs to spaces
    $line =~ s/\ {8}/\t/g;

    return $line;
}

($oldfh, $oldfile) = mkstemp("/tmp/oldXXXXX");
($newfh, $newfile) = mkstemp("/tmp/newXXXXX");

while (my $param1 = shift()) {
    my $param2 = shift;

    if ($param2 =~ /^$/) {
	usage();
    }
    push @subs, [$param1, $param2];
}

while (<>) {
    my $line = $_;

    if ($line =~ /^---/) {
	next;
    }
    if ($line =~ /^\+\+\+/) {
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

system("diff -u $oldfile $newfile");

unlink($oldfile);
unlink($newfile);

--WhfpMioaduB5tiZL--
