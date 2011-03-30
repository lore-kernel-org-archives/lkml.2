Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab1C3X1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 19:27:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43007 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab1C3X1I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 19:27:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vWr3fyVrDpUzVjfFiBI0skGUSJ2u7matmCBSAhc8PWEgvuWs1hOQMq/ImDC33aZqYb
         g7pWJXtbsPLzzs8jgLYwQEVS+r7K1aQP2HEo4C928IgZaDd1uldr5irH1RxdlJy+P7nR
         NbGzBNVOLfxPj6q3yPzq+DQ0RevKGo1mwBvAU=
MIME-Version: 1.0
In-Reply-To: <20110326000456.346395018@clark.kroah.org>
References: <20110326000509.GA29736@kroah.com>
	<20110326000456.346395018@clark.kroah.org>
Date: Wed, 30 Mar 2011 19:27:06 -0400
X-Google-Sender-Auth: RC75AnBa1N8XErtFuZ-dA02MCMQ
Message-ID: <AANLkTi=XPPxVYPB8fzr2Ent3QOsKF=JunhGL+ExEk_7f@mail.gmail.com>
Subject: Re: [05/35] powerpc/kdump: Fix race in kdump shutdown
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 8:03 PM, Greg KH <gregkh@suse.de> wrote:
> 2.6.33-longterm review patch.  If anyone has any objections, please let us know.
>
> ------------------
>
> From: Michael Neuling <mikey@neuling.org>
>
> commit 60adec6226bbcf061d4c2d10944fced209d1847d upstream.

Hi Greg,

It looks like this introduces an issue for ppc32 unless we also take
the upstream c2be05481f612525 commit.  There is an e500 kexec
patch in between that modifies context; here is the one I've tentatively
queued for 2.6.34 without a dependency on the e500 patch context.

http://git.kernel.org/?p=linux/kernel/git/longterm/longterm-queue-2.6.34.git;a=blob;f=next_round/powerpc-Fix-default_machine_crash_shutdown-ifdef-bot.patch

Paul.

>
> When we are crashing, the crashing/primary CPU IPIs the secondaries to
> turn off IRQs, go into real mode and wait in kexec_wait.  While this
> is happening, the primary tears down all the MMU maps.  Unfortunately
> the primary doesn't check to make sure the secondaries have entered
> real mode before doing this.
>
> On PHYP machines, the secondaries can take a long time shutting down
> the IRQ controller as RTAS calls are need.  These RTAS calls need to
> be serialised which resilts in the secondaries contending in
> lock_rtas() and hence taking a long time to shut down.
>
> We've hit this on large POWER7 machines, where some secondaries are
> still waiting in lock_rtas(), when the primary tears down the HPTEs.
>
> This patch makes sure all secondaries are in real mode before the
> primary tears down the MMU.  It uses the new kexec_state entry in the
> paca.  It times out if the secondaries don't reach real mode after
> 10sec.
>
> Signed-off-by: Michael Neuling <mikey@neuling.org>
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> ---
>  arch/powerpc/kernel/crash.c |   27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>
> --- a/arch/powerpc/kernel/crash.c
> +++ b/arch/powerpc/kernel/crash.c
> @@ -162,6 +162,32 @@ static void crash_kexec_prepare_cpus(int
>        /* Leave the IPI callback set */
>  }
>
> +/* wait for all the CPUs to hit real mode but timeout if they don't come in */
> +static void crash_kexec_wait_realmode(int cpu)
> +{
> +       unsigned int msecs;
> +       int i;
> +
> +       msecs = 10000;
> +       for (i=0; i < NR_CPUS && msecs > 0; i++) {
> +               if (i == cpu)
> +                       continue;
> +
> +               while (paca[i].kexec_state < KEXEC_STATE_REAL_MODE) {
> +                       barrier();
> +                       if (!cpu_possible(i)) {
> +                               break;
> +                       }
> +                       if (!cpu_online(i)) {
> +                               break;
> +                       }
> +                       msecs--;
> +                       mdelay(1);
> +               }
> +       }
> +       mb();
> +}
> +
>  /*
>  * This function will be called by secondary cpus or by kexec cpu
>  * if soft-reset is activated to stop some CPUs.
> @@ -419,6 +445,7 @@ void default_machine_crash_shutdown(stru
>        crash_kexec_prepare_cpus(crashing_cpu);
>        cpu_set(crashing_cpu, cpus_in_crash);
>        crash_kexec_stop_spus();
> +       crash_kexec_wait_realmode(crashing_cpu);
>        if (ppc_md.kexec_cpu_down)
>                ppc_md.kexec_cpu_down(1, 0);
>  }
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
