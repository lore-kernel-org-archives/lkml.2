Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab1K2UaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 15:30:01 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45139 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287Ab1K2UaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 15:30:00 -0500
Date: Wed, 30 Nov 2011 00:29:51 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [rfc 3/3] prctl: Add PR_SET_MM codes to tune up mm_struct entires
Message-ID: <20111129202951.GG1775@moon>
References: <20111129191252.769160532@openvz.org>
 <20111129191638.912537377@openvz.org>
 <20111129201938.GP5169@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129201938.GP5169@outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 12:19:38PM -0800, Kees Cook wrote:
> On Tue, Nov 29, 2011 at 11:12:55PM +0400, Cyrill Gorcunov wrote:
> > At restore time we need a mechanism to restore those values
> > back and for this sake PR_SET_MM prctl code is introduced.
> > 
> > Note at moment this inteface is allowed for CAP_SYS_ADMIN
> > only.
> 
> NAK from me; this needs more bounds checking. Though, yes, it absolutely
> must be a privileged action since this is potentially very dangerous. Can
> we invent something stronger than CAP_SYS_ADMIN? ;)

Heh.

> 
> > @@ -1841,6 +1841,58 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
> >  			else
> >  				error = PR_MCE_KILL_DEFAULT;
> >  			break;
> > +		case PR_SET_MM: {
> > +			struct mm_struct *mm;
> > +			struct vm_area_struct *vma;
> > +
> > +			if (arg4 | arg5)
> > +				return -EINVAL;
> > +
> > +			if (!capable(CAP_SYS_ADMIN))
> > +				return -EPERM;
> > +
> > +			error = -ENOENT;
> > +			mm = get_task_mm(current);
> > +			if (!mm)
> > +				return error;
> > +
> > +			down_read(&mm->mmap_sem);
> > +			vma = find_vma(mm, arg3);
> > +			if (!vma)
> > +				goto out;
> 
> arg3 needs to be significantly more carefully validated. find_vma() doesn't
> say that vm_start <= addr, only that vm_end > addr. This effectively
> bypasses all the vma checks (mmap_min_addr, max process size, etc), with
> some pretty crazy side-effects, I think.
> 

Yes, I know it needs some more testing, but apart from vma bounds (yup,
good point with find_vma, I'll fix) I thought about what else should be
checked? I think VMA prototype should be checked to fit "code", "data"
templates, ie code should be at least readable and execytable, but what
about data and stack and brk, should stack be executable? That is the
point where I've got a bit confused and though putting RFC out might be
a good idea to collect opinions.
