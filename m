Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933982Ab2JWU0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:26:21 -0400
Received: from mail.x86-64.org ([217.9.48.20]:55680 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933945Ab2JWU0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:26:17 -0400
Date: Tue, 23 Oct 2012 22:26:12 +0200
From: Borislav Petkov <bp@amd64.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Denis Kirjanov <kirjanov@gmail.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH] edac: fix buffer overrun if no suitable bandwidth found
Message-ID: <20121023202612.GA20526@aftab.osrc.amd.com>
References: <1350919858-26202-1-git-send-email-kirjanov@gmail.com>
 <20121023121005.ed33061a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121023121005.ed33061a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 12:10:05PM -0700, Andrew Morton wrote:
> That's pretty strange code in there.
> 
> If the comment is to be believed, isn't this a suitable fix?
> 
> --- a/drivers/edac/amd64_edac.c~a
> +++ a/drivers/edac/amd64_edac.c
> @@ -171,7 +171,7 @@ static int __amd64_set_scrub_rate(struct
>  	 * bandwidth entry that is greater or equal than the setting requested
>  	 * and program that. If at last entry, turn off DRAM scrubbing.
>  	 */
> -	for (i = 0; i < ARRAY_SIZE(scrubrates); i++) {
> +	for (i = 0; i < ARRAY_SIZE(scrubrates) - 1; i++) {
>  		/*
>  		 * skip scrub rates which aren't recommended
>  		 * (see F10 BKDG, F3x58)
> _
> 
> Also, I don't think "buffer overrun" is an appropriate description here
> - to me, "buffer overrun" implies writing to memory outside the buffer.
>  I'd call this "array overindexing" or similar.
> 
> Finally, when fixing a bug, please always describe the user-visible
> impact of that bug.  You have cc'ed stable on this patch (using the
> incorrect email address, btw) which implies that the effects are serious,
> but people will want to know specific details about those effects when
> considering the patch.

Right, I took it for correctness' sake but after a heavy massaging. And
this is only a hypothetical case since we're always falling back to the
last element of scrubrates array which turns off scrubbing, based on the
supplied bandwidth. Thus no need for stable, IMO.

Let me know if this is what you had in mind.

 [ And yes, maybe I should rewrite this to de-awkwardize it :) ]

--
>From 70f063eb9aa9674613a21fb8e3f21ec4df0629c7 Mon Sep 17 00:00:00 2001
From: Denis Kirjanov <kirjanov@gmail.com>
Date: Mon, 22 Oct 2012 19:30:58 +0400
Subject: [PATCH] amd64_edac: Fix hypothetical out-of-bounds access

Make sure we stay within scrubrates' array bounds.

Boris: this is a correctness fix only because the loop terminates
earlier due to us capping scrubbing bandwidth to 0.

Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 501bfb938f26..73d9108d6200 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -181,14 +181,16 @@ static int __amd64_set_scrub_rate(struct pci_dev *ctl, u32 new_bw, u32 min_rate)
 
 		if (scrubrates[i].bandwidth <= new_bw)
 			break;
-
-		/*
-		 * if no suitable bandwidth found, turn off DRAM scrubbing
-		 * entirely by falling back to the last element in the
-		 * scrubrates array.
-		 */
 	}
 
+	/*
+	 * if no suitable bandwidth found, turn off DRAM scrubbing
+	 * entirely by falling back to the last element in the scrubrates
+	 * array.
+	 */
+	if (i == ARRAY_SIZE(scrubrates))
+		i--;
+
 	scrubval = scrubrates[i].scrubval;
 
 	pci_write_bits32(ctl, SCRCTRL, scrubval, 0x001F);
-- 
1.8.0

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
