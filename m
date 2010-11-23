Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab0KWONb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 09:13:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754407Ab0KWON2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 09:13:28 -0500
Date: Tue, 23 Nov 2010 09:13:05 -0500
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, jason.wessel@windriver.com,
        gorcunov@gmail.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, perf, nmi:  Disable perf if counters are not
 accessable
Message-ID: <20101123141305.GA17346@redhat.com>
References: <1290462923-30734-1-git-send-email-dzickus@redhat.com>
 <1290509166.2072.384.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290509166.2072.384.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 11:46:06AM +0100, Peter Zijlstra wrote:
> On Mon, 2010-11-22 at 16:55 -0500, Don Zickus wrote:
> > +static bool check_hw_exists(void)
> > +{
> > +       u64 val, val_new;
> > +
> > +       val = 0xabcdUL;
> > +       (void) checking_wrmsrl(x86_pmu.perfctr, val);
> > +       rdmsrl_safe(x86_pmu.perfctr, &val_new);
> > +       if (val != val_new)
> > +               return false;
> > +
> > +       return true;
> > +} 
> 
> If I can make any sense of the implementation of native_read_msr_safe()
> then I think it doesn't actually sets val_new in case it faults, it just
> returns -EIO.
> 
> So I changed it to:
> 
> static bool check_hw_exists(void)
> {
>         u64 val, val_new = 0;
>         int ret = 0;
> 
>         val = 0xabcdUL;
>         ret |= checking_wrmsrl(x86_pmu.perfctr, val);
>         ret |= rdmsrl_safe(x86_pmu.perfctr, &val_new);
>         if (ret || val != val_new)
>                 return false;
> 
>         return true;
> }
> 
> And have applied the patch,

Looks good to me.  Thanks!

Cheers,
Don
