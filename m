Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab2LYLHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 06:07:48 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58141 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718Ab2LYLHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 06:07:45 -0500
Date: Tue, 25 Dec 2012 12:07:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        linux-edac@vger.kernel.org
Subject: Re: [PATCH 15/25] x86/mce: don't use [delayed_]work_pending()
Message-ID: <20121225110742.GA7720@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, Tejun Heo <tj@kernel.org>,
	linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
	linux-edac@vger.kernel.org
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-16-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1356141435-17340-16-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 05:57:05PM -0800, Tejun Heo wrote:
> There's no need to test whether a (delayed) work item in pending
> before queueing, flushing or cancelling it.  Most uses are unnecessary
> and quite a few of them are buggy.
> 
> Remove unnecessary pending tests from x86/mce.  Only compile tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: linux-edac@vger.kernel.org
> ---
> Please let me know how this patch should be routed.  I can take it
> through the workqueue tree if necessary.
> 
> Thanks.
> 
>  arch/x86/kernel/cpu/mcheck/mce.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 80dbda8..c06a736 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -514,8 +514,7 @@ static void mce_schedule_work(void)
>  {
>  	if (!mce_ring_empty()) {
>  		struct work_struct *work = &__get_cpu_var(mce_work);
> -		if (!work_pending(work))
> -			schedule_work(work);
> +		schedule_work(work);

Right, just a nit. You could remove the local variable and have the
function simply be:

static void mce_schedule_work(void)
{
        if (!mce_ring_empty())
                schedule_work(&__get_cpu_var(mce_work));
}

before you send it upstream.

Also, the workqueue stuff is used on Intel boxes to poke mcelog when
there's an MCE to be reported to userspace so if Tony wants to give it a
run...

I'm fine with this being routed through your tree:

Acked-by: Borislav Petkov <bp@alien8.de>

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
