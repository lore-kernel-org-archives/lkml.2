Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab1EAPna (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 11:43:30 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:35414 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab1EAPn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 11:43:27 -0400
X-Originating-IP: 217.70.178.134
X-Originating-IP: 50.43.15.19
Date: Sun, 1 May 2011 08:43:10 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 17/86] rcu: fix boost-tracing bug and update
 tracing documentation
Message-ID: <20110501154310.GD14829@feather>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
 <1304256126-26015-17-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304256126-26015-17-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bugfix here should really go in a separate commit from the updated
documentation.  Also:

On Sun, May 01, 2011 at 06:20:57AM -0700, Paul E. McKenney wrote:
> --- a/Documentation/RCU/trace.txt
> +++ b/Documentation/RCU/trace.txt
> @@ -10,34 +10,37 @@ for rcutree and next for rcutiny.
>  
>  CONFIG_TREE_RCU and CONFIG_TREE_PREEMPT_RCU debugfs Files and Formats
>  
> -These implementations of RCU provides five debugfs files under the
> +These implementations of RCU provides seven debugfs files under the

s/seven/several/, so this doesn't continue to need updates as you add
more tracing?  It doesn't seem entirely accurate even now, given that
the set of files available now depends on CONFIG_RCU_BOOST.

>  top-level directory RCU: rcu/rcudata (which displays fields in struct

RCU or rcu?

>  rcu_data), rcu/rcudata.csv (which is a .csv spreadsheet version of
>  rcu/rcudata), rcu/rcugp (which displays grace-period counters),
> -rcu/rcuhier (which displays the struct rcu_node hierarchy), and
> +rcu/rcuhier (which displays the struct rcu_node hierarchy),
>  rcu/rcu_pending (which displays counts of the reasons that the
> -rcu_pending() function decided that there was core RCU work to do).
> +rcu_pending() function decided that there was core RCU work to do),
> +rcu/rcutorture (which displays rcutorture test progress), and, if the
> +kernel is built with CONFIG_RCU_BOOST, rcu/rcuboost (which displays RCU
> +boosting statistics).

I think this would work better as a list:

rcu/rcudata:
    Displays fields in struct rcu_data.
rcu/rcudata.csv:
    Comma-separated values spreadsheet version of rcudata.
rcu/rcugp:
    Displays grace-period counters.
rcu/rcuhier
    Displays the struct rcu_node hierarchy.
rcu/rcu_pending:
    Displays counts of the reasons rcu_pending() decided that RCU had
    work to do.
rcu/rcutorture:
    Displays rcutorture test progress.
rcu/rcuboost
    Displays RCU boosting statistics. Only present if
    CONFIG_RCU_BOOST=y.

Feel free to put the descriptions on the same lines as the filenames if
you prefer; however, I thought this style worked better for the
descriptions longer than one line.

Also, does rcu/rcutorture appear with rcutorture not loaded?  Hopefully
not, since rcutorture shouldn't take up any additional resources when
not loaded.

> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -1086,7 +1086,7 @@ static void rcu_initiate_boost_trace(struct rcu_node *rnp)
>  	else if (rnp->gp_tasks != NULL && rnp->qsmask != 0)
>  		rnp->n_balk_notblocked++;
>  	else if (rnp->gp_tasks != NULL &&
> -		 ULONG_CMP_GE(jiffies, rnp->boost_time))
> +		 ULONG_CMP_LT(jiffies, rnp->boost_time))
>  		rnp->n_balk_notyet++;
>  	else
>  		rnp->n_balk_nos++;

This bugfix should go in a separate commit.

- Josh Triplett
