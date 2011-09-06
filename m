Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab1IFKub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 06:50:31 -0400
Received: from mail.openrapids.net ([64.15.138.104]:52213 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754173Ab1IFKu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 06:50:28 -0400
Date: Tue, 6 Sep 2011 06:50:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -mm 2/4] llist, Define macro to check NMI safe cmpxchg
Message-ID: <20110906105026.GB21602@Krystal>
References: <1315290307-25145-1-git-send-email-ying.huang@intel.com> <1315290307-25145-2-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315290307-25145-2-git-send-email-ying.huang@intel.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 06:49:04 up 286 days, 15:52,  1 user,  load average: 1.00, 1.00,
	0.81
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Huang Ying (ying.huang@intel.com) wrote:
> To make code cleaner and reduce code duplication.  Thanks Peter
> Zijlstra for reminding.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> ---
>  include/linux/llist.h |   22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
> 
> --- a/include/linux/llist.h
> +++ b/include/linux/llist.h
> @@ -70,6 +70,12 @@ struct llist_node {
>  #define LLIST_HEAD_INIT(name)	{ NULL }
>  #define LLIST_HEAD(name)	struct llist_head name = LLIST_HEAD_INIT(name)
>  
> +#ifdef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
> +#define CHECK_NMI_SAFE_CMPXCHG()

Does it have to be in caps ? And can it be turned into a static inline
function ? I'm thinking about something close to might_sleep().

Thanks,

Mathieu

> +#else
> +#define CHECK_NMI_SAFE_CMPXCHG()	BUG_ON(in_nmi())
> +#endif
> +
>  /**
>   * init_llist_head - initialize lock-less list head
>   * @head:	the head for your lock-less list
> @@ -147,9 +153,7 @@ static inline void llist_add(struct llis
>  {
>  	struct llist_node *entry, *old_entry;
>  
> -#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
> -	BUG_ON(in_nmi());
> -#endif
> +	CHECK_NMI_SAFE_CMPXCHG();
>  
>  	entry = head->first;
>  	do {
> @@ -171,9 +175,7 @@ static inline void llist_add_batch(struc
>  {
>  	struct llist_node *entry, *old_entry;
>  
> -#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
> -	BUG_ON(in_nmi());
> -#endif
> +	CHECK_NMI_SAFE_CMPXCHG();
>  
>  	entry = head->first;
>  	do {
> @@ -201,9 +203,7 @@ static inline struct llist_node *llist_d
>  {
>  	struct llist_node *entry, *old_entry, *next;
>  
> -#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
> -	BUG_ON(in_nmi());
> -#endif
> +	CHECK_NMI_SAFE_CMPXCHG();
>  
>  	entry = head->first;
>  	do {
> @@ -227,9 +227,7 @@ static inline struct llist_node *llist_d
>   */
>  static inline struct llist_node *llist_del_all(struct llist_head *head)
>  {
> -#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
> -	BUG_ON(in_nmi());
> -#endif
> +	CHECK_NMI_SAFE_CMPXCHG();
>  
>  	return xchg(&head->first, NULL);
>  }

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
