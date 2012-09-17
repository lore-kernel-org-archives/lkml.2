Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab2IQLgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 07:36:09 -0400
Received: from ozlabs.org ([203.10.76.45]:33407 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755889Ab2IQLgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 07:36:06 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: LKML <linux-kernel@vger.kernel.org>, Jon Masters <jonathan@jonmasters.org>,
        linux-modules <linux-modules@vger.kernel.org>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>
Subject: Re: [PATCH 2/2] module: wait when loading a module which is currently initializing.
In-Reply-To: <CAMOw1v6Qy1wHhRcPQkyhDe7LrGaM_qRdhufr8YtHnfp5pTPFAA@mail.gmail.com>
References: <87obl9rsg2.fsf@rustcorp.com.au> <87ligdrscn.fsf@rustcorp.com.au> <CAMOw1v6Qy1wHhRcPQkyhDe7LrGaM_qRdhufr8YtHnfp5pTPFAA@mail.gmail.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 17 Sep 2012 14:06:16 +0930
Message-ID: <878vc9s1tr.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucas De Marchi <lucas.demarchi@profusion.mobi> writes:
>> -       if (find_module(mod->name)) {
>> +       if ((old = find_module(mod->name)) != NULL) {
>> +               if (old->state == MODULE_STATE_COMING) {
>> +                       /* Wait in case it fails to load. */
>> +                       mutex_unlock(&module_mutex);
>> +                       err = wait_event_interruptible(module_wq,
>> +                                              finished_loading(mod->name));
>> +                       if (err)
>> +                               goto free_arch_cleanup;
>> +                       goto again;
>
> I wonder if we should indeed retry in case the module failed to load
> or if we should just skip straight to returning the error code. We
> don't have the return code for the failed load, but maybe we can
> fabricate one here.
>
> Thoughts?

Could have different cmdline parameters, or other randomness like
out-of-memory.  I think this is safest.

Cheers,
Rusty.
