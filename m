Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab0LVQZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 11:25:08 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38109 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab0LVQZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 11:25:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NrEYQezgWNgrP59qwL0g1HQd4RwQytpXfF21sOgRfIHiuJgm6G+Mqtxlntl7nodK7k
         xsQ0hWNjlFTCHe/37lEVYqsRzHkhfNsFxDW3rArcNGAHuAcMl2EiSqV9VuY3RwrHdQDG
         KXwIWzbVYJKlLkiPebxyhs1gv5QMp5F8MLeco=
Subject: Re: Help: major pppoe regression since 2.6.35 (panic on first ppp
 conection)?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Joel Soete <soete.joel@scarlet.be>
Cc: Jarek Poplawski <jarkao2@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
In-Reply-To: <4D122093.6060900@scarlet.be>
References: <20101222110021.GA8985@ff.dom.local>
	 <4D122093.6060900@scarlet.be>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 17:25:00 +0100
Message-ID: <1293035100.3027.247.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 22 décembre 2010 à 17:00 +0100, Joel Soete a écrit :
> Hello Jarek,
> 
> Nice to read you :<)
> 
> On 12/22/2010 12:00 PM, Jarek Poplawski wrote:
> > On 2010-12-22 09:22, Andrew Morton wrote:
> >> (cc netdev)
> >>
> >> The bug is still present in 2.6.37-rc6.
> >>
> >> On Sat, 18 Dec 2010 11:33:14 +0000 Joel Soete<soete.joel@scarlet.be>  wrote:
> >>
> >>> Hello all,
> >
> > Hi,
> > Could you reproduce this bug with a vanilla kernel (without nvidia
> > patch)? If so, please include dmesg and .config to the next report.
> >
> Yes (it was already a vanilla kernel but 2.6.35 with my config, even thought same issue occurs some other distro stock 
> kernel 2.6.35), but here are some more dmesg with vanilla 2.6.37-rc6 and rc7 (I just added your debugging patch
> I found here, just because if I don't do it kernel is panicing immediately without letting any chance to capture dmesg (and 
> unfortunately I don't have any more chance to grab panic messages from serial console: no more rs232 on latest office laptop :<)
> 
> So you will find here attached personal config files of 2 kernels and respective dmesg.
> 
> If ever you need more details, don't hesitate to ask me.
> 
> Thanks a lot,
> 	J.

Something overwrites nr_frags in skb_shinfo(skb)

As skb_shinfo follows head portion of an skb, something overflows skb
head

Please try adding some room like in following patch ?

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index e6ba898..adf2834 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -187,6 +187,7 @@ enum {
  * the end of the header data, ie. at skb->end.
  */
 struct skb_shared_info {
+	char		filler[64];
 	unsigned short	nr_frags;
 	unsigned short	gso_size;
 	/* Warning: this field is not always filled in (UFO)! */


