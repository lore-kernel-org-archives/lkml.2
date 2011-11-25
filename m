Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab1KYXnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 18:43:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59589 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab1KYXnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 18:43:40 -0500
Date: Fri, 25 Nov 2011 16:42:53 -0700
From: Jean Sacren <sakiwit@gmail.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Reinhard Tartler <Reinhard.Tartler@informatik.uni-erlangen.de>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, amwang@redhat.com, sakiwit@gmail.com
Subject: [PATCH] kbuild: Fix compiler warning with assertion when calling
 'fwrite'
Message-ID: <20111125234253.GD14454@mail.gmail.com>
References: <87lisype1v.fsf@faui43f.informatik.uni-erlangen.de>
 <CACqU3MWZuqgpxG7FSvr2LkqTqwF-gQM8hQSnTTpHpcWT2LHGNA@mail.gmail.com>
 <4EC8FF93.7010706@suse.cz>
 <20111123055351.GB14454@mail.gmail.com>
 <877h2r1hb3.fsf@faui43f.informatik.uni-erlangen.de>
 <CACqU3MXe3vu8OmcTsU4u8h+zWfOyo455Q-RLAJrADJM4xoJnPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACqU3MXe3vu8OmcTsU4u8h+zWfOyo455Q-RLAJrADJM4xoJnPg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaud Lacombe <lacombar@gmail.com>
Date: Wed, 23 Nov 2011 13:05:53 -0500
>
> Hi,
> 
> 2011/11/23 Reinhard Tartler <Reinhard.Tartler@informatik.uni-erlangen.de>:
> > On Mi, Nov 23, 2011 at 06:53:51 (CET), Jean Sacren wrote:
> >
> >> From: Michal Marek <mmarek@suse.cz>
> >> Date: Sun, 20 Nov 2011 14:24:35 +0100
> >>>
> >>> On 7.10.2011 05:29, Arnaud Lacombe wrote:
> >>> > Hi,
> >>> >
> >>> > 2011/10/6 Reinhard Tartler <Reinhard.Tartler@informatik.uni-erlangen.de>:
> >>> >> fwrite indicates '1' written member if a zero-length string is written.
> >>> > you forgot the "Signed-off-by: " part :)
> >>>
> >>> Reinhard, can I assume
> >>>
> >>> Signed-off-by: Reinhard Tartler
> >>> <Reinhard.Tartler@informatik.uni-erlangen.de>
> >>>
> >>> ? The patch is otherwise correct.
> >>
> >> I have two reasons to oppose this patch.
> >>
> >> 1. If 'len' value is zero, there is an issue already and it should be
> >> taken care of _before_ calling fwrite().
> >
> > So you're saying the function assumes a non-empty string? Why?
> AFAIK, fwrite(3) is currently used:
>  1) in comment printers. Empty comment are not allowed.
>  2) in a callback passed to expr_print(), where the string printed is
> non-empty[0]
>  2) in the lexer, auto-generated, and unused
> 
> So Jean's point is valid, but for this comment to be pedantic, I would
> not weakly test for `len > 0', but enforce assumptions above with an
> assertion, by both converting the existing direct call to xfwrite()
> and add `assert(len > 0)' before calling fwrite(3).

I prepared a patch to take care of this corner case. Review is
appreciated. Thanks.

-- 
Jean Sacren

-->8

[PATCH] kbuild: Fix compiler warning with assertion when calling 'fwrite'

Reinhard Tartler discovered a corner case of calling xfwrite() where the
length of the string is zero.

Arnaud Lacombe suggested to use assertion for the corner case, as
fwrite(3) is currently used:

 1) in comment printers. Empty comment are not allowed.
 2) in a callback passed to expr_print(), where the string printed is
    either NULL OR non-empty.
 3) in the lexer, auto-generated, and unused.

I feel using assertion is a good solution:

 1) It cleanly takes care of the above-mentioned corner case.
 2) It can be easily disabled by defining NDEBUG.
 3) It asserts xfwrite() is simply a wrapper for fwrite().

Reported-by: Reinhard Tartler <Reinhard.Tartler@informatik.uni-erlangen.de>
Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
Signed-off-by: Jean Sacren <sakiwit@gmail.com>
---
 scripts/kconfig/expr.h |    1 +
 scripts/kconfig/lkc.h  |    6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index 80fce57..d4ecce8 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -10,6 +10,7 @@
 extern "C" {
 #endif
 
+#include <assert.h>
 #include <stdio.h>
 #ifndef __cplusplus
 #include <stdbool.h>
diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index b633bdb..c18f2bd 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -90,8 +90,10 @@ struct conf_printer {
 /* confdata.c and expr.c */
 static inline void xfwrite(const void *str, size_t len, size_t count, FILE *out)
 {
-	if (fwrite(str, len, count, out) < count)
-		fprintf(stderr, "\nError in writing or end of file.\n");
+	assert(len != 0);
+
+	if (fwrite(str, len, count, out) != count)
+		fprintf(stderr, "Error in writing or end of file.\n");
 }
 
 /* menu.c */
