Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab0HKSzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 14:55:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44626 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559Ab0HKSy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 14:54:58 -0400
X-Authority-Analysis: v=1.1 cv=mWMe3HXt1P3ELXxrmMgI9QKdSRnwjSxQbBh3ay0KAh4= c=1 sm=0 a=TzTR-pdnRKgA:10 a=Q9fys5e9bTEA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:17 a=7mOBRU54AAAA:8 a=Lk9nDxBHVk0cXHw4TiMA:9 a=UlcZCNRE7ihlrh1rZntg_GahHH4A:4 a=PUjeQqilurYA:10 a=WeOa-AV5lc8A:10 a=IXo+6rlC6z1XzBFn1RNpIA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.87.39
Subject: Re: [PATCH] tracing: extend recordmcount to better support
 Blackfin mcount
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        uclinux-dist-devel@blackfin.uclinux.org
In-Reply-To: <1281079584-21205-1-git-send-email-vapier@gentoo.org>
References: <1281079584-21205-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 11 Aug 2010 14:54:56 -0400
Message-ID: <1281552896.3058.41.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-06 at 03:26 -0400, Mike Frysinger wrote:
> The mcount call on Blackfin systems includes some stack manipulation
> around the actual call site, so extend the build time perl script to
> support this.  This way we can avoid doing the calculation at runtime.

Hmm, this might be something we could do in other archs.

You want me to pull it? or should this go via another tree?

-- Steve

> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  scripts/recordmcount.pl |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index f3c9c0a..2c56539 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -159,6 +159,7 @@ my $section_regex;	# Find the start of a section
>  my $function_regex;	# Find the name of a function
>  			#    (return offset and func name)
>  my $mcount_regex;	# Find the call site to mcount (return offset)
> +my $mcount_adjust;	# Address adjustment to mcount offset
>  my $alignment;		# The .align value to use for $mcount_section
>  my $section_type;	# Section header plus possible alignment command
>  my $can_use_local = 0; 	# If we can use local function references
> @@ -213,6 +214,7 @@ $section_regex = "Disassembly of section\\s+(\\S+):";
>  $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
>  $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
>  $section_type = '@progbits';
> +$mcount_adjust = 0;
>  $type = ".long";
>  
>  if ($arch eq "x86_64") {
> @@ -351,6 +353,9 @@ if ($arch eq "x86_64") {
>  } elsif ($arch eq "microblaze") {
>      # Microblaze calls '_mcount' instead of plain 'mcount'.
>      $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s_mcount\$";
> +} elsif ($arch eq "blackfin") {
> +    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s__mcount\$";
> +    $mcount_adjust = -4;
>  } else {
>      die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
>  }
> @@ -511,7 +516,7 @@ while (<IN>) {
>      }
>      # is this a call site to mcount? If so, record it to print later
>      if ($text_found && /$mcount_regex/) {
> -	push(@offsets, hex $1);
> +	push(@offsets, (hex $1) + $mcount_adjust);
>      }
>  }
>  


