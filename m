Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab1LWPOC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 10:14:02 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:24288 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754094Ab1LWPN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 10:13:59 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: yfpeiDgVM1nmFLDPsfy0V6df3bc.p.MQnSb1vHy2nDzcDHi
 BxlRCU868gOIPTzQCYO5E2mLTFDYoF4fhmTbK7.C1L5PNmMt__c0c4WvymPE
 KB_7xNE9HXOoXGnHN_PTBHQGsuPwxEG6ZYoX0NuZen2c5ESs0VO58mOclSuH
 tGOwfL3BqglIvKboLQvYXDzXRk.ASdg_bNi2qBR4qgv48Z7pGt0E6A06K5wc
 WF8aWX6UkXbCAGhpVm4DtAJ6Y7ZJh9WXXdryRwhRWa89Vb8jOudPLI4pdj_u
 XuQFm1yBeK8ksrSw.7a1IORsAXXoCsIwZJVdqrpSxFtM32yr25vr.Q7yD_W2
 jAVr9JJuXzuf9FkxGo36JvWElUJwJtOGvU2o0Gb84hBC5AQ--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 23 Dec 2011 09:13:57 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Jan Beulich <JBeulich@suse.com>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: irqsafe_cpu_...() 64-bit operations on 32-bit platform
In-Reply-To: <4EF4581C0200007800069BA2@nat28.tlf.novell.com>
Message-ID: <alpine.DEB.2.00.1112230908550.1691@router.home>
References: <4EF4581C0200007800069BA2@nat28.tlf.novell.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Dec 2011, Jan Beulich wrote:

> you introduced these for 2.6.33, but I wonder about their completeness

> in the current state: On ix86, I can add, sub, xor, etc a 64-bit variable
> this way (through the generic implementation), but there's no way to
> read or write such a variable. While not documented explicitly, it seems
> like the assumption is that this_cpu_{read,write}() can be used for this
> purpose, but that's clearly wrong.

Hmmm... We could add those but then you would usually not assign the
initial values in a situation where concurrency is an issue. Typically you would have
a loop over all possible cpus and then simply do a 64 bit assign to the 64
bit values address determined via per_cpu_ptr().

And yes reading could be an issue if you have concurrent updates ongoing.

However, if you are using a loop to sum up all counters from every
processor then you cannot use the this_cpu ops but would have to use
something like get_64(). Reliably reading a 64 bit value on 32 bit may
strangely require a write operation via cmpxchg8b.


