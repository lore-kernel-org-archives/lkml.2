Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab0LPMxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 07:53:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50352 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753875Ab0LPMxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 07:53:13 -0500
Date: Thu, 16 Dec 2010 12:24:28 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Brandon Leong <bleong@codeaurora.org>
Cc: lrg@slimlogic.co.uk, dwalker@codeaurora.org, davidb@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] regulator: debugfs: Adding debugfs functions into
 regulator framework
Message-ID: <20101216122428.GA19211@rakim.wolfsonmicro.main>
References: <1292464145-14204-1-git-send-email-bleong@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292464145-14204-1-git-send-email-bleong@codeaurora.org>
X-Cookie: VMS must die!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 05:49:05PM -0800, Brandon Leong wrote:

I just noticed that you only posted this to the MSM kernel list -
please always post generic patches to the relevant generic list, lkml in
this case.  I've CCed lkml.

> Allow the user to read and edit regulator information in user space
> through the debugfs file system.

> Signed-off-by: Brandon Leong <bleong@codeaurora.org>
> ---
> Dynamic allocation of buffer added for debugfs.
> Cleaned up error messages and stylistic errors.
> Clean-up function created.

Quoting my reply to your previous version:

| Basically what you're doing here is providing a default consumer via
| debugfs along with the consumers that have been defined by the board.
| On the one hand it's good that this means that we won't let the user
| change anything unless it has been explicitly enabled, on the other hand
| it means that we've not really added anything that you can't do already
| with the virtual consumer except made it slightly more convenient to set
| up and give it a different interface.

| This makes me a bit nervous, especially given that the regulator API is
| mostly used in embedded systems where things like debugfs not being a
| production API don't entirely count for much.  It feels like it
| encourages people to write random userspace code which prods and pokes
| at the regulators directly without any form of mediation and without
| suggesting that perhaps they ought to be doing something a bit nicer.

| I can see some useful debug facilities we could add using debugfs.  For
| example, it'd be good to expose more of the dynamic structures the API
| has like the consumers, their reference counts and the voltages they
| have requested.  Showing the voltage lists could also be nice.  This is
| all peering inside the API to provide additional insight to the user,
| though, rather than something layered on top of the API as this is.

| If we do want to go this way it'd be good to have more discussion in the
| changelog about what we're adding here, what it gives us, how it should
| be used and how it compares with the existing approaches.  Given the
| similarities with the virtual consumer I am inclined to wonder why we'd
| want to reimplement the actual user visible API bit.

Please engage with the above - it feels rather like you've ignoring it.
I'm not completely against a debugfs interface but we do need to
consider how this fits in with both the existing debug facilities and
the need to avoid having random userspace code just going in and
fiddling with stuff directly.

Some more specific comments on the code, but please don't post any
updated patches without discussing the above:

>   *
>   */
>  
> +#define pr_fmt(fmt) "%s: " fmt, __func__
> +

Hrm?  If this is needed we shouldn't be adding it in the regulator API
with a name like that, and we probably ought to be doing something with
the rdev_ variants.

> +#ifdef CONFIG_DEBUG_FS
> +
> +#define INIT_DEBUG_BUF_SIZE 20
> +
> +/* debug_buf_resize: dynamically resizes debug_buffer as needed */
> +static char *debug_buf_resize(struct regulator_debug *reg_debug, int bufsize)
> +{
> +	if (bufsize <= reg_debug->debug_buffer_len)
> +		return reg_debug->debug_buffer;
> +
> +	kfree(reg_debug->debug_buffer);
> +
> +	reg_debug->debug_buffer = kmalloc(bufsize, GFP_KERNEL);
> +	reg_debug->debug_buffer_len = bufsize;
> +
> +	return reg_debug->debug_buffer;
> +}

This seems more trouble than it's worth - why not just allocate and free
the buffer as needed?  If we're doing enough of this for it to be worth
avoding the allocations it seems we're doing something wrong.

> +static int reg_debug_enable_set(void *data, u64 val)
> +{
> +	int err_info = 0;
> +	struct regulator_debug *reg_debug = data;
> +
> +	BUG_ON(data == NULL);
> +
> +	if (val && !(reg_debug->enabled))
> +		err_info = regulator_enable(reg_debug->reg);
> +	else if (!val && (reg_debug->enabled))
> +		err_info = regulator_disable(reg_debug->reg);
> +	else if (val && (reg_debug->enabled))
> +		pr_err("regulator_enable has already been called for this regulator\n");
> +	else
> +		pr_err("regulator_disable has already been called for this regulator\n");

This feels like an awkward halfway house between a debug facility and a
proper consumer - it interacts with the refcounting real consumers do
but tries to work directly with the actual hardware state.  You end up
not being able to do multiple enables if you want to but with disable
only decremeting the refcount so possibly needing to be iterated
multiple times.

Either this should be a real consumer and make sure it balances its own
enables and disables or it should be a diagnostic facility for the
reference counts and the hardware state should be reported separately.
This all ties in with the overall comments at the top...

> +	/* check that user entered two integers */
> +	if (filled < 2 || min < 0 || max < min) {
> +		pr_info("Error, correct format: 'echo \"min max\" > voltage\n");
> +		return -ENOMEM;
> +	} else
> +		err_info = regulator_set_voltage(reg_debug->reg, min, max);

It'd be more friendly to accept a single voltage and DTRT with it as
well.

> +static int reg_debug_mode_set(void *data, u64 val)
> +{
> +	int err_info;
> +	struct regulator_debug *reg_debug = data;
> +
> +	BUG_ON(data == NULL);
> +
> +	err_info = regulator_set_mode(reg_debug->reg, (unsigned int)val);
> +
> +	if (err_info < 0)
> +		pr_err("regulator_set_mode returned error: %d\n", err_info);

Taking strings would be much nicer here, and...

> +static int reg_debug_mode_get(void *data, u64 *val)
> +{
> +	int err_info;
> +	struct regulator_debug *reg_debug = data;
> +
> +	BUG_ON(data == NULL);
> +
> +	err_info = regulator_get_mode(reg_debug->reg);
> +
> +	if (err_info < 0) {
> +		pr_err("Regulator_get_mode returned error: %d\n", err_info);
> +	} else {
> +		*val = err_info;

...displaying them here also.  Even more friendly would be showing the
set of available modes.

> +/**
> + * regulator_debug_create_directory - Creates debugfs directories and files
> + *					for each regulator

This doesn't need kerneldoc, it's not an exported API so shouldn't end
up in the generated documentation (so no /** only /* at the start of the
comment).

> +       if (reg_ops->get_voltage)
> +               mode |= S_IRUGO;
> +       if (reg_ops->set_voltage)
> +               mode |= S_IWUSR;

This needs refreshing against -next at a minimum.
