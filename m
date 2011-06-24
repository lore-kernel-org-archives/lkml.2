Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529Ab1FXNvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:51:07 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:50162 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340Ab1FXNvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:51:03 -0400
Date: Fri, 24 Jun 2011 15:51:00 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Michal Marek <mmarek@suse.cz>
Cc: Joe Perches <joe@perches.com>, Nick Bowler <nbowler@elliptictech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Frysinger <vapier@gentoo.org>, Sam Ravnborg <sam@ravnborg.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: {PATCH] fix __packed in exported kernel headers
Message-ID: <20110624135100.GB1708@x4.trippels.de>
References: <20110622063441.GA1740@x4.trippels.de>
 <20110623134209.GA10813@elliptictech.com>
 <20110623150209.GA12413@x4.trippels.de>
 <1308848277.6688.7.camel@Joe-Laptop>
 <4E048C0D.7020403@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E048C0D.7020403@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.06.24 at 15:07 +0200, Michal Marek wrote:
> On 23.6.2011 18:57, Joe Perches wrote:
> > On Thu, 2011-06-23 at 17:02 +0200, Markus Trippelsdorf wrote:
> >> On 2011.06.23 at 09:42 -0400, Nick Bowler wrote:
> >>> On 2011-06-22 08:34 +0200, Markus Trippelsdorf wrote:
> >>>> One possible solution would be to let the "scripts/headers_install.pl"
> >>>> script automatically substitute __packed with __attribute__((packed)):
> >>>>
> >>>> diff --git a/scripts/headers_install.pl b/scripts/headers_install.pl
> > []
> >> I'm not an expert of Perl regular expressions, but maybe this:
> >>   $line =~ s/\s__packed;$/ __attribute__((packed));/g
> >> is a little bit closer to the intention?
> >
> > Maybe:
> >
> > s/\b__packed\b/__attribute__((packed))/g
> 
> Markus, will you post a patch with this fix?
> 

checkpatch.pl warns about using __attribute__((packed)) in kernel
headers: "__packed is preferred over __attribute__((packed))". If one
follows that advice it could cause problems in the exported header
files, because the outside world doesn't know about this shortcut.

For example busybox will fail to compile:
 CC      miscutils/ubi_attach_detach.o
 In file included from miscutils/ubi_attach_detach.c:27:0:
 /usr/include/mtd/ubi-user.h:330:3: error: conflicting types for ‘__packed’
 /usr/include/mtd/ubi-user.h:314:3: note: previous declaration of ‘__packed’ was here
...

Fix the problem by substituting __packed with __attribute__((packed)) in
the header_install.pl script.

Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
CC: Joe Perches <joe@perches.com>
Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>
---
 scripts/headers_install.pl |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/headers_install.pl b/scripts/headers_install.pl
index efb3be1..48462be 100644
--- a/scripts/headers_install.pl
+++ b/scripts/headers_install.pl
@@ -35,6 +35,7 @@ foreach my $file (@files) {
 		$line =~ s/([\s(])__iomem\s/$1/g;
 		$line =~ s/\s__attribute_const__\s/ /g;
 		$line =~ s/\s__attribute_const__$//g;
+		$line =~ s/\b__packed\b/__attribute__((packed))/g;
 		$line =~ s/^#include <linux\/compiler.h>//;
 		$line =~ s/(^|\s)(inline)\b/$1__$2__/g;
 		$line =~ s/(^|\s)(asm)\b(\s|[(]|$)/$1__$2__$3/g;
-- 
Markus
