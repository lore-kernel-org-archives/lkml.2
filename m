Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab0JWEl6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 00:41:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63442 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab0JWEl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 00:41:57 -0400
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=LuwKl7ggZIAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=toNs--1LxKYd4FgY-ywA:9 a=FgdmhcPsYZgHCevuh_kA:7 a=0DFEu6EbdXgZIZhIwUv0qrsutkQA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=3mcsVdrlTzAzLI9z:21 a=pYKL4FdJ1EPPiG5H:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for
 trace_sched_wakeup.c
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        masami.hiramatsu.pt@hitachi.com
In-Reply-To: <20101022214211.GJ6498@redhat.com>
References: <1287508282.16971.386.camel@gandalf.stny.rr.com>
	 <20101019184111.GA17266@elte.hu> <20101020154045.GA18353@elte.hu>
	 <20101020164324.GC7348@redhat.com> <20101020183329.GA12666@elte.hu>
	 <20101021110925.GA27219@elte.hu> <20101022175845.GF6498@redhat.com>
	 <20101022182433.GA24637@elte.hu>  <20101022214211.GJ6498@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 23 Oct 2010 00:41:53 -0400
Message-ID: <1287808913.16971.645.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-22 at 17:42 -0400, Jason Baron wrote:

> > > this looks potentially like a separate issue from the 'hang' one - I'm wondering 
> > > if this was re-produced with the same .config as the 'hang' case? I haven't been 
> > > able to hit this one yet....
> > 
> > Not the same config, and it's very spurious - i.e. a slightly different -tip version 
> > with the same config will boot fine. (this suggests some race)
> > 
> > Something very much not good with the fundamental mechanics of jump labels i'm 
> > afraid. It might be corrupting some memory here, or have some window of 
> > vulnerability in which an IRQ hits (or so) we will crash.
> > 
> > Thanks,
> > 
> > 	Ingo
> 
> we probably should have more sanity checks in the jump label code. The
> patch below verifies the the src and target addresses are within the
> text sections, and checks that we are not jumping to target out of
> range. 
> 
> comments? it be nice to get these into the tree asap, so that these
> might indicate what the issue is. Only lightly tested at this point.
> 
> thanks,
> 

Note, if you want a patch processed, please send it as a separate thread
with "[PATCH]" in the subject. Do not embed patches inside of replies,
because they most likely will be ignored by most people.

> -Jason
> 
> Add sanity checks to the jump label code. Check that the src and dest
> addresses are in the text sections, and that we aren't jump farther than
> we can reach.
> 
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> 
> diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
> index 961b6b3..14b2180 100644
> --- a/arch/x86/kernel/jump_label.c
> +++ b/arch/x86/kernel/jump_label.c
> @@ -28,11 +28,17 @@ void arch_jump_label_transform(struct jump_entry *entry,
>  			       enum jump_label_type type)
>  {
>  	union jump_code_union code;
> +	long diff;
>  
>  	if (type == JUMP_LABEL_ENABLE) {
>  		code.jump = 0xe9;
> -		code.offset = entry->target -
> -				(entry->code + JUMP_LABEL_NOP_SIZE);
> +		diff = (long)entry->target -
> +				((long)(entry->code + JUMP_LABEL_NOP_SIZE));
> +		if (abs(diff) > 0x7fffffff) {
> +			printk(KERN_ERR "jump label out of bounds!\n");
> +			BUG();

Is there a nicer way to fail here? Can we have a:

	if (WARN_ON_ONCE(abs(diff) > 0x7fffffff)
		return;

?


> +		}
> +		code.offset = (s32)diff;
>  	} else
>  		memcpy(&code, ideal_nop5, JUMP_LABEL_NOP_SIZE);
>  	get_online_cpus();
> diff --git a/kernel/jump_label.c b/kernel/jump_label.c
> index 7be868b..a33b01d 100644
> --- a/kernel/jump_label.c
> +++ b/kernel/jump_label.c
> @@ -78,6 +78,28 @@ static struct jump_label_entry *get_jump_label_entry(jump_label_t key)
>  	return NULL;
>  }
>  
> +static void verify_jump_addresses(struct jump_entry *table, int nr_entries)
> +{
> +	int count;
> +	struct jump_entry *iter;
> +
> +	count = nr_entries;
> +	iter = table;
> +	while (count--) {
> +		if (!kernel_text_address(iter->code)) {
> +			printk(KERN_ERR "jump label: invalid src addr: %lx\n",
> +					(unsigned long)iter->code);
> +			BUG();
> +		}
> +		if (!kernel_text_address(iter->target)) {
> +			printk(KERN_ERR "jump label: invalid dest addr: %lx\n",
> +					(unsigned long)iter->target);
> +			BUG();

Same for these BUG()s.

-- Steve

> +		}
> +		iter++;
> +	}
> +}
> +
>  static struct jump_label_entry *
>  add_jump_label_entry(jump_label_t key, int nr_entries, struct jump_entry *table)
>  {
> @@ -85,6 +107,9 @@ add_jump_label_entry(jump_label_t key, int nr_entries, struct jump_entry *table)
>  	struct jump_label_entry *e;
>  	u32 hash;
>  
> +	/* first verify that the addresses are ok */
> +	verify_jump_addresses(table, nr_entries);
> +
>  	e = get_jump_label_entry(key);
>  	if (e)
>  		return ERR_PTR(-EEXIST);
> @@ -289,6 +314,8 @@ add_jump_label_module_entry(struct jump_label_entry *entry,
>  {
>  	struct jump_label_module_entry *e;
>  
> +	verify_jump_addresses(iter_begin, count);
> +
>  	e = kmalloc(sizeof(struct jump_label_module_entry), GFP_KERNEL);
>  	if (!e)
>  		return ERR_PTR(-ENOMEM);


