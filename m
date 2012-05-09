Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760589Ab2EITES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 15:04:18 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3500 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760413Ab2EITEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 15:04:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 09 May 2012 12:03:24 -0700
From: Diwakar Tundlam <dtundlam@nvidia.com>
To: "'Peter Zijlstra'" <peterz@infradead.org>
CC: "'Ingo Molnar'" <mingo@kernel.org>,
        "'David Rientjes'" <rientjes@google.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Date: Wed, 9 May 2012 12:04:07 -0700
Subject: RE: [PATCH] sched: Make nr_uninterruptible count a signed value
Thread-Topic: [PATCH] sched: Make nr_uninterruptible count a signed value
Thread-Index: Ac0tu2C+vh+h5DsrQ+mPKx2QiGamsAAWgORw
Message-ID: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF118@HQMAIL04.nvidia.com>
References: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10C@HQMAIL04.nvidia.com>
	 <1336514192.8226.52.camel@twins>
	 <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10D@HQMAIL04.nvidia.com>
	 <1336516020.8226.57.camel@twins> <1336516174.8226.59.camel@twins>
	 <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10E@HQMAIL04.nvidia.com>
 <1336551100.27020.84.camel@laptop>
In-Reply-To: <1336551100.27020.84.camel@laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q49J4RUr005272

The issue is because when promoting from 32-bit unsigned to 64-bit signed, the compiler first does SIZE increase and then the sign change. If it did SIGN change first and then size increase (with sign-extension) and it will work correctly.

But then, the compiler is probably doing the right thing here because the starting point is an unsigned value and when it is assigned a negative value, the compiler is perfectly justified in converting it to a large positive value which is what happened here.

The theoretical correct fix is to change the declaration to signed long nr_uninterruptible simply because it can sometimes become -ve.

The other fix is to fix the print statement - but it feels wrong.

It would be good to fix the declaration...

Thanks,
--Diwakar.

-----Original Message-----
From: Peter Zijlstra [mailto:peterz@infradead.org] 
Sent: Wednesday, May 09, 2012 1:12 AM
To: Diwakar Tundlam
Cc: 'Ingo Molnar'; 'David Rientjes'; 'linux-kernel@vger.kernel.org'; Peter De Schrijver
Subject: RE: [PATCH] sched: Make nr_uninterruptible count a signed value

On Tue, 2012-05-08 at 15:46 -0700, Diwakar Tundlam wrote:
> Maybe it is an artifact of 32-bit machine displaying 64-bit print format.
> An (unsigned long)(-24) promoted to (signed long long) ends up as 4294967272.
> As seen in my output of sched_debug.

Ah, quite possible. %Ld is indeed %lld and the value is long, not long long. So the proper fix is to fudge that printk statement somehow.

> Your machine is probably natively 64-bit. 

Yeah, I gave up on 32bit computing a while ago..

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
