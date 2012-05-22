Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736Ab2EVQsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 12:48:20 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46807 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751032Ab2EVQsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 12:48:18 -0400
Message-ID: <1337705294.326.11.camel@joe2Laptop>
Subject: Re: [PATCH 1/1] checkpatch: don't fake typedefs with #define
From: Joe Perches <joe@perches.com>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: linux-kernel@vger.kernel.org, apw@canonical.com
Date: Tue, 22 May 2012 09:48:14 -0700
In-Reply-To: <20120522080123.GD25862@pcarmody2.research.nokia.com>
References: <1337259132-28774-1-git-send-email-ext-phil.2.carmody@nokia.com>
	 <1337288048.17726.64.camel@joe2Laptop>
	 <20120517211641.GC27953@pcarmody2.research.nokia.com>
	 <1337289897.8872.8.camel@joe2Laptop>
	 <20120521120511.GG1197@pcarmody2.research.nokia.com>
	 <1337618463.13010.4.camel@joe2Laptop>
	 <20120522080123.GD25862@pcarmody2.research.nokia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-22 at 11:01 +0300, Phil Carmody wrote:
> On 21/05/12 09:41 -0700, ext Joe Perches wrote:
> > On Mon, 2012-05-21 at 15:05 +0300, Phil Carmody wrote:
> > > +# check for deliberate avoidance of the above anti-typedef rule
> > > +               if ($line =~ /#\s*define\s+$Ident\s+(enum|union|struct)\s+$Ident\b/) {
>  
> > I believe this would not catch,
> > 
> > #define typedeflike_define_t	\
> > 	struct foo
> > 
> > If it's deliberate, you probably want to.
> > 
> > So maybe you want to move this and use
> > the $stat tests like the extern or memset
> > tests do (look around line 3200).
> 
> Thanks for the pointer. This flags everything I'm interested in:
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index faea0ec..408aee0 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -3319,6 +3319,13 @@ sub process {
>                              "externs should be avoided in .c files\n" .  $herecurr);
>                 }
>  
> +# check for deliberate avoidance of the anti-typedef rule
> +               if (defined $stat &&
> +                   $stat =~ /#\s*define\s+$Ident\s+(enum|union|struct)\s+$Ident\b/) {
> +                       WARN("NEW_TYPEDEFS",
> +                            "do not fake typedefs using #define\n" . $herecurr);
> +               }
> +

This doesn't trigger on the example I gave you.

$ cat def_type.c
#define foo struct bar

#define foo					\
	struct bar

#define foo /* baz */				\
	struct bar

#define foo /* baz */				\
						\
	struct /* baz */ bar
$

It seems for macros the $dstat variable needs to be tested.

Try this:

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index faea0ec..fc4df52 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2933,6 +2933,21 @@ sub process {
 				^\"|\"$
 			}x;
 			#print "REST<$rest> dstat<$dstat> ctx<$ctx>\n";
+
+# check for deliberate avoidance of the anti-typedef rule
+			if ($dstat =~ /(enum|union|struct)\s+$Ident\b/) {
+				$ctx =~ s/\n*$//;
+				my $herectx = $here . "\n";
+				my $cnt = statement_rawlines($ctx);
+
+				for (my $n = 0; $n < $cnt; $n++) {
+					$herectx .= raw_line($linenr, $n) . "\n";
+				}
+
+				WARN("NEW_TYPEDEFS",
+				     "do not fake typedefs using #define\n" . $herectx);
+			}
+
 			if ($dstat ne '' &&
 			    $dstat !~ /^(?:$Ident|-?$Constant),$/ &&			# 10, // foo(),
 			    $dstat !~ /^(?:$Ident|-?$Constant);$/ &&			# foo();


