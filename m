Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab0IOP1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 11:27:52 -0400
Received: from mail.perches.com ([173.55.12.10]:2053 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115Ab0IOP1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 11:27:51 -0400
Subject: Re: [v2 PATCH rfc] scripts/get_maintainer.pl: add interactive mode
From: Joe Perches <joe@perches.com>
To: florian@mickler.org
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1284558207-10223-1-git-send-email-florian@mickler.org>
References: <1284552799-12748-1-git-send-email-florian@mickler.org>
	 <1284558207-10223-1-git-send-email-florian@mickler.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 08:27:49 -0700
Message-ID: <1284564469.1759.93.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-15 at 15:43 +0200, florian@mickler.org wrote:
> This is a first version of an interactive mode for
> scripts/get_maintainer.pl .
> 
> It allows the user to interact with the script. Each cc candidate can be
> selected and deselected and a shortlog of authored commits can be
> displayed for each candidate.
> 
> The menu is displayed via STDERR, the end result is outputted to STDOUT.
> 
> This allows using get_maintainer.pl in interactive mode via
> git send-email --cc-cmd.
> 
> ---
>  scripts/get_maintainer.pl |  119 +++++++++++++++++++++++++++++++++++++++++++--
>  1 files changed, 115 insertions(+), 4 deletions(-)
> 
> changes from v1: I forgot to git add a small bugfix, that made it actually work 
> 
> TODO:
>  - fixup multiple file case
>  - fixup chief_penguin handling
>  - make output prettier
>  - usability?
> 
> diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
> index b228198..2e15c22 100755
> --- a/scripts/get_maintainer.pl
> +++ b/scripts/get_maintainer.pl
> @@ -32,6 +32,7 @@ my $email_git_max_maintainers = 5;
>  my $email_git_min_percent = 5;
>  my $email_git_since = "1-year-ago";
>  my $email_hg_since = "-365";
> +my $interactive = 0;
>  my $email_remove_duplicates = 1;
>  my $output_multiline = 1;
>  my $output_separator = ", ";
> @@ -51,6 +52,8 @@ my $help = 0;
>  
>  my $exit = 0;
>  
> +my %shortlog_buffer;
> +
>  my @penguin_chief = ();
>  push(@penguin_chief, "Linus Torvalds:torvalds\@linux-foundation.org");
>  #Andrew wants in on most everything - 2009/01/14
> @@ -91,7 +94,8 @@ my %VCS_cmds_git = (
>      "blame_range_cmd" => "git blame -l -L \$diff_start,+\$diff_length \$file",
>      "blame_file_cmd" => "git blame -l \$file",
>      "commit_pattern" => "^commit [0-9a-f]{40,40}",
> -    "blame_commit_pattern" => "^([0-9a-f]+) "
> +    "blame_commit_pattern" => "^([0-9a-f]+) ",
> +    "shortlog_cmd" => "git log --no-color --oneline --since=\$email_git_since --author=\"\$email\" -- \$file"

Perhaps git shortlog might be better.

This will also miss commits where $email, which is
"name <address>", is slightly different on multiple
commits or when --remove-duplicates is set and the
"name" part of $email matches.

>  );
>  
>  my %VCS_cmds_hg = (
> @@ -104,7 +108,8 @@ my %VCS_cmds_hg = (
>      "blame_range_cmd" => "",		# not supported
>      "blame_file_cmd" => "hg blame -c \$file",
>      "commit_pattern" => "^commit [0-9a-f]{40,40}",
> -    "blame_commit_pattern" => "^([0-9a-f]+):"
> +    "blame_commit_pattern" => "^([0-9a-f]+):",
> +    "shortlog_cmd" => "ht log --date=\$email_hg_since"

hg and don't you want some additional filtering?

>  );
>  
>  if (-f "${lk_path}.get_maintainer.conf") {
> @@ -142,6 +147,7 @@ if (!GetOptions(
>  		'git-min-percent=i' => \$email_git_min_percent,
>  		'git-since=s' => \$email_git_since,
>  		'hg-since=s' => \$email_hg_since,
> +		'i|interactive!' => \$interactive,
>  		'remove-duplicates!' => \$email_remove_duplicates,
>  		'm!' => \$email_maintainer,
>  		'n!' => \$email_usename,
> @@ -219,6 +225,8 @@ if ($email_git_all_signature_types) {
>      $signaturePattern = "(.+?)[Bb][Yy]:";
>  }
>  
> +
> +

Please don't add blank lines.

>  ## Read MAINTAINERS for type/value pairs
>  
>  my @typevalue = ();
> @@ -440,10 +448,14 @@ foreach my $file (@files) {
>      if ($email && $email_git) {
>  	vcs_file_signoffs($file);
>      }
> -

Or remove them.

>      if ($email && $email_git_blame) {
>  	vcs_file_blame($file);
>      }
> +    if ($email && $interactive){
> +	#FIXME: multiple file case is broken at the moment
> +	#FIXME: penguin_chief handlich is broken at the moment
> +	vcs_interactive_menu($file);
> +    }
>  }
>  
>  if ($keywords) {
> @@ -476,6 +488,7 @@ if ($email) {
>      }
>  }
>  
> +

Please don't add blank lines

>  if ($email || $email_list) {
>      my @to = ();
>      if ($email) {
> @@ -545,6 +558,7 @@ MAINTAINER field selection options:
>      --git-blame => use git blame to find modified commits for patch or file
>      --git-since => git history to use (default: $email_git_since)
>      --hg-since => hg history to use (default: $email_hg_since)
> +    --interactive => display a menu (mostly useful if used with the --git option)
>      --m => include maintainer(s) if any
>      --n => include name 'Full Name <addr\@domain.tld>'
>      --l => include list(s) if any
> @@ -1104,6 +1118,103 @@ sub vcs_exists {
>      return 0;
>  }
>  
> +sub vcs_interactive_menu {
> +    my ($file) = @_;
> +
> +    return if (!vcs_exists());
> +
> +    my %selected;
> +    my %shortlog;
> +    my $input;
> +    my $count = 0;
> +
> +    #select maintainers by default
> +    foreach my $entry (@email_to){
> +	    my $role = $entry->[1];
> +	    $selected{$count} = ($role =~ /maintainer:/);

This should probably be:
	$selected{$count} = ($role =~ /(\(supporter/maintainer/open list)/i);

> +	    $count++;
> +    }
> +
> +    #menu loop
> +    do {
> +	my $count = 0;
> +	foreach my $entry (@email_to){
> +	    my $email = $entry->[0];
> +	    my $role = $entry->[1];
> +	    if ($selected{$count}){
> +		print STDERR "* ";
> +	    } else {
> +		print STDERR "  ";
> +	    }
> +	    print STDERR "$count: $email,\t\t $role";

This won't align well, maybe something like
	my $sel;
	$sel = "*" if $selected{$count};
	printf STDERR "%1s %2d %-40s %s\n", $sel, $count, $email, $role;

or just don't try to align it at all.

> +	    print STDERR "\n";
> +	    if ($shortlog{$count}){
> +		my @lines = @{vcs_get_shortlog($email, $file)};

You should do this once before the loop for each non-list candidate,
save the result and display it only if the user asks for details.

It could be a very long list and will scroll off some display.

> +		print STDERR "\tauthored commits:" . @lines . ".\n";
> +		foreach my $commit (@lines){
> +		    print STDERR "\t$commit\n";
> +		}
> +		print STDERR "\n";
> +	    }
> +	    $count++;
> +	}

If you're going to show commits, then perhaps any commit type
(signed-off-by, tested-by, etc) should be shown.

Perhaps the vcs_<foo> commands like vcs_file_signoffs should
be modified to return a list of commit IDs and you could
parse and use that.  That way you wouldn't need to make
multiple vcs/git passes over the same content.

> +	print STDERR "\n";
> +	print STDERR "Choose whom to cc by entering a commaseperated list of numbers and hitting enter.\n";
> +	print STDERR "To show a short list of commits, precede the number by a '?',\n";

Won't necessarily be short.

> +	print STDERR "A blank line indicates that you are satisfied with your choice.\n";
> +	$input = <STDIN>;
> +	chomp($input);
> +
> +	my @wish = split(/[, ]+/,$input);
> +	foreach my $nr (@wish){
> +		my $logtoggle = 0;
> +		if ($nr =~ /\?/){
> +			$nr =~ s/\?//;
> +			$logtoggle = 1;
> +		}
> +
> +		#skip out of bounds numbers
> +		next unless ($nr <= $count && $nr >= 0);
> +
> +		if ($logtoggle){
> +			$shortlog{$nr} = !$shortlog{$nr};
> +		} else {
> +			$selected{$nr} = !$selected{$nr};
> +		}
> +	};
> +    } while(length($input) > 0);
> +
> +    #drop not selected entries
> +    $count = 0;
> +    my @new_emailto;
> +    foreach my $entry (@email_to){
> +	if ($selected{$count}){
> +		push(@new_emailto,$email_to[$count]);
> +		print STDERR "$count: ";
> +		print STDERR $email_to[$count]->[0];
> +		print STDERR ",\t\t ";
> +		print STDERR $email_to[$count]->[1];

printf should be used here too.

> +		print STDERR "\n";
> +	}
> +	$count++;
> +    }
> +    @email_to = @new_emailto;
> +}
> +
> +sub vcs_get_shortlog {
> +	my $email = shift;
> +	my ($file) = @_;
> +
> +	if (!$shortlog_buffer{$email}){
> +		my $cmd = $VCS_cmds{"shortlog_cmd"};
> +		$cmd =~ s/(\$\w+)/$1/eeg;		#interpolate $cmd
> +
> +		my @lines = &{$VCS_cmds{"execute_cmd"}}($cmd);
> +		$shortlog_buffer{$email}=\@lines;
> +	}
> +	return $shortlog_buffer{$email};
> +}
> +
>  sub vcs_assign {
>      my ($role, $divisor, @lines) = @_;
>  
> @@ -1179,7 +1290,7 @@ sub vcs_file_blame {
>  	my @commit_signers = ();
>  
>  	my $cmd = $VCS_cmds{"find_commit_signers_cmd"};
> -	$cmd =~ s/(\$\w+)/$1/eeg;	#interpolate $cmd
> +	$cmd =~ s/(\$\w+)/$1/eeg;	#substitute variables in $cmd
>  
>  	($commit_count, @commit_signers) = vcs_find_signers($cmd);
>  	push(@signers, @commit_signers);



