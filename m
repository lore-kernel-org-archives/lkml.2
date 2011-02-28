Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab1B1Td6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 14:33:58 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56305 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180Ab1B1Td5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 14:33:57 -0500
Date: Mon, 28 Feb 2011 11:33:54 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jiri Pirko <jpirko@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] list: add list_last_entry macros
Message-ID: <20110228193354.GW2331@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110227104620.GA2814@psychotron.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110227104620.GA2814@psychotron.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 27, 2011 at 11:46:21AM +0100, Jiri Pirko wrote:
> Handy to get last item in a list. Also corrected parameter name for
> list_first_entry.
> 
> Signed-off-by: Jiri Pirko <jpirko@redhat.com>
> 
> diff --git a/include/linux/list.h b/include/linux/list.h
> index 3a54266..e10862e 100644
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -352,14 +352,25 @@ static inline void list_splice_tail_init(struct list_head *list,
> 
>  /**
>   * list_first_entry - get the first element from a list
> - * @ptr:	the list head to take the element from.
> + * @head:	the list head to take the element from.
>   * @type:	the type of the struct this is embedded in.
>   * @member:	the name of the list_struct within the struct.
>   *
>   * Note, that list is expected to be not empty.
>   */
> -#define list_first_entry(ptr, type, member) \
> -	list_entry((ptr)->next, type, member)
> +#define list_first_entry(head, type, member) \
> +	list_entry((head)->next, type, member)
> +
> +/**
> + * list_last_entry - get the last element from a list
> + * @head:	the list head to take the element from.
> + * @type:	the type of the struct this is embedded in.
> + * @member:	the name of the list_struct within the struct.
> + *
> + * Note, that list is expected to be not empty.
> + */
> +#define list_last_entry(head, type, member) \
> +	list_entry((head)->prev, type, member)
> 
>  /**
>   * list_for_each	-	iterate over a list
> diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> index 2dea94f..2cfa99f 100644
> --- a/include/linux/rculist.h
> +++ b/include/linux/rculist.h
> @@ -229,7 +229,7 @@ static inline void list_splice_init_rcu(struct list_head *list,
> 
>  /**
>   * list_first_entry_rcu - get the first element from a list
> - * @ptr:        the list head to take the element from.
> + * @head:       the list head to take the element from.
>   * @type:       the type of the struct this is embedded in.
>   * @member:     the name of the list_struct within the struct.
>   *
> @@ -238,8 +238,23 @@ static inline void list_splice_init_rcu(struct list_head *list,
>   * This primitive may safely run concurrently with the _rcu list-mutation
>   * primitives such as list_add_rcu() as long as it's guarded by rcu_read_lock().
>   */
> -#define list_first_entry_rcu(ptr, type, member) \
> -	list_entry_rcu((ptr)->next, type, member)
> +#define list_first_entry_rcu(head, type, member) \
> +	list_entry_rcu((head)->next, type, member)
> +
> +/**
> + * list_last_entry_rcu - get the last element from a list
> + * @head:       the list head to take the element from.
> + * @type:       the type of the struct this is embedded in.
> + * @member:     the name of the list_struct within the struct.
> + *
> + * Note, that list is expected to be not empty.
> + *
> + * This primitive may safely run concurrently with the _rcu list-mutation
> + * primitives such as list_add_rcu() as long as it's guarded by rcu_read_lock().
> + */
> +
> +#define list_last_entry_rcu(head, type, member) \
> +	list_entry_rcu((head)->prev, type, member)

But won't a concurrent list_del_rcu() on head, which removes the full
list, poison the ->prev pointer?

Do you have a definite use case for list_last_entry_rcu()?

							Thanx, Paul

>  /**
>   * list_for_each_entry_rcu	-	iterate over rcu list of given type
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
