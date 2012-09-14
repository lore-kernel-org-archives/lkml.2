Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759837Ab2INSLY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 14:11:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759782Ab2INSLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 14:11:21 -0400
Date: Fri, 14 Sep 2012 20:10:50 +0200
From: Andrew Jones <drjones@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, acme@ghostprotocols.net, tzanussi@gmail.com
Subject: Re: perf script: rwtop: SIGALRM and pipe read race
Message-ID: <20120914181049.GA16618@turtle.usersys.redhat.com>
References: <20120914153952.GA8834@turtle.usersys.redhat.com>
 <505355AF.7000006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505355AF.7000006@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 10:05:03AM -0600, David Ahern wrote:
> On 9/14/12 9:39 AM, Andrew Jones wrote:
> >
> >I recently tried 'perf script rwtop', and it immediately failed with
> >'failed to read event header'. Running it through strace I found that the
> >when rwtop.pl is reading from the pipe, and gets one of it's alarms, that
> >the ERESTARTSYS seems to confuse it - causing it to fail. It also appears
> >that the problem only happens early in execution, or not at all. If I get
> >lucky and don't hit the problem right away, then rwtop will run fine as
> >long as I want, without any ERESTARTSYS's in its trace. I also found that
> >I can avoid hitting the problem by throwing a 'pv -q' in front of the perf
> >command in tools/perf/scripts/perl/bin/rwtop-report. Which I guess slows
> >things down in the reader enough to always avoid the race.
> >
> >Sorry I don't have a solution (patch). I'll look at it more as time
> >permits, but I thought I'd get it reported for starters though.
> 
> 
> This fixes the run-time problem:
> 
> diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
> index 1b8775c..a4371ae 100644
> --- a/tools/perf/util/util.c
> +++ b/tools/perf/util/util.c
> @@ -142,6 +142,9 @@ int readn(int fd, void *buf, size_t n)
>     while (n) {
>         int ret = read(fd, buf, n);
> 
> +        if ((ret < 0) && (errno == EINTR))
> +            continue;
> +
>         if (ret <= 0)
>             return ret;
> 
> 
> 
> The only problem you will find with rwtop is that bytes_read will be
> really whacky. I traced it to:
> 
>     if ($ret > 0) {
> printf("comm %s bytes_read %d\n", $common_comm, $ret);
>         $reads{$common_pid}{bytes_read} += $ret;
> 
> Somehow the $ret > 0 is passing when in fact it is negative. I do
> not know much about perl to fix it.
> 

This actually appears to be an issue with how perl sighandlers are
supposed to work.

http://perldoc.perl.org/perlipc.html#Restartable-system-calls

I tried the below patch though, and while it gets me past the read failure
it still doesn't solve the problem. With it the script stops processing
events after the first one.

Drew

diff --git a/tools/perf/scripts/perl/rwtop.pl
b/tools/perf/scripts/perl/rwtop.pl
index 4bb3ecd..8b20787 100644
--- a/tools/perf/scripts/perl/rwtop.pl
+++ b/tools/perf/scripts/perl/rwtop.pl
@@ -17,6 +17,7 @@ use lib
"$ENV{'PERF_EXEC_PATH'}/scripts/perl/Perf-Trace-Util/l
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
+    POSIX::sigaction(SIGALRM, $sa) or die "Can't set SIGALRM handler:
$!\n";
     alarm 1;
 }
 
Drew
