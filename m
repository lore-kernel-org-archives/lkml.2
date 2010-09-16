Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab0IPIaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 04:30:11 -0400
Received: from ist.d-labs.de ([213.239.218.44]:50678 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819Ab0IPIaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 04:30:09 -0400
Date: Thu, 16 Sep 2010 10:30:03 +0200
From: Florian Mickler <florian@mickler.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [v2 PATCH rfc] scripts/get_maintainer.pl: add interactive mode
Message-ID: <20100916103003.3ca98179@schatten.dmk.lab>
In-Reply-To: <1284564469.1759.93.camel@Joe-Laptop>
References: <1284552799-12748-1-git-send-email-florian@mickler.org>
 <1284558207-10223-1-git-send-email-florian@mickler.org>
 <1284564469.1759.93.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010 08:27:49 -0700
Joe Perches <joe@perches.com> wrote:

> On Wed, 2010-09-15 at 15:43 +0200, florian@mickler.org wrote:
> > This is a first version of an interactive mode for
> > scripts/get_maintainer.pl .
> > 
> > It allows the user to interact with the script. Each cc candidate can be
> > selected and deselected and a shortlog of authored commits can be
> > displayed for each candidate.
> > 
> > The menu is displayed via STDERR, the end result is outputted to STDOUT.
> > 
> > This allows using get_maintainer.pl in interactive mode via
> > git send-email --cc-cmd.
> > 
> > ---
> >  scripts/get_maintainer.pl |  119 +++++++++++++++++++++++++++++++++++++++++++--
> >  1 files changed, 115 insertions(+), 4 deletions(-)
> > 
> > changes from v1: I forgot to git add a small bugfix, that made it actually work 
> > 
> > TODO:
> >  - fixup multiple file case
> >  - fixup chief_penguin handling
> >  - make output prettier
> >  - usability?
> > 
> > diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
> > index b228198..2e15c22 100755
> > --- a/scripts/get_maintainer.pl
> > +++ b/scripts/get_maintainer.pl
> > @@ -32,6 +32,7 @@ my $email_git_max_maintainers = 5;
> >  my $email_git_min_percent = 5;
> >  my $email_git_since = "1-year-ago";
> >  my $email_hg_since = "-365";
> > +my $interactive = 0;
> >  my $email_remove_duplicates = 1;
> >  my $output_multiline = 1;
> >  my $output_separator = ", ";
> > @@ -51,6 +52,8 @@ my $help = 0;
> >  
> >  my $exit = 0;
> >  
> > +my %shortlog_buffer;
> > +
> >  my @penguin_chief = ();
> >  push(@penguin_chief, "Linus Torvalds:torvalds\@linux-foundation.org");
> >  #Andrew wants in on most everything - 2009/01/14
> > @@ -91,7 +94,8 @@ my %VCS_cmds_git = (
> >      "blame_range_cmd" => "git blame -l -L \$diff_start,+\$diff_length \$file",
> >      "blame_file_cmd" => "git blame -l \$file",
> >      "commit_pattern" => "^commit [0-9a-f]{40,40}",
> > -    "blame_commit_pattern" => "^([0-9a-f]+) "
> > +    "blame_commit_pattern" => "^([0-9a-f]+) ",
> > +    "shortlog_cmd" => "git log --no-color --oneline --since=\$email_git_since --author=\"\$email\" -- \$file"
> 
> Perhaps git shortlog might be better.

I want the abbreviated sha1, so that the user can investigate more
easily if he wants to.


> >  );
> >  
> >  my %VCS_cmds_hg = (
> > @@ -104,7 +108,8 @@ my %VCS_cmds_hg = (
> >      "blame_range_cmd" => "",		# not supported
> >      "blame_file_cmd" => "hg blame -c \$file",
> >      "commit_pattern" => "^commit [0-9a-f]{40,40}",
> > -    "blame_commit_pattern" => "^([0-9a-f]+):"
> > +    "blame_commit_pattern" => "^([0-9a-f]+):",
> > +    "shortlog_cmd" => "ht log --date=\$email_hg_since"
> 

> hg and don't you want some additional filtering?

Yes. But I don't have any hg installed over here atm....

> >  
> > +sub vcs_interactive_menu {
> > +    my ($file) = @_;
> > +
> > +    return if (!vcs_exists());
> > +
> > +    my %selected;
> > +    my %shortlog;
> > +    my $input;
> > +    my $count = 0;
> > +
> > +    #select maintainers by default
> > +    foreach my $entry (@email_to){
> > +	    my $role = $entry->[1];
> > +	    $selected{$count} = ($role =~ /maintainer:/);
> 
> This should probably be:
> 	$selected{$count} = ($role =~ /(\(supporter/maintainer/open list)/i);

our mails crossed. see v3.  

> 
> > +	    $count++;
> > +    }
> > +
> > +    #menu loop
> > +    do {
> > +	my $count = 0;
> > +	foreach my $entry (@email_to){
> > +	    my $email = $entry->[0];
> > +	    my $role = $entry->[1];
> > +	    if ($selected{$count}){
> > +		print STDERR "* ";
> > +	    } else {
> > +		print STDERR "  ";
> > +	    }
> > +	    print STDERR "$count: $email,\t\t $role";
> 
> This won't align well, maybe something like
> 	my $sel;
> 	$sel = "*" if $selected{$count};
> 	printf STDERR "%1s %2d %-40s %s\n", $sel, $count, $email, $role;

Yup, something like that is better.


> 
> or just don't try to align it at all.

I think the alignment is beneficial. 

> 
> > +	    print STDERR "\n";
> > +	    if ($shortlog{$count}){
> > +		my @lines = @{vcs_get_shortlog($email, $file)};
> 
> You should do this once before the loop for each non-list candidate,
> save the result and display it only if the user asks for details.
> 
> It could be a very long list and will scroll off some display.

Let's see how it plays out. Maybe wrapping the print STDERR in a
function that keeps count of how many lines it put out and waits after
N lines for user input ("press enter to see the next 80 lines"). 

But perhaps it's better to trim the output to not be too long. If
there are many authored commits, the individual commit is not 
that much new information for this usecase.

> 
> > +		print STDERR "\tauthored commits:" . @lines . ".\n";
> > +		foreach my $commit (@lines){
> > +		    print STDERR "\t$commit\n";
> > +		}
> > +		print STDERR "\n";
> > +	    }
> > +	    $count++;
> > +	}
> 
> If you're going to show commits, then perhaps any commit type
> (signed-off-by, tested-by, etc) should be shown.

The individual commits of Tested-By: and non-author Signed-Off-By: are
probably not that interesting. But the individual counts should be
displayed. 
Individual commits for Reviewed-By: could be interesting, though. 

I think the statistics gathering in get_maintainer.pl needs a little
tweaking. It's the next thing on my ToDo. 

> 
> Perhaps the vcs_<foo> commands like vcs_file_signoffs should
> be modified to return a list of commit IDs and you could
> parse and use that.  That way you wouldn't need to make
> multiple vcs/git passes over the same content.

Yes, it should be a single pass that yields all the information we
need. 


> 
> > +	print STDERR "\n";
> > +	print STDERR "Choose whom to cc by entering a commaseperated list of numbers and hitting enter.\n";
> > +	print STDERR "To show a short list of commits, precede the number by a '?',\n";
>
> Won't necessarily be short.

Indeed. 

> 
> > +	if ($selected{$count}){
> > +		push(@new_emailto,$email_to[$count]);
> > +		print STDERR "$count: ";
> > +		print STDERR $email_to[$count]->[0];
> > +		print STDERR ",\t\t ";
> > +		print STDERR $email_to[$count]->[1];
> 
> printf should be used here too.

Ack.

Thx for your feedback, suggestions and help here and per private mail!


Cheers,
Flo
