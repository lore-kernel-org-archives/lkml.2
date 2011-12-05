Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab1LETQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:16:21 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47065 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab1LETQU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:16:20 -0500
MIME-Version: 1.0
In-Reply-To: <201112051547.43298.trenn@suse.de>
References: <1322683014-13285-1-git-send-email-jim.cromie@gmail.com>
 <201112011215.21146.trenn@suse.de> <CAJfuBxzF7ScsQrrh4PYo5p0VQ1h=1EYTyanoVkRmwcwWRFimkw@mail.gmail.com>
 <201112051547.43298.trenn@suse.de>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Mon, 5 Dec 2011 12:15:48 -0700
Message-ID: <CAJfuBxzqCboEOdP5EtY1XwOffn8AtGEzhtHFBvA5cpT4YSL=nw@mail.gmail.com>
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

On Mon, Dec 5, 2011 at 7:47 AM, Thomas Renninger <trenn@suse.de> wrote:
> On Monday, December 05, 2011 06:42:42 AM Jim Cromie wrote:
>> 2011/12/1 Thomas Renninger <trenn@suse.de>:
>> > On Wednesday 30 November 2011 20:56:48 jim.cromie@gmail.com wrote:
>> >> From: Jim Cromie <jim.cromie@gmail.com>
>> >>
>> >> resubmit of https://lkml.org/lkml/2010/9/15/398
>> >>
>> >> This allows usage of generic pnp.ddebug debug parameter instead of
>> >> pnp.debug PNP specific parameter.
>>
>> > It depends on what you compile in which pnp debug parameter one has to use
>> > and both are doing more or less the same?
>> >
>> > We could add two pnp parameters in !defined(CONFIG_DYNAMIC_DEBUG) case:
>> >  - deprecate pnp.debug by a message:
>> >    "pnp.debug deprecated, use pnp.ddebug" instead
>>
>> Just to be clear, this patch (yours) does this deprecation.
>>
>> >  - pnp.ddebug doing what pnp.debug is doing currently
>>
>> FWIW, the patch after this changes the name .ddebug to .dyndbg.
>>
>> Why is this better than just fixing kernel-parameters to
>> advise using dyndbg directly, and skipping the indirection ?
> With this patch you'd have pnp.debug and pnp.dyndbg essentially doing
> the same (from what I can see),
> but you'd either have to use the one or the other, depending
> on what is compiled in.
>
> It's not a big deal, but imo it would be nice to have one pnp debug
> option which would always work.
>
> This could look like this (not even compile tested):
>
> #if !defined(CONFIG_DYNAMIC_DEBUG)
> static int __init pnp_debug_setup(char *__unused)
> {
>     pnp_debug = 1;
> }
> __setup("pnp.dyndbg", pnp_debug_setup);
>
> static int __init pnp_old_debug_setup(char *__unused)
> {
>     printk(KERN_INFO "pnp.debug is deprecated, use pnp.dyndbg instead\n");
> }
> __setup("pnp.debug", pnp_old_debug_setup);
> #endif
>
>
> As said, not a big deal. Maybe nicer, not sure.

I agree with this size assessment :-)

However, you trimmed my argument against your approach;

$modname.dyndbg is generally fake, __setup("pnp.dyndbg"...) is not.
This makes a completely different control interface for 2 kinds of builds.

echo $setting > /sys/modules/pnp/parameters/dyndbg
vs
echo "module pnp +/-p" > /dbg/dynamic/control

its certainly possible to translate $setting into
ddebug_exec_query( (setting ? "+p" : "-p"), "pnp");
but this still leaves the issue of the different interface,
hidden below the skin-deep appearance of a single parameter.
It also doesnt address what this means:
echo "-pmf" > /sys/modules/pnp/parameters/dyndbg
I think its a rabbit-hole of special cases, which we shouldnt go down.

Summarizing, I think the choices are:

1- 2 different module-options for yes/no CONFIG_DYNAMIC_DEBUG builds
2- 1 module-option with 2 different interfaces
3- deeper but still imperfect translations of 1 to other.

Ive coded 1, and will submit it shortly,
but am willing to reconsider, or to just follow marching orders.

>
>    Thomas

thanks
Jim
