Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab1EWQqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 12:46:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756603Ab1EWQpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 12:45:53 -0400
Date: Mon, 23 May 2011 18:45:41 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org
Cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3] jump_label,x86: make batch update of jump_label entries
Message-ID: <20110523164541.GE2052@jolsa.brq.redhat.com>
References: <1304023961-12741-1-git-send-email-jolsa@redhat.com>
 <1304502103-3228-1-git-send-email-jolsa@redhat.com>
 <20110509183816.GF3981@jolsa.brq.redhat.com>
 <20110509192726.GB2524@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110509192726.GB2524@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
any feedback?

thanks,
jirka

On Mon, May 09, 2011 at 03:27:26PM -0400, Jason Baron wrote:
> On Mon, May 09, 2011 at 08:38:16PM +0200, Jiri Olsa wrote:
> > On Wed, May 04, 2011 at 11:41:41AM +0200, Jiri Olsa wrote:
> > > hi,
> > > 
> > > I'm changing the jump label update code to use batch processing
> > > for x86 architectures. 
> > > 
> > > Currently each jump label update calls text_poke_smp for each
> > > jump label key entry. Thus one key update ends up calling stop
> > > machine multiple times.
> > > 
> > > This patch is using text_poke_smp_batch, which is called for
> > > all the key's entries. Thus ensuring the stop machine is called
> > > only once per jump_label key.
> > > 
> > > attached patches:
> > > 1/2 - jump_label,x86: use text_poke_smp_batch for entries update
> > > 	- added jump_label_update_end function which is paired with
> > > 	the key's entries update
> > > 	- jump_label_update_end calls arch_jump_label_update_end which
> > > 	is overloaded by x86 arch and makes the batch update of all the
> > > 	entries queued by arch_jump_label_transform function.
> > > 
> > > 2/2 - jump_label,x86: using static arrays before dynamic allocation is needed
> > > 	- in the first patch, the queue array, which stores jump_label
> > > 	entries is allocated/resized dynamically.
> > > 	- due to the fact that many jump_label entries have low number
> > > 	of callers, it seems appropriate to use static sized array
> > > 	when the update starts and if needed (in case of high number
> > > 	of jump_label entries) allocate/use the dynamic array
> > > 
> > > 
> > > Patch 2/2 and could be ommited if the benefit/complexity ratio
> > > would seem too low.. ;)
> > > 
> > > I tested this on x86 and s390 archs.
> > > 
> > > v2 changes:
> > >  - queueing all entries for single key and process them
> > >    all at one time
> > > 
> > > wrb,
> > > jirka
> > > ---
> > >  arch/x86/kernel/jump_label.c |  177 +++++++++++++++++++++++++++++++++++++++--
> > >  include/linux/jump_label.h   |    1 +
> > >  kernel/jump_label.c          |   16 ++++-
> > >  3 files changed, 183 insertions(+), 11 deletions(-)
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> > hi,
> > 
> > I did jump_label entries statistics on allyesconfig kernel
> > and got following numbers:
> > 
> > callers - keys
> >       1 - 964
> >       2 - 28
> >       3 - 5
> >       4 - 1
> >       6 - 1
> >      11 - 2
> >      12 - 1
> >      14 - 2
> >      17 - 2
> >      21 - 1
> >     170 - 1
> > 
> > 
> > So the maximum is 170 callers and just for one key,
> > which is the key used in trace_module_get function.
> > 
> > Jason suggested we might stay with the static way because for most
> > of the entries the maximum number of callers is up to 21.
> > 
> > I'm attaching the static version for consideration.
> > 
> > wbr,
> > jirka
> > 
> > ---
> > Changing the jump label update code to use batch processing
> > for x86 architectures.
> > 
> > Currently each jump label update calls text_poke_smp for each
> > jump label key entry. Thus one key update ends up calling stop
> > machine multiple times.
> > 
> > This patch is using text_poke_smp_batch, which is called for
> > mmultiple entries at a time.
> > 
> > Added jump_label_update_end function which is paired with
> > the key's entries update.
> > 
> > The jump_label_update_end calls arch_jump_label_update_end
> > (with generic weak definition) which is overloaded by x86
> > arch and makes the batch update of all the entries queued
> > by arch_jump_label_transform function.
> > 
> > The number of entries that can be updated at a single time
> > is set to 30. This number is based on statistics from allyesconfig
> > kernel showing most of the keys having upto 30 callers.
> > 
> > callers - keys
> >       1 - 964
> >       2 - 28
> >       3 - 5
> >       4 - 1
> >       6 - 1
> >      11 - 2
> >      12 - 1
> >      14 - 2
> >      17 - 2
> >      21 - 1
> >     170 - 1
> > 
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com> 
> > ---
> >  arch/x86/kernel/jump_label.c |   68 ++++++++++++++++++++++++++++++++++++-----
> >  include/linux/jump_label.h   |    1 +
> >  kernel/jump_label.c          |   16 ++++++++-
> >  3 files changed, 74 insertions(+), 11 deletions(-)
> > 
> 
> For me, this version is much simpler (less than half the code size of
> the original patch), while being optimal for 1007/1008 of the keys.
> 
> Acked-by: Jason Baron <jbaron@redhat.com> 
> 
> 
> Thanks.
> 
> > diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
> > index 3fee346..bbde5db 100644
> > --- a/arch/x86/kernel/jump_label.c
> > +++ b/arch/x86/kernel/jump_label.c
> > @@ -24,24 +24,74 @@ union jump_code_union {
> >  	} __attribute__((packed));
> >  };
> >  
> > -void arch_jump_label_transform(struct jump_entry *entry,
> > -			       enum jump_label_type type)
> > +struct text_poke_buffer {
> > +	u8 code[JUMP_LABEL_NOP_SIZE];
> > +};
> > +
> > +#define POKE_CNT_MAX 30
> > +
> > +static struct text_poke_param  poke_pars[POKE_CNT_MAX];
> > +static struct text_poke_buffer poke_bufs[POKE_CNT_MAX];
> > +static int poke_cnt;
> > +
> > +static void poke_setup(struct text_poke_param *param, u8 *buf,
> > +		       int enable,
> > +		       struct jump_entry *entry)
> >  {
> > -	union jump_code_union code;
> > +	union jump_code_union *code = (union jump_code_union *) buf;
> >  
> > -	if (type == JUMP_LABEL_ENABLE) {
> > -		code.jump = 0xe9;
> > -		code.offset = entry->target -
> > -				(entry->code + JUMP_LABEL_NOP_SIZE);
> > +	if (enable == JUMP_LABEL_ENABLE) {
> > +		code->jump = 0xe9;
> > +		code->offset = entry->target -
> > +			       (entry->code + JUMP_LABEL_NOP_SIZE);
> >  	} else
> > -		memcpy(&code, ideal_nops[NOP_ATOMIC5], JUMP_LABEL_NOP_SIZE);
> > +		memcpy(code, ideal_nops[NOP_ATOMIC5], JUMP_LABEL_NOP_SIZE);
> > +
> > +	param->addr = (void *) entry->code;
> > +	param->opcode = code;
> > +	param->len = JUMP_LABEL_NOP_SIZE;
> > +}
> > +
> > +static void poke_process(void)
> > +{
> >  	get_online_cpus();
> >  	mutex_lock(&text_mutex);
> > -	text_poke_smp((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
> > +
> > +	text_poke_smp_batch(poke_pars, poke_cnt);
> > +	poke_cnt = 0;
> > +
> >  	mutex_unlock(&text_mutex);
> >  	put_online_cpus();
> >  }
> >  
> > +static void poke_end(void)
> > +{
> > +	if (!poke_cnt)
> > +		return;
> > +
> > +	poke_process();
> > +}
> > +
> > +void arch_jump_label_transform(struct jump_entry *entry,
> > +			       enum jump_label_type enable)
> > +{
> > +	if (poke_cnt == POKE_CNT_MAX)
> > +		poke_process();
> > +
> > +	poke_setup(&poke_pars[poke_cnt], poke_bufs[poke_cnt].code,
> > +		   enable, entry);
> > +	poke_cnt++;
> > +}
> > +
> > +/*
> > + * Called after arch_jump_label_transform is called for
> > + * all entries of a single key.
> > + */
> > +void arch_jump_label_update_end(void)
> > +{
> > +	poke_end();
> > +}
> > +
> >  void arch_jump_label_text_poke_early(jump_label_t addr)
> >  {
> >  	text_poke_early((void *)addr, ideal_nops[NOP_ATOMIC5],
> > diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
> > index 83e745f..e7a8fa3 100644
> > --- a/include/linux/jump_label.h
> > +++ b/include/linux/jump_label.h
> > @@ -46,6 +46,7 @@ extern void jump_label_unlock(void);
> >  extern void arch_jump_label_transform(struct jump_entry *entry,
> >  				 enum jump_label_type type);
> >  extern void arch_jump_label_text_poke_early(jump_label_t addr);
> > +extern void arch_jump_label_update_end(void);
> >  extern int jump_label_text_reserved(void *start, void *end);
> >  extern void jump_label_inc(struct jump_label_key *key);
> >  extern void jump_label_dec(struct jump_label_key *key);
> > diff --git a/kernel/jump_label.c b/kernel/jump_label.c
> > index 74d1c09..6657a37 100644
> > --- a/kernel/jump_label.c
> > +++ b/kernel/jump_label.c
> > @@ -125,6 +125,15 @@ void __weak arch_jump_label_text_poke_early(jump_label_t addr)
> >  {
> >  }
> >  
> > +void __weak arch_jump_label_update_end(void)
> > +{
> > +}
> > +
> > +void jump_label_update_end(void)
> > +{
> > +	arch_jump_label_update_end();
> > +}
> > +
> >  static __init int jump_label_init(void)
> >  {
> >  	struct jump_entry *iter_start = __start___jump_table;
> > @@ -244,10 +253,11 @@ static int jump_label_add_module(struct module *mod)
> >  		jlm->next = key->next;
> >  		key->next = jlm;
> >  
> > -		if (jump_label_enabled(key))
> > +		if (jump_label_enabled(key)) {
> >  			__jump_label_update(key, iter, JUMP_LABEL_ENABLE);
> > +			jump_label_update_end();
> > +		}
> >  	}
> > -
> >  	return 0;
> >  }
> >  
> > @@ -376,6 +386,8 @@ static void jump_label_update(struct jump_label_key *key, int enable)
> >  #ifdef CONFIG_MODULES
> >  	__jump_label_mod_update(key, enable);
> >  #endif
> > +
> > +	jump_label_update_end();
> >  }
> >  
> >  #endif
> > -- 
> > 1.7.1
> > 
