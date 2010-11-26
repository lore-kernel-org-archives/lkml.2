Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab0KZLnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 06:43:21 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:44995 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751278Ab0KZLnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 06:43:20 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Hugh Dickins <hughd@google.com>
Subject: Re: 2.6.35.5: hibernation broken... AGAIN
Date: Fri, 26 Nov 2010 12:43:14 +0100
User-Agent: KMail/1.9.10
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@in.ibm.com>
References: <201011171139.33398.linux@rainbow-software.org> <201011172218.42053.linux@rainbow-software.org> <alpine.LSU.2.00.1011171531310.15942@sister.anvils>
In-Reply-To: <alpine.LSU.2.00.1011171531310.15942@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201011261243.15091.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 November 2010, Hugh Dickins wrote:
> On Wed, 17 Nov 2010, Ondrej Zary wrote:
> > On Wednesday 17 November 2010 22:12:01 Rafael J. Wysocki wrote:
> > > On Wednesday, November 17, 2010, Andrew Morton wrote:
> > > > On Wed, 17 Nov 2010 21:53:52 +0100
> > > >
> > > > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > > > On Wednesday, November 17, 2010, Ondrej Zary wrote:
> > > > > > Hello,
> > > > > > the nasty memory-corrupting hibernation bug
> > > > > > https://bugzilla.kernel.org/show_bug.cgi?id=15753 is back since
> > > > > > 2.6.35.5. 2.6.35.4 works fine, 2.6.35.5 crashes after two days.
>
> That's distressing, for both and all of us: I'm sorry.
>
> > > > > > It seems to be caused by
> > > > > > b77c254d8d66e5e9aa81239fedba9f3d568097d9.
> > > >
> > > > commit b77c254d8d66e5e9aa81239fedba9f3d568097d9
> > > > Author: Hugh Dickins <hughd@google.com>
> > > > Date:   Thu Sep 9 16:38:09 2010 -0700
> > > >
> > > >     swap: prevent reuse during hibernation
>
> Embarrassing: I suspect that I've been confused, not for the first
> time, by the fork-like nature of hibernation and its images.
> I wonder if this patch below fixes it, Ondrej?
>
> (And is it kernel swsusp or user swsusp that you're using?  May not
> matter at all, but will help us to think more clearly about it,
> if the corruption remains after this patch.)
>
> Rafael, do you agree that this patch was actually required even for
> your original commit 452aa6999e6703ffbddd7f6ea124d3968915f3e3
> mm/pm: force GFP_NOIO during suspend/hibernation and resume?
>
> Or am I still just as confused?  Or if not, are there more forking
> places which require a similar patch?
>
> Not signing it off yet,
> Hugh

Could you please do that? The patch fixes the problem.


> ---
>
>  kernel/power/hibernate.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> --- 2.6.37-rc2/kernel/power/hibernate.c	2010-11-01 13:01:31.000000000 -0700
> +++ linux/kernel/power/hibernate.c	2010-11-17 15:23:36.000000000 -0800
> @@ -348,16 +348,19 @@ int hibernation_snapshot(int platform_mo
>  		goto Recover_platform;
>
>  	error = create_image(platform_mode);
> -	/* Control returns here after successful restore */
> +	/* Control returns here after successful restore,
> +	 * and also after creating the image in memory (or failing to do so).
> +	 */
>
>   Resume_devices:
>  	/* We may need to release the preallocated image pages here. */
> -	if (error || !in_suspend)
> +	if (error || !in_suspend) {
>  		swsusp_free();
> +		set_gfp_allowed_mask(saved_mask);
> +	}
>
>  	dpm_resume_end(in_suspend ?
>  		(error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE);
> -	set_gfp_allowed_mask(saved_mask);
>  	resume_console();
>   Close:
>  	platform_end(platform_mode);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Ondrej Zary
