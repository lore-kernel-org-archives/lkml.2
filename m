Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab1KUOo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 09:44:58 -0500
Received: from service87.mimecast.com ([91.220.42.44]:49024 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab1KUOo4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 09:44:56 -0500
Subject: Re: [PATCH] virtio-mmio: Devices parameter parsing
From: Pawel Moll <pawel.moll@arm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>
In-Reply-To: <87vcqe9ml9.fsf@rustcorp.com.au>
References: <1321365185-2928-1-git-send-email-pawel.moll@arm.com>
	 <87sjlooq3m.fsf@rustcorp.com.au>
	 <1321467222.3137.417.camel@hornet.cambridge.arm.com>
	 <87vcqe9ml9.fsf@rustcorp.com.au>
Date: Mon, 21 Nov 2011 14:44:48 +0000
Message-ID: <1321886688.3093.248.camel@hornet.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 21 Nov 2011 14:44:48.0852 (UTC) FILETIME=[1E77B140:01CCA85C]
X-MC-Unique: 111112114445213901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 03:32 +0000, Rusty Russell wrote:
> No it's not; I didn't bother when I converted things across, and it
> shows.  

546970bc (Rusty Russell   2010-08-11 23:04:20 -0600 133) #define module_param_cb

Now I understand... :-)

> But we expect virtio hackers to be smarter than average :)

Hope I'll stand up to the challenge ;-)

> > there would be a clash. So I wanted to add a "first_id" parameter, but
<...>
> Well, tell them to get the cmdline order right, or allow an explicit
> device id in the commandline.

Yeah, I've came up with the same idea last night:

	<size>[KMG]@<base>:<irq>[:<id>]

<id>, if specified, sets the id for the current device and a base for
the next one.

> Since I hope we're going to be coding together more often, I've written
> this how I would have done it (based loosely on your version) to
> compare.

Thanks, your efforts are truly appreciated!

> Main changes other than the obvious:
> 1) Documentation in kernel-parameters.txt

I was considering this previously but for some reason I thought
kernel-parameters.txt wasn't a place for module parameters at all. Now I
had another look and see I was wrong.

> 2) Doesn't leak mem on error paths.

Em, I don't think my code was leaking memory in any error case? (no
offence meant or taken ;-)

> 3) Handles error from platform_device_register_resndata().

As my code was ignoring wrong descriptions (all the continues) I ignored
this result as well (the implementation complains on its own anyway),
but I get your point.

> 4) Uses shorter names for static functions/variables.

Ah, I get the hint :-) I'm trying to keep the naming convention in
static symbols as well, as it makes cscope/ctags/grep usage easier...
I'll just use the abbreviated "vm_" prefixes then.

> See what you think...

Funnily enough when I proposed some string parser few years ago (totally
different story) I was flamed for using strchr() instead of strsep() ;-)
But ok, I don't mind getting back to basics.

> +static int set_cmdline_device(const char *device, const struct kernel_param *kp)
[...]
> +       delim = strchr(device, '@');
[...]
> +	*delim = '\0';

Ah. I forgot that strchr() takes const char * but returns "non-const"
char *... Cheating, that's what it is ;-), but will work. Probably what
we really want is something like
	kstrtoull_delim(device, 0, &val, "@\0")
I'll have a look and may try to propose something of that sort, but
that's another story. Maybe I should just use simple_strtol() for the
time being?

I'll post v3 tonight or tomorrow.

Cheers!

Paweł


