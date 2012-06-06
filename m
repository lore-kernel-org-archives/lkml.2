Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832Ab2FFS66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 14:58:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41923 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785Ab2FFS64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 14:58:56 -0400
Message-ID: <4FCFA85E.9010101@zytor.com>
Date: Wed, 06 Jun 2012 11:58:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, shai@scalemp.com,
        akpm@linux-foundation.org, tglx@linutronix.de, ido@wizery.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mm] x86/pat: Avoid contention on cpa_lock if possible
References: <1334873492-31255-1-git-send-email-ido@wizery.com>  <tip-d2956406fb61e15ad2b47eda823288db4996acf1@git.kernel.org> <1339003443.23343.6.camel@twins>
In-Reply-To: <1339003443.23343.6.camel@twins>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2012 10:24 AM, Peter Zijlstra wrote:
> On Wed, 2012-06-06 at 09:18 -0700, tip-bot for Shai Fultheim wrote:
> 
>> [ I absolutely hate these locking patterns ... yet I have no better idea. Maybe the gents on Cc: ... ]
>> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> 
> Oh yuck, this is vile..
> 
> static struct static_key scale_mp_trainwreck = STATIC_KEY_INIT_FALSE;
> 
> static DEFINE_SPINLOCK(_cpa_lock);
> 
> static inline void cpa_lock(void)
> {
> 	if (static_key_false(&scale_mp_trainwreck))
> 		return;
> 
> 	spin_lock(&_cpa_lock);
> }
> 
> static inline void cpa_unlock(void)
> {
> 	if (static_key_false(&scale_mp_trainwreck))
> 		return;
> 
> 	spin_lock(&_cpa_lock);
> }
> 
> And then use cpa_{,un}lock(), and the scale-mp guys can
> static_key_slow_inc(&scale_mp_trainwreck).
> 

Actually, for this particular subcase I would use a synthetic CPUID bit
and use static_cpu_has().

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

