Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086Ab1KRPjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 10:39:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39022 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757645Ab1KRPi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 10:38:59 -0500
X-Authority-Analysis: v=2.0 cv=Pdt9d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=jse97-sfE1UA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=7EmI2jxxPtW0Z_KlsfEA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 2/3] ktest: check parent options for a repeated test
From: Steven Rostedt <rostedt@goodmis.org>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1321616131-21352-2-git-send-email-rabin@rab.in>
References: <1321616131-21352-1-git-send-email-rabin@rab.in>
	 <1321616131-21352-2-git-send-email-rabin@rab.in>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 10:38:57 -0500
Message-ID: <1321630737.3533.49.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 17:05 +0530, Rabin Vincent wrote:
> Let's say we have "OUTPUT_DIR = build/${TEST_NAME}", and we're iterating
> a test.  In the second iteration of a test, the TEST_NAME of the test
> we're repeating is not used.  Instead, ${TEST_NAME} appears literally:
> 
>    touch /home/rabin/kernel/test/build/${TEST_NAME}/.config ... SUCCESS
> 
> Fix this by making __eval_option() check the parent test options
> for a repeated test.

Nice catch! I missed this. I'll give it a test run, and if all is fine,
I'll pull it in. Thanks.

This looks like a bug fix, so I may even push this to Linus now.

Thanks!

-- Steve

> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
>  tools/testing/ktest/ktest.pl |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
> index 3185e0a..e93c21c 100755
> --- a/tools/testing/ktest/ktest.pl
> +++ b/tools/testing/ktest/ktest.pl
> @@ -748,6 +748,18 @@ sub __eval_option {
>      # Add space to evaluate the character before $
>      $option = " $option";
>      my $retval = "";
> +    my $repeated = 0;
> +    my $parent = 0;
> +
> +    foreach my $test (keys %repeat_tests) {
> +	if ($i >= $test &&
> +	    $i < $test + $repeat_tests{$test}) {
> +
> +	    $repeated = 1;
> +	    $parent = $test;
> +	    last;
> +	}
> +    }
>  
>      while ($option =~ /(.*?[^\\])\$\{(.*?)\}(.*)/) {
>  	my $start = $1;
> @@ -761,10 +773,14 @@ sub __eval_option {
>  	# otherwise see if the default OPT (without [$i]) exists.
>  
>  	my $o = "$var\[$i\]";
> +	my $parento = "$var\[$parent\]";
>  
>  	if (defined($opt{$o})) {
>  	    $o = $opt{$o};
>  	    $retval = "$retval$o";
> +	} elsif ($repeated && defined($opt{$parento})) {
> +	    $o = $opt{$parento};
> +	    $retval = "$retval$o";
>  	} elsif (defined($opt{$var})) {
>  	    $o = $opt{$var};
>  	    $retval = "$retval$o";


