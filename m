Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab2ASWbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 17:31:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42587 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755331Ab2ASWbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 17:31:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [Update][PATCH] PM / Hibernate: Fix s2disk regression related to unlock_system_sleep()
Date: Thu, 19 Jan 2012 23:35:20 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0+; KDE/4.6.0; x86_64; ; )
Cc: Tejun Heo <tj@kernel.org>, Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, horms@verge.net.au,
        "pavel@ucw.cz" <pavel@ucw.cz>, Len Brown <lenb@kernel.org>
References: <201201172345.15010.rjw@sisk.pl> <201201182322.58301.rjw@sisk.pl> <4F182B59.9000807@linux.vnet.ibm.com>
In-Reply-To: <4F182B59.9000807@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201192335.20383.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 19, 2012, Srivatsa S. Bhat wrote:
> On 01/19/2012 03:52 AM, Rafael J. Wysocki wrote:
> 
> > On Wednesday, January 18, 2012, Srivatsa S. Bhat wrote:
> >> On 01/19/2012 01:16 AM, Srivatsa S. Bhat wrote:
> >>
> >>> On 01/19/2012 01:00 AM, Tejun Heo wrote:
> >>>
> >>>> Hello,
> >>>>
> >>>> On Thu, Jan 19, 2012 at 12:52:32AM +0530, Srivatsa S. Bhat wrote:
> >>>>> Somehow I don't think its a hack, based on my perception as described
> >>>>> above. But feel free to prove me wrong :-)
> >>>>
> >>>> Thanks for the explanation.  Yeah, I agree and it's much simpler this
> >>>> way, which is nice.  So, in short, because freezing state can't change
> >>>> across lock_system_sleep(), there's no reason to check for freezing
> >>>> state on unlock and this nicely resolves the freezer problem together.
> >>>>
> >>>
> >>>
> >>> Absolutely!
> >>>
> >>>> The only thing to be careful is, then, we need to set and clear SKIP
> >>>> inside pm_mutex.
> >>>>
> >>>
> >>>
> >>> Not exactly. We need to set SKIP before grabbing pm_mutex and clear it
> >>> inside pm_mutex. The reason is that we decided to set SKIP in the first
> >>> place just to avoid the freezer from declaring failure when we are
> >>> blocked on pm_mutex. If we move it to *after* mutex_lock(&pm_mutex), that
> >>> original intention itself is not satisfied, and we will hit freezing
> >>> failures - IOW making the set and clear exercise useless!
> >>>
> >>> So, something like this should work perfectly:
> >>>
> >>> lock_system_sleep()
> >>> {
> >>> 	freezer_do_not_count();
> >>> 	mutex_lock(&pm_mutex);
> >>> 	current->flags &= ~PF_FREEZER_SKIP;
> >>> }
> >>>
> >>> But in the interest of making the code look a bit symmetric, we can do:
> >>>
> >>> lock_system_sleep()
> >>> {
> >>> 	freezer_do_not_count();
> >>> 	mutex_lock(&pm_mutex);
> >>> }
> >>>
> >>> unlock_system_sleep()
> >>> {
> >>> 	current->flags &= ~PF_FREEZER_SKIP;
> >>> 	mutex_unlock(&pm_mutex);
> >>> }
> >>>  
> >>
> >>
> >> So how about this patch, with the comment updated?
> >> (and the changelog updated as well to reflect the movement of code)
> >>
> >> ---
> >> From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> >> Subject: [PATCH] PM / Hibernate: Rewrite unlock_system_sleep() to fix s2disk regression
> >>
> >> Commit 33e638b, "PM / Sleep: Use the freezer_count() functions in
> >> [un]lock_system_sleep() APIs" introduced an undesirable change in the
> >> behaviour of unlock_system_sleep() since freezer_count() internally calls
> >> try_to_freeze() - which we don't need in unlock_system_sleep().
> >>
> >> And commit bcda53f, "PM / Sleep: Replace mutex_[un]lock(&pm_mutex) with
> >> [un]lock_system_sleep()" made these APIs wide-spread. This caused a
> >> regression in suspend-to-disk where snapshot_read() and snapshot_write()
> >> were getting frozen due to the try_to_freeze embedded in
> >> unlock_system_sleep(), since these functions were invoked when the freezing
> >> condition was still in effect.
> >>
> >> Fix this by rewriting unlock_system_sleep() by open-coding freezer_count()
> >> and dropping the try_to_freeze() part. Not only will this fix the
> >> regression but this will also ensure that the API only does what it is
> >> intended to do, and nothing more, under the hood.
> >>
> >> While at it, make the code more correct and robust by ensuring that the
> >> PF_FREEZER_SKIP flag gets cleared with pm_mutex held, to avoid a race with
> >> the freezer.
> >>
> >> Reported-by: Rafael J. Wysocki <rjw@sisk.pl>
> >> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> > 
> > So, I'd prefer lock_system_sleep() to be open-coded too, to
> > avoid situations in which someone changes freezer_do_not_count()
> > and freezer_count() leaving unmodified unlock_system_sleep() behind.
> >
> 
> 
> Hehe, actually, I had left lock_system_sleep() as it is, intentionally, due to
> a far-fetched idea to keep the code sane: I felt that people who go through
> this code would naturally feel tempted to replace any open-coded stuff (if
> possible) with the appropriate function call. And my rationale was that when
> they see that lock_system_sleep() has a function call but
> unlock_system_sleep() has been open-coded, they would immediately know that
> this was not yet another case of "oh I wasn't aware of this function,
> hence I open-coded it", but it was rather "I was very much aware of the
> available functions, but I chose to open-code it intentionally - so touch it
> only if you really know what you are doing" :-)
> 
> And I guess, now that job of guarding the code from "obvious code cleanups"
> like that would be done by the comment I added as per Tejun's suggestion.
> And moreover, your point to open-code in lock_system_sleep() sounds more
> compelling than my far-fetched idea :-) So okay, I will open-code it.. 
> 
> > Also, have you actually tested this?
> 
> 
> Oh I almost forgot to mention: I have not specifically tested this with the
> userspace s2disk utility (part of uswsusp/suspend-utils package) as such.
> I have only tested it in general (by invoking hibernate by writing to
> /sys/power/disk, and testing different levels of pm_test framework etc) to
> ensure that this patch doesn't break anything else.
> So, any help with testing the userspace utilities would be great!
> 
> So Rafael, could you please check if the following patch solves the
> regression for you? Thanks a lot!

Yes, it does, thanks!

Applied to linux-pm/linux-next.

Thanks,
Rafael


> ---
> From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Subject: [PATCH] PM / Hibernate: Rewrite unlock_system_sleep() to fix s2disk regression
> 
> Commit 33e638b, "PM / Sleep: Use the freezer_count() functions in
> [un]lock_system_sleep() APIs" introduced an undesirable change in the
> behaviour of unlock_system_sleep() since freezer_count() internally calls
> try_to_freeze() - which we don't need in unlock_system_sleep().
> 
> And commit bcda53f, "PM / Sleep: Replace mutex_[un]lock(&pm_mutex) with
> [un]lock_system_sleep()" made these APIs wide-spread. This caused a
> regression in suspend-to-disk where snapshot_read() and snapshot_write()
> were getting frozen due to the try_to_freeze embedded in
> unlock_system_sleep(), since these functions were invoked when the freezing
> condition was still in effect.
> 
> Fix this by rewriting unlock_system_sleep() by open-coding freezer_count()
> and dropping the try_to_freeze() part. Not only will this fix the
> regression but this will also ensure that the API only does what it is
> intended to do, and nothing more, under the hood.
> 
> While at it, make the code more correct and robust by ensuring that the
> PF_FREEZER_SKIP flag gets cleared with pm_mutex held, to avoid a race with
> the freezer.
> 
> Also, to be on the safer side, open-code freezer_do_not_count() as well
> (inside lock_system_sleep()), to ensure that any unrelated modification to
> freezer[_do_not]_count() does not break things again!
> 
> Reported-by: Rafael J. Wysocki <rjw@sisk.pl>
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
> 
>  include/linux/suspend.h |   19 +++++++++++++++++--
>  1 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/suspend.h b/include/linux/suspend.h
> index 95040cc..91784a4 100644
> --- a/include/linux/suspend.h
> +++ b/include/linux/suspend.h
> @@ -357,14 +357,29 @@ extern bool pm_save_wakeup_count(unsigned int count);
>  
>  static inline void lock_system_sleep(void)
>  {
> -	freezer_do_not_count();
> +	current->flags |= PF_FREEZER_SKIP;
>  	mutex_lock(&pm_mutex);
>  }
>  
>  static inline void unlock_system_sleep(void)
>  {
> +	/*
> +	 * Don't use freezer_count() because we don't want the call to
> +	 * try_to_freeze() here.
> +	 *
> +	 * Reason:
> +	 * Fundamentally, we just don't need it, because freezing condition
> +	 * doesn't come into effect until we release the pm_mutex lock,
> +	 * since the freezer always works with pm_mutex held.
> +	 *
> +	 * More importantly, in the case of hibernation,
> +	 * unlock_system_sleep() gets called in snapshot_read() and
> +	 * snapshot_write() when the freezing condition is still in effect.
> +	 * Which means, if we use try_to_freeze() here, it would make them
> +	 * enter the refrigerator, thus causing hibernation to lockup.
> +	 */
> +	current->flags &= ~PF_FREEZER_SKIP;
>  	mutex_unlock(&pm_mutex);
> -	freezer_count();
>  }
>  
>  #else /* !CONFIG_PM_SLEEP */
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

