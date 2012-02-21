Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab2BUS0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:26:08 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:48005 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab2BUS0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:26:05 -0500
Date: Tue, 21 Feb 2012 19:26:02 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>, thomas@m3y3r.de, raven@themaw.net,
        linux-kernel@vger.kernel.org
Subject: Use gcc to check exported files [Was: Linux 3.3-rc4]
Message-ID: <20120221182602.GA23831@merkur.ravnborg.org>
References: <CA+55aFy2pnoNhpTstAMTs+dtm5iRaGCGKLwW6ScCLhEkWtHXGw@mail.gmail.com> <FE1DCD87-0055-4C3E-B06A-251055E1492F@m3y3r.de> <CA+55aFzUWDEuj85sOKjwk8ufy+1rbS7hgstw0cCWpjTgu=7B4A@mail.gmail.com> <20120219.144947.660678318380307878.davem@davemloft.net> <CA+55aFwqChUmmDfoYX7HRUUZg5s7nBOh834=g+7avj=yc42gGg@mail.gmail.com> <4F431BE8.1030201@zytor.com> <20120221130345.5c96ce60@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120221130345.5c96ce60@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 01:03:45PM +0000, Alan Cox wrote:
> > I'm starting to think we should compile the kernel with -Wpadded by
> > default (currently it's only done at "warning level 3", which I doubt
> > anyone ever uses, especially since that also includes -Wpacked which is
> > an actively toxic warning) and force people to add explicit padding
> > where it needs to go, if necessary.  Unfortunately even that doesn't
> > guarantee compatibility with userspace, but it's at least something.
> 
> We generate a set of believed correct export headers and check them these
> days as an option. Can that work not be turned to do this. Ie create a
> temporary .c file that includes all the user visible header data (without
> KERNEL being defined) and runs it through -Wpacked etc

Hi Alan.

If we require every exported file to be buildable on thier own
then it is simple to run gcc on every exported file.

We have before discussed that our header files should include everything
they need - and at least forcing this for our user-space headers would not be bad.

Simple hack I cooked up (will not work if you use O=...):

diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
index 7957e7a..b479575 100644
--- a/scripts/headers_check.pl
+++ b/scripts/headers_check.pl
@@ -27,12 +27,16 @@ my $line;
 my $lineno = 0;
 my $filename;
 
+my $gcc_options = "-Wall -Wpadded";
+my $gcc_include = "-I usr/include";
+
 foreach my $file (@files) {
 	$filename = $file;
 
 	open(my $fh, '<', $filename)
 		or die "$filename: $!\n";
 	$lineno = 0;
+	&check_build();
 	while ($line = <$fh>) {
 		$lineno++;
 		&check_include();
@@ -45,6 +49,13 @@ foreach my $file (@files) {
 }
 exit $ret;
 
+# Check that the header-file can build
+# All exported headers are assumed to include what they need
+sub check_build
+{
+	system("gcc -xc -c $gcc_include $gcc_options $filename")
+}
+
 sub check_include
 {
 	if ($line =~ m/^\s*#\s*include\s+<((asm|linux).*)>/) {


Now we just need someone to fix up the headers....
I counted around 870 errors in 160 files.
But 99% looked trivial to fix...

Almost all is a matter of adding one or a few missing includes.

	Sam

