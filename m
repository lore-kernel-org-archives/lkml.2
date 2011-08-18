Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab1HRV2H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 17:28:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39873 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab1HRV2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 17:28:06 -0400
X-Authority-Analysis: v=1.1 cv=Pm0sEXe2MdIPK/rOEC7hwDW84D/yDsPO3JtCzsVYOFU= c=1 sm=0 a=ZGE7i9NbjMkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=BfH3A-dIJrfGY89PYqwA:9 a=PUjeQqilurYA:10 a=Fk1TE4jC9N6hrb79:21 a=Lvzs15R4VIr0HioA:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 04/10 v2] ktest: Introduce CONSOLE_RESET_TIME
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Jones <drjones@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1313166353-3664-1-git-send-email-drjones@redhat.com>
References: <1313155932-20092-5-git-send-email-drjones@redhat.com>
	 <1313166353-3664-1-git-send-email-drjones@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 18 Aug 2011 17:28:03 -0400
Message-ID: <1313702883.15704.78.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-12 at 18:25 +0200, Andrew Jones wrote:
> When rebooting, some targets may lose their console connection. This
> certainly happens with 'virsh console' when used with my xen guests.
> Setting CONSOLE_RESET_TIME will tell ktest to reconnect the console
> after reboot.

Oops, you forgot to add your SOB to this version of the patch. Could you
just reply to this with your signed-off-by tag.

Thanks!

-- Steve

> ---
>  tools/testing/ktest/ktest.pl    |   28 +++++++++++++++++++++++-----
>  tools/testing/ktest/sample.conf |    8 ++++++++
>  2 files changed, 31 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
> index 12c392e..8bc6dd8 100755
> --- a/tools/testing/ktest/ktest.pl
> +++ b/tools/testing/ktest/ktest.pl
> @@ -108,6 +108,7 @@ my $monitor_cnt = 0;
>  my $sleep_time;
>  my $bisect_sleep_time;
>  my $patchcheck_sleep_time;
> +my $console_reset_time;
>  my $ignore_warnings;
>  my $store_failures;
>  my $test_name;
> @@ -606,6 +607,7 @@ sub run_command;
>  sub start_monitor;
>  sub end_monitor;
>  sub wait_for_monitor;
> +sub reset_monitor;
>  
>  sub reboot {
>      my ($time) = @_;
> @@ -626,6 +628,7 @@ sub reboot {
>  	wait_for_monitor $time;
>  	end_monitor;
>      }
> +    reset_monitor;
>  }
>  
>  sub do_not_reboot {
> @@ -685,7 +688,9 @@ sub close_console {
>  }
>  
>  sub start_monitor {
> -    if ($monitor_cnt++) {
> +    my ($force) = @_;
> +
> +    if ($monitor_cnt++ && !defined($force)) {
>  	return;
>      }
>      $monitor_fp = \*MONFD;
> @@ -697,12 +702,23 @@ sub start_monitor {
>  }
>  
>  sub end_monitor {
> -    if (--$monitor_cnt) {
> +    my ($force) = @_;
> +
> +    if (--$monitor_cnt && !defined($force)) {
>  	return;
>      }
>      close_console($monitor_fp, $monitor_pid);
>  }
>  
> +sub reset_monitor {
> +    if ($monitor_cnt <= 0 || !defined($console_reset_time)) {
> +	return;
> +    }
> +    end_monitor 'force';
> +    sleep $console_reset_time;
> +    start_monitor 'force';
> +}
> +
>  sub wait_for_monitor {
>      my ($time) = @_;
>      my $line;
> @@ -911,10 +927,11 @@ sub wait_for_input
>  sub reboot_to {
>      if ($reboot_type eq "grub") {
>  	run_ssh "'(echo \"savedefault --default=$grub_number --once\" | grub --batch && reboot)'";
> -	return;
> +    } else {
> +	run_command "$reboot_script";
>      }
> -
> -    run_command "$reboot_script";
> +    wait_for_monitor $sleep_time;
> +    reset_monitor;
>  }
>  
>  sub get_sha1 {
> @@ -2817,6 +2834,7 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
>      $sleep_time = set_test_option("SLEEP_TIME", $i);
>      $bisect_sleep_time = set_test_option("BISECT_SLEEP_TIME", $i);
>      $patchcheck_sleep_time = set_test_option("PATCHCHECK_SLEEP_TIME", $i);
> +    $console_reset_time = set_test_option("CONSOLE_RESET_TIME", $i);
>      $ignore_warnings = set_test_option("IGNORE_WARNINGS", $i);
>      $bisect_manual = set_test_option("BISECT_MANUAL", $i);
>      $bisect_skip = set_test_option("BISECT_SKIP", $i);
> diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
> index b8bcd14..ba430a7 100644
> --- a/tools/testing/ktest/sample.conf
> +++ b/tools/testing/ktest/sample.conf
> @@ -491,6 +491,14 @@
>  # (default 60)
>  #PATCHCHECK_SLEEP_TIME = 60
>  
> +# If the console needs to be reset during a reboot cycle in
> +# order to reestablish it's connection, then set this option
> +# to the number of seconds ktest should wait between disconnect
> +# and reconnect. This is needed when using 'virsh console' to
> +# connect to guests.
> +# (default undefined)
> +#CONSOLE_RESET_TIME = 5
> +
>  # Reboot the target box on error (default 0)
>  #REBOOT_ON_ERROR = 0
>  


