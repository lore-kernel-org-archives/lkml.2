Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab1K2V25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 16:28:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57200 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab1K2V24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 16:28:56 -0500
Date: Tue, 29 Nov 2011 21:28:51 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Improve memset and min/max with cast checking
Message-ID: <20111129212851.GA6165@shadowen.org>
References: <1322494973-29225-1-git-send-email-apw@canonical.com>
 <1322494973-29225-3-git-send-email-apw@canonical.com>
 <1322537070.2075.27.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322537070.2075.27.camel@Joe-Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 07:24:30PM -0800, Joe Perches wrote:
> Improve the checking of arguments to memset and min/max tests.
> 
> Move the checking of min/max to statement blocks instead of single line.
> Change $Constant to allow any case type 0x initiator and trailing ul specifier.
> Add $FuncArg type as any function argument with or without a cast.
> Print the whole statement when showing memset or min/max messages.
> Improve the memset with 0 as 3rd argument error message.
> 
> There are still weaknesses in the $FuncArg and $Constant code as
> arbitrary parentheses and negative signs are not generically supported.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> 
> On top of Andy's 0/11 series.
> 
>  scripts/checkpatch.pl |   69 +++++++++++++++++++++++-------------------------
>  1 files changed, 33 insertions(+), 36 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 59435a9..d72a71e 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -227,7 +227,7 @@ our $Inline	= qr{inline|__always_inline|noinline};
>  our $Member	= qr{->$Ident|\.$Ident|\[[^]]*\]};
>  our $Lval	= qr{$Ident(?:$Member)*};
>  
> -our $Constant	= qr{(?:[0-9]+|0x[0-9a-fA-F]+)[UL]*};
> +our $Constant	= qr{(?i:[0-9]+|0x[0-9a-f]+)[ul]*};

This should actually be as below so that the UL is included in the case
insensitive match:

our $Constant  = qr{(?i:(?:[0-9]+|0x[0-9a-f]+)[ul]*)};

Other than that it looks good passing my testing.

Acked-by: Andy Whitcroft <apw@canonical.com>

Applied to my next branch.

>  our $Assignment	= qr{(?:\*\=|/=|%=|\+=|-=|<<=|>>=|&=|\^=|\|=|=)};
>  our $Compare    = qr{<=|>=|==|!=|<|>};
>  our $Operators	= qr{
> @@ -334,6 +334,7 @@ our $match_balanced_parentheses = qr/(\((?:[^\(\)]+|(-1))*\))/;
>  
>  our $Typecast	= qr{\s*(\(\s*$NonptrType\s*\)){0,1}\s*};
>  our $LvalOrFunc	= qr{($Lval)\s*($match_balanced_parentheses{0,1})\s*};
> +our $FuncArg = qr{$Typecast{0,1}($LvalOrFunc|$Constant)};
>  
>  sub deparenthesize {
>  	my ($string) = @_;
> @@ -2633,28 +2634,6 @@ sub process {
>  			}
>  		}
>  
> -# typecasts on min/max could be min_t/max_t
> -		if ($line =~ /^\+(?:.*?)\b(min|max)\s*\($Typecast{0,1}($LvalOrFunc)\s*,\s*$Typecast{0,1}($LvalOrFunc)\s*\)/) {
> -			if (defined $2 || defined $8) {
> -				my $call = $1;
> -				my $cast1 = deparenthesize($2);
> -				my $arg1 = $3;
> -				my $cast2 = deparenthesize($8);
> -				my $arg2 = $9;
> -				my $cast;
> -
> -				if ($cast1 ne "" && $cast2 ne "") {
> -					$cast = "$cast1 or $cast2";
> -				} elsif ($cast1 ne "") {
> -					$cast = $cast1;
> -				} else {
> -					$cast = $cast2;
> -				}
> -				WARN("MINMAX",
> -				     "$call() should probably be ${call}_t($cast, $arg1, $arg2)\n" . $herecurr);
> -			}
> -		}
> -
>  # Need a space before open parenthesis after if, while etc
>  		if ($line=~/\b(if|while|for|switch)\(/) {
>  			ERROR("SPACING", "space required before the open parenthesis '('\n" . $herecurr);
> @@ -3148,24 +3127,42 @@ sub process {
>  		}
>  
>  # Check for misused memsets
> -		if (defined $stat && $stat =~ /\bmemset\s*\((.*)\)/s) {
> -			my $args = $1;
> +		if (defined $stat &&
> +		    $stat =~ /^\+(?:.*?)\bmemset\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*$FuncArg\s*\)/s) {
> +
> +			my $ms_addr = $2;
> +			my $ms_val = $8;
> +			my $ms_size = $14;
>  
> -			# Flatten any parentheses and braces
> -			while ($args =~ s/\([^\(\)]*\)/10/s ||
> -			       $args =~ s/\{[^\{\}]*\}/10/s ||
> -			       $args =~ s/\[[^\[\]]*\]/10/s)
> -			{
> -			}
> -			# Extract the simplified arguments.
> -			my ($ms_addr, $ms_val, $ms_size) =
> -						split(/\s*,\s*/, $args);
>  			if ($ms_size =~ /^(0x|)0$/i) {
>  				ERROR("MEMSET",
> -				      "memset size is 3rd argument, not the second.\n" . $herecurr);
> +				      "memset to 0's uses 0 as the 2nd argument, not the 3rd\n" . "$here\n$stat\n");
>  			} elsif ($ms_size =~ /^(0x|)1$/i) {
>  				WARN("MEMSET",
> -				     "single byte memset is suspicious. Swapped 2nd/3rd argument?\n" . $herecurr);
> +				     "single byte memset is suspicious. Swapped 2nd/3rd argument?\n" . "$here\n$stat\n");
> +			}
> +		}
> +
> +# typecasts on min/max could be min_t/max_t
> +		if (defined $stat &&
> +		    $stat =~ /^\+(?:.*?)\b(min|max)\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\)/) {
> +			if (defined $2 || defined $8) {
> +				my $call = $1;
> +				my $cast1 = deparenthesize($2);
> +				my $arg1 = $3;
> +				my $cast2 = deparenthesize($8);
> +				my $arg2 = $9;
> +				my $cast;
> +
> +				if ($cast1 ne "" && $cast2 ne "") {
> +					$cast = "$cast1 or $cast2";
> +				} elsif ($cast1 ne "") {
> +					$cast = $cast1;
> +				} else {
> +					$cast = $cast2;
> +				}
> +				WARN("MINMAX",
> +				     "$call() should probably be ${call}_t($cast, $arg1, $arg2)\n" . "$here\n$stat\n");
>  			}
>  		}

-apw
