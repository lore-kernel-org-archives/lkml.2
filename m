Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab0IVL5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 07:57:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53210 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab0IVL5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 07:57:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GzLisly/pDxFNIICBDnJjH081366Hf8N7kyB5ORegPhIKTRUALUrN6FXp5KcY85apv
         oWLLtQRMl8FWz9ezt6Tip/6E1VH6NdvdX/d9xTyAXFJwNHJyC8to4AuXvChCgthS4bGH
         0Z3vk6/LaOBTOx333SYGG44mF0gwwexSRNNeI=
Date: Wed, 22 Sep 2010 13:57:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andi Kleen <andi@firstfloor.org>, jbaron@redhat.com, rostedt@goodmis.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
        tglx@linutronix.de, roland@redhat.com, rth@redhat.com,
        mhiramat@redhat.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] Rewrite jump_label.c to use binary search
Message-ID: <20100922115729.GA5336@nowhere>
References: <1285150102-5506-1-git-send-email-andi@firstfloor.org> <1285150102-5506-2-git-send-email-andi@firstfloor.org> <20100922113114.GA14179@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100922113114.GA14179@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 07:31:14AM -0400, Mathieu Desnoyers wrote:
> > -static struct jump_label_entry *add_jump_label_entry(jump_label_t key, int nr_entries, struct jump_entry *table)
> > +void patch_jump_table(unsigned long key, enum jump_label_type type,
> > +	 	      struct jump_entry *start, struct jump_entry *stop)
> >  {
> > -	struct hlist_head *head;
> > -	struct jump_label_entry *e;
> > -	u32 hash;
> > -
> > -	e = get_jump_label_entry(key);
> > -	if (e)
> > -		return ERR_PTR(-EEXIST);
> > -
> > -	e = kmalloc(sizeof(struct jump_label_entry), GFP_KERNEL);
> > -	if (!e)
> > -		return ERR_PTR(-ENOMEM);
> > -
> > -	hash = jhash((void *)&key, sizeof(jump_label_t), 0);
> > -	head = &jump_label_table[hash & (JUMP_LABEL_TABLE_SIZE - 1)];
> > -	e->key = key;
> > -	e->table = table;
> > -	e->nr_entries = nr_entries;
> > -	INIT_HLIST_HEAD(&(e->modules));
> > -	hlist_add_head(&e->hlist, head);
> > -	return e;
> > +	struct jump_entry *entry = search_jump_table(start, stop, key);
> > +	if (!entry)
> > +		return;
> > +	while (entry > start && entry[-1].key == key)
> > +		entry--;
> 
> OK, I like the way it handles patching of multiple entries with the same
> key at once. Sorting really makes sense here.
> 
> > +	for (; entry < stop && entry->key == key; entry++)
> > +		if (kernel_text_address(entry->code))
> 
> This does not work for modules I'm afraid, only for the core kernel. You
> should test for __module_text_address() somewhere.



No, look:

int kernel_text_address(unsigned long addr)
{
	if (core_kernel_text(addr))
		return 1;
	return is_module_text_address(addr);
}


 
> Dumb question: why do you need this test at all ?


I wonder about that too.

