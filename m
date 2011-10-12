Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab1JLA6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 20:58:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62208 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab1JLA63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 20:58:29 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=KITMlWpeWUEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=et7ekRV8vsD_uUcHbtkA:9 a=Mbzp6AKKnw1EBlLryAYA:7 a=PUjeQqilurYA:10 a=wzta_qkUlcM9S-9x:21 a=CP33O9MTiWOVSVCq:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH v3] quilt mail: Add way to sign mail with GPG
From: Steven Rostedt <rostedt@goodmis.org>
To: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, quilt-dev <quilt-dev@nongnu.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Date: Tue, 11 Oct 2011 20:58:25 -0400
In-Reply-To: <1318379537.1887.25.camel@schurl.linbit>
References: <1318262910.7904.94.camel@gandalf.stny.rr.com>
	 <1318379537.1887.25.camel@schurl.linbit>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1318381107.7904.191.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-12 at 02:32 +0200, Andreas Gruenbacher wrote:
> Steve,
> 
> On Mon, 2011-10-10 at 12:08 -0400, Steven Rostedt wrote:
> > diff --git a/Makefile.in b/Makefile.in
> > index bdf015d..e509a55 100644
> > --- a/Makefile.in
> > +++ b/Makefile.in
> > @@ -83,7 +83,7 @@ SRC +=		$(QUILT_SRC:%=quilt/%)
> >  DIRT +=		$(QUILT_IN:%=quilt/%)
> >  
> >  SCRIPTS_IN :=	patchfns parse-patch inspect dependency-graph edmail	\
> > -		remove-trailing-ws
> > +		remove-trailing-ws gpgmail gpgvmail
> >  
> >  SCRIPTS_SRC :=	$(SCRIPTS_IN:%=%.in)
> >  SCRIPTS :=	$(SCRIPTS_IN)
> > @@ -397,6 +397,8 @@ test/.depend : Makefile $(TESTS)
> >  	    -e 's:quilt/mail:quilt/mail quilt/scripts/edmail:' \
> >  	    -e 's:quilt/refresh:quilt/refresh quilt/scripts/remove-trailing-ws:' \
> >  	    -e 's:quilt/setup:quilt/setup quilt/scripts/inspect:' \
> > +	    -e 's:quilt/setup:quilt/setup quilt/scripts/gpgmail:' \
> > +	    -e 's:quilt/setup:quilt/setup quilt/scripts/gpgvmail:' \
> >  	  > $@
> 
> this must be wrong.

Probably, that was just cut and pasting what I saw.

> 
> >  ifneq ($(shell . $(QUILTRC) ;  echo $$QUILT_PATCHES_PREFIX),)
> > diff --git a/quilt/mail.in b/quilt/mail.in
> > index 5752542..ba35114 100644
> > --- a/quilt/mail.in
> > +++ b/quilt/mail.in
> > @@ -21,7 +21,7 @@ fi
> >  
> >  usage()
> >  {
> > -	printf $"Usage: quilt mail {--mbox file|--send} [-m text] [--prefix prefix] [--sender ...] [--from ...] [--to ...] [--cc ...] [--bcc ...] [--subject ...] [--reply-to message] [first_patch [last_patch]]\n"
> > +	printf $"Usage: quilt mail {--mbox file|--send} [-m text] [--prefix prefix] [--sender ...] [--from ...] [--to ...] [--cc ...] [--bcc ...] [--subject ...] [--reply-to message][--gpg [-u ID]] [first_patch [last_patch]]\n"
> >  	if [ x$1 = x-h ]
> >  	then
> >  		printf $"
> > @@ -65,6 +65,12 @@ first, and a last patch name of \`-' denotes the last patch in the series.
> >  
> >  --reply-to message
> >  	Add the appropriate headers to reply to the specified message.
> > +
> > +--gpg
> > +	Sign email with GPG signatures.
> > +
> > +-u ID
> > +	Use ID as the GPG key id.
> 
> Can you please add --local-user as the long form.

Sure.

> 
> >  " "@DOCSUBDIR@/README.MAIL"
> >  		exit 0
> >  	else
> > @@ -121,6 +127,20 @@ references_header() {
> >  	[ -n "$references" ] && echo "References: $references"
> >  }
> >  
> > +sign_mail()
> > +{
> > +	if [ -z "$opt_gpg" ]; then
> > +		cat
> > +	else
> > +		local tmpfile=$(gen_tempfile)
> > +
> > +		$QUILT_DIR/scripts/gpgmail.pl --agent $opt_gpgid > $tmpfile || exit 1
> > +		$QUILT_DIR/scripts/gpgvmail.pl $opt_gpgid $tmpfile || exit 1
> > +		cat $tmpfile;
> > +		rm -r $tmpfile;
> > +	fi
> > +}
> > +	
> >  process_mail()
> >  {
> >  	local tmpfile=$(gen_tempfile)
> > @@ -138,12 +158,12 @@ process_mail()
> >  			${QUILT_SENDMAIL_ARGS--f "$opt_sender"} "$@"
> >  		$QUILT_DIR/scripts/edmail --charset $opt_charset \
> >  				 --remove-header Bcc "$@" < $tmpfile \
> > -		| ${QUILT_SENDMAIL:-sendmail} \
> > +		| sign_mail | ${QUILT_SENDMAIL:-sendmail} \
> >  			${QUILT_SENDMAIL_ARGS--f "$opt_sender"} "$@"
> >  	else
> >  		local from_date=$(date "+%a %b %e %H:%M:%S %Y")
> >  		echo "From $opt_sender_address $from_date"
> > -		sed -e 's/^From />From /' $tmpfile
> > +		sed -e 's/^From />From /' $tmpfile | sign_mail
> >  		echo
> >  	fi
> >  	rm -f $tmpfile
> > @@ -159,8 +179,8 @@ join_lines() {
> >  	'
> >  }
> >  
> > -options=`getopt -o m:h --long from:,to:,cc:,bcc:,subject: \
> > -		       --long send,mbox:,charset:,sender: \
> > +options=`getopt -o m:u:h --long from:,to:,cc:,bcc:,subject: \
> > +		       --long send,gpg,mbox:,charset:,sender: \
> >  		       --long prefix:,reply-to:,signature: -- "$@"`
> >  
> >  if [ $? -ne 0 ]
> > @@ -215,6 +235,12 @@ do
> >  	--reply-to)
> >  		opt_reply_to=$2
> >  		shift 2 ;;
> > +	--gpg)
> > +		opt_gpg=1
> > +		shift ;;
> > +	-u)
> > +		opt_gpgid="-u $2"
> > +		shift 2;;
> >  	--signature)
> >  		if [ "$2" = - ]
> >  		then
> > diff --git a/quilt/scripts/gpgmail.in b/quilt/scripts/gpgmail.in
> > new file mode 100644
> > index 0000000..57151af
> > --- /dev/null
> > +++ b/quilt/scripts/gpgmail.in
> > @@ -0,0 +1,144 @@
> > +#! @PERL@ -w
> > +
> > +use strict;
> > +
> > +use MIME::QuotedPrint;
> > +use Getopt::Long;
> > +
> > +my $agent = 0;
> > +my $pass = "";
> > +my $gpgid = "";
> > +
> > +my $result = GetOptions(
> > +    "passwd=s"	=>	\$pass,
> > +    "u=s"	=>	\$gpgid,
> > +    "agent"	=>	\$agent,
> > +    );
> > +
> > +if (length($gpgid) > 0) {
> > +    $gpgid = "-u $gpgid";
> > +}
> > +
> > +if ($agent) {
> > +    $pass = " --use-agent ";
> > +} elsif (length($pass)) {
> > +    $pass = " --passphrase $pass ";
> > +}
> > +
> > +if ($#ARGV >= 0) {
> > +    open(IN, $ARGV[0]) or die "can't read $ARGV[0]";
> > +} else {
> > +    *IN = *STDIN;
> > +}
> > +
> > +my $debug = 0;
> > +my $debugfile = "/tmp/debug-gpgmail.pl";
> > +if ($debug) {
> > +    open (OUT, ">", $debugfile) or die "Can't open debug file $debugfile";
> > +} else {
> > +    *OUT = *STDOUT;
> > +}
> 
> What's this $debugfile stuff?  Can't this be removed?

Oops, sorry. Yeah you can remove it. I needed it to see what was
screwing up.

> 
> > +my $content;
> > +my $quot;
> > +my $quoted = 0;
> > +
> > +while (<IN>) {
> > +    if (/^Content-Type/) {
> > +	s/$/\r/;
> > +	$content = $_;
> > +
> > +    } elsif (/^Content-Transfer-Encoding/) {
> > +	s/$/\r/;
> > +	$quot = $_;
> > +	$quoted = 1;
> > +
> > +    } elsif (/^$/) {
> > +	last;
> > +    } else {
> > +	print OUT;
> > +    }
> > +}
> > +
> > +my $scissor = sprintf "%s", crypt( sprintf("%d", rand * 1000), sprintf("%d", rand * 100));
> > +
> > +print OUT "Content-Type: multipart/signed; micalg=\"pgp-sha1\"; protocol=\"application/pgp-signature\"; boundary=\"$scissor\"";
> > +
> > +print OUT "\n\n";
> > +
> > +my $convert = 0;
> > +
> > +if (!defined($content)) {
> > +    $content = "Content-Type: text/plain; charset=\"UTF-8\"\r\n";
> > +    $quot = "Content-Transfer-Encoding: quoted-printable\r\n";
> > +    $convert = 1;
> > +    $quoted = 1;
> > +}
> > +
> > +print OUT "--$scissor\n";
> > +
> > +my @lines;
> > +
> > +$lines[$#lines + 1] = $content;
> > +if ($quoted) {
> > +    $lines[$#lines + 1] = $quot;
> > +}
> > +$lines[$#lines + 1] = "\r\n";
> > +
> > +my @rest;
> > +
> > +my @rest = <IN>;
> > +
> > +    
> > +if ($convert) {
> > +    foreach my $line (@rest) {
> > +	$line = encode_qp($line,"\r\n");
> > +	$line =~ s/^From />From /;
> > +    }
> > +}
> > +
> > +@lines = (@lines, @rest);
> > +
> > +close IN;
> > +
> > +my $tmpfile = "/tmp/gpgmail.$$";
> > +
> > +open(TMP, ">", $tmpfile) or die "Can't create a temporary file";
> 
> That's not an appropriate way to create a temp file ... do we need a
> temp file in the first place though?

OK, what's the "appropriate" way?  As for removing the temp file, I just
found it was the easiest way to pipe into gpg. If there's a better way
to do that, I'm all ears.

> 
> > +print TMP @lines;
> > +
> > +close TMP;
> > +
> > +# put the lines back to unix
> > +foreach my $line (@lines) {
> > +    $line =~ s/\r//g;
> > +}
> 
> What's going on with "\r\n" line endings all over the script?  Can't the
> "\n" line endings be converted to "\r\n" in a single place instead?
> 
> 	foreach my $line (@lines) {
> 	    $_ = $line; s/\n$/\r\n/; print;
> 	}

gpg email sigs requires that the lines it process end with a \r\n even
when the lines do not. But I also find that this makes the patch ugly.
We could try to keep it, but the biggest stumbling block I had in
getting the signatures to work was the stupid \r\n manipulations :-p

-- Steve


