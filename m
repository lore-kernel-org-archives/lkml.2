Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003Ab0I1AKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 20:10:23 -0400
Received: from imr3.ericy.com ([198.24.6.13]:34448 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517Ab0I1AKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 20:10:22 -0400
Date: Mon, 27 Sep 2010 17:07:04 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH v2] hwmon (coretemp): Fix build breakage if SMP is
 undefined
Message-ID: <20100928000704.GB4875@ericsson.com>
References: <1285588796-20956-1-git-send-email-guenter.roeck@ericsson.com>
 <20100927125946.GB2862@elte.hu>
 <AANLkTinPHP8WhoAZQqcmhotEfFa6=mG_Acy+xCBQ0_5+@mail.gmail.com>
 <20100927232716.GB4744@ericsson.com>
 <AANLkTinDkJu2MSJM6bUpWJoB2XOD4LLf6GTPBX39wteD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <AANLkTinDkJu2MSJM6bUpWJoB2XOD4LLf6GTPBX39wteD@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 07:44:01PM -0400, Linus Torvalds wrote:
> On Mon, Sep 27, 2010 at 4:27 PM, Guenter Roeck
> <guenter.roeck@ericsson.com> wrote:
> > On Mon, Sep 27, 2010 at 09:02:57AM -0400, Pekka Enberg wrote:
> >> On Mon, Sep 27, 2010 at 3:59 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >> >
> >> > * Guenter Roeck <guenter.roeck@ericsson.com> wrote:
> >> >
> >> >> +#ifdef CONFIG_SMP
> >> >> +#endif
> >> >> +#ifdef CONFIG_SMP
> >> >> +#endif
> >> >
> >> > Hm, this tickles my uglo-meter. Is there no cleaner way, preferably one
> >> > that doesnt involve preprocessor directives?
> >>
> >> Implement cpu_sibling_mask() on UP so that the loop goes away?
> >
> > So what is the take ? Looks like Linus won't accept my patch without someone
> > else signing off on it. If the uglo-meter prevents it from being accepted,
> > I'll be happy to submit the SMP cleanup patch instead. As I mentioned
> > before, I would prefer that to go into -next.
> 
> I'd _much_ rather see cpu_sibling_mask() on UP, and just have the loop go away.
> 
> But that would be a generic change. Something like the (UNTESTED!)

Which is why I didn't do it...

> attached. It returns a NULL, since it would always be a bug to
> actually _use_ the (nonexistent) mask. And that's fine for things like
> for_each_cpu() that will then happily ignore the mask.
> 
> Ingo, does this make those randconfig things work? I think it's
> prettier than the horrible "sprinkle #ifdef CONFIG_SMP around in
> random places".
> 
>                         Linus

>  include/linux/smp.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/smp.h b/include/linux/smp.h
> index cfa2d20..ad48077 100644
> --- a/include/linux/smp.h
> +++ b/include/linux/smp.h
> @@ -149,6 +149,8 @@ smp_call_function_any(const struct cpumask *mask, void (*func)(void *info),
>  	return smp_call_function_single(0, func, info, wait);
>  }
>  
> +static inline const struct cpumask *cpu_sibling_mask(int cpu) { return NULL; }
> +
>  #endif /* !SMP */
>  
That works. Every other use of cpu_sibling_mask() is either in smp code
or surrounded with #ifdef CONFIG_SMP.

Ok, I'll submit another version of the patch with the generic change after 
some more testing.

Guenter
