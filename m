Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab0DHIkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 04:40:23 -0400
Received: from mail-ew0-f222.google.com ([209.85.219.222]:50159 "EHLO
	mail-ew0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab0DHIkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 04:40:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=p7/TiysNMm+p3MqqZfqfbDpuUKdvJO0SYA8KSHLUp9Cuf47O4Qg5N7rKVFUwA5xp2w
         llxyk8/TbkCeIgsm6DTUfoJwW7Oe++OxucGGT9fXtlkRC/+89kycb6MTuvHKX0Dilzcd
         02HKgJD/xsVyvdiE44Wv4w2PfSUzuG3Hf//AY=
Message-ID: <4BBD966D.8020404@iki.fi>
Date: Thu, 08 Apr 2010 11:40:13 +0300
From: =?ISO-8859-1?Q?Timo_Ter=E4s?= <timo.teras@iki.fi>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: powerpc boot failure
References: <20100408165848.38f75f40.sfr@canb.auug.org.au>	<4BBD81B3.3030500@iki.fi>	<20100408172316.e6ee451d.sfr@canb.auug.org.au>	<4BBD85ED.4090209@iki.fi> <20100408174549.2f45ceea.sfr@canb.auug.org.au>
In-Reply-To: <20100408174549.2f45ceea.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> On Thu, 08 Apr 2010 10:29:49 +0300 Timo Teräs <timo.teras@iki.fi> wrote:
>> You don't probably have any xfrm policies then. And that code should not
>> really get executed.
>>
>> Some of the changes touch globally visible structs, and inline functions.
>> Was this a clean rebuild? And did you update all kernel modules, also in
>> the initramfs?
> 
> Yes, the build is started from scratch and the kernel and modules are
> updated (this is our automated build and test system).
> 
> I have attached the config in case that is of use.

It looks like my new code uses xfrm_pols_put assuming it always does the
proper thing. But seems like it's doing funny stuff if CONFIG_XFRM_SUB_POLICY
is not set, which is your case.

Can you try if this helps?

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 625dd61..cccb049 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -735,19 +735,12 @@ static inline void xfrm_pol_put(struct xfrm_policy *policy
                xfrm_policy_destroy(policy);
 }
 
-#ifdef CONFIG_XFRM_SUB_POLICY
 static inline void xfrm_pols_put(struct xfrm_policy **pols, int npols)
 {
        int i;
        for (i = npols - 1; i >= 0; --i)
                xfrm_pol_put(pols[i]);
 }
-#else
-static inline void xfrm_pols_put(struct xfrm_policy **pols, int npols)
-{
-       xfrm_pol_put(pols[0]);
-}
-#endif
 
 extern void __xfrm_state_destroy(struct xfrm_state *);
 
