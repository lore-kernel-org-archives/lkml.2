Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab2IMG4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 02:56:20 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46700 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab2IMG4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 02:56:18 -0400
Date: Wed, 12 Sep 2012 23:56:13 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 05/20] Input: Send events one packet at a time
Message-ID: <20120913065613.GG17105@core.coreip.homeip.net>
References: <1346528835-363-1-git-send-email-rydberg@euromail.se>
 <1346528835-363-6-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346528835-363-6-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 01, 2012 at 09:47:00PM +0200, Henrik Rydberg wrote:
> On heavy event loads, such as a multitouch driver, the irqsoff latency
> can be as high as 250 us.  By accumulating a frame worth of data
> before passing it on, the latency can be dramatically reduced.  As a
> side effect, the special EV_SYN handling can be removed, since the
> frame is now atomic.
> 
> This patch adds the events() handler callback and uses it if it
> exists. The latency is improved by 50 us even without the callback.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/input/input.c | 176 +++++++++++++++++++++++++++++++++++---------------
>  include/linux/input.h |  24 ++++++-
>  2 files changed, 144 insertions(+), 56 deletions(-)
> 
> diff --git a/drivers/input/input.c b/drivers/input/input.c
> index a57c4a5..5b66b2f 100644
> --- a/drivers/input/input.c
> +++ b/drivers/input/input.c
> @@ -47,6 +47,8 @@ static DEFINE_MUTEX(input_mutex);
>  
>  static struct input_handler *input_table[8];
>  
> +static const struct input_value input_value_sync = { EV_SYN, SYN_REPORT, 1 };
> +
>  static inline int is_event_supported(unsigned int code,
>  				     unsigned long *bm, unsigned int max)
>  {
> @@ -90,46 +92,81 @@ static void input_stop_autorepeat(struct input_dev *dev)
>   * filtered out, through all open handles. This function is called with
>   * dev->event_lock held and interrupts disabled.
>   */
> -static void input_pass_event(struct input_dev *dev,
> -			     unsigned int type, unsigned int code, int value)
> +static unsigned int input_to_handler(struct input_handle *handle,
> +			struct input_value *vals, unsigned int count)
>  {
> -	struct input_handler *handler;
> -	struct input_handle *handle;
> +	struct input_handler *handler = handle->handler;
> +	struct input_value *end = vals;
> +	struct input_value *v;
>  
> -	rcu_read_lock();
> +	for (v = vals; v != vals + count; v++) {
> +		if (handler->filter &&
> +		    handler->filter(handle, v->type, v->code, v->value))
> +			continue;
> +		if (end != v)
> +			*end = *v;
> +		end++;
> +	}
>  
> -	handle = rcu_dereference(dev->grab);
> -	if (handle)
> -		handle->handler->event(handle, type, code, value);
> -	else {
> -		bool filtered = false;
> +	count = end - vals;
> +	if (!count)
> +		return 0;
>  
> -		list_for_each_entry_rcu(handle, &dev->h_list, d_node) {
> -			if (!handle->open)
> -				continue;
> +	if (handler->events)
> +		handler->events(handle, vals, count);
> +	else
> +		for (v = vals; v != end; v++)
> +			handler->event(handle, v->type, v->code, v->value);

Filter handlers do not typically have ->event() methods, that's the
reason for reported panic.

Thanks.

-- 
Dmitry
