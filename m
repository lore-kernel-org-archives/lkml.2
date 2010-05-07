Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab0EGIBH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 04:01:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754158Ab0EGIBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 04:01:05 -0400
Date: Fri, 7 May 2010 09:59:52 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux@arm.linux.org.uk, ysato@users.sourceforge.jp, tony.luck@intel.com,
       dhowells@redhat.com, kyle@mcmartin.ca, benh@kernel.crashing.org,
       schwidefsky@de.ibm.com, jgarzik@pobox.com, hare@suse.de,
       felipe.balbi@nokia.com
Subject: Re: [PATCH] removing redundant ifdefs
Message-ID: <20100507075952.GA1880@jolsa.lab.eng.brq.redhat.com>
References: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
 <20100506104343.96d6a952.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100506104343.96d6a952.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 10:43:43AM -0700, Randy Dunlap wrote:
> On Thu,  6 May 2010 19:36:04 +0200 Jiri Olsa wrote:
> 
> > removing redundant ifdefs.
> > 
> > the pattern is
> > 
> > 	#ifdef DEF1
> > 	...
> > 	#ifdef DEF1
> > 	...
> > 	#endif
> > 	...
> > 	#endif
> > 
> > and removing the inner ifdef.
> > 
> > I found them using script all over the kernel so
> > I haven't even compile-tested some of them.
> 
> what script, please?
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***

I made one after I spot one place like that.. it's simple
perl script, which spits many false warnings (attached).
I took what I thought was right. I did not want to spend
much time with that. ;)

wbr,
jirka

---
#!/usr/bin/perl

my @ifdefs;
my $lnb = 0;
my $file = $ARGV[0];

open FILE, $file or die $!;

while($line = <FILE>) {
        chop $line;
        $lnb++;

        if ($line =~ /^#[ ]*ifdef|^#[ ]*if/) {
                my @ifdef = split(/\s/, $line);
                my $def = $ifdef[1];

                foreach $d(@ifdefs) {
                        next if ($d ne $def);
                        print "$file: [$line]\n";
                        print "$file:  got duplicate $def, line $lnb\n";
                }

                push(@ifdefs, $def);
        }

        if ($line =~ /^#[ ]*endif/) {
                pop(@ifdefs);
        }
}

