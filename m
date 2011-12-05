Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab1LEFnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 00:43:16 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51831 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab1LEFnP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 00:43:15 -0500
MIME-Version: 1.0
In-Reply-To: <201112011215.21146.trenn@suse.de>
References: <1322683014-13285-1-git-send-email-jim.cromie@gmail.com>
 <1322683014-13285-20-git-send-email-jim.cromie@gmail.com> <201112011215.21146.trenn@suse.de>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Sun, 4 Dec 2011 22:42:42 -0700
Message-ID: <CAJfuBxzF7ScsQrrh4PYo5p0VQ1h=1EYTyanoVkRmwcwWRFimkw@mail.gmail.com>
Subject: Re: [PATCH 19/25] pnp: if CONFIG_DYNAMIC_DEBUG, use pnp.ddebug
 instead of pnp.debug
To: Thomas Renninger <trenn@suse.de>
Cc: jbaron@redhat.com, greg@kroah.com, joe@perches.com,
        bart.vanassche@gmail.com, linux-kernel@vger.kernel.org,
        bhelgaas@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/1 Thomas Renninger <trenn@suse.de>:
> On Wednesday 30 November 2011 20:56:48 jim.cromie@gmail.com wrote:
>> From: Jim Cromie <jim.cromie@gmail.com>
>>
>> resubmit of https://lkml.org/lkml/2010/9/15/398
>>
>> This allows usage of generic pnp.ddebug debug parameter instead of
>> pnp.debug PNP specific parameter.

> It depends on what you compile in which pnp debug parameter one has to use
> and both are doing more or less the same?
>
> We could add two pnp parameters in !defined(CONFIG_DYNAMIC_DEBUG) case:
>  - deprecate pnp.debug by a message:
>    "pnp.debug deprecated, use pnp.ddebug" instead

Just to be clear, this patch (yours) does this deprecation.

>  - pnp.ddebug doing what pnp.debug is doing currently

FWIW, the patch after this changes the name .ddebug to .dyndbg.

Why is this better than just fixing kernel-parameters to
advise using dyndbg directly, and skipping the indirection ?

With the newer unknown-parameter approach that Jason, Rusty recommended
(now done), it is possible for a module to implement its own .dyndbg option
handler (using __setup only, not with nicer module_param_named() macro,
at least with patch 25 included), but that doesnt seem wise:

modname.dyndbg is a fake option,
it doesnt show up in /sys/module/pnp/parameters/debug.
Adding pnp.dyndbg using __setup would add the sys file, giving an
entirely different interface than the one implemented in
/dbg/dynamic_debug/control.
Explaining this special case sounds difficult to do clearly, a sign of trouble.



> The only misleading would be that pnp.ddebug has nothing to do with
> dynamic debug if not compiled in, but user would have one parameter
> to rely on.
>
> In Documentation/kernel-parameters:
>        pnp.debug       [PNP]
>                        Enable PNP debug messages.  This depends on the
>                        CONFIG_PNP_DEBUG_MESSAGES option.
>
> Would be wrong in defined(CONFIG_DYNAMIC_DEBUG) case with your patch,
> but would always work with:
>        pnp.ddebug
> with my above suggestions.

how about a something like this ?


	pnp.debug=1	[PNP]
			Enable PNP debug messages (depends on the
			CONFIG_PNP_DEBUG_MESSAGES option and
                       !CONFIG_DYNAMIC_DEBUG).   If
CONFIG_DYNAMIC_DEBUG use pnp.dyndbg instead.  ...

This approach doesnt add any new failures;
if ! CONFIG_DYNAMIC_DEBUG,
     pnp.dyndbg will fail/warn just like any.dyndbg would
else
     pnp.debug will warn, yndbg will fail/warn just like any.dyndbg

>
> It's not a big deal and not a perfect solution, just looks a bit confusing
> to have 2 different parameters for the same thing.

I think this is covered adequately by a doc update, and less confusing than
different behavior/usage of 1 parameter under 2 different configs.

>
> Bjorn should have a look and acknowledge or sign the pnp parts off.
>
>    Thomas
>

thanks
Jim
