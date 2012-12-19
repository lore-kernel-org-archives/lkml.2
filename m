Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab2LSRQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 12:16:34 -0500
Received: from mail.skyhub.de ([78.46.96.112]:32803 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552Ab2LSRQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 12:16:28 -0500
Date: Wed, 19 Dec 2012 18:16:24 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 01/27] x86, mm: Fix page table early allocation offset
 checking
Message-ID: <20121219171624.GE24895@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
 <1355436141-8668-2-git-send-email-yinghai@kernel.org>
 <20121214105327.GA4966@liondog.tnic>
 <CAE9FiQVt9kwrwZysLe_KkEXHF-scRVA1-0UJqqu0NMs1h=jZMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQVt9kwrwZysLe_KkEXHF-scRVA1-0UJqqu0NMs1h=jZMg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 07:30:06PM -0800, Yinghai Lu wrote:
> change that too:
> ---
> Subject: [PATCH] x86, mm: Fix page table early allocation offset checking
> 
> During debug load kernel above 4G, found one page if is not used in BRK
> and it should be with early page allocation.
> 
> pgt_buf_top is address that can not be used, so should check if then new
> end is above than that top, otherwise last page will not used.

Oh oh, I'm starting to slowly see the light. :-) You mean that at least
on 64-bit, we're calling alloc_low_pages with num=1 and the comparison
">=" is wrong because in that case we fall back to memblock allocation
even if we have the last page in BRK and can use it, correct?

If so, why don't you write the commit message like this instead:

"pgt_buf_top is the top BRK address which can not be used. We check
it before falling back to memblock allocation. However, the check to
fallback is wrongly off-by-one, leading to us not using the last BRK
page. However, we should do so, so fix that."

Makes sense?

[ … ]

> I really hate pr_debug.
> 
> pr_debug is useless. it will not print out anything.

Ok, I agree, pr_debug can mean different things depending on .config
settings.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
