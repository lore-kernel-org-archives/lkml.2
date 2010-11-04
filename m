Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab0KDXkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 19:40:39 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:28129 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab0KDXkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 19:40:37 -0400
Date: Fri, 5 Nov 2010 00:29:40 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Michael Ellerman <michael@ellerman.id.au>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] iSeries: Remove unused mf_getSrcHistory function and
 caller.
In-Reply-To: <1288657250.16790.4.camel@concordia>
Message-ID: <alpine.LNX.2.00.1011050026220.16015@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1010301911220.1572@swampdragon.chaosbits.net>  <1288609842.10671.7.camel@concordia>  <20101102071025.2fe5e6ca.sfr@canb.auug.org.au>  <alpine.LNX.2.00.1011012104050.12889@swampdragon.chaosbits.net>  <20101102082634.65342ce6.sfr@canb.auug.org.au>
  <alpine.LNX.2.00.1011012218420.12889@swampdragon.chaosbits.net> <1288657250.16790.4.camel@concordia>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Nov 2010, Michael Ellerman wrote:

> On Mon, 2010-11-01 at 22:20 +0100, Jesper Juhl wrote:
> > Hi Stephen,
> > 
> > On Tue, 2 Nov 2010, Stephen Rothwell wrote:
> > 
> > > On Mon, 1 Nov 2010 21:06:23 +0100 (CET) Jesper Juhl <jj@chaosbits.net> wrote:
> > > >
> > > > Remove unused function 'mf_getSrcHistory' (that will never be used ever 
> > > > according to Stephen Rothwell).
> > > > 
> > > > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > > 
> > > Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > > 
> > 
> > Ok, so if you are the (unofficial) iSeries maintainer and you don't merge 
> > the patch somewhere that'll eventually go up-stream, but just ACK it 
> > (thank you for that btw), then where do I send it to get it merged?
> 
> Here. ie. linuxppc-dev.
> 
> But, while you're removing it you should remove the #if 0'ed callsite as
> well, see mf_src_proc_show() in that file. :)
> 
Done. See patch below.


Remove unused function 'mf_getSrcHistory' (that will never be used 
ever according to Stephen Rothwell) and also remove most of (under 'if 
0') code from mf_src_proc_show() where the function was called.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 mf.c |   62 
--------------------------------------------------------------
 1 file changed, 62 deletions(-)

diff --git a/arch/powerpc/platforms/iseries/mf.c b/arch/powerpc/platforms/iseries/mf.c
index 42d0a88..b5e026b 100644
--- a/arch/powerpc/platforms/iseries/mf.c
+++ b/arch/powerpc/platforms/iseries/mf.c
@@ -1045,71 +1045,9 @@ static const struct file_operations mf_side_proc_fops = {
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
-#if 0
-	int len;
-
-	mf_getSrcHistory(page, count);
-	len = count;
-	len -= off;
-	if (len < count) {
-		*eof = 1;
-		if (len <= 0)
-			return 0;
-	} else
-		len = count;
-	*start = page + off;
-	return len;
-#else
 	return 0;
-#endif
 }
 
 static int mf_src_proc_open(struct inode *inode, struct file *file)



-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

