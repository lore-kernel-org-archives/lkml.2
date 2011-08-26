Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab1HZLtC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 07:49:02 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:64472 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751360Ab1HZLs6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 07:48:58 -0400
X-AuditID: 1209190e-b7c22ae000000a2c-fc-4e5787ac81f7
Subject: Re: [PATCH 2/2] percpu_counter: Put a reasonable upper bound on percpu_counter_batch
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=windows-1252
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <20110826072927.5b4781f9@kryten>
Date: Fri, 26 Aug 2011 07:48:52 -0400
Cc: adilger.kernel@dilger.ca, eric.dumazet@gmail.com, tj@kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <A91A91A5-9EF0-42FE-B1C3-184D65112EA9@mit.edu>
References: <20110826072622.406d3395@kryten> <20110826072927.5b4781f9@kryten>
To: Anton Blanchard <anton@samba.org>
X-Mailer: Apple Mail (2.1244.3)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsUixCmqrLumPdzP4O4KNouvXzpYLP7df8Fu
	se/9WTaLmfPusFlc3jWHzeLX8qOMDmweLZvLPXbOusvusWlVJ5vH3F19jB6fN8kFsEZx2aSk
	5mSWpRbp2yVwZTz5u42xoJm34u2Xp4wNjPO4uhg5OSQETCQOH5vPAmGLSVy4t56ti5GLQ0hg
	H6PE8YM/GSGcDYwSv38eYAWpEhI4zSSx4YotiC0sECvx4V87UAcHB6+AscTrf0wgYWYBPYkd
	13+BlbMJKEnc+bQfbAGngK7Er23z2EFsFgFVic83z7ODzGcWaGOU+Luxgw2iWVti2cLXzCA2
	r4CVxK+7n6H2+krc2L2TCWSXCFDz9dU8EEfLSyxu+cw4gVFwFsIVs5BcMQvJ0AWMzKsYZVNy
	q3RzEzNzilOTdYuTE/PyUot0jfVyM0v0UlNKNzGCw1+Sbwfj14NKhxgFOBiVeHgv5oT5CbEm
	lhVX5h5ilORgUhLllWkL9xPiS8pPqcxILM6ILyrNSS0+xCjBwawkwnutAijHm5JYWZValA+T
	kuZgURLnXb3DwU9IID2xJDU7NbUgtQgmK8PBoSTB6weMcyHBotT01Iq0zJwShDQTByfIcB6g
	4dNAFvMWFyTmFmemQ+RPMSpKifNOAmkWAElklObB9cLS0ytGcaBXhHnbQap4gKkNrvsV0GAm
	oMEqjmCDSxIRUlINjEEbI56VdvCfT3TxSo1PEL+1Liq+MuMfc/F+s5qiZhWv5btOSpb82CJ6
	8V7Zqlyno1KHkny6O7SOV8w49sCVWfz2u2m747d8+WJWKxmmZZHbZem/5AjfnZTnq75+VHZZ
	6X9vQnz6jTmCBksdPvAkv2OI6srfNSWxlFeKQ639qam/r9xsf8PdSizFGYmGWsxFxYkAjKSU
	iioDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 25, 2011, at 5:29 PM, Anton Blanchard wrote:

> 
> When testing on a 1024 thread ppc64 box I noticed a large amount of
> CPU time in ext4 code.
> 
> ext4_has_free_blocks has a fast path to avoid summing every free and
> dirty block per cpu counter, but only if the global count shows more
> free blocks than the maximum amount that could be stored in all the
> per cpu counters.
> 
> Since percpu_counter_batch scales with num_online_cpus() and the maximum
> amount in all per cpu counters is percpu_counter_batch * num_online_cpus(),
> this breakpoint grows at O(n^2).

I understand why we would want to reduce this number.   Unfortunately, the
question is what do we do if all 1024 threads try to do buffered writes into
the file system at the same instant, when we have less than 4 megabytes
of space left?

The problem is that we can then do more writes than we have space, and
we will only find out about it at write back time, when the process may have
exited already -- at which point data loss is almost inevitable.  (We could
keep the data in cache and frantically page the system administrator to
delete some files to make room for dirty data, but that's probably not going
to end well….)

What we can do if we must clamp this threshold is to also increase the
threshold at which we shift away from delayed allocation.  We'll then
allocate each block at write time, which does mean more CPU and 
less efficient allocation of blocks, but if we're down to our last 4 megabytes,
there's probably not much we can do that will be efficient as far as
block layout anyway….

-- Ted


