Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085Ab1KRPki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 10:40:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53350 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab1KRPkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 10:40:37 -0500
X-Authority-Analysis: v=2.0 cv=JOm5Qr2b c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=56UTa_Yws6AA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=NtboY739xHmK9IUWaAwA:9 a=QEXdDO2ut3YA:10 a=9OiymDLNeDFLLtVN:21 a=54QPjSM7qBXubBjI:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 3/3] ktest: allow success logs to be stored
From: Steven Rostedt <rostedt@goodmis.org>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1321616131-21352-3-git-send-email-rabin@rab.in>
References: <1321616131-21352-1-git-send-email-rabin@rab.in>
	 <1321616131-21352-3-git-send-email-rabin@rab.in>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 10:40:35 -0500
Message-ID: <1321630835.3533.50.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 17:05 +0530, Rabin Vincent wrote:
> Add a STORE_SUCCESSES option, to allow success logs to be stored, for
> example to double-check or otherwise post-process the test logs.

Looks good. I'll give it a test run and put it into the 3.3 queue.

Thanks!

-- Steve

> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
>  tools/testing/ktest/ktest.pl    |   80 ++++++++++++++++++++++----------------
>  tools/testing/ktest/sample.conf |    6 +++
>  2 files changed, 52 insertions(+), 34 deletions(-)
> 
> diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
> index e93c21c..6ef104e 100755
> --- a/tools/testing/ktest/ktest.pl
> +++ b/tools/testing/ktest/ktest.pl
> @@ -113,6 +113,7 @@ my $bisect_sleep_time;
>  my $patchcheck_sleep_time;
>  my $ignore_warnings;
>  my $store_failures;
> +my $store_successes;
>  my $test_name;
>  my $timeout;
>  my $booted_timeout;
> @@ -976,6 +977,43 @@ sub wait_for_monitor {
>      print "** Monitor flushed **\n";
>  }
>  
> +sub save_logs {
> +	my ($result, $basedir) = @_;
> +	my @t = localtime;
> +	my $date = sprintf "%04d%02d%02d%02d%02d%02d",
> +		1900+$t[5],$t[4],$t[3],$t[2],$t[1],$t[0];
> +
> +	my $type = $build_type;
> +	if ($type =~ /useconfig/) {
> +	    $type = "useconfig";
> +	}
> +
> +	my $dir = "$machine-$test_type-$type-$result-$date";
> +
> +	$dir = "$basedir/$dir";
> +
> +	if (!-d $dir) {
> +	    mkpath($dir) or
> +		die "can't create $dir";
> +	}
> +
> +	my %files = (
> +		"config" => $output_config,
> +		"buildlog" => $buildlog,
> +		"dmesg" => $dmesg,
> +		"testlog" => $testlog,
> +	);
> +
> +	while (my ($name, $source) = each(%files)) {
> +		if (-f "$source") {
> +			cp "$source", "$dir/$name" or
> +				die "failed to copy $source";
> +		}
> +	}
> +
> +	doprint "*** Saved info to $dir ***\n";
> +}
> +
>  sub fail {
>  
>  	if ($die_on_failure) {
> @@ -1004,40 +1042,9 @@ sub fail {
>  	doprint "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n";
>  	doprint "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n";
>  
> -	return 1 if (!defined($store_failures));
> -
> -	my @t = localtime;
> -	my $date = sprintf "%04d%02d%02d%02d%02d%02d",
> -		1900+$t[5],$t[4],$t[3],$t[2],$t[1],$t[0];
> -
> -	my $type = $build_type;
> -	if ($type =~ /useconfig/) {
> -	    $type = "useconfig";
> -	}
> -
> -	my $dir = "$machine-$test_type-$type-fail-$date";
> -	my $faildir = "$store_failures/$dir";
> -
> -	if (!-d $faildir) {
> -	    mkpath($faildir) or
> -		die "can't create $faildir";
> -	}
> -
> -	my %files = (
> -		"config" => $output_config,
> -		"buildlog" => $buildlog,
> -		"dmesg" => $dmesg,
> -		"testlog" => $testlog,
> -	);
> -
> -	while (my ($name, $source) = each(%files)) {
> -		if (-f "$source") {
> -			cp "$source", "$faildir/$name" or
> -				die "failed to copy $source";
> -		}
> -	}
> -
> -	doprint "*** Saved info to $faildir ***\n";
> +	if (defined($store_failures)) {
> +	    save_logs "fail", $store_failures;
> +        }
>  
>  	return 1;
>  }
> @@ -1643,6 +1650,10 @@ sub success {
>      doprint     "*******************************************\n";
>      doprint     "*******************************************\n";
>  
> +    if (defined($store_successes)) {
> +        save_logs "success", $store_successes;
> +    }
> +
>      if ($i != $opt{"NUM_TESTS"} && !do_not_reboot) {
>  	doprint "Reboot and wait $sleep_time seconds\n";
>  	reboot $sleep_time;
> @@ -3137,6 +3148,7 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
>      $bisect_skip = set_test_option("BISECT_SKIP", $i);
>      $config_bisect_good = set_test_option("CONFIG_BISECT_GOOD", $i);
>      $store_failures = set_test_option("STORE_FAILURES", $i);
> +    $store_successes = set_test_option("STORE_SUCCESSES", $i);
>      $test_name = set_test_option("TEST_NAME", $i);
>      $timeout = set_test_option("TIMEOUT", $i);
>      $booted_timeout = set_test_option("BOOTED_TIMEOUT", $i);
> diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
> index dbedfa1..42e0eb9 100644
> --- a/tools/testing/ktest/sample.conf
> +++ b/tools/testing/ktest/sample.conf
> @@ -589,6 +589,12 @@
>  # (default undefined)
>  #STORE_FAILURES = /home/test/failures
>  
> +# Directory to store success directories on success. If this is not
> +# set, the .config, dmesg and bootlog will not be saved if a
> +# test succeeds.
> +# (default undefined)
> +#STORE_SUCCESSES = /home/test/successes
> +
>  # Build without doing a make mrproper, or removing .config
>  # (default 0)
>  #BUILD_NOCLEAN = 0


