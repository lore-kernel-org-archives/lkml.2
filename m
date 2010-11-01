Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab0KAUQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 16:16:58 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:56927 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab0KAUQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 16:16:56 -0400
Date: Mon, 1 Nov 2010 21:06:23 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: michael@ellerman.id.au, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@pcug.org.au>
Subject: Re: [PATCH] iSeries: Remove unused mf_getSrcHistory function.
In-Reply-To: <20101102071025.2fe5e6ca.sfr@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1011012104050.12889@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1010301911220.1572@swampdragon.chaosbits.net> <1288609842.10671.7.camel@concordia> <20101102071025.2fe5e6ca.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Nov 2010, Stephen Rothwell wrote:

> Hi Jesper,
> 
> On Mon, 01 Nov 2010 22:10:42 +1100 Michael Ellerman <michael@ellerman.id.au> wrote:
> >
> > On Sat, 2010-10-30 at 19:20 +0200, Jesper Juhl wrote:
> > > 
> > > If memory is tight and a dynamic allocation fails there's no reason to 
> > > make a bad situation worse by leaking memory.
> > > 
> > > mf_getSrcHistory potentially leaks pages[0-3]. I believe the right thing 
> > > to do is to free that memory again before returning -ENOMEM - which is 
> > > what this patch does.
> > > 
> > > I realize that the function is under '#if 0' so this probably doesn't 
> > > matter much, but I assume that the function is still there for a reason 
> > > (but I could be wrong, I don't know the powerpc code).
> > > Anyway, I suggest we remove the leak.
> > 
> > Stephen is the iSeries maintainer, and I think he #if 0'ed the code. But
> > I don't think it will ever be un-ifdef'ed, so should probably just be
> > removed.
> 
> Well, only unofficially iseries maintainer :-)
> 
> Yes, just remove the whole function ... it was never used and never will
> be.
> 

Done.

Remove unused function 'mf_getSrcHistory' (that will never be used ever 
according to Stephen Rothwell).

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 mf.c |   46 ----------------------------------------------
 1 file changed, 46 deletions(-)

diff --git a/arch/powerpc/platforms/iseries/mf.c b/arch/powerpc/platforms/iseries/mf.c
index 42d0a88..56cfd8c 100644
--- a/arch/powerpc/platforms/iseries/mf.c
+++ b/arch/powerpc/platforms/iseries/mf.c
@@ -1045,52 +1045,6 @@ static const struct file_operations mf_side_proc_fops = {
 	.write		= mf_side_proc_write,
 };
 
-#if 0
-static void mf_getSrcHistory(char *buffer, int size)
-{
-	struct IplTypeReturnStuff return_stuff;
-	struct pending_event *ev = new_pending_event();
-	int rc = 0;
-	char *pages[4];
-
-	pages[0] = kmalloc(4096, GFP_ATOMIC);
-	pages[1] = kmalloc(4096, GFP_ATOMIC);
-	pages[2] = kmalloc(4096, GFP_ATOMIC);
-	pages[3] = kmalloc(4096, GFP_ATOMIC);
-	if ((ev == NULL) || (pages[0] == NULL) || (pages[1] == NULL)
-			 || (pages[2] == NULL) || (pages[3] == NULL))
-		return -ENOMEM;
-
-	return_stuff.xType = 0;
-	return_stuff.xRc = 0;
-	return_stuff.xDone = 0;
-	ev->event.hp_lp_event.xSubtype = 6;
-	ev->event.hp_lp_event.x.xSubtypeData =
-		subtype_data('M', 'F', 'V', 'I');
-	ev->event.data.vsp_cmd.xEvent = &return_stuff;
-	ev->event.data.vsp_cmd.cmd = 4;
-	ev->event.data.vsp_cmd.lp_index = HvLpConfig_getLpIndex();
-	ev->event.data.vsp_cmd.result_code = 0xFF;
-	ev->event.data.vsp_cmd.reserved = 0;
-	ev->event.data.vsp_cmd.sub_data.page[0] = iseries_hv_addr(pages[0]);
-	ev->event.data.vsp_cmd.sub_data.page[1] = iseries_hv_addr(pages[1]);
-	ev->event.data.vsp_cmd.sub_data.page[2] = iseries_hv_addr(pages[2]);
-	ev->event.data.vsp_cmd.sub_data.page[3] = iseries_hv_addr(pages[3]);
-	mb();
-	if (signal_event(ev) != 0)
-		return;
-
- 	while (return_stuff.xDone != 1)
- 		udelay(10);
- 	if (return_stuff.xRc == 0)
- 		memcpy(buffer, pages[0], size);
-	kfree(pages[0]);
-	kfree(pages[1]);
-	kfree(pages[2]);
-	kfree(pages[3]);
-}
-#endif
-
 static int mf_src_proc_show(struct seq_file *m, void *v)
 {
 #if 0
 

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

