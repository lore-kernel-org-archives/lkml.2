Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab1FCWQO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 18:16:14 -0400
Received: from smtp-out.google.com ([74.125.121.67]:42150 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab1FCWQM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 18:16:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=imCgi5fFiVaaTuWVJespftxsj5HWDzeKwjxMOH7PndwtL1fjEGXRYN6uaqgnGUrsKB
         HUQX0SZqLKnhiaEO8pNg==
MIME-Version: 1.0
In-Reply-To: <20110603144540.d182c231.akpm@linux-foundation.org>
References: <1306279146-23487-1-git-send-email-snanda@chromium.org>
 <20110603140054.a0f1859d.akpm@linux-foundation.org> <4DE94D31.3040104@caviumnetworks.com>
 <20110603144540.d182c231.akpm@linux-foundation.org>
From: Sameer Nanda <snanda@google.com>
Date: Fri, 3 Jun 2011 15:15:34 -0700
Message-ID: <BANLkTi=FmJHjcvNLSj7fuEP6jGMnt0NK+O7-eHEPPoOaJ3Lk_w@mail.gmail.com>
Subject: Re: [PATCH] init: skip calibration delay if previously done
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Daney <ddaney@caviumnetworks.com>, ext-phil.2.carmody@nokia.com,
        Tim.Deegan@citrix.com, jbeulich@novell.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 2:45 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Fri, 03 Jun 2011 14:08:01 -0700
> David Daney <ddaney@caviumnetworks.com> wrote:
>
> > On 06/03/2011 02:00 PM, Andrew Morton wrote:
> > > On Tue, 24 May 2011 16:19:06 -0700
> > > Sameer Nanda<snanda@chromium.org>  wrote:
> > >
> > >> For each CPU, do the calibration delay only once. For subsequent calls,
> > >> use the cached per-CPU value of loops_per_jiffy.
> > >>
> > >> This saves about 200ms of resume time on dual core Intel Atom N5xx based
> > >> systems. This helps bring down the kernel resume time on such systems from
> > >> about 500ms to about 300ms.
> > >>
> > >> Signed-off-by: Sameer Nanda<snanda@chromium.org>
> > >> ---
> > >>   init/calibrate.c |   10 +++++++++-
> > >>   1 files changed, 9 insertions(+), 1 deletions(-)
> > >>
> > >> diff --git a/init/calibrate.c b/init/calibrate.c
> > >> index 76ac919..47d3408 100644
> > >> --- a/init/calibrate.c
> > >> +++ b/init/calibrate.c
> > >> @@ -183,11 +183,18 @@ recalibrate:
> > >>    return lpj;
> > >>   }
> > >>
> > >> +DEFINE_PER_CPU(unsigned long, cpu_loops_per_jiffy) = { 0 };
> > >> +
> > >>   void __cpuinit calibrate_delay(void)
> > >>   {
> > >>    static bool printed;
> > >> +  int this_cpu = smp_processor_id();
> > >>
> > >> -  if (preset_lpj) {
> > >> +  if (per_cpu(cpu_loops_per_jiffy, this_cpu)) {
> > >> +          loops_per_jiffy = per_cpu(cpu_loops_per_jiffy, this_cpu);
> > >> +          pr_info("Calibrating delay loop (skipped) "
> > >> +                          "already calibrated this CPU previously.. ");
> >
> > That wording seems a little redundant, and there are two '.' at the end.
> >
> > How about:
> > s/"already calibrated this CPU previously.. "/", this CPU previously
> > calibrated."/
> >
>
> Pedant ;)
>
> --- a/init/calibrate.c~init-skip-calibration-delay-if-previously-done-fix-fix
> +++ a/init/calibrate.c
> @@ -256,7 +256,7 @@ void __cpuinit calibrate_delay(void)
>        if (per_cpu(cpu_loops_per_jiffy, this_cpu)) {
>                loops_per_jiffy = per_cpu(cpu_loops_per_jiffy, this_cpu);
>                pr_info("Calibrating delay loop (skipped) "
> -                               "already calibrated this CPU previously.. ");
> +                               "already calibrated this CPU");
>        } else if (preset_lpj) {
>                loops_per_jiffy = preset_lpj;
>                if (!printed)
> _
>
> But the whole thing is a bit weird.  Does this look better?
>
> From: Andrew Morton <akpm@linux-foundation.org>
>
> Make these messages more gramatically pleasing, more consistent and remove
> strange ellipses.
>
> Cc: Andrew Worsley <amworsley@gmail.com>
> Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>
> Cc: Sameer Nanda <snanda@chromium.org>
> Cc: David Daney <ddaney@caviumnetworks.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  init/calibrate.c |   18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff -puN init/calibrate.c~init-calibratec-calibrate_delay-tidy-up-the-pr_info-messages init/calibrate.c
> --- a/init/calibrate.c~init-calibratec-calibrate_delay-tidy-up-the-pr_info-messages
> +++ a/init/calibrate.c
> @@ -255,24 +255,24 @@ void __cpuinit calibrate_delay(void)
>
>        if (per_cpu(cpu_loops_per_jiffy, this_cpu)) {
>                loops_per_jiffy = per_cpu(cpu_loops_per_jiffy, this_cpu);
> -               pr_info("Calibrating delay loop (skipped) "
> -                               "already calibrated this CPU");
> +               pr_info("Calibrating delay loop.  Skipped: already calibrated "
> +                               "this CPU");
>        } else if (preset_lpj) {
>                loops_per_jiffy = preset_lpj;
>                if (!printed)
> -                       pr_info("Calibrating delay loop (skipped) "
> -                               "preset value.. ");
> +                       pr_info("Calibrating delay loop.  Skipped: "
> +                               "preset value");
>        } else if ((!printed) && lpj_fine) {
>                loops_per_jiffy = lpj_fine;
> -               pr_info("Calibrating delay loop (skipped), "
> -                       "value calculated using timer frequency.. ");
> +               pr_info("Calibrating delay loop.  Skipped: value calculated "
> +                               "using timer frequency");
>        } else if ((loops_per_jiffy = calibrate_delay_direct()) != 0) {
>                if (!printed)
> -                       pr_info("Calibrating delay using timer "
> -                               "specific routine.. ");
> +                       pr_info("Calibrating delay loop using timer-specific "
> +                                       "routine");
>        } else {
>                if (!printed)
> -                       pr_info("Calibrating delay loop... ");
> +                       pr_info("Calibrating delay loop");
>                loops_per_jiffy = calibrate_delay_converge();
>        }
>        per_cpu(cpu_loops_per_jiffy, this_cpu) = loops_per_jiffy;
> _
>

Thanks for picking this up.
Mind adding the following to this patch to prevent ARM build breakage :)

diff --git a/init/calibrate.c b/init/calibrate.c
index ec1e528..1b76597 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -9,6 +9,7 @@
 #include <linux/init.h>
 #include <linux/timex.h>
 #include <linux/smp.h>
+#include <linux/percpu.h>

 unsigned long lpj_fine;
 unsigned long preset_lpj;





--
Sameer
