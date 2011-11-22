Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723Ab1KVBAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 20:00:01 -0500
Received: from ozlabs.org ([203.10.76.45]:51829 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757666Ab1KVA74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 19:59:56 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pawel Moll <pawel.moll@arm.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization\@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH] virtio-mmio: Devices parameter parsing
In-Reply-To: <1321886688.3093.248.camel@hornet.cambridge.arm.com>
References: <1321365185-2928-1-git-send-email-pawel.moll@arm.com> <87sjlooq3m.fsf@rustcorp.com.au> <1321467222.3137.417.camel@hornet.cambridge.arm.com> <87vcqe9ml9.fsf@rustcorp.com.au> <1321886688.3093.248.camel@hornet.cambridge.arm.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 22 Nov 2011 11:14:18 +1030
Message-ID: <87ipmdx9y5.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Nov 2011 14:44:48 +0000, Pawel Moll <pawel.moll@arm.com> wrote:
> On Mon, 2011-11-21 at 03:32 +0000, Rusty Russell wrote:
> > 2) Doesn't leak mem on error paths.
> 
> Em, I don't think my code was leaking memory in any error case? (no
> offence meant or taken ;-)

You're right, I'm wrong.  In your original version, your innovative use
of free() then strdup() worked as intended.

> > 3) Handles error from platform_device_register_resndata().
> 
> As my code was ignoring wrong descriptions (all the continues) I ignored
> this result as well (the implementation complains on its own anyway),
> but I get your point.

I was referring to this:

	  return platform_device_register_resndata(&virtio_mmio_cmdline_parent,
			  "virtio-mmio", virtio_mmio_cmdline_id++,
			  resources, ARRAY_SIZE(resources), NULL, 0) != NULL;

The set function returns 0 or a -ve errno, not true/false.

> > 4) Uses shorter names for static functions/variables.
> 
> Ah, I get the hint :-) I'm trying to keep the naming convention in
> static symbols as well, as it makes cscope/ctags/grep usage easier...
> I'll just use the abbreviated "vm_" prefixes then.
> 
> > See what you think...
> 
> Funnily enough when I proposed some string parser few years ago (totally
> different story) I was flamed for using strchr() instead of strsep() ;-)
> But ok, I don't mind getting back to basics.
> 
> > +static int set_cmdline_device(const char *device, const struct kernel_param *kp)
> [...]
> > +       delim = strchr(device, '@');
> [...]
> > +	*delim = '\0';
> 
> Ah. I forgot that strchr() takes const char * but returns "non-const"
> char *... Cheating, that's what it is ;-), but will work. Probably what
> we really want is something like
> 	kstrtoull_delim(device, 0, &val, "@\0")
> I'll have a look and may try to propose something of that sort, but
> that's another story. Maybe I should just use simple_strtol() for the
> time being?

Or would it be simpler to enhance sscanf() with some weird format option
for suffixing?  I haven't looked for similar cases, but I'd suspect a
big win in general.

This would be neater than anything else we've got:
        if (sscanf(device, "%llu@%llu[KMG]:%u", ...) != 3
            && sscanf(device, "%llu@%llu[KMG]:%u:%u", ...) != 4)
                return -EINVAL;

Cheers,
Rusty.
