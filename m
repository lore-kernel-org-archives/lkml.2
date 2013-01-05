Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab3AENVk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 08:21:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37285 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755491Ab3AENVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 08:21:38 -0500
Date: Sat, 5 Jan 2013 14:21:52 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7u1 04/31] x86, 64bit, mm: add generic kernel/ident
 mapping helper
Message-ID: <20130105132152.GC4297@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kiszka <jan.kiszka@web.de>,
	Jason Wessel <jason.wessel@windriver.com>,
	linux-kernel@vger.kernel.org
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
 <1357260531-11115-5-git-send-email-yinghai@kernel.org>
 <20130104211913.GC24228@x1.alien8.de>
 <CAE9FiQUHS3RY3OBtLhjzLjz7CBfx6jbQ6VN2T9W5KbLuCxwGww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAE9FiQUHS3RY3OBtLhjzLjz7CBfx6jbQ6VN2T9W5KbLuCxwGww@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 02:19:17PM -0800, Yinghai Lu wrote:
> On Fri, Jan 4, 2013 at 1:19 PM, Borislav Petkov <bp@alien8.de> wrote:
> > On Thu, Jan 03, 2013 at 04:48:24PM -0800, Yinghai Lu wrote:
> >> +int kernel_mapping_init(pgd_t *pgd_page, unsigned long addr, unsigned long end)
> >> +{
> >> +     struct x86_mapping_info info = {
> >> +             .alloc_pgt_page = alloc_pgt_page,
> >> +             .pmd_flag       = __PAGE_KERNEL_LARGE,
> >> +             .kernel_mapping = true,
> >> +     };
> >> +
> >> +     return kernel_ident_mapping_init(&info, pgd_page, addr, end);
> >
> > This patch looks good so far except this:
> > kernel_ident_mapping_init says it initializes ident mapping but
> > this is wrong and the type of mapping is actually controlled by
> > info.kernel_mapping.
> 
> it is not wrong, and it could do two things.
> kernel_mapping
> ident_mapping

I know that. But it has kernel_ident_mapping in the name although it can
do both. IMO, it should be like this:


int kernel_mapping_init_range(pgd_t *pgd_page, unsigned long addr, unsigned long end)

...
	return kernel_mapping_init(&info, pgd_page, addr, end);

so that your workhorse is kernel_mapping_init and it can do both kernel
and ident mapping and the wrapper is kernel_mapping_init_range() which
gets a range of (addr, end), preps the &info descriptor and calls the
workhorse.

See what I mean?

> > So this function which gets &info, etc should be called
> > kernel_mapping_init, AFAICT. And wrt the one wrapping
> > kernel_ident_mapping_init, I can't seem to find where it is called.
> > What's up?
> 
> this kernel_mapping_init is for -v8 ..., should be dropped if -v7 is
> used at last.

Well, this *DEFINITELY* should be in the commit message so that
reviewers don't go crazy looking for functions used in other branches.
Maan, this was absolutely insane.

-- 
Regards/Gruss,
Boris.
