Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749Ab1JLJ4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 05:56:11 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38859 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab1JLJ4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 05:56:10 -0400
Subject: Re: [PATCH v3] quilt mail: Add way to sign mail with GPG
From: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, quilt-dev <quilt-dev@nongnu.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Date: Wed, 12 Oct 2011 11:56:05 +0200
In-Reply-To: <1318381107.7904.191.camel@gandalf.stny.rr.com>
References: <1318262910.7904.94.camel@gandalf.stny.rr.com>
	 <1318379537.1887.25.camel@schurl.linbit>
	 <1318381107.7904.191.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1318413367.24907.15.camel@schurl.linbit>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-11 at 20:58 -0400, Steven Rostedt wrote:
> On Wed, 2011-10-12 at 02:32 +0200, Andreas Gruenbacher wrote:
> > Steve,
> > 
> > On Mon, 2011-10-10 at 12:08 -0400, Steven Rostedt wrote:
> > > +my $tmpfile = "/tmp/gpgmail.$$";
> > > +
> > > +open(TMP, ">", $tmpfile) or die "Can't create a temporary file";
> > 
> > That's not an appropriate way to create a temp file ... do we need a
> > temp file in the first place though?
> 
> OK, what's the "appropriate" way?

One that doesn't introduce a temp file vulnerability, for example using
File::Temp.

But ...

> As for removing the temp file, I just found it was the easiest way to
> pipe into gpg. If there's a better way to do that, I'm all ears.

... how about this approach?

    my @lines = <>;
    map { print } @lines;
    print "\n";

    #-----------------------------------------------

    sub crlf($) {
        my $_ = shift;
        #s/\n$/\r\n/;
        s/^/> /;
        return $_;
    }

    my $command = 'tr a-z A-Z';
    open(PIPE, "| $command")
        or die "$command: $!\n";
    foreach my $line (@lines) {
        print PIPE crlf($line);
    }
    close PIPE
        or die "$command: $!\n";

> > What's going on with "\r\n" line endings all over the script?  Can't the
> > "\n" line endings be converted to "\r\n" in a single place instead?
> > 
> > 	foreach my $line (@lines) {
> > 	    $_ = $line; s/\n$/\r\n/; print;
> > 	}
> 
> gpg email sigs requires that the lines it process end with a \r\n even
> when the lines do not. But I also find that this makes the patch ugly.
> We could try to keep it, but the biggest stumbling block I had in
> getting the signatures to work was the stupid \r\n manipulations :-p

I can see why this is needed, I just don't like to have it spread out
over the entire code and converting @lines forth and back :)

Thanks,
Andreas

