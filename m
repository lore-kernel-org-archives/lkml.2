Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab2JTVhz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 17:37:55 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:46156 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2JTVhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 17:37:53 -0400
Date: Sat, 20 Oct 2012 14:37:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] RCU: update docs to include kfree_rcu()
Message-ID: <20121020213748.GQ2518@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121019164830.GA4896@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121019164830.GA4896@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12102021-2398-0000-0000-00000CA47309
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000197; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00184210; UDB=6.00041728; UTC=2012-10-20
 21:37:52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 09:48:30AM -0700, Kees Cook wrote:
> Mention kfree_rcu() in the call_rcu() section. Additionally fix the
> example code for list replacement that used the wrong structure element.

Good catch!  Queued, and thank you for your review and feedback!  ;-)

							Thanx, Paul

> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  Documentation/RCU/listRCU.txt   |    2 +-
>  Documentation/RCU/whatisRCU.txt |   13 +++++++++++--
>  2 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/RCU/listRCU.txt b/Documentation/RCU/listRCU.txt
> index 4349c14..adb5a37 100644
> --- a/Documentation/RCU/listRCU.txt
> +++ b/Documentation/RCU/listRCU.txt
> @@ -205,7 +205,7 @@ RCU ("read-copy update") its name.  The RCU code is as follows:
>  				audit_copy_rule(&ne->rule, &e->rule);
>  				ne->rule.action = newaction;
>  				ne->rule.file_count = newfield_count;
> -				list_replace_rcu(e, ne);
> +				list_replace_rcu(&e->list, &ne->list);
>  				call_rcu(&e->rcu, audit_free_rule);
>  				return 0;
>  			}
> diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
> index bf0f6de..160ac55 100644
> --- a/Documentation/RCU/whatisRCU.txt
> +++ b/Documentation/RCU/whatisRCU.txt
> @@ -499,6 +499,8 @@ The foo_reclaim() function might appear as follows:
>  	{
>  		struct foo *fp = container_of(rp, struct foo, rcu);
> 
> +		foo_cleanup(fp->a);
> +
>  		kfree(fp);
>  	}
> 
> @@ -521,6 +523,12 @@ o	Use call_rcu() -after- removing a data element from an
>  	read-side critical sections that might be referencing that
>  	data item.
> 
> +If the callback for call_rcu() is not doing anything more than calling
> +kfree() on the structure, you can use kfree_rcu() instead of call_rcu()
> +to avoid having to write your own callback:
> +
> +	kfree_rcu(old_fp, rcu);
> +
>  Again, see checklist.txt for additional rules governing the use of RCU.
> 
> 
> @@ -773,8 +781,8 @@ a single atomic update, converting to RCU will require special care.
> 
>  Also, the presence of synchronize_rcu() means that the RCU version of
>  delete() can now block.  If this is a problem, there is a callback-based
> -mechanism that never blocks, namely call_rcu(), that can be used in
> -place of synchronize_rcu().
> +mechanism that never blocks, namely call_rcu() or kfree_rcu(), that can
> +be used in place of synchronize_rcu().
> 
> 
>  7.  FULL LIST OF RCU APIs
> @@ -813,6 +821,7 @@ RCU:	Critical sections	Grace period		Barrier
>  	rcu_read_unlock		synchronize_rcu
>  	rcu_dereference		synchronize_rcu_expedited
>  				call_rcu
> +				kfree_rcu
> 
> 
>  bh:	Critical sections	Grace period		Barrier
> -- 
> 1.7.9.5
> 
> 
> -- 
> Kees Cook
> Chrome OS Security
> 

