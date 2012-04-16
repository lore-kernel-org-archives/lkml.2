Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751116Ab2DPF3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 01:29:25 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48891 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab2DPF3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 01:29:23 -0400
Message-ID: <4F8BAE2F.5090200@lwfinger.net>
Date: Mon, 16 Apr 2012 00:29:19 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
CC: driverdevel <devel@driverdev.osuosl.org>,
        wireless <linux-wireless@vger.kernel.org>,
        Jan Simonson <jan@simonson.se>
Subject: Problem with crypto when initializing TKIP
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to fix the driver r8192e_pci from the staging tree. It works fine 
with WEP and CCMP encryption, but it fails when trying to initialize TKIP. This 
driver does not use mac80211, but incorporates its own softmac routines.

This problem is a regression between 3.2.0 and 3.3.0, but I was unable to get a 
reasonable result using bisection.

Routine rtllib_tkip_init() from drivers/staging/rtl8192e/rtllib_crypt_tkip.c 
does the same set of steps as is done in mac80211. Everything works with mac80211.

The block cipher allocation calls to crypto_alloc_blkcipher("ecb(arc4)",...) are 
OK. The crypto_alloc_hash("michael_mic",...) call is the part that fails. The 
problem shows up in the code fragment below from crypto/api.c:

         ok = crypto_probing_notify(CRYPTO_MSG_ALG_REQUEST, larval);

         if (ok == NOTIFY_STOP)
                 alg = crypto_larval_wait(larval);
         else {
                 crypto_mod_put(larval);
                 alg = ERR_PTR(-ENOENT);
         }

The value of ok is NOTIFY_OK, which leads to a return of -ENOENT and a failure 
of the initialization.

I know this code is pretty old, and perhaps nobody remembers it, but I would 
appreciate some pointers on debugging this issue.

Thanks,

Larry
