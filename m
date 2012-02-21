Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab2BUWJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 17:09:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:38721 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998Ab2BUWJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 17:09:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="119834911"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: Joe Perches <joe@perches.com>, David Miller <davem@davemloft.net>,
        Andy Whitcroft <apw@shadowen.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "andrei.emeltchenko.news@gmail.com" 
	<andrei.emeltchenko.news@gmail.com>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] checkpatch: Add some --strict coding style checks
Thread-Topic: [PATCH] checkpatch: Add some --strict coding style checks
Thread-Index: AQHM8Nu9391LFUTMFEuqxrbxHQK9JZZH4RQA
Date: Tue, 21 Feb 2012 22:09:09 +0000
Message-ID: <804857E1F29AAC47BF68C404FC60A18429B3EE@ORSMSX102.amr.corp.intel.com>
References: <20120221151435.GA19354@tuxdriver.com>
	 <20120221.144417.1445117001833888214.davem@davemloft.net>
	 <CAMXE1-qB8_5oGey2=Ypa5BitZnye3YqdM=yB8oKCGLvoZu_8HQ@mail.gmail.com>
	 <20120221.154053.2103818562080068513.davem@davemloft.net>
 <1329857959.5143.11.camel@joe2Laptop>
In-Reply-To: <1329857959.5143.11.camel@joe2Laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1LM9OSJ021136

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Joe Perches
> Sent: Tuesday, February 21, 2012 12:59 PM
> To: David Miller; Andy Whitcroft; Andrew Morton
> Cc: andrei.emeltchenko.news@gmail.com; linville@tuxdriver.com; linux-
> wireless@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH] checkpatch: Add some --strict coding style checks
> 
> Argument alignment across multiple lines should
> match the open parenthesis.
> 
> Logical continuations should be at the end of
> the previous line, not the start of a new line.
> 
> These are not required by CodingStyle so make the
> tests active only when using --strict.
> 
> Tested with:
> int foo(void)
> {
> 	if (foo &&
> 	    bar())
> 		baz();
> 
> 	if (foo &&
> 	     bar())
> 		baz();
> 
> 	foo_some_long_function(bar,
> 			       baz);
> 
> 	foo_some_long_function(bar,
> 		baz);
> 
> 	return 0;
> }
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  scripts/checkpatch.pl |   22 ++++++++++++++++++++++
>  1 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index a3b9782..629944e 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1783,6 +1783,28 @@ sub process {
>  			     "please, no space before tabs\n" . $herevet);
>  		}
> 
> +# check for && or || at the start of a line
> +		if ($rawline =~ /^\+\s*(&&|\|\|)/) {
> +			CHK("LOGICAL_CONTINUATIONS",
> +			    "Logical continuations should be on the previous
> line\n" . $hereprev);
> +		}
> +
> +# check multi-line statement indentation matches previous line
> +		if ($prevline =~ /^\+(\t*)(if
> \(|$Ident\().*(\&\&|\|\||,)\s*$/ && $rawline =~ /^\+([ \t]*)/) {
> +			$prevline =~ /^\+(\t*)(if
> \(|$Ident\().*(\&\&|\|\||,)\s*$/;
> +			my $oldindent = $1;
> +			my $if_or_func = $2;
> +			$rawline =~ /^\+([ \t]*)/;
> +			my $newindent = $1;
> +			my $goodindent = $oldindent .
> +					 "\t" x (length($if_or_func) / 8) .
> +					 " "  x (length($if_or_func) % 8);
> +			if ($newindent ne "$goodindent") {
> +				CHK("PARENTHESIS_ALIGNMENT",
> +				    "Alignment should match open
> parenthesis\n" . $hereprev);
> +			}
> +		}
> +
>  # check for spaces at the beginning of a line.
>  # Exceptions:
>  #  1) within comments

This appears to falsely complain about parenthesis alignment in conditional statements with multiple opening parentheses.  For example, these will report a check condition:

	if (test_and_set_bit(nr,
				   addr))
		baz();

	if (!(func_a(x) &&
		func_b(y)))
		baz();

Assuming my stupid mailer will screw up the indentation above, the 'a' in addr in the first example is meant to be immediately below the 'n' in nr, and the two 'f's in func_* are meant to be vertically lined up in the second example.


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
