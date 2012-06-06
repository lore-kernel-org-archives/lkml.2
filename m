Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab2FFRYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 13:24:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:40894 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756934Ab2FFRYO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 13:24:14 -0400
Message-ID: <1339003443.23343.6.camel@twins>
Subject: Re: [tip:x86/mm] x86/pat: Avoid contention on cpa_lock if possible
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, shai@scalemp.com,
        akpm@linux-foundation.org, tglx@linutronix.de, ido@wizery.com
Cc: linux-tip-commits@vger.kernel.org
Date: Wed, 06 Jun 2012 19:24:03 +0200
In-Reply-To: <tip-d2956406fb61e15ad2b47eda823288db4996acf1@git.kernel.org>
References: <1334873492-31255-1-git-send-email-ido@wizery.com>
	 <tip-d2956406fb61e15ad2b47eda823288db4996acf1@git.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 09:18 -0700, tip-bot for Shai Fultheim wrote:

> [ I absolutely hate these locking patterns ... yet I have no better idea. Maybe the gents on Cc: ... ]
> Signed-off-by: Ingo Molnar <mingo@kernel.org>

Oh yuck, this is vile..

static struct static_key scale_mp_trainwreck = STATIC_KEY_INIT_FALSE;

static DEFINE_SPINLOCK(_cpa_lock);

static inline void cpa_lock(void)
{
	if (static_key_false(&scale_mp_trainwreck))
		return;

	spin_lock(&_cpa_lock);
}

static inline void cpa_unlock(void)
{
	if (static_key_false(&scale_mp_trainwreck))
		return;

	spin_lock(&_cpa_lock);
}

And then use cpa_{,un}lock(), and the scale-mp guys can
static_key_slow_inc(&scale_mp_trainwreck).

[ and yes I hate those jump_label names ... but I'm not wanting
  to go through another round of bike-shed painting. ]
