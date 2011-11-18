Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab1KRPgp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 10:36:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46311 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126Ab1KRPgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 10:36:44 -0500
X-Authority-Analysis: v=2.0 cv=NJxXCjGg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=yV41G_FBfBoA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=L5qsA8XTgh3iIs4-FGkA:9 a=QEXdDO2ut3YA:10 a=WkQjhlJjcU7LmvZI:21 a=YMxjHyzRDPrKLjje:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 1/3] ktest: save test output
From: Steven Rostedt <rostedt@goodmis.org>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1321616131-21352-1-git-send-email-rabin@rab.in>
References: <1321616131-21352-1-git-send-email-rabin@rab.in>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 10:36:41 -0500
Message-ID: <1321630601.3533.47.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 17:05 +0530, Rabin Vincent wrote:
> The test output may contain useful information; save it along with the
> already-saved buildlog, dmesg, and .config.

Makes sense.

> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
>  tools/testing/ktest/ktest.pl |   30 +++++++++++++++++++-----------
>  1 files changed, 19 insertions(+), 11 deletions(-)
> 
> diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
> index 30e2bef..3185e0a 100755
> --- a/tools/testing/ktest/ktest.pl
> +++ b/tools/testing/ktest/ktest.pl
> @@ -103,6 +103,7 @@ my $in_patchcheck = 0;
>  my $run_test;
>  my $redirect;
>  my $buildlog;
> +my $testlog;
>  my $dmesg;
>  my $monitor_fp;
>  my $monitor_pid;
> @@ -1005,17 +1006,19 @@ sub fail {
>  	    mkpath($faildir) or
>  		die "can't create $faildir";
>  	}
> -	if (-f "$output_config") {
> -	    cp "$output_config", "$faildir/config" or
> -		die "failed to copy .config";
> -	}
> -	if (-f $buildlog) {
> -	    cp $buildlog, "$faildir/buildlog" or
> -		die "failed to move $buildlog";
> -	}
> -	if (-f $dmesg) {
> -	    cp $dmesg, "$faildir/dmesg" or
> -		die "failed to move $dmesg";
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
> +			cp "$source", "$faildir/$name" or
> +				die "failed to copy $source";
> +		}

Nice little clean up. You can see that I think more C like than Perl. I
usually don't like "perlisms" but this is a clean perl fix that isn't
too complex to understand by non perl folks.

>  	}
>  
>  	doprint "*** Saved info to $faildir ***\n";
> @@ -1653,7 +1656,10 @@ sub child_run_test {
>      $poweroff_on_error = 0;
>      $die_on_failure = 1;
>  
> +    $redirect = "$testlog";
>      run_command $run_test or $failed = 1;
> +    undef $redirect;
> +
>      exit $failed;
>  }
>  
> @@ -3153,6 +3159,7 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
>      $target = "$ssh_user\@$machine";
>  
>      $buildlog = "$tmpdir/buildlog-$machine";
> +    $testlog = "$tmpdir/testlog-$machine";
>      $dmesg = "$tmpdir/dmesg-$machine";
>      $make = "$makecmd O=$outputdir";
>      $output_config = "$outputdir/.config";
> @@ -3189,6 +3196,7 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
>  
>      unlink $dmesg;
>      unlink $buildlog;
> +    unlink $testlog;
>  
>      if (defined($addconfig)) {
>  	my $min = $minconfig;

I'll pull it in, thanks!

-- Steve


