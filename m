Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838Ab0DIVYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 17:24:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757766Ab0DIVYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 17:24:52 -0400
Date: Fri, 9 Apr 2010 17:24:25 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 7/9] jump label: sort jump table at build-time
Message-ID: <20100409212425.GB8219@redhat.com>
References: <cover.1270839564.git.jbaron@redhat.com> <9cd6a0307ac55f2090c5b75a26ee9ca6a167cc8d.1270839564.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cd6a0307ac55f2090c5b75a26ee9ca6a167cc8d.1270839564.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 03:49:57PM -0400, Jason Baron wrote:
> The jump label table is more optimal accessed if the entries are continguous.
> Sorting the table accomplishes this. Do the sort at build-time. Adds a '-j'
> option to 'modpost' which replaces the vmlinux, with a sorted jump label
> section vmlinux. I've tested this on x86 with relocatable and it works fine
> there as well. Note that I have not sorted the jump label table in modules.
> This is b/c the jump label names can be exported by the core kernel, and thus
> I don't have them available at buildtime. This could be solved by either
> finding the correct ones in the vmlinux, or by embedding the name of the jump
> label in the module tables (and not just a pointer), but the module tables
> tend to be smaller, and thus their is less value to this kind of change
> anyway. The kernel continues to do the sort, just in case, but at least for
> the vmlinux, this is just a verfication that the jump label table has
> already been sorted.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> ---

[ CCing Eric ]

[..]
> +static void swap_jump_label_entries(struct jump_entry *previous, struct jump_entry *next)
> +{
> +	struct jump_entry tmp;
> +
> +	tmp = *next;
> +	*next = *previous;
> +	*previous = tmp;
> +}
> +
> +static void sort_jump_label_table(struct elf_info *info, Elf_Ehdr *hdr)
> +{
> +	int swapped = 0;
> +	struct jump_entry *iter, *iter_next;
> +	char *name, *next_name;
> +	Elf_Shdr *sechdrs = info->sechdrs;
> +	unsigned long jump_table, jump_table_end;
> +	unsigned long jump_strings, jump_strings_addr;
> +
> +	if ((info->jump_sec == 0) && (info->jump_strings_sec == 0))
> +		return;
> +
> +	jump_table = (unsigned long)hdr + sechdrs[info->jump_sec].sh_offset;
> +	jump_table_end = jump_table + sechdrs[info->jump_sec].sh_size;
> +	jump_strings = (unsigned long)hdr +
> +				sechdrs[info->jump_strings_sec].sh_offset;
> +	jump_strings_addr = sechdrs[info->jump_strings_sec].sh_addr;
> +
> +	do {
> +		swapped = 0;
> +		iter = iter_next = (struct jump_entry *)jump_table;
> +		iter_next++;
> +		for (; iter_next < (struct jump_entry *)jump_table_end;
> +							iter++, iter_next++) {
> +			name = jump_strings + (iter->name - jump_strings_addr);
> +			next_name = jump_strings +
> +					(iter_next->name - jump_strings_addr);
> +			if (strcmp(name, next_name) > 0) {
> +				swap_jump_label_entries(iter, iter_next);
> +				swapped = 1;


Jason,

As we were chatting about this, it looks like you are modifying vmlinux
section outside the knowledge of compiler. So theoritically associated
relocation section knowledge is no more valid and it can be a problem during
i386 relocatable kernels where we read the section's relocation inforamtion
and perform the relocations at runtime.

I know you have tested this on i386 and it works for you. I guess it works
because all the entries in the section are same and we apply same relocation
offset to all entries so even changing the order of entries is not impacting.

But conceptually, changing the vmlinux section outside knowledge of compiler
and assuming that we don't have to change the associated relocation section
probably is not the best thing.

I am not sure how to fix it. May be rely back on boot time sorting, or if
there is a way to relink sections after sorting etc. I just wanted to raise
a concern. May be other people (Eric, hpa) have ideas whether it is a valid
concern or not or how to handle it better.

Thanks
Vivek
