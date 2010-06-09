Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123Ab0FIWfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 18:35:52 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:45701 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab0FIWfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 18:35:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pFbZRKh41iX4OKRNS+IFDrQtKki3nSmP5xPuTeBm2oRbVLff9iwXbzLnGSiTRvCK15
         OQ/m1ZcETrKECCu2xVI1o1RTnr6GhS53JelNUiBkmz59LRwnAmQBu6YE6A0NPgzd5mig
         Jd4STpHp0sKeBQ8+wDYB6qu6iLDGABFky2f4A=
Date: Thu, 10 Jun 2010 00:35:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, avi@redhat.com, davem@davemloft.net,
       vgoyal@redhat.com, sam@ravnborg.org
Subject: Re: [PATCH 02/13] jump label v9: base patch
Message-ID: <20100609223548.GB12752@nowhere>
References: <cover.1276116186.git.jbaron@redhat.com> <ba56ef382c3b1a1d17a21005d5c4eda54cced0bf.1276116186.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba56ef382c3b1a1d17a21005d5c4eda54cced0bf.1276116186.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 09, 2010 at 05:38:57PM -0400, Jason Baron wrote:
> +static int build_jump_label_hashtable(struct jump_entry *start, struct jump_entry *stop)
> +{
> +	struct jump_entry *iter, *iter_begin;
> +	struct jump_label_entry *entry;
> +	int count;
> +
> +	sort_jump_label_entries(start, stop);
> +	iter = start;
> +	while (iter < stop) {
> +		entry = get_jump_label_entry((char *)iter->name);
> +		if (!entry) {
> +			iter_begin = iter;
> +			count = 0;
> +			while ((iter < stop) &&
> +				(strcmp((char *)iter->name,
> +					(char *)iter_begin->name) == 0)) {
> +				iter++;
> +				count++;
> +			}




So, you can have multiple entries with the same name? How can that happen
in fact?




> +			entry = add_jump_label_entry((char *)iter_begin->name,
> +							count, iter_begin);
> +			if (IS_ERR(entry))
> +				return PTR_ERR(entry);
> +			continue;
> +		}
> +		WARN(1, KERN_ERR "build_jump_hashtable: unexpected entry!\n");



It seems you are going to endless loop in this fail case.



> +	}
> +	return 0;
> +}
> +
> +/***
> + * jump_label_update - update jump label text
> + * @name - name of the jump label
> + * @type - enum set to JUMP_LABEL_ENABLE or JUMP_LABEL_DISABLE
> + *
> + * Will enable/disable the jump for jump label @name, depending on the
> + * value of @type.
> + *
> + */
> +
> +void jump_label_update(const char *name, enum jump_label_type type)
> +{
> +	struct jump_entry *iter;
> +	struct jump_label_entry *entry;
> +	struct hlist_node *module_node;
> +	struct jump_label_module_entry *e_module;
> +	int count;
> +
> +	mutex_lock(&jump_label_mutex);
> +	entry = get_jump_label_entry(name);
> +	if (entry) {
> +		count = entry->nr_entries;
> +		iter = entry->table;
> +		while (count--) {
> +			if (kernel_text_address(iter->code))
> +				arch_jump_label_transform(iter, type);
> +			iter++;
> +		}



So, this is going to patch multiple times the same value on the
same address in case you have multiple entries for the same name?

That look weird.

BTW, if you can't find the entry, you should perhaps propagate an error.



> +	}
> +	mutex_unlock(&jump_label_mutex);
> +}
> +
> +static int init_jump_label(void)



This can be __init.

