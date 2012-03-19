Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964945Ab2CSGSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 02:18:07 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42090 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab2CSGSB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 02:18:01 -0400
MIME-Version: 1.0
In-Reply-To: <87aa3dxs6m.fsf@rustcorp.com.au>
References: <1331766126-11674-1-git-send-email-jim.cromie@gmail.com> <87aa3dxs6m.fsf@rustcorp.com.au>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Mon, 19 Mar 2012 00:17:29 -0600
Message-ID: <CAJfuBxxPY_25P70qzmEw0JgoxyCpKDuzB1vKsJR6R-GxS+NGCA@mail.gmail.com>
Subject: Re: [00/11] pr_debug during module initialization
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org,
        Thomas Renninger <trenn@suse.de>, pawel.moll@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2012 at 8:04 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Wed, 14 Mar 2012 17:01:55 -0600, jim.cromie@gmail.com wrote:
>>
>> This is 3rd revision of the dyndbg modinit patches, previously sent
>> Dec 11.  Patches 1-17/25 sent then were added to driver-core-next,
>> this set reworks the remainder.
>>
>> It implements the "fake" module param approach proposed by
>> Thomas Renninger, back in https://lkml.org/lkml/2010/9/15/397
>>
>> This set is on top of linux-next, since that includes Pawel Moll's
>> initcall-level params patch.  Im not using this feature, but I didnt
>> know that when I started.
>>
>> Rusty Russell did a partial review of 2nd rev (sent off-list), here:
>> http://thread.gmane.org/gmane.linux.kernel/1262934
>> This revision incorporates my understanding of his feedback.
>
> The module parts seem fine.  The re-parsing of the commandline seems
> weird:  I'd really rather see something in unknown_bootoption(), like:
>
>        /* Unused module parameter. */
>        if (strchr(param, '.') && (!val || strchr(param, '.') < val)) {
> +               /* Check for <module>.dyndebug fake param */
> +               dyndebug_parse(param, val);
>                return 0;
>        }
>
> (Note that param will be the whole line here, eg "foo.dyndebug=+p", with
>  val pointing just past the "=" (if any)).
>
> Of course, that means the parsing happens at that "parse_args("Booting
> kernel"...)" point in init/main.c, which may not suit.
>

That is too early - the dyndbg rules cant be activated
until dynamic_debug_init() runs, which is currently an
arch_initcall(dynamic_debug_init);

Patch 11 makes it core-initcall, (which Im not sure is ok
for all cases, but works for me), I also tried it with
early_initcall (and that worked too)
but I think thats still after the Booting kernel parse.

I *could* capture the dyndbg options during Booting kernel
parse, and activate them once the tables are loaded,
but this seems convoluted.

Thomas' original approach (iirc, Id have to dig for the patches)
was to reuse parse_one after filtering for dyndbg params in
a "private" parse-args. After your earlier suggestion to use a
callback, it occurred to me that just reusing parse_args would
work, be fairly minimal (only 2 lines in dynamic_debug_init())
and its already called a bunch of times; Booting kernel,
module-load, and do-initcall-level (in Pawel's patch).
Pawels patch doesnt do anything to avoid reparsing
boot-time params.

Does this change your weirdness assessment ?

BTW, I think I can now drop ddebug_setup_string, ddebug_setup_query,
and __setup("ddebug_query="...)



Lastly, my earlier rev handled  foo.dyndbg params
for loadable modules.  I took that out cuz
Documentation/kernel-parameters.txt says thats
for builtins (only, as I read it), and treating foo.dyndbg
differently should be done w/o discussion.

Is there a reason why foo.knownparam=val is not handled ?
When I had it in, it was processed before modprobe args
IIRC, it was /etc/modprobe.d/*, foo.dyndbg in boot-args,
then modprobe args, which seemed correct - it let each override the
previous settings.


> Otherwise, all looks good!
>
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>

thanks.  I guess the Ack (vs SOB) means that Jason should
forward it on to Greg as a single set ?
(subject to his Ack of course)

>
> Cheers,
> Rusty.
> --
>  How could I marry someone with more hair than me?  http://baldalex.org
