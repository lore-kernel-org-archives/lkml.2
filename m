Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934012Ab2J3Q2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:28:10 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:27852 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933864Ab2J3Q2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:28:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAG6Zu0/O+Ip3/2dsb2JhbABEtBGBCIIVAQEFJxMbASMQCxUDLhQlJBOIDroJiyGEQWIDlRqOGYFYgwWBQw
X-IronPort-AV: E=Sophos;i="4.75,637,1330923600"; 
   d="scan'208";a="203159629"
Date: Tue, 30 Oct 2012 12:21:03 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 4/4] rcu: Document alternative
 RCU/reference-count algorithms
Message-ID: <20121030162103.GA17261@Krystal>
References: <20121030160350.GA21837@linux.vnet.ibm.com>
 <1351613076-22022-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1351613076-22022-4-git-send-email-paulmck@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1351613076-22022-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Editor: vi
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> The approach for mixing RCU and reference counting listed in the RCU
> documentation only describes one possible approach.  This approach can
> result in failure on the read side, which is nice if you want fresh data,
> but not so good if you want simple code.  This commit therefore adds
> two additional approaches that feature unconditional reference-count
> acquisition by RCU readers.  These approaches are very similar to that
> used in the security code.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  Documentation/RCU/rcuref.txt |   61 ++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 59 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/RCU/rcuref.txt b/Documentation/RCU/rcuref.txt
> index 4202ad0..99ca662 100644
> --- a/Documentation/RCU/rcuref.txt
> +++ b/Documentation/RCU/rcuref.txt
> @@ -20,7 +20,7 @@ release_referenced()			delete()
>  {					{
>      ...					    write_lock(&list_lock);
>      atomic_dec(&el->rc, relfunc)	    ...
> -    ...					    delete_element
> +    ...					    remove_element
>  }					    write_unlock(&list_lock);
>   					    ...
>  					    if (atomic_dec_and_test(&el->rc))
> @@ -52,7 +52,7 @@ release_referenced()			delete()
>  {					{
>      ...					    spin_lock(&list_lock);
>      if (atomic_dec_and_test(&el->rc))       ...
> -        call_rcu(&el->head, el_free);       delete_element
> +        call_rcu(&el->head, el_free);       remove_element
>      ...                                     spin_unlock(&list_lock);
>  } 					    ...
>  					    if (atomic_dec_and_test(&el->rc))
> @@ -64,3 +64,60 @@ Sometimes, a reference to the element needs to be obtained in the
>  update (write) stream.  In such cases, atomic_inc_not_zero() might be
>  overkill, since we hold the update-side spinlock.  One might instead
>  use atomic_inc() in such cases.
> +
> +It is not always convenient to deal with "FAIL" in the
> +search_and_reference() code path.  In such cases, the
> +atomic_dec_and_test() may be moved from delete() to el_free()
> +as follows:
> +
> +1.					2.
> +add()					search_and_reference()
> +{					{
> +    alloc_object			    rcu_read_lock();
> +    ...					    search_for_element
> +    atomic_set(&el->rc, 1);		    atomic_inc(&el->rc);
> +    spin_lock(&list_lock);		    ...
> +				
> +    add_element				    rcu_read_unlock();
> +    ...					}

indentation looks wrong in my mail client for the two lines above (for
the 2. block).

Otherwise, it looks good to me,

Thanks,

Mathieu


> +    spin_unlock(&list_lock);		4.
> +}					delete()
> +3.					{
> +release_referenced()			    spin_lock(&list_lock);
> +{					    ...
> +    ...					    remove_element
> +    if (atomic_dec_and_test(&el->rc))       spin_unlock(&list_lock);
> +        kfree(el);			    ...
> +    ...                                     call_rcu(&el->head, el_free);
> +} 					    ...
> +5.					}
> +void el_free(struct rcu_head *rhp)
> +{
> +    release_referenced();
> +}
> +
> +The key point is that the initial reference added by add() is not removed
> +until after a grace period has elapsed following removal.  This means that
> +search_and_reference() cannot find this element, which means that the value
> +of el->rc cannot increase.  Thus, once it reaches zero, there are no
> +readers that can or ever will be able to reference the element.  The
> +element can therefore safely be freed.  This in turn guarantees that if
> +any reader finds the element, that reader may safely acquire a reference
> +without checking the value of the reference counter.
> +
> +In cases where delete() can sleep, synchronize_rcu() can be called from
> +delete(), so that el_free() can be subsumed into delete as follows:
> +
> +4.
> +delete()
> +{
> +    spin_lock(&list_lock);
> +    ...
> +    remove_element
> +    spin_unlock(&list_lock);
> +    ...
> +    synchronize_rcu();
> +    if (atomic_dec_and_test(&el->rc))
> +    	kfree(el);
> +    ...
> +}
> -- 
> 1.7.8
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
