Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab2KTPI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:08:27 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:1383 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab2KTPIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:08:25 -0500
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <1353424027.6559.15.camel@lb-tlvb-eilong.il.broadcom.com>
Subject: Re: [PATCH v2] checkpatch: add double empty line check
From: "Eilon Greenstein" <eilong@broadcom.com>
Reply-to: eilong@broadcom.com
To: "Andy Whitcroft" <apw@canonical.com>
cc: "Joe Perches" <joe@perches.com>, "David Rientjes" <rientjes@google.com>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Date: Tue, 20 Nov 2012 17:07:07 +0200
In-Reply-To: <20121120144329.GE7955@dm>
References: <1353151057.14327.18.camel@lb-tlvb-eilong.il.broadcom.com>
 <20121120115239.GA7955@dm>
 <1353421624.6559.9.camel@lb-tlvb-eilong.il.broadcom.com>
 <20121120144329.GE7955@dm>
Organization: Broadcom
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-Version: 1.0
X-WSS-ID: 7CB544513P86373451-11-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-20 at 14:43 +0000, Andy Whitcroft wrote:

> > > Also this fails if the fragment
> > > is at the top of the hunk emiting a perl warning.
> > 
> > I did not see this warning. Can you please share this example? I tried
> > adding a couple of empty lines at the beginning of a file and it seemed
> > to work just fine for me (using perl v5.14.2).lines
> 
> Ok, this is actually if it is at the bottom, not the top.  So if you
> have a range of lines newly added to the bottom of the file.  Leading to
> this warning:
> 
> Use of uninitialized value within @rawlines in pattern match (m//) at
> ../checkpatch/scripts/checkpatch.pl line 3586.

Oh... of course, I should have seen that. I did not check changes at the
end of the file.

What do you say about something like that (using nextline out of
rawlines only if it defined):
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 21a9f5d..c0c610c 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3579,6 +3579,19 @@ sub process {
                        WARN("EXPORTED_WORLD_WRITABLE",
                             "Exporting world writable files is usually an error. Consider more restrictive permissions.
                }
+
+# check for double empty lines
+               if ($line =~ /^\+\s*$/) {
+                       my $nextline = "";
+                       if (defined($rawlines[$linenr])) {
+                               $nextline = $rawlines[$linenr];
+                       }
+                       if ($nextline =~ /^\s*$/ ||
+                           $prevline =~ /^\+?\s*$/ && $nextline !~ /^\+\s*$/) {
+                               CHK("DOUBLE_EMPTY_LINE",
+                                   "One empty line should be sufficient. Consider removing this one.\n" . $herecurr);
+                       }
+               }
        }
 


If you think it's appropriate, I will send a clean copy.

Thanks,
Eilon


