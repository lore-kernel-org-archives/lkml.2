Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab2IRJab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 05:30:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757374Ab2IRJa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 05:30:29 -0400
Date: Tue, 18 Sep 2012 11:30:07 +0200
From: Andrew Jones <drjones@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        tzanussi@gmail.com
Subject: Re: perf script: rwtop: SIGALRM and pipe read race
Message-ID: <20120918093006.GB2467@turtle.usersys.redhat.com>
References: <20120914153952.GA8834@turtle.usersys.redhat.com>
 <505355AF.7000006@gmail.com>
 <20120914181049.GA16618@turtle.usersys.redhat.com>
 <505739EF.5010000@gmail.com>
 <20120918090541.GA2467@turtle.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120918090541.GA2467@turtle.usersys.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 11:05:42AM +0200, Andrew Jones wrote:
> Please read the link I posted to the Perl documentation. The standard
> Perl signal handling doesn't support SA_RESTART. The Perl developers
> found it could lead to data corruption. The patch above attempts to
> replace the standard signal handler with a safe one that supports
> SA_RESTART. It has nothing to do with the display routine, and
> everything to do with avoiding the need for your EINTR patch.

Oh, I should state that it *does* avoid your EINTR patch. With the -D
added to the record script, then besides the unsigned $ret issue,
rwtop works fine for me now with with this SA_RESTART patch.

Below is a v2 where I've also updated the minimum version of Perl
needed. My understanding is that < 5.8.0 $SIG might work fine.
>= 5.8.0 it won't, and 5.8.2 or later is needed for ->safe().

diff --git a/tools/perf/scripts/perl/rwtop.pl b/tools/perf/scripts/perl/rwtop.pl
index 4bb3ecd..617a4d5 100644
--- a/tools/perf/scripts/perl/rwtop.pl
+++ b/tools/perf/scripts/perl/rwtop.pl
@@ -9,7 +9,7 @@
 # refreshed every [interval] seconds.  The default interval is 3
 # seconds.
 
-use 5.010000;
+use 5.8.2;
 use strict;
 use warnings;
 
@@ -17,6 +17,7 @@ use lib "$ENV{'PERF_EXEC_PATH'}/scripts/perl/Perf-Trace-Util/lib";
 use lib "./Perf-Trace-Util/lib";
 use Perf::Trace::Core;
 use Perf::Trace::Util;
+use POSIX qw/SIGALRM SA_RESTART/;
 
 my $default_interval = 3;
 my $nlines = 20;
@@ -90,7 +91,10 @@ sub syscalls::sys_enter_write
 
 sub trace_begin
 {
-    $SIG{ALRM} = \&set_print_pending;
+    my $sa = POSIX::SigAction->new(\&set_print_pending);
+    $sa->flags(SA_RESTART);
+    $sa->safe(1);
+    POSIX::sigaction(SIGALRM, $sa) or die "Can't set SIGALRM handler: $!\n";
     alarm 1;
 }
 
