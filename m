Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031662Ab2CGAsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 19:48:43 -0500
Received: from ozlabs.org ([203.10.76.45]:54867 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932719Ab2CGAsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 19:48:42 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jason Baron <jbaron@redhat.com>, Thomas Renninger <trenn@suse.de>
Cc: Jim Cromie <jim.cromie@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/25] dynamic_debug: Introduce global fake module param module.ddebug
In-Reply-To: <20120306144754.GA2421@redhat.com>
References: <1322683014-13285-1-git-send-email-jim.cromie@gmail.com> <201203051614.29457.trenn@suse.de> <CAJfuBxw=kL5j2VNxXLqiY3ftY3n7MQnY5SkfB09Nscyw8Fh9Zw@mail.gmail.com> <201203061002.57810.trenn@suse.de> <20120306144754.GA2421@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 07 Mar 2012 11:00:56 +1030
Message-ID: <87eht5xnen.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2012 09:47:54 -0500, Jason Baron <jbaron@redhat.com> wrote:
> On Tue, Mar 06, 2012 at 10:02:56AM +0100, Thomas Renninger wrote:
> > On Monday, March 05, 2012 06:22:06 PM Jim Cromie wrote:
> > > 2012/3/5 Thomas Renninger <trenn@suse.de>:
> > ...
> > > I have reworked 18-25 on top of linux-next, and have been
> > > casually boot testing it on my i586 based soekris, also for
> > > several weeks.
> > > 
> > > I have some misgivings about trivial things I added to params.c
> > > (primarily pr-debugs in init-level), and about a few other details,
> > > but I guess I should just write up an explanation and send it out.
> > Seeing the stuff in linux-next soon would be great.

Agreed.  OK, here's a partial review.

Patch 1: init: add a pr_info, pr_debug to initcall-levels
> add a pr_info to print current level of initcall,
> add a pr_debug and a counter to initcall_level() to indicate

Meh.  We have an initcall_debug flag.  Let's use it please.

Patch 2: params: add a pr-debug to parse_one's min/max level

No, this is a great deal of spew for little purpose.

Patch 3: params: parse_one's pr_debug("They are equal! ...") isnt informative

Actually, callback address is informative, since it's kernel devs who
are debugging this.  But as they can add it, we should just drop this
patch, or remove the line altogether.

[PATCH 04/15] params: add 3rd arg to option handler callback

This is fine, I'll take this as is.

[PATCH 05/15] dynamic_debug: make dynamic-debug work during module initialization:

> +static inline int ddebug_dyndbg_param_cb(char *param, char *val,
> +					const char *modname)
> +{
> +	if (strstr(param, "dyndbg"))
> +		pr_warn("dyndbg supported only in "
> +			"CONFIG_DYNAMIC_DEBUG builds\n");
> +	return 0; /* allow unknown options */
> +}

No, this breaks unknown module params!  Please split into two callbacks:

        check_for_dyndebug()

        check_for_module_dyndebug()

The latter may be in module.c and call a common helper, depends how neat it
is.

> +	char *param, *modname;
> +
> +	param = strstr(fqparam, "dyndbg");
> +	if (!param) {
> +		pr_debug("%s: skip %s\n", doing, fqparam);
> +		return 0; /* param is unknown, ignore it (for boot) */
> +	}
> +	if (param > fqparam) {
> +		/* fqparam has module prefix, split it in 2 */
> +		*(param-1) = '\0';
> +		modname = fqparam;
> +	}
> +	else
> +		modname = doing;
> +
> +	if (verbose)
> +		pr_info("module: %s %s=\"%s\"\n", modname, param, val);
> +
> +	ddebug_exec_queries(val ? val : "+p");
> +	return 0; /* query failure shouldnt stop module load */

Please don't hack-parse, this accepts all kinds of invalid crap.

Your wildcard patch is even worse.  A sane option is:

        "dyndbg[=...]" on boot line turns dyndbg for everything.
        "<modname>.dyndbg[=...]" on boot line turns on dyndbg for
        that module.
        "dyndbg[=...]" on module line turns dyndbg for that module.

Something like:
        const char *modname = NULL;
        char *sep;
       
        sep = strchr(fqparam, '.');
        if (sep) {
                *sep = '\0';
                modname = fqparam;
                fqparam = sep + 1;
        }

        ...

[PATCH 07/15] dynamic_debug: add modname arg to exec_query callchain

This looks sane.

[PATCH 08/15] dynamic_debug: allow *.dyndbg=+p in boot args

No, just make it "dyndbg=+p", as above.

[PATCH 09/15] dynamic_debug: protect "dyndbg" fake module param name at compile-time

BUILD_BUG_DECL is redundant, you should use BUILD_BUG_ZERO.  But that
insists on a constant expression, so you'd need a new variant.  Probably
easiest to drop this one.  If someone calls their parameter dyndbg they
probably mean exactly what they say.

[PATCH 11/15] dyndbg: init at core level, not arch

Please say why.

[PATCH 14/15] dyndbg: replace if (verbose) pr_info with macro vpr_info

>  #define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
> +#define vpr_info(fmt, ...) if (verbose) { pr_info(fmt, ##__VA_ARGS__); }

This is a bear trap waiting to happen.  Please do { } while(0) wrap!

Thanks,
Rusty.
-- 
  How could I marry someone with more hair than me?  http://baldalex.org
