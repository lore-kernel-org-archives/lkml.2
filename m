Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831Ab1JXO5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 10:57:11 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:48332 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932589Ab1JXO5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 10:57:09 -0400
Message-ID: <4EA57CBF.2050901@xenotime.net>
Date: Mon, 24 Oct 2011 07:57:03 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111001 Thunderbird/7.0.1
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Greg KH <greg@kroah.com>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] module,bug: Add TAINT_OOT_MODULE flag for modules not
 built in-tree
References: <1319461948.31243.31.camel@deadeye>
In-Reply-To: <1319461948.31243.31.camel@deadeye>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/11 06:12, Ben Hutchings wrote:
> Use of the GPL or a compatible licence doesn't necessarily make the code
> any good.  We already consider staging modules to be suspect, and this
> should also be true for out-of-tree modules which may receive very
> little review.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
> Debian has been carrying this for the last few kernel versions.  The
> recent thread '[RFC] virtualbox tainting.' and discussions at KS suggest
> that this might be more generally useful.
> 
> Ben.
> 
>  include/linux/kernel.h |    1 +
>  kernel/module.c        |    5 +++++
>  kernel/panic.c         |    2 ++
>  scripts/mod/modpost.c  |    7 +++++++
>  4 files changed, 15 insertions(+), 0 deletions(-)

Hi,

Please add 'O' to Documentation/oops-tracing.txt.

Thanks.

> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 46ac9a5..2c05967 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -369,6 +369,7 @@ extern enum system_states {
>  #define TAINT_WARN			9
>  #define TAINT_CRAP			10
>  #define TAINT_FIRMWARE_WORKAROUND	11
> +#define TAINT_OOT_MODULE		12
>  
>  extern const char hex_asc[];
>  #define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
> diff --git a/kernel/module.c b/kernel/module.c
> index 04379f92..c0872f1 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2487,6 +2487,9 @@ static int check_modinfo(struct module *mod, struct load_info *info)
>  		return -ENOEXEC;
>  	}
>  
> +	if (!get_modinfo(info, "intree"))
> +		add_taint_module(mod, TAINT_OOT_MODULE);
> +
>  	if (get_modinfo(info, "staging")) {
>  		add_taint_module(mod, TAINT_CRAP);
>  		printk(KERN_WARNING "%s: module is from the staging directory,"
> @@ -3257,6 +3260,8 @@ static char *module_flags(struct module *mod, char *buf)
>  		buf[bx++] = '(';
>  		if (mod->taints & (1 << TAINT_PROPRIETARY_MODULE))
>  			buf[bx++] = 'P';
> +		else if (mod->taints & (1 << TAINT_OOT_MODULE))
> +			buf[bx++] = 'O';
>  		if (mod->taints & (1 << TAINT_FORCED_MODULE))
>  			buf[bx++] = 'F';
>  		if (mod->taints & (1 << TAINT_CRAP))
> diff --git a/kernel/panic.c b/kernel/panic.c
> index d7bb697..b2659360 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -177,6 +177,7 @@ static const struct tnt tnts[] = {
>  	{ TAINT_WARN,			'W', ' ' },
>  	{ TAINT_CRAP,			'C', ' ' },
>  	{ TAINT_FIRMWARE_WORKAROUND,	'I', ' ' },
> +	{ TAINT_OOT_MODULE,		'O', ' ' },
>  };
>  
>  /**
> @@ -194,6 +195,7 @@ static const struct tnt tnts[] = {
>   *  'W' - Taint on warning.
>   *  'C' - modules from drivers/staging are loaded.
>   *  'I' - Working around severe firmware bug.
> + *  'O' - Out-of-tree module has been loaded.
>   *
>   *	The string is overwritten by the next call to print_tainted().
>   */
> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index a509ff8..2bd594e 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -1849,6 +1849,12 @@ static void add_header(struct buffer *b, struct module *mod)
>  	buf_printf(b, "};\n");
>  }
>  
> +static void add_intree_flag(struct buffer *b, int is_intree)
> +{
> +	if (is_intree)
> +		buf_printf(b, "\nMODULE_INFO(intree, \"Y\");\n");
> +}
> +
>  static void add_staging_flag(struct buffer *b, const char *name)
>  {
>  	static const char *staging_dir = "drivers/staging";
> @@ -2169,6 +2175,7 @@ int main(int argc, char **argv)
>  		buf.pos = 0;
>  
>  		add_header(&buf, mod);
> +		add_intree_flag(&buf, !external_module);
>  		add_staging_flag(&buf, mod->name);
>  		err |= add_versions(&buf, mod);
>  		add_depends(&buf, mod, modules);


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
