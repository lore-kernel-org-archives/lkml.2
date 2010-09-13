Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab0IMGNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 02:13:35 -0400
Received: from ist.d-labs.de ([213.239.218.44]:40203 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab0IMGNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 02:13:34 -0400
Date: Mon, 13 Sep 2010 08:13:30 +0200
From: Florian Mickler <florian@mickler.org>
To: Joe Perches <joe@perches.com>
Cc: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
        "Stephen Hemminger (role:commit_signer)" <shemminger@vyatta.com>,
        "Wolfram Sang (role:commit_signer)" <w.sang@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get_maintainer.pl: Look for .get_maintainer.conf in lk,
 then $HOME then scripts
Message-ID: <20100913081330.57ab03bc@schatten.dmk.lab>
In-Reply-To: <1284355299.22185.65.camel@Joe-Laptop>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	<1284111767.1783.35.camel@Joe-Laptop>
	<20100910123040.5a6f0128@schatten.dmk.lab>
	<30366.1284350506@localhost>
	<1284355299.22185.65.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Sep 2010 22:21:39 -0700
Joe Perches <joe@perches.com> wrote:

> On Mon, 2010-09-13 at 00:01 -0400, Valdis.Kletnieks@vt.edu wrote:
> > Any chance of getting that to be ~/.get_maintainer.conf rather than
> > ./.get_maintainer.conf? I've just gotten bit like the 3rd or 4th time by "oh but
> > you didn't create that file in *this* tree" (I usually have a linus git tree, a linux-next
> > tree, and 3-4 -mm trees lying around).
> 
> Sure.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
> index b228198..ea54561 100755
> --- a/scripts/get_maintainer.pl
> +++ b/scripts/get_maintainer.pl
> @@ -107,10 +107,12 @@ my %VCS_cmds_hg = (
>      "blame_commit_pattern" => "^([0-9a-f]+):"
>  );
>  
> -if (-f "${lk_path}.get_maintainer.conf") {
> +my $conf = which_conf(".get_maintainer.conf");
> +if (-f $conf) {
>      my @conf_args;
> -    open(my $conffile, '<', "${lk_path}.get_maintainer.conf")
> -	or warn "$P: Can't open .get_maintainer.conf: $!\n";
> +    open(my $conffile, '<', "$conf")
> +	or warn "$P: Can't find a readable .get_maintainer.conf file $!\n";
> +
>      while (<$conffile>) {
>  	my $line = $_;
>  
> @@ -952,6 +954,18 @@ sub which {
>      return "";
>  }
>  
> +sub which_conf {
> +    my ($conf) = @_;
> +
> +    foreach my $path (split(/:/, ".:$ENV{HOME}:.scripts")) {
> +	if (-e "$path/$conf") {
> +	    return "$path/$conf";
> +	}
> +    }
> +
> +    return "";
> +}
> +
>  sub mailmap {
>      my (@lines) = @_;
>      my %hash;
> 
> 

What about just using an array?

From: Florian Mickler <florian@mickler.org>
Date: Mon, 13 Sep 2010 07:57:29 +0200
Subject: [PATCH] get_maintainer.pl: read also ~/.get_maintainer.conf

Read first .get_maintainer.conf from current source tree, then from
home.
This means that cmdline switches trump source-tree-config which trump
~/.get_maintainer.conf.

Signed-off-by: Florian Mickler <florian@mickler.org>
---
 scripts/get_maintainer.pl |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index b228198..937da0b 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -107,10 +107,15 @@ my %VCS_cmds_hg = (
     "blame_commit_pattern" => "^([0-9a-f]+):"
 );
 
-if (-f "${lk_path}.get_maintainer.conf") {
+my @configfiles = ("${lk_path}.get_maintainer.conf",
"$ENV{ HOME }/.get_maintainer.conf"); +while (my $cf =
shift(@configfiles)){ my @conf_args;
-    open(my $conffile, '<', "${lk_path}.get_maintainer.conf")
-	or warn "$P: Can't open .get_maintainer.conf: $!\n";
+
+    next unless (-f $cf);
+
+    open(my $conffile, '<', $cf)
+	or warn "$P: Can't open $cf: $!\n";
+
     while (<$conffile>) {
 	my $line = $_;
 
-- 
1.7.2



