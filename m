Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab1EUTiy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 15:38:54 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62640 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001Ab1EUTiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 15:38:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=pqaR+FY3sYiP+w/UaAPtVPgLmmApf2Gn48Kb8UWEnrhvc+0bZCytUyl0/1B1PAXtr9
         z0ZJcZO+Yhc/dkxaTjVwXuM3MB3YFSE1BCVODO99lIFKVPyM+JExgdBpW9DK70vYtlUK
         eXnUr3KgnNAA/vLuq1ck2OHC1pMEYAlk6y6CI=
Subject: Re: PATCH] patch to generate warning when signed-of line in patch
 in not proper
From: anish <anish198519851985@gmail.com>
To: joe@perches.com
Cc: davej@redhat.com, rostedt@goodmis.org, apw@shadowen.org,
        akpm@linux-foundation.org, vapier@gentoo.org,
        linux-kernel@vger.kernel.org, man.k1983@gmail.com
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 May 2011 01:08:41 +0530
Message-ID: <1306006721.1622.18.camel@anish-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 21, 2011 at 9:33 PM, Joe Perches <joe@perches.com> wrote:

On Sat, 2011-05-21 at 20:14 +0530, anish singh wrote:
> Re-sending to get some comments on this.
>
> On Thu, May 19, 2011 at 10:53 PM, anish <anish198519851985@gmail.com>
> wrote:
>         From: anish kumar <anish198519851985@gmail.com>
>
>         This patch generates warning when there is no space between
>         the
>         patch submitter name and successive mail-id.


>>If you do this, why not do it for all signature types?

>>our $Valid_Signatures "(?:Signed-off-by:|Reviewed-by:|Acked-by:)"

Definitely.Please check below modified patch.

>         Signed-off-by: anish kumar <anish198519851985@gmail.com>
>         ---
>          scripts/checkpatch.pl |   10 ++++++++--
>          1 files changed, 8 insertions(+), 2 deletions(-)
>
>         diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
>         index d867081..437c6d4 100755
>         --- a/scripts/checkpatch.pl
>         +++ b/scripts/checkpatch.pl
>         @@ -1373,10 +1373,16 @@ sub process {
>                                        WARN("Signed-off-by: is the
>         preferred form\n" .
>                                                $herecurr);
>                                }
>         -                       if ($line =~ /^\s*signed-off-by:\S/i)
>         {
>         -                               WARN("space required after
>         Signed-off-by:\n" .


>>       if ($line =~ /^(\s*)($ValidSignatures)(\s*)(.*)$/i) {
>>               my $space_before = $1;
>>               my $sign_off = $2;
>>               my $space_after = $3;
>>               my $email = $4;
>>               if (defined $space_before && $space_before ne "") {
>>                       warning (no space before...)
>>               }
>>               if ($sign_off !~ /$Valid_Signature/) {
>>                       warning (signature case...)
>>               }
>>               if (!defined $space_after || $space_after ne " ") {
>>                       warning (need only one space after colon...)
>>               }
>>               if (!validate_email($4)) {
>>                       warning (bad email...)

Please check the below patch.

--------------------------------------------------------------------------

From: anish kumar <anish198519851985@gmail.com>

This patch generates warning when there is no space betweenthe  patch
submitter name and successive mail-id.As suggested by
Joe Perches(joe@perches.com) that we can do this for
all signature types.

Signed-off-by: anish kumar <anish198519851985@gmail.com>
---
 scripts/checkpatch.pl |   38 ++++++++++++++++++++++++--------------
 1 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d867081..6d67a17 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -29,6 +29,8 @@ my $summary_file = 0;
 my $root;
 my %debug;
 my $help = 0;
+my $sign;
+my @signs = ("Reviewed-by:","Acked-by:","Signed-off-by:","Tested-by:");
 
 sub help {
 	my ($exitcode) = @_;
@@ -1365,20 +1367,27 @@ sub process {
 			}
 		}
 
-#check the patch for a signoff:
-		if ($line =~ /^\s*signed-off-by:/i) {
-			# This is a signoff, if ugly, so do not double report.
-			$signoff++;
-			if (!($line =~ /^\s*Signed-off-by:/)) {
-				WARN("Signed-off-by: is the preferred form\n" .
-					$herecurr);
-			}
-			if ($line =~ /^\s*signed-off-by:\S/i) {
-				WARN("space required after Signed-off-by:\n" .
-					$herecurr);
-			}
-		}
-
+#check the patch for a signoff/Reviewed/Acked/Tested:
+        foreach $sign (@signs) {
+                 if ($line =~ /^\s*$sign/i) {
+                        # This is a signoff, if ugly, so do not double report.
+                        $signoff++;
+                   if (!($line =~ /^\s*$sign/)) {
+                                WARN("$sign is the preferred form\n" .
+                                        $herecurr);
+                        }
+                     if ($line =~ /^\s*$sign(.*)/i) {
+                          if($1 !~ /^\s*(\s[a-zA-Z]*.*)/i) {
+                                WARN("Space required after $sign\n" .
+                                        $herecurr);
+                                  }
+                              if($1 !~ /[\sa-zA-Z]+\s<.*>/i) {
+                                   WARN("Space required b/w Full Name & Mail-id:\n" .
+                                        $herecurr);
+                                }
+                        }
+        }
+}
 # Check for wrappage within a valid hunk of the file
 		if ($realcnt != 0 && $line !~ m{^(?:\+|-| |\\ No newline|$)}) {
 			ERROR("patch seems to be corrupt (line wrapped?)\n" .
@@ -2964,3 +2973,4 @@ sub process {
 
 	return $clean;
 }
+
-- 
1.7.0.4


