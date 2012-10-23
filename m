Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965592Ab2JWVJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:09:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56375 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933701Ab2JWVJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 17:09:40 -0400
Date: Tue, 23 Oct 2012 14:09:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Denis Kirjanov <kirjanov@gmail.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] edac: fix buffer overrun if no suitable bandwidth found
Message-Id: <20121023140939.28ed0df4.akpm@linux-foundation.org>
In-Reply-To: <20121023204926.GA20787@aftab.osrc.amd.com>
References: <1350919858-26202-1-git-send-email-kirjanov@gmail.com>
	<20121023121005.ed33061a.akpm@linux-foundation.org>
	<20121023202612.GA20526@aftab.osrc.amd.com>
	<20121023133709.21e9cb72.akpm@linux-foundation.org>
	<20121023204926.GA20787@aftab.osrc.amd.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2012 22:49:26 +0200
Borislav Petkov <bp@amd64.org> wrote:

> Now you only need to give me a proper patch with your S-O-B and we're
> ready to go :).

who, me, what?!?!  Sounds stressful.

umm, OK here we go.

What I don't understand is the effects of the bug.  If the present code
can indeed start using the n+1th element of the array then it's writing
random garbage into the hardware.  If this can ever happen then I
suspect that yes, a cc:stable is needed?



From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/edac/amd64_edac.c:__amd64_set_scrub_rate(): avoid overindexing scrubrates[]

If none of the elements in scrubrates[] matches, this loop will cause
__amd64_set_scrub_rate() to incorrectly use the n+1th element.

As the function is designed to use the final scrubrates[] element in the
case of no match, we can fix this bug by simply terminating the array
search at the n-1th element.

Reported-by: Denis Kirjanov <kirjanov@gmail.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/amd64_edac.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN drivers/edac/amd64_edac.c~drivers-edac-amd64_edacc-__amd64_set_scrub_rate-avoid-overindexing-scrubrates drivers/edac/amd64_edac.c
--- a/drivers/edac/amd64_edac.c~drivers-edac-amd64_edacc-__amd64_set_scrub_rate-avoid-overindexing-scrubrates
+++ a/drivers/edac/amd64_edac.c
@@ -170,8 +170,11 @@ static int __amd64_set_scrub_rate(struct
 	 * memory controller and apply to register. Search for the first
 	 * bandwidth entry that is greater or equal than the setting requested
 	 * and program that. If at last entry, turn off DRAM scrubbing.
+	 *
+	 * If no suitable bandwidth is found, turn off DRAM scrubbing entirely
+	 * by falling back to the last element in scrubrates[].
 	 */
-	for (i = 0; i < ARRAY_SIZE(scrubrates); i++) {
+	for (i = 0; i < ARRAY_SIZE(scrubrates) - 1; i++) {
 		/*
 		 * skip scrub rates which aren't recommended
 		 * (see F10 BKDG, F3x58)
@@ -181,12 +184,6 @@ static int __amd64_set_scrub_rate(struct
 
 		if (scrubrates[i].bandwidth <= new_bw)
 			break;
-
-		/*
-		 * if no suitable bandwidth found, turn off DRAM scrubbing
-		 * entirely by falling back to the last element in the
-		 * scrubrates array.
-		 */
 	}
 
 	scrubval = scrubrates[i].scrubval;
_

