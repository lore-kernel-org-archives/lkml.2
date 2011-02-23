Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab1BWPtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 10:49:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005Ab1BWPtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 10:49:35 -0500
Date: Wed, 23 Feb 2011 10:48:29 -0500
From: Jason Baron <jbaron@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: hpa@zytor.com, mathieu.desnoyers@polymtl.ca, rostedt@goodmis.org,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jump label: introduce static_branch() interface
Message-ID: <20110223154829.GA2829@redhat.com>
References: <201102222228.p1MMSxnT016454@int-mx10.intmail.prod.int.phx2.redhat.com> <1298455885.2217.354.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298455885.2217.354.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 11:11:25AM +0100, Peter Zijlstra wrote:
> On Tue, 2011-02-22 at 17:28 -0500, Jason Baron wrote:
> > @@ -33,7 +28,11 @@ struct _ddebug {
> >  #define _DPRINTK_FLAGS_PRINT   (1<<0)  /* printk() a message using
> > the format */
> >  #define _DPRINTK_FLAGS_DEFAULT 0
> >         unsigned int flags:8;
> > -       char enabled;
> > +#ifdef HAVE_JUMP_LABEL
> > +       struct jump_label_key enabled;
> > +#else
> > +       int enabled;
> > +#endif
> >  } __attribute__((aligned(8)));
> >   
> 
> Also, didn't you promise Mathieu a comment explaining why dynamic debug
> does funny things like this? :-) I mean we all know its because of the
> cyclic header stuff involving atomic etc.. but I'm also quite sure we'll
> all have forgotten about that in a few weeks time.

ok, how about something along these linnes:

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 7e51b6f..5cc4771 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -1,6 +1,14 @@
 #ifndef _DYNAMIC_DEBUG_H
 #define _DYNAMIC_DEBUG_H
 
+/* 
+ * When jump labels are disabled, they make use of atomic_read(). Since
+ * dynamic_debug.h gets included by kernel.h, the inclusion of jump_label.h by
+ * dynamic_debug.h and thus atomic.h (to get atomic_read()), would cause a
+ * circular dependency since atomic.h requires kernel.h. Thus, for dynamic debug
+ * we are explicitly including jump_label.h when jump labels are configured, and
+ * making use of a regular reads (non-atomic), when jump labels are disabled.
+ */  
 #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
 #include <linux/jump_label.h>
 #endif
