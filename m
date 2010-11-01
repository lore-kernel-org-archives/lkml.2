Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab0KAVzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 17:55:10 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23378 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab0KAVzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 17:55:07 -0400
Date: Mon, 1 Nov 2010 22:44:34 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Borislav Petkov <bp@alien8.de>
cc: linux-kernel@vger.kernel.org, Peter Oruba <peter.oruba@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        amd64-microcode@amd64.org
Subject: [PATCH v2] AMD Microcode: Prefer vzalloc() over calls to
 vmalloc()+memset().
In-Reply-To: <20101101212747.GA23907@liondog.tnic>
Message-ID: <alpine.LNX.2.00.1011012239390.12889@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1010302118160.1572@swampdragon.chaosbits.net> <20101031100833.GA18633@liondog.tnic> <alpine.LNX.2.00.1011012020500.12889@swampdragon.chaosbits.net> <20101101212747.GA23907@liondog.tnic>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Nov 2010, Borislav Petkov wrote:

> On Mon, Nov 01, 2010 at 08:23:23PM +0100, Jesper Juhl wrote:
> > Thank you for the feedback I'll prepare a new version of the patch 
> > incorporating it, then resend it. 
> > 
> > One thing I'm not entirely sure about though is how to credit you with 
> > your improment to my original patch. Would I simply prepend
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > Signed-off-by: Borislav Petkov <bp@alien8.de>
> > 
> > or should I leave just my own Signed-off-by: and then mention you in the 
> > changelog part of the mail or? 
> 
> How very considerate of you, but no need. Simply put your SOB in and
> I'll ack it.
> 
Ok. I just care a great deal about assigning credit where due, since for 
some of us (me included) the only credit we ever get for our work is the 
small credit attributed to us via the SOB or similar... But, I'll just 
(almost) respin the patch with just my own SOB below.



We don't have to do memset() ourselves after vmalloc() when we have 
vzalloc(), so change that in 
arch/x86/kernel/microcode_amd.c::get_next_ucode().
Thanks to Borislav Petkov for improvement suggestions.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 microcode_amd.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index e1af7c0..383d4f8 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -183,16 +183,17 @@ get_next_ucode(const u8 *buf, unsigned int size, unsigned int *mc_size)
 		return NULL;
 	}
 
-	mc = vmalloc(UCODE_MAX_SIZE);
-	if (mc) {
-		memset(mc, 0, UCODE_MAX_SIZE);
-		if (get_ucode_data(mc, buf + UCODE_CONTAINER_SECTION_HDR,
-				   total_size)) {
-			vfree(mc);
-			mc = NULL;
-		} else
-			*mc_size = total_size + UCODE_CONTAINER_SECTION_HDR;
+	mc = vzalloc(UCODE_MAX_SIZE);
+	if (!mc)
+		return NULL;
+
+	if (get_ucode_data(mc, buf + UCODE_CONTAINER_SECTION_HDR, total_size)) {
+		vfree(mc);
+		mc = NULL;
+	} else {
+		*mc_size = total_size + UCODE_CONTAINER_SECTION_HDR;
 	}
+
 	return mc;
 }
 


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

