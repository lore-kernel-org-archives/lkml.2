Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab2HQVjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 17:39:54 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35409 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab2HQVjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 17:39:46 -0400
Message-ID: <502EBA1E.2030807@suse.cz>
Date: Fri, 17 Aug 2012 23:39:42 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120731 Thunderbird/15.0
MIME-Version: 1.0
To: mathieu.poirier@linaro.org
CC: linux-kernel@vger.kernel.org, arve@android.com, kernel-team@android.com,
        dmitry.torokhov@gmail.com, john.stultz@linaro.org
Subject: Re: [PATCH] [RFC]: drivers/tty: Folding Android's keyreset driver
 in sysRQ
References: <1345154810-1509-1-git-send-email-mathieu.poirier@linaro.org>
In-Reply-To: <1345154810-1509-1-git-send-email-mathieu.poirier@linaro.org>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2012 12:06 AM, mathieu.poirier@linaro.org wrote:
> +static int do_keyreset_event(struct sysrq_state *state,
> +					 unsigned int code, int value)
> +{
> +	int ret;
> +	int processed = 0;
> +
> +	/* Is the code is of interestest to us */
> +	if (!test_bit(code, state->keybit))
> +		return processed;
> +
> +	/* No need to take care of key up events */
> +	if (!test_bit(code, state->key) == !value)
> +		return processed;
> +
> +	/* Record new entry */
> +	__change_bit(code, state->key);

Hmm, this function is not atomic. Can do_keyreset_event be called
simultaneously from different CPUs? I suppose not...

> +	if (value && !state->restart_disabled &&
> +			state->key_down_ctn == state->key_down_target) {
> +		state->restart_disabled = 1;
> +		if (atomic_read(&restart_requested))
> +			panic(KERN_ERR "keyboard reset failed, %d - panic\n",
> +					 atomic_read(&restart_requested));

panic() does not take KERN_* prefixes.

regards,
-- 
js
suse labs
