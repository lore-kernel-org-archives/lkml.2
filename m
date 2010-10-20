Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab0JTOU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 10:20:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012Ab0JTOU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 10:20:56 -0400
Message-ID: <4CBEFABC.3030400@redhat.com>
Date: Wed, 20 Oct 2010 16:20:44 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100914 Thunderbird/3.1.3
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: device-mapper development <dm-devel@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, pedrib@gmail.com,
        Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs v3
References: <20101010115941.GA8539@basil.fritz.box>	<4CB1B3B9.4030205@redhat.com>	<20101010130842.GE8256@basil.fritz.box>	<4CB1DD1A.5080906@redhat.com> <20101010162257.GA1272@redhat.com>	<4CB1ECCA.8040801@redhat.com> <20101010170750.GA1475@redhat.com> <4CB20C72.3030504@redhat.com> <4CB7595C.4000801@redhat.com>
In-Reply-To: <4CB7595C.4000801@redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> any progress here?
> I would like to achieve some consensus and merge some version
> of patch to dm tree...
> Maybe with known problems if there is no better solution for now. 

I have to reply to myself:
this patch introduces apparent regressions in async crypto mode.

- Without per-cpu patch applied, the test script runs fine even
with >16 levels stacked devices, both in sync/forced async crypto

- With the per-cpu patch it seems to deadlocks if the stacked
devices level is more than 16 levels, even in crypto sync mode

- With added force async patch below it deadlocks even for
10 level stacked device (maybe even less)

Tested on VM with 256M RAM and Linus' tree from today...

But is it possible that there is another problem related.

You can easily test it using this patch, which forces dmcrypt to use
cryptd (thus async crypto):

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 88a2a05..1d8ddc1 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1267,7 +1267,7 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 		goto bad_mem;
 
 	ret = snprintf(cipher_api, CRYPTO_MAX_ALG_NAME,
-		       "%s(%s)", chainmode, cipher);
+		       "cryptd(%s(%s-generic))", chainmode, cipher);
 	if (ret < 0) {
 		kfree(cipher_api);
 		goto bad_mem;


And this test script (maybe some parameters mangling needed):

#!/bin/bash

DEVICE=/dev/sde
NUM=10

echo xxx | cryptsetup create -c aes-xts-plain64 -s 256 CTEST1 $DEVICE
for i in $(seq 1 $NUM); do
	j=$i
	i=$(($i + 1))
	echo xxx | cryptsetup create -c aes-xts-plain64 -s 256 CTEST$i /dev/mapper/CTEST$j
done

NUM=$(($NUM + 1))

dd if=/dev/zero of=/dev/mapper/CTEST$NUM bs=512 count=102400

for i in $(seq $NUM -1 1); do
	dmsetup remove CTEST$i
done


Milan


