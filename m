Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab2CAAWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 19:22:40 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:34190 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581Ab2CAAWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 19:22:39 -0500
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Muthu Kumar <muthu.lkml@gmail.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, Jens Axboe <axboe@kernel.dk>,
        martin.petersen@oracle.com
Subject: Re: [PATCH] Fix setting bio flags in drivers (sd_dif/floppy).
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <CAFR8uef08sDCR=FM_v4EV0CLX9f4UuJezSTPFX6V7T-4b7xBVQ@mail.gmail.com>
	<20120229161215.81505738.akpm@linux-foundation.org>
Date: Wed, 29 Feb 2012 19:22:28 -0500
In-Reply-To: <20120229161215.81505738.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 29 Feb 2012 16:12:15 -0800")
Message-ID: <yq11updqiez.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110017 (No Gnus v0.17) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090202.4F4EC148.0107,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Andrew" == Andrew Morton <akpm@linux-foundation.org> writes:

>> + bio->bi_flags |= (1 << BIO_MAPPED_INTEGRITY);
>> }
>> 
>> return 0;

Andrew> urgh.  This isn't the first time.

Andrew> It's too easy for people to make this mistake.  I'm not sure
Andrew> what a good fix would be - I don't think sparse can save us with
Andrew> __bitwise or similar.

Yeah. I actually got bitten by this recently.

This is what I'm doing in my current working tree (this particular flag
has moved for other reasons). But we could provide a similar wrapper for
bio->bi_flags...

[...]
+static inline unsigned int bio_integrity_flagged(struct bio *bio, enum bip_flags flag)
+{
+	if (bio && bio->bi_integrity)
+		return bio->bi_integrity->bip_flags & (1 << flag);
+
+	return 0;
+}
+
+static inline void bio_integrity_flag(struct bio *bio, enum bip_flags flag)
+{
+	if (bio && bio->bi_integrity)
+		bio->bi_integrity->bip_flags |= (1 << flag);
+}
[...]

-- 
Martin K. Petersen	Oracle Linux Engineering
