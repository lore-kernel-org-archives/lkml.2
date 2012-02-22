Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab2BVB43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 20:56:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:21217 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab2BVB40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 20:56:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="119903711"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: Joe Perches <joe@perches.com>
CC: David Miller <davem@davemloft.net>, Andy Whitcroft <apw@shadowen.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "andrei.emeltchenko.news@gmail.com" 
	<andrei.emeltchenko.news@gmail.com>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] checkpatch: Add some --strict coding style checks
Thread-Topic: [PATCH] checkpatch: Add some --strict coding style checks
Thread-Index: AQHM8Nu9391LFUTMFEuqxrbxHQK9JZZH4RQAgADIE4D//30WsA==
Date: Wed, 22 Feb 2012 01:56:25 +0000
Message-ID: <804857E1F29AAC47BF68C404FC60A18429B8F2@ORSMSX102.amr.corp.intel.com>
References: <20120221151435.GA19354@tuxdriver.com>
	 <20120221.144417.1445117001833888214.davem@davemloft.net>
	 <CAMXE1-qB8_5oGey2=Ypa5BitZnye3YqdM=yB8oKCGLvoZu_8HQ@mail.gmail.com>
	 <20120221.154053.2103818562080068513.davem@davemloft.net>
	 <1329857959.5143.11.camel@joe2Laptop>
	 <804857E1F29AAC47BF68C404FC60A18429B3EE@ORSMSX102.amr.corp.intel.com>
 <1329874581.5143.22.camel@joe2Laptop>
In-Reply-To: <1329874581.5143.22.camel@joe2Laptop>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1M1uYCA022122

> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Tuesday, February 21, 2012 5:36 PM
> To: Allan, Bruce W
> Cc: David Miller; Andy Whitcroft; Andrew Morton;
> andrei.emeltchenko.news@gmail.com; linville@tuxdriver.com; linux-
> wireless@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: RE: [PATCH] checkpatch: Add some --strict coding style checks
> 
> On Tue, 2012-02-21 at 22:09 +0000, Allan, Bruce W wrote:
> > This appears to falsely complain about parenthesis alignment in
> > conditional statements with multiple opening parentheses.
> 
> Hey Allan.
> 
> Can you try this one please?
> ---
>  scripts/checkpatch.pl |   58
> +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 58 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index a3b9782..e95419e 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1330,6 +1330,35 @@ sub check_absolute_file {
>  	}
>  }
> 
> +sub pos_last_openparen {
> +
> +	my ($args) = @_;
> +
> +	my $pos = 0;
> +	my $len = length($args);
> +
> +	my $opens = $args =~ tr/\(/\(/;
> +	my $closes = $args =~ tr/\)/\)/;
> +
> +	my $last_openparen = 0;
> +
> +	if (($opens == 0) || ($closes >= $opens)) {
> +		return 0;
> +	}
> +
> +	for ($pos = 0; $pos < $len; $pos++) {
> +		if (substr($args, $pos) =~ /^($FuncArg)/) {
> +			$pos += length($1);
> +		}
> +
> +		if (substr($args, $pos, 1) eq '(') {
> +			$last_openparen = $pos;
> +		}
> +	}
> +
> +	return $last_openparen + 1;
> +}
> +
>  sub process {
>  	my $filename = shift;
> 
> @@ -1783,6 +1812,35 @@ sub process {
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
> \(|$Ident\()(.*)(\&\&|\|\||,)\s*$/;
> +			my $oldindent = $1;
> +			my $if_or_func = $2;
> +			my $args = $3;
> +
> +			my $pos = pos_last_openparen($args);
> +
> +			my $len = length($if_or_func) + $pos;
> +			$rawline =~ /^\+([ \t]*)/;
> +			my $newindent = $1;
> +
> +			my $goodindent = $oldindent .
> +					 "\t" x ($len / 8) .
> +					 " "  x ($len % 8);
> +
> +			if ($newindent ne $goodindent) {
> +				CHK("PARENTHESIS_ALIGNMENT",
> +				    "Alignment should match open
> parenthesis\n" . $hereprev);
> +			}
> +		}
> +
>  # check for spaces at the beginning of a line.
>  # Exceptions:
>  #  1) within comments
> 

It's better, but there are still instances of false hits AFAICT.

Bruce.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
