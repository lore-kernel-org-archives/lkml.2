Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab2ICW3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 18:29:11 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63915 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab2ICW3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 18:29:10 -0400
Message-ID: <1346711342.2312.1.camel@Cruz-PC>
Subject: Re: [PATCH 2/5] scripts/checkincludes.pl: Simplify and shorten
 argument logic
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: mcgrof@gmail.com
Cc: linux-kernel@vger.kernel.org
Date: Tue, 04 Sep 2012 08:29:02 +1000
In-Reply-To: <1346710853-19166-3-git-send-email-cruzjbishop@gmail.com>
References: <1346710853-19166-1-git-send-email-cruzjbishop@gmail.com>
	 <1346710853-19166-3-git-send-email-cruzjbishop@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In my last submission, Joe Perches (is that right?)
suggested using a function that is built in to Perl.

I haven't had a chance to test it yet, but if it turns
out to be okay, I'll make a separate merge request at
a later date.

On Tue, 2012-09-04 at 08:20 +1000, Cruz Julian Bishop wrote:
> This patch allows for much easier implementation of arguments
> when modifying checkincludes.pl
> 
> The variable $file is also initially named $arg - I wasn't sure
> if memory would be a problem (I know it would be in Java/C#) if
> another $file variable was initialized with the value of $arg,
> so I just left it.
> 
> Overall, this still works nicely. There are some more
> potential simplifications, but I will cover those in another
> patch if I decide to implement them tonight.
> 
> Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
> ---
>  scripts/checkincludes.pl | 85 ++++++++++++++++++++++--------------------------
>  1 file changed, 39 insertions(+), 46 deletions(-)
> 
> diff --git a/scripts/checkincludes.pl b/scripts/checkincludes.pl
> index 801ed5f..7d713c2 100755
> --- a/scripts/checkincludes.pl
> +++ b/scripts/checkincludes.pl
> @@ -30,64 +30,57 @@ if ($#ARGV < 0) {
>  	usage();
>  }
>  
> -if ($#ARGV >= 1) {
> -	if ($ARGV[0] =~ /^-/) {
> -		if ($ARGV[0] eq "-r") {
> -			$remove = 1;
> -			shift;
> -		} else {
> -			usage();
> -		}
> -	}
> -}
> +foreach my $arg (@ARGV) {
> +	if ($arg eq "-r") {
> +		$remove = 1;
> +	} else {
> +		open(my $f, '<', $arg)
> +		    or die "Cannot open $arg: $!.\n";
>  
> -foreach my $file (@ARGV) {
> -	open(my $f, '<', $file)
> -	    or die "Cannot open $file: $!.\n";
> +		my %includedfiles = ();
> +		my @file_lines = ();
>  
> -	my %includedfiles = ();
> -	my @file_lines = ();
> -
> -	while (<$f>) {
> -		if (m/^\s*#\s*include\s*[<"](\S*)[>"]/o) {
> -			++$includedfiles{$1};
> +		while (<$f>) {
> +			if (m/^\s*#\s*include\s*[<"](\S*)[>"]/o) {
> +				++$includedfiles{$1};
> +			}
> +			push(@file_lines, $_);
>  		}
> -		push(@file_lines, $_);
> -	}
>  
> -	close($f);
> +		close($f);
>  
> -	if (!$remove) {
> -		foreach my $filename (keys %includedfiles) {
> -			if ($includedfiles{$filename} > 1) {
> -				print "$file: $filename is included more than once.\n";
> +		if (!$remove) {
> +			foreach my $filename (keys %includedfiles) {
> +				if ($includedfiles{$filename} > 1) {
> +					print "$arg: $filename is included more than once.\n";
> +				}
>  			}
> +			next;
>  		}
> -		next;
> -	}
>  
> -	open($f, '>', $file)
> -	    or die("Cannot write to $file: $!");
> +		open($f, '>', $arg)
> +			or die("Cannot write to $arg: $!");
>  
> -	my $dups = 0;
> -	foreach (@file_lines) {
> -		if (m/^\s*#\s*include\s*[<"](\S*)[>"]/o) {
> -			foreach my $filename (keys %includedfiles) {
> -				if ($1 eq $filename) {
> -					if ($includedfiles{$filename} > 1) {
> -						$includedfiles{$filename}--;
> -						$dups++;
> -					} else {
> -						print {$f} $_;
> +		my $dups = 0;
> +		foreach(@file_lines) {
> +			if (m/^\s*#\s*include\s*[<"](\S*)[>"]/o) {
> +				foreach my $filename (keys %includedfiles) {
> +					if ($1 eq $filename) {
> +						if ($includedfiles{$filename} > 1) {
> +							$includedfiles{$filename}--;
> +							$dups++;
> +						} else {
> +							print {$f} $_;
> +						}
>  					}
>  				}
> +			} else {
> +				print {$f} $_;
>  			}
> -		} else {
> -			print {$f} $_;
>  		}
> +		if ($dups > 0) {
> +			print "$arg: removed $dups duplicate includes \n";
> +		}
> +		close($f);
>  	}
> -	if ($dups > 0) {
> -		print "$file: removed $dups duplicate includes\n";
> -	}
> -	close($f);
>  }


