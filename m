Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031486Ab2CVXPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 19:15:54 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19329 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab2CVXPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 19:15:52 -0400
Date: Fri, 23 Mar 2012 00:15:50 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg KH <gregkh@linuxfoundation.org>
cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Ed Okerson <eokerson@quicknet.net>,
        Greg Herlein <gherlein@quicknet.net>,
        "David W. Erhart" <derhart@quicknet.net>,
        John Sellers <jsellers@quicknet.net>,
        Mike Preston <mpreston@quicknet.net>,
        David Huggins-Daines <dhd@cepstral.com>,
        Fabio Ferrari <fabio.ferrari@digitro.com.br>,
        Artis Kugevics <artis@mt.lv>, Daniele Bellucci <bellucda@tiscali.it>
Subject: Re: [PATCH 1/2] drivers/telephony/ixj.c::add_caps(): don't rely on
 undefined behaviour
In-Reply-To: <20120320135143.GA4535@kroah.com>
Message-ID: <alpine.LNX.2.00.1203230014530.2935@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1203192332420.9012@swampdragon.chaosbits.net> <1332197078.7847.1.camel@joe2Laptop> <alpine.LNX.2.00.1203192345020.9012@swampdragon.chaosbits.net> <1332198657.7847.7.camel@joe2Laptop> <alpine.LNX.2.00.1203200017100.9012@swampdragon.chaosbits.net>
 <1332199784.7847.12.camel@joe2Laptop> <alpine.LNX.2.00.1203200034040.9012@swampdragon.chaosbits.net> <20120320135143.GA4535@kroah.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2012, Greg KH wrote:

> On Tue, Mar 20, 2012 at 12:40:50AM +0100, Jesper Juhl wrote:
> > On Mon, 19 Mar 2012, Joe Perches wrote:
> > 
> > > On Tue, 2012-03-20 at 00:19 +0100, Jesper Juhl wrote:
> > > > On Mon, 19 Mar 2012, Joe Perches wrote:
> > > > > On Mon, 2012-03-19 at 23:46 +0100, Jesper Juhl wrote:
> > > > > > On Mon, 19 Mar 2012, Joe Perches wrote:
> > > > > > > On Mon, 2012-03-19 at 23:37 +0100, Jesper Juhl wrote:
> > > > > > > > In drivers/telephony/ixj.c::add_caps() we have several statements like this:
> > > > > > > >   	j->caplist[j->caps].handle = j->caps++;
> > > > > > > > That's undefined behaviour right there.
> > > > > > > telephony has been moved to staging.
> > > > > > Since when? Where?
> > > > > > In my up-to-date Linus tree with HEAD at 
> > > > > > c16fa4f2ad19908a47c63d8fa436a1178438c7e7, that file is is still in 
> > > > > > drivers/telephony/, not in staging/...
> > > > > > /confused
> > > > > In the -next tree.
> > > > Ok, seems I've missed that.
> > > > > Yes, it's a bug fix, but drivers/telephony is pretty dead.
> > > > Dead or not, as long as it's in the tree I think that fixing bugs is 
> > > > relevant.
> > > > Besides, who knows if/when it'll get ressurrected ;)
> > > 
> > > Sorry, I didn't mean to suggest it shouldn't
> > > be fixed.
> > > 
> > > I meant that it probably didn't need to be
> > > fixed during the merge window or maybe even
> > > not backported to stable unless you're sure
> > > the order of operations is now done correctly
> > > and with no real change in current operation
> > > by inspecting the object.  I presume it worked
> > > before but it's likely not too many people
> > > actually still use this hardware with the
> > > current kernel.
> > > 
> > I never intended to push it for -stable, it probably "works" in its 
> > current form with any relevant compiler. I just spotted a bug and wanted 
> > to fix it :-)
> > If it gets fixed during the merge window or at some other time I don't 
> > really care - but I don't see any reason to not just fix it as soon as 
> > possible.
> > 
> > I have no idea how many people still use this hardware with current 
> > kernels, but even if just a few do, they deserve to get code that has 
> > well-defined behaviour with standards conforming C compilers and not what 
> > is currently there that can change with different compilers/different 
> > compiler versions.
> 
> Then care to send me the patch, against the linux-next tree, so I can
> queue it up for the 3.5 merge window?
> 
Sure thing. Here's one against next-20120322



>From e518aca86e08129b71204c07200ec450a6fbe2c7 Mon Sep 17 00:00:00 2001
From: Jesper Juhl <jj@codesealer.com>
Date: Thu, 22 Mar 2012 17:54:58 +0100
Subject: [PATCH 1/2] drivers/staging/telephony/ixj.c::add_caps(): don't rely
 on undefined behaviour

In drivers/staging/telephony/ixj.c::add_caps() we have several statements like this:

        j->caplist[j->caps].handle = j->caps++;

That's undefined behaviour right there. Since j->caps is both read
(left hand side of assignment) and written to (right hand side of
assignment) but there is no intervening sequence point, the order
of the read and write happening is undefined.

I believe that what we want to have happen is that the assignment
happens with the same value of "j->caps" that's used as the
left-hand-side index value and then subsequently increment
"j->caps". So I've changed all those statements to:

        j->caplist[j->caps].handle = j->caps;
        j->caps++;

which has well-defined behaviour since there's now a sequence point
(";") involved, so we know the order of the read/write.
---
 drivers/staging/telephony/ixj.c |   57 ++++++++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/telephony/ixj.c b/drivers/staging/telephony/ixj.c
index d5f923b..f960279 100644
--- a/drivers/staging/telephony/ixj.c
+++ b/drivers/staging/telephony/ixj.c
@@ -5927,7 +5927,8 @@ static void add_caps(IXJ *j)
 	j->caplist[j->caps].cap = PHONE_VENDOR_QUICKNET;
 	strcpy(j->caplist[j->caps].desc, "Quicknet Technologies, Inc. (www.quicknet.net)");
 	j->caplist[j->caps].captype = vendor;
-	j->caplist[j->caps].handle = j->caps++;
+	j->caplist[j->caps].handle = j->caps;
+	j->caps++;
 	j->caplist[j->caps].captype = device;
 	switch (j->cardtype) {
 	case QTI_PHONEJACK:
@@ -5947,11 +5948,13 @@ static void add_caps(IXJ *j)
 		break;
 	}
 	j->caplist[j->caps].cap = j->cardtype;
-	j->caplist[j->caps].handle = j->caps++;
+	j->caplist[j->caps].handle = j->caps;
+	j->caps++;
 	strcpy(j->caplist[j->caps].desc, "POTS");
 	j->caplist[j->caps].captype = port;
 	j->caplist[j->caps].cap = pots;
-	j->caplist[j->caps].handle = j->caps++;
+	j->caplist[j->caps].handle = j->caps;
+	j->caps++;
 
  	/* add devices that can do speaker/mic */
 	switch (j->cardtype) {
@@ -5962,7 +5965,8 @@ static void add_caps(IXJ *j)
 		strcpy(j->caplist[j->caps].desc, "SPEAKER");
 		j->caplist[j->caps].captype = port;
 		j->caplist[j->caps].cap = speaker;
-		j->caplist[j->caps].handle = j->caps++;
+		j->caplist[j->caps].handle = j->caps;
+		j->caps++;
         default:
      		break;
 	}
@@ -5973,7 +5977,8 @@ static void add_caps(IXJ *j)
 		strcpy(j->caplist[j->caps].desc, "HANDSET");
 		j->caplist[j->caps].captype = port;
 		j->caplist[j->caps].cap = handset;
-		j->caplist[j->caps].handle = j->caps++;
+		j->caplist[j->caps].handle = j->caps;
+		j->caps++;
 		break;
         default:
      		break;
@@ -5985,7 +5990,8 @@ static void add_caps(IXJ *j)
 		strcpy(j->caplist[j->caps].desc, "PSTN");
 		j->caplist[j->caps].captype = port;
 		j->caplist[j->caps].cap = pstn;
-		j->caplist[j->caps].handle = j->caps++;
+		j->caplist[j->caps].handle = j->caps;
+		j->caps++;
 		break;
         default:
      		break;
@@ -5995,50 +6001,59 @@ static void add_caps(IXJ *j)
 	strcpy(j->caplist[j->caps].desc, "ULAW");
 	j->caplist[j->caps].captype = codec;
 	j->caplist[j->caps].cap = ULAW;
-	j->caplist[j->caps].handle = j->caps++;
+	j->caplist[j->caps].handle = j->caps;
+	j->caps++;
 
 	strcpy(j->caplist[j->caps].desc, "LINEAR 16 bit");
 	j->caplist[j->caps].captype = codec;
 	j->caplist[j->caps].cap = LINEAR16;
-	j->caplist[j->caps].handle = j->caps++;
+	j->caplist[j->caps].handle = j->caps;
+	j->caps++;
 
 	strcpy(j->caplist[j->caps].desc, "LINEAR 8 bit");
 	j->caplist[j->caps].captype = codec;
 	j->caplist[j->caps].cap = LINEAR8;
-	j->caplist[j->caps].handle = j->caps++;
+	j->caplist[j->caps].handle = j->caps;
+	j->caps++;
 
 	strcpy(j->caplist[j->caps].desc, "Windows Sound System");
 	j->caplist[j->caps].captype = codec;
 	j->caplist[j->caps].cap = WSS;
-	j->caplist[j->caps].handle = j->caps++;
+	j->caplist[j->caps].handle = j->caps;
+	j->caps++;
 
 	/* software ALAW codec, made from ULAW */
 	strcpy(j->caplist[j->caps].desc, "ALAW");
 	j->caplist[j->caps].captype = codec;
 	j->caplist[j->caps].cap = ALAW;
-	j->caplist[j->caps].handle = j->caps++;
+	j->caplist[j->caps].handle = j->caps;
+	j->caps++;
 
 	/* version 12 of the 8020 does the following codecs in a broken way */
 	if (j->dsp.low != 0x20 || j->ver.low != 0x12) {
 		strcpy(j->caplist[j->caps].desc, "G.723.1 6.3kbps");
 		j->caplist[j->caps].captype = codec;
 		j->caplist[j->caps].cap = G723_63;
-		j->caplist[j->caps].handle = j->caps++;
+		j->caplist[j->caps].handle = j->caps;
+		j->caps++;
 
 		strcpy(j->caplist[j->caps].desc, "G.723.1 5.3kbps");
 		j->caplist[j->caps].captype = codec;
 		j->caplist[j->caps].cap = G723_53;
-		j->caplist[j->caps].handle = j->caps++;
+		j->caplist[j->caps].handle = j->caps;
+		j->caps++;
 
 		strcpy(j->caplist[j->caps].desc, "TrueSpeech 4.8kbps");
 		j->caplist[j->caps].captype = codec;
 		j->caplist[j->caps].cap = TS48;
-		j->caplist[j->caps].handle = j->caps++;
+		j->caplist[j->caps].handle = j->caps;
+		j->caps++;
 
 		strcpy(j->caplist[j->caps].desc, "TrueSpeech 4.1kbps");
 		j->caplist[j->caps].captype = codec;
 		j->caplist[j->caps].cap = TS41;
-		j->caplist[j->caps].handle = j->caps++;
+		j->caplist[j->caps].handle = j->caps;
+		j->caps++;
 	}
 
 	/* 8020 chips can do TS8.5 native, and 8021/8022 can load it */
@@ -6046,7 +6061,8 @@ static void add_caps(IXJ *j)
 		strcpy(j->caplist[j->caps].desc, "TrueSpeech 8.5kbps");
 		j->caplist[j->caps].captype = codec;
 		j->caplist[j->caps].cap = TS85;
-		j->caplist[j->caps].handle = j->caps++;
+		j->caplist[j->caps].handle = j->caps;
+		j->caps++;
 	}
 
 	/* 8021 chips can do G728 */
@@ -6054,7 +6070,8 @@ static void add_caps(IXJ *j)
 		strcpy(j->caplist[j->caps].desc, "G.728 16kbps");
 		j->caplist[j->caps].captype = codec;
 		j->caplist[j->caps].cap = G728;
-		j->caplist[j->caps].handle = j->caps++;
+		j->caplist[j->caps].handle = j->caps;
+		j->caps++;
 	}
 
 	/* 8021/8022 chips can do G729 if loaded */
@@ -6062,13 +6079,15 @@ static void add_caps(IXJ *j)
 		strcpy(j->caplist[j->caps].desc, "G.729A 8kbps");
 		j->caplist[j->caps].captype = codec;
 		j->caplist[j->caps].cap = G729;
-		j->caplist[j->caps].handle = j->caps++;
+		j->caplist[j->caps].handle = j->caps;
+		j->caps++;
 	}
 	if (j->dsp.low != 0x20 && j->flags.g729_loaded) {
 		strcpy(j->caplist[j->caps].desc, "G.729B 8kbps");
 		j->caplist[j->caps].captype = codec;
 		j->caplist[j->caps].cap = G729B;
-		j->caplist[j->caps].handle = j->caps++;
+		j->caplist[j->caps].handle = j->caps;
+		j->caps++;
 	}
 }
 
-- 
1.7.9.4




-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

