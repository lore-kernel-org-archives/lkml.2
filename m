Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab0LMDN4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 22:13:56 -0500
Received: from mail.perches.com ([173.55.12.10]:2542 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754844Ab0LMDNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 22:13:55 -0500
Subject: Re: [PATCH 3/3] Staging: rt2860: include KERN_* in printk
From: Joe Perches <joe@perches.com>
To: "L. Alberto" =?ISO-8859-1?Q?Gim=E9nez?= <agimenez@sysvalve.es>
Cc: devel@linuxdriverproject.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101213000106.GA2049@bart.evergreen.loc>
References: <1292176591-26081-1-git-send-email-agimenez@sysvalve.es>
	 <1292176591-26081-4-git-send-email-agimenez@sysvalve.es>
	 <1292180668.18202.43.camel@Joe-Laptop>
	 <20101212192554.GA32583@bart.evergreen.loc>
	 <1292183170.18202.56.camel@Joe-Laptop>
	 <20101213000106.GA2049@bart.evergreen.loc>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Dec 2010 19:13:53 -0800
Message-ID: <1292210033.18202.81.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-13 at 01:01 +0100, L. Alberto Giménez wrote:
> On Sun, Dec 12, 2010 at 11:46:09AM -0800, Joe Perches wrote:
> > On Sun, 2010-12-12 at 20:25 +0100, L. Alberto Giménez wrote:
> > > On Sun, Dec 12, 2010 at 11:04:28AM -0800, Joe Perches wrote:
> > > > On Sun, 2010-12-12 at 18:56 +0100, L. Alberto Giménez wrote:
> > > > > diff --git a/drivers/staging/rt2860/pci_main_dev.c b/drivers/staging/rt2860/pci_main_dev.c
> > > > > @@ -601,15 +600,15 @@ void hex_dump(char *str, unsigned char *pSrcBufVA, unsigned int SrcBufLen)
> > > > >[...]
> > > > This should use print_hex_dump
> > > Ok, but I'll have to figure out how to translate the arguments without losing
> > > the original developers intended format.
> > 
> > I think you can change the format without concern.
> > 
> > print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 1,
> > 	       pSrcBufVA, SrcBufLen, true);
> 
> Hi Joe,
> 
> If you don't mind, I will send this as a separate patch, since including it in
> the KERN_* cleanup would clobber the patch and I'd prefer to make an standalone
> patch for the hex_dump -> print_hex_dump modifications (many files in the source
> do use the function).

It's fine to keep the hex_dump function, just change
the function itself to use print_hex_dump.

Changing all the callers will simply increase the code
without any other value.

Something simple like this should work:

 drivers/staging/rt2860/rt_linux.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/rt2860/rt_linux.c
b/drivers/staging/rt2860/rt_linux.c
index abfeea1..5b081ce 100644
--- a/drivers/staging/rt2860/rt_linux.c
+++ b/drivers/staging/rt2860/rt_linux.c
@@ -594,22 +594,12 @@ rt_get_sg_list_from_packet(void *pPacket, struct rt_rtmp_sg_list *sg)
 
 void hex_dump(char *str, unsigned char *pSrcBufVA, unsigned int SrcBufLen)
 {
-	unsigned char *pt;
-	int x;
-
 	if (RTDebugLevel < RT_DEBUG_TRACE)
 		return;
 
-	pt = pSrcBufVA;
-	printk("%s: %p, len = %d\n", str, pSrcBufVA, SrcBufLen);
-	for (x = 0; x < SrcBufLen; x++) {
-		if (x % 16 == 0)
-			printk("0x%04x : ", x);
-		printk("%02x ", ((unsigned char)pt[x]));
-		if (x % 16 == 15)
-			printk("\n");
-	}
-	printk("\n");
+	printk(KERN_DEBUG "%s: %p, len = %d\n", str, pSrcBufVA, SrcBufLen);
+	print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 1,
+		       pSrcBufVA, SrcBufLen, true);
 }
 
 /*


