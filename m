Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab1D2PPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:15:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552Ab1D2PPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:15:17 -0400
Date: Fri, 29 Apr 2011 11:15:09 -0400
From: Jason Baron <jbaron@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: rostedt@goodmis.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jump_label,x86: use text_poke_smp_batch for entries
 update
Message-ID: <20110429151509.GA2545@redhat.com>
References: <1304023961-12741-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304023961-12741-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 10:52:41PM +0200, Jiri Olsa wrote:
> Changing the jump label update code to use batch processing
> for x86 architectures. 
> 
> Currently each jump label update calls text_poke_smp for each
> jump label key entry. Thus one key update ends up calling stop
> machine multiple times.
> 

cool. Batching the updates is a nice idea.

> This patch is using text_poke_smp_batch, which is called for
> all the key's entries.  Ensuring the stop machine is called
> only once.
> 

Since we walk the modules list per key (calling __jump_label_update()),
this is not always the case. I'm wondering then if maybe what we want to do
is 'queue' each update from the core code. Then, when the queue fills
up, we flush out the queue. In this way, we cover jump labels that might
be in both the core kernel and in modules. This also has the side effect
of moving code such as:

/*
 * The entry->code set to 0 invalidates module
 * init text
 * sections (see
 * jump_label_invalidate_module_init).
 */
if (!entry->code || !kernel_text_address(entry->code))
              continue;


out of the arch code into the generic code, which in my opinion is a bit
cleaner. thoughts?

Thanks,

-Jason
