Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab0IVOfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 10:35:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57496 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab0IVOfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 10:35:20 -0400
Date: Wed, 22 Sep 2010 16:35:15 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andi Kleen <andi@firstfloor.org>, jbaron@redhat.com, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
        tglx@linutronix.de, roland@redhat.com, rth@redhat.com,
        mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] Add for_each_module iterator function v2
Message-ID: <20100922143515.GF5766@basil.fritz.box>
References: <1285162001-9556-1-git-send-email-andi@firstfloor.org>
 <20100922141432.GB30730@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100922141432.GB30730@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 10:14:32AM -0400, Mathieu Desnoyers wrote:
> * Andi Kleen (andi@firstfloor.org) wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > This is a generic function to iterate over all modules.
> > To be used in the next patch.
> > 
> > v2: Use module_mutex instead of preempt disabling
> > 
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > ---
> >  include/linux/module.h |    1 +
> >  kernel/module.c        |   10 ++++++++++
> >  2 files changed, 11 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/module.h b/include/linux/module.h
> > index 403ac26..809b6db 100644
> > --- a/include/linux/module.h
> > +++ b/include/linux/module.h
> > @@ -410,6 +410,7 @@ struct module *__module_address(unsigned long addr);
> >  bool is_module_address(unsigned long addr);
> >  bool is_module_percpu_address(unsigned long addr);
> >  bool is_module_text_address(unsigned long addr);
> > +void for_each_module(void (*op)(struct module *, void *arg), void *arg);
> >  
> >  static inline int within_module_core(unsigned long addr, struct module *mod)
> >  {
> > diff --git a/kernel/module.c b/kernel/module.c
> > index eba1341..9e2a561 100644
> > --- a/kernel/module.c
> > +++ b/kernel/module.c
> > @@ -384,6 +384,16 @@ struct module *find_module(const char *name)
> >  }
> >  EXPORT_SYMBOL_GPL(find_module);
> >  
> > +void for_each_module(void (*op)(struct module *, void *arg), void *arg)
> > +{
> > +	struct module *mod;
> > +
> > +	mutex_lock(&module_mutex);
> 
> I'm concerned about the following mutex dependency chain:
> 
> module_mutex -> jump_label_mutex (on module load)
> jump_label_mutex -> module_mutex (on jump_label_update)

There are actually more problems in this version with using
module_mutex().  Looking at a fix.

> 
> Actually, I think your module notifier is missing in your version. This
> is why you don't see this dependency problem.

The module notifier is not needed anymore, but there's another 
callback through the trace point code on module load.

Unload notifier is not needed anymore because there is no
state to tear down.

-Andi
