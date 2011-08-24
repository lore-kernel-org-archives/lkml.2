Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab1HXIqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 04:46:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755977Ab1HXIqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 04:46:02 -0400
Date: Wed, 24 Aug 2011 10:45:56 +0200
From: Andrew Jones <drjones@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10 v2] ktest: Introduce CONSOLE_RESET_TIME
Message-ID: <20110824084555.GA3457@turtle.usersys.redhat.com>
References: <1313155932-20092-5-git-send-email-drjones@redhat.com>
 <1313166353-3664-1-git-send-email-drjones@redhat.com>
 <1313702883.15704.78.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313702883.15704.78.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 05:28:03PM -0400, Steven Rostedt wrote:
> On Fri, 2011-08-12 at 18:25 +0200, Andrew Jones wrote:
> > When rebooting, some targets may lose their console connection. This
> > certainly happens with 'virsh console' when used with my xen guests.
> > Setting CONSOLE_RESET_TIME will tell ktest to reconnect the console
> > after reboot.
> 
> Oops, you forgot to add your SOB to this version of the patch. Could you
> just reply to this with your signed-off-by tag.
>

Doh, I think I may have missed all my v2s.
 
> Thanks!
> 
> -- Steve
> 
> > ---
> >  tools/testing/ktest/ktest.pl    |   28 +++++++++++++++++++++++-----
> >  tools/testing/ktest/sample.conf |    8 ++++++++
> >  2 files changed, 31 insertions(+), 5 deletions(-)
> > 
> > diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
> > index 12c392e..8bc6dd8 100755
> > --- a/tools/testing/ktest/ktest.pl
> > +++ b/tools/testing/ktest/ktest.pl
> > @@ -108,6 +108,7 @@ my $monitor_cnt = 0;
> >  my $sleep_time;
> >  my $bisect_sleep_time;
> >  my $patchcheck_sleep_time;
> > +my $console_reset_time;
> >  my $ignore_warnings;
> >  my $store_failures;
> >  my $test_name;
> > @@ -606,6 +607,7 @@ sub run_command;
> >  sub start_monitor;
> >  sub end_monitor;
> >  sub wait_for_monitor;
> > +sub reset_monitor;
> >  
> >  sub reboot {
> >      my ($time) = @_;
> > @@ -626,6 +628,7 @@ sub reboot {
> >  	wait_for_monitor $time;
> >  	end_monitor;
> >      }
> > +    reset_monitor;
> >  }
> >  
> >  sub do_not_reboot {
> > @@ -685,7 +688,9 @@ sub close_console {
> >  }
> >  
> >  sub start_monitor {
> > -    if ($monitor_cnt++) {
> > +    my ($force) = @_;
> > +
> > +    if ($monitor_cnt++ && !defined($force)) {
> >  	return;
> >      }
> >      $monitor_fp = \*MONFD;
> > @@ -697,12 +702,23 @@ sub start_monitor {
> >  }
> >  
> >  sub end_monitor {
> > -    if (--$monitor_cnt) {
> > +    my ($force) = @_;
> > +
> > +    if (--$monitor_cnt && !defined($force)) {
> >  	return;
> >      }
> >      close_console($monitor_fp, $monitor_pid);
> >  }
> >  
> > +sub reset_monitor {
> > +    if ($monitor_cnt <= 0 || !defined($console_reset_time)) {
> > +	return;
> > +    }
> > +    end_monitor 'force';
> > +    sleep $console_reset_time;
> > +    start_monitor 'force';
> > +}
> > +
> >  sub wait_for_monitor {
> >      my ($time) = @_;
> >      my $line;
> > @@ -911,10 +927,11 @@ sub wait_for_input
> >  sub reboot_to {
> >      if ($reboot_type eq "grub") {
> >  	run_ssh "'(echo \"savedefault --default=$grub_number --once\" | grub --batch && reboot)'";
> > -	return;
> > +    } else {
> > +	run_command "$reboot_script";
> >      }
> > -
> > -    run_command "$reboot_script";
> > +    wait_for_monitor $sleep_time;
> > +    reset_monitor;
> >  }
> >  
> >  sub get_sha1 {
> > @@ -2817,6 +2834,7 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
> >      $sleep_time = set_test_option("SLEEP_TIME", $i);
> >      $bisect_sleep_time = set_test_option("BISECT_SLEEP_TIME", $i);
> >      $patchcheck_sleep_time = set_test_option("PATCHCHECK_SLEEP_TIME", $i);
> > +    $console_reset_time = set_test_option("CONSOLE_RESET_TIME", $i);
> >      $ignore_warnings = set_test_option("IGNORE_WARNINGS", $i);
> >      $bisect_manual = set_test_option("BISECT_MANUAL", $i);
> >      $bisect_skip = set_test_option("BISECT_SKIP", $i);
> > diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
> > index b8bcd14..ba430a7 100644
> > --- a/tools/testing/ktest/sample.conf
> > +++ b/tools/testing/ktest/sample.conf
> > @@ -491,6 +491,14 @@
> >  # (default 60)
> >  #PATCHCHECK_SLEEP_TIME = 60
> >  
> > +# If the console needs to be reset during a reboot cycle in
> > +# order to reestablish it's connection, then set this option
> > +# to the number of seconds ktest should wait between disconnect
> > +# and reconnect. This is needed when using 'virsh console' to
> > +# connect to guests.
> > +# (default undefined)
> > +#CONSOLE_RESET_TIME = 5
> > +
> >  # Reboot the target box on error (default 0)
> >  #REBOOT_ON_ERROR = 0
> >  
> 
>
Signed-off-by: Andrew Jones <drjones@redhat.com>
