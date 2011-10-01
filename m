Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab1JALYF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 07:24:05 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:34536 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab1JALYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 07:24:00 -0400
Subject: Re: [PATCH RFC 7/8] s390/jump-label: add
 arch_jump_label_transform_early()
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jason Baron <jbaron@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
In-Reply-To: <4E85E867.8080809@goop.org>
References: <cover.1317338254.git.jeremy.fitzhardinge@citrix.com>
	 <b1d87557dc3001031ee8d7f69ee97b90cecba6aa.1317338254.git.jeremy.fitzhardinge@citrix.com>
	 <1317394099.11297.54.camel@localhost.localdomain>
	 <4E85E867.8080809@goop.org>
Content-Type: text/plain; charset="windows-1251"
Date: Sat, 01 Oct 2011 13:22:17 +0200
Message-Id: <1317468137.11297.70.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-30 at 09:03 -0700, Jeremy Fitzhardinge wrote:
> On 09/30/2011 07:48 AM, Jan Glauber wrote:
> > On Thu, 2011-09-29 at 16:26 -0700, Jeremy Fitzhardinge wrote:
> >> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> >>
> >> This allows jump-label entries to be modified early, in a pre-SMP
> >> environment.
> >>
> >> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> >> Cc: Jan Glauber <jang@linux.vnet.ibm.com>
> > Hi Jeremy,
> >
> > Your patch looks fine, if you can fix the minor compiler warnings
> > below. Excluding stop_machine() on pre-SMP also looks safer too me.
> 
> Do you think there would be an actual problem, or are you just being
> cautious?

Just cautious since stop_machine() is quite a big hammer. Who knows how
many jump labels we might get? So without an early exit in
stop_machine() for pre-SMP we might waste performance there.

> It seems to me - in general - stop_machine could just be defined to be a
> no-op (ie, just directly calls the callback) until enough SMP is
> initialized for it to make sense, rather than having to make every user
> work around it (if there's a chance they might call it early).

Agreed.

> >   CC      arch/s390/kernel/jump_label.o
> > arch/s390/kernel/jump_label.c: In function ‘__jump_label_transform’:
> > arch/s390/kernel/jump_label.c:41:2: error: ‘rc’ undeclared (first use in this function)
> > arch/s390/kernel/jump_label.c:41:2: note: each undeclared identifier is reported only once for each function it appears in
> > arch/s390/kernel/jump_label.c:41:2: warning: passing argument 1 of ‘probe_kernel_write’ makes pointer from integer without a cast [enabled by default]
> > include/linux/uaccess.h:108:21: note: expected ‘void *’ but argument is of type ‘jump_label_t’
> > arch/s390/kernel/jump_label.c:28:19: warning: unused variable ‘args’ [-Wunused-variable]
> > make[2]: *** [arch/s390/kernel/jump_label.o] Error 1
> >
> >
> 
> Like so?

Yes, that compiles!

--Jan

> From 9572689d1e5e6f54a1936a1dca09a6920d1bce27 Mon Sep 17 00:00:00 2001
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Date: Thu, 29 Sep 2011 10:58:46 -0700
> Subject: [PATCH] s390/jump-label: add arch_jump_label_transform_early()
> 
> This allows jump-label entries to be modified early, in a pre-SMP
> environment.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc: Jan Glauber <jang@linux.vnet.ibm.com>
> 
> diff --git a/arch/s390/kernel/jump_label.c b/arch/s390/kernel/jump_label.c
> index 44cc06b..4fbe63b 100644
> --- a/arch/s390/kernel/jump_label.c
> +++ b/arch/s390/kernel/jump_label.c
> @@ -18,26 +18,15 @@ struct insn {
>  } __packed;
> 
>  struct insn_args {
> -	unsigned long *target;
> -	struct insn *insn;
> -	ssize_t size;
> +	struct jump_entry *entry;
> +	enum jump_label_type type;
>  };
> 
> -static int __arch_jump_label_transform(void *data)
> +static void __jump_label_transform(struct jump_entry *entry,
> +				   enum jump_label_type type)
>  {
> -	struct insn_args *args = data;
> -	int rc;
> -
> -	rc = probe_kernel_write(args->target, args->insn, args->size);
> -	WARN_ON_ONCE(rc < 0);
> -	return 0;
> -}
> -
> -void arch_jump_label_transform(struct jump_entry *entry,
> -			       enum jump_label_type type)
> -{
> -	struct insn_args args;
>  	struct insn insn;
> +	int rc;
> 
>  	if (type == JUMP_LABEL_ENABLE) {
>  		/* brcl 15,offset */
> @@ -49,11 +38,33 @@ void arch_jump_label_transform(struct jump_entry *entry,
>  		insn.offset = 0;
>  	}
> 
> -	args.target = (void *) entry->code;
> -	args.insn = &insn;
> -	args.size = JUMP_LABEL_NOP_SIZE;
> +	rc = probe_kernel_write((void *)entry->code, &insn, JUMP_LABEL_NOP_SIZE);
> +	WARN_ON_ONCE(rc < 0);
> +}
> 
> -	stop_machine(__arch_jump_label_transform, &args, NULL);
> +static int __sm_arch_jump_label_transform(void *data)
> +{
> +	struct insn_args *args = data;
> +
> +	__jump_label_transform(args->entry, args->type);
> +	return 0;
> +}
> +
> +void arch_jump_label_transform(struct jump_entry *entry,
> +			       enum jump_label_type type)
> +{
> +	struct insn_args args;
> +
> +	args.entry = entry;
> +	args.type = type;
> +
> +	stop_machine(__sm_arch_jump_label_transform, &args, NULL);
> +}
> +
> +void __init arch_jump_label_transform_early(struct jump_entry *entry,
> +					    enum jump_label_type type)
> +{
> +	__jump_label_transform(entry, type);
>  }
> 
>  #endif
> 
> 	J
> 

