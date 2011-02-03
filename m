Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab1BCKvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 05:51:11 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40725 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196Ab1BCKvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 05:51:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=BoKYq9giVTomYP7tsivGt/xvfi8UyTnL989Hw411uf31PkBtce3yPwQdaI4SvEDD1b
         U0a/WGldxhNE95YjpgoCewUz/mrPGWAo0b2G27HM+kZEuf8GyJsnSqnDdVq4ZMhSfv2a
         mugb4jWNSSZZF6LIsFVY8L3BRDEqjtEWkxPB4=
Date: Thu, 3 Feb 2011 13:50:48 +0300
From: Dan Carpenter <error27@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: rename_rev.pl script for reviewing renames
Message-ID: <20110203105048.GR20606@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
	devel@driverdev.osuosl.org
References: <20110203100828.GO20606@bicker>
 <20110203102219.GB6508@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="uh9ZiVrAOUUm9fzH"
Content-Disposition: inline
In-Reply-To: <20110203102219.GB6508@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uh9ZiVrAOUUm9fzH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 03, 2011 at 11:22:19AM +0100, Wolfram Sang wrote:
> On Thu, Feb 03, 2011 at 01:08:28PM +0300, Dan Carpenter wrote:
> > There are a lot of refactoring patches where people change camel case
> > names to kernel style names etc.  I've written a script to make it
> > easier to review them.  It's attached.
> 
> Cool, thanks for sharing. I guess my comments won't matter much, here
> they are anyway :)
> 

Thanks for the review.  I made the changes.  

regards,
dan carpenter

--uh9ZiVrAOUUm9fzH
Content-Type: text/x-perl; charset=us-ascii
Content-Disposition: attachment; filename="rename_rev.pl"

#!/usr/bin/perl

use File::Temp qw/ :mktemp  /;

sub usage() {
    print "usage: cat diff | $0 old new old new old new...\n";
    exit(1);
}

my @subs;

sub filter($) {
    my $line = shift();

    foreach my $sub (@subs) {
	$line =~ s/$sub->[0]/$sub->[1]/g;
    }

    # remove the first char
    $line =~ s/^[ +-]//;

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

--uh9ZiVrAOUUm9fzH--
