Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab0EJFHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 01:07:19 -0400
Received: from ist.d-labs.de ([213.239.218.44]:47880 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621Ab0EJFHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 01:07:14 -0400
Date: Mon, 10 May 2010 07:07:08 +0200
From: Florian Mickler <florian@mickler.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] scripts/get_maintainer.pl: optionally ignore
 non-maintainer signatures
Message-ID: <20100510070708.2fc284c5@schatten.dmk.lab>
In-Reply-To: <30a2fd47565ff33d6f47d9a76746b56d923856ac.1273466698.git.joe@perches.com>
References: <1273396544-4189-1-git-send-email-florian@mickler.org>
	<30a2fd47565ff33d6f47d9a76746b56d923856ac.1273466698.git.joe@perches.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  9 May 2010 21:56:02 -0700
Joe Perches <joe@perches.com> wrote:

> This patch has been modified from Florian's original submission to
> change the supported signature types to the canonical forms and use
> slightly different spacing.  A couple of spacing issues were also
> corrected in the original source.  The command line argument was
> also renamed.
> 
> Original-patch-by: Florian Mickler <florian@mickler.org>
> Signed-off-by: Florian Mickler <florian@mickler.org>

I'm ok with your changes. Looks good.

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  scripts/get_maintainer.pl |   35 ++++++++++++++++++++++++++---------
>  1 files changed, 26 insertions(+), 9 deletions(-)
> 
> diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
> index 6f97a13..f66018d 100755
> --- a/scripts/get_maintainer.pl
> +++ b/scripts/get_maintainer.pl
> @@ -25,6 +25,7 @@ my $email_list = 1;
>  my $email_subscriber_list = 0;
>  my $email_git_penguin_chiefs = 0;
>  my $email_git = 1;
> +my $email_git_all_signature_types = 1;
>  my $email_git_blame = 0;
>  my $email_git_min_signatures = 1;
>  my $email_git_max_maintainers = 5;
> @@ -51,9 +52,9 @@ my $help = 0;
>  my $exit = 0;
>  
>  my @penguin_chief = ();
> -push(@penguin_chief,"Linus Torvalds:torvalds\@linux-foundation.org");
> +push(@penguin_chief, "Linus Torvalds:torvalds\@linux-foundation.org");
>  #Andrew wants in on most everything - 2009/01/14
> -#push(@penguin_chief,"Andrew Morton:akpm\@linux-foundation.org");
> +#push(@penguin_chief, "Andrew Morton:akpm\@linux-foundation.org");
>  
>  my @penguin_chief_names = ();
>  foreach my $chief (@penguin_chief) {
> @@ -63,7 +64,16 @@ foreach my $chief (@penguin_chief) {
>  	push(@penguin_chief_names, $chief_name);
>      }
>  }
> -my $penguin_chiefs = "\(" . join("|",@penguin_chief_names) . "\)";
> +my $penguin_chiefs = "\(" . join("|", @penguin_chief_names) . "\)";
> +
> +# Signature types of people who are either
> +# 	a) responsible for the code in question, or
> +# 	b) familiar enough with it to give relevant feedback
> +my @signature_tags = ();
> +push(@signature_tags, "Signed-off-by:");
> +push(@signature_tags, "Reviewed-by:");
> +push(@signature_tags, "Acked-by:");
> +my $signaturePattern = "\(" . join("|", @signature_tags) . "\)";
>  
>  # rfc822 email address - preloaded methods go here.
>  my $rfc822_lwsp = "(?:(?:\\r\\n)?[ \\t])";
> @@ -100,6 +110,7 @@ my %VCS_cmds_hg = (
>  if (!GetOptions(
>  		'email!' => \$email,
>  		'git!' => \$email_git,
> +		'git-all-signature-types!' => \$email_git_all_signature_types,
>  		'git-blame!' => \$email_git_blame,
>  		'git-chief-penguins!' => \$email_git_penguin_chiefs,
>  		'git-min-signatures=i' => \$email_git_min_signatures,
> @@ -180,6 +191,10 @@ if (!top_of_kernel_tree($lk_path)) {
>  	. "a linux kernel source tree.\n";
>  }
>  
> +if ($email_git_all_signature_types) {
> +    $signaturePattern = "(.+?)[Bb][Yy]:";
> +}
> +
>  ## Read MAINTAINERS for type/value pairs
>  
>  my @typevalue = ();
> @@ -497,13 +512,15 @@ version: $V
>  MAINTAINER field selection options:
>    --email => print email address(es) if any
>      --git => include recent git \*-by: signers
> +    --git-all-signature-types => include signers regardless of signature type
> +        or use only ${signaturePattern} signers (default: $email_git_all_signature_types)
>      --git-chief-penguins => include ${penguin_chiefs}
> -    --git-min-signatures => number of signatures required (default: 1)
> -    --git-max-maintainers => maximum maintainers to add (default: 5)
> -    --git-min-percent => minimum percentage of commits required (default: 5)
> +    --git-min-signatures => number of signatures required (default: $email_git_min_signatures)
> +    --git-max-maintainers => maximum maintainers to add (default: $email_git_max_maintainers)
> +    --git-min-percent => minimum percentage of commits required (default: $email_git_min_percent)
>      --git-blame => use git blame to find modified commits for patch or file
> -    --git-since => git history to use (default: 1-year-ago)
> -    --hg-since => hg history to use (default: -365)
> +    --git-since => git history to use (default: $email_git_since)
> +    --hg-since => hg history to use (default: $email_hg_since)
>      --m => include maintainer(s) if any
>      --n => include name 'Full Name <addr\@domain.tld>'
>      --l => include list(s) if any
> @@ -964,7 +981,7 @@ sub vcs_find_signers {
>  
>      $commits = grep(/$pattern/, @lines);	# of commits
>  
> -    @lines = grep(/^[-_ 	a-z]+by:.*\@.*$/i, @lines);
> +    @lines = grep(/^[ \t]*${signaturePattern}.*\@.*$/, @lines);
>      if (!$email_git_penguin_chiefs) {
>  	@lines = grep(!/${penguin_chiefs}/i, @lines);
>      }
