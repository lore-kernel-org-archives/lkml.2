Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab0HWXnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 19:43:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752221Ab0HWXnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 19:43:49 -0400
Date: Mon, 23 Aug 2010 16:43:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: hvaibhav@ti.com
Cc: linux-kernel@vger.kernel.org, byron.bbradley@gmail.com,
        linux-omap@vger.kernel.org, felipe.balbi@nokia.com
Subject: Re: [PATCH-V2 3/3] RTC:s35390a: Add update_irq (per Min interrupt)
 support
Message-Id: <20100823164340.562f466f.akpm@linux-foundation.org>
In-Reply-To: <1282393829-7326-4-git-send-email-hvaibhav@ti.com>
References: <hvaibhav@ti.com>
	<1282393829-7326-4-git-send-email-hvaibhav@ti.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Aug 2010 18:00:29 +0530
hvaibhav@ti.com wrote:

> +static int s35390a_update_irq_enable(struct i2c_client *client,
> +						unsigned enabled)
> +{
> +	struct s35390a *s35390a = i2c_get_clientdata(client);
> +	char buf[1];
> +
> +	if (s35390a_get_reg(s35390a, S35390A_CMD_STATUS2, buf, sizeof(buf)) < 0)
> +		return -EIO;
> +
> +	/* This chip returns the bits of each byte in reverse order */
> +	buf[0] = bitrev8(buf[0]);
> +
> +	buf[0] &= ~S35390A_INT1_MODE_MASK;
> +	if (enabled)
> +		buf[0] |= S35390A_INT1_MODE_PMIN_STDY;
> +	else
> +		buf[0] |= S35390A_INT1_MODE_NOINTR;
> +
> +	/* This chip expects the bits of each byte in reverse order */
> +	buf[0] = bitrev8(buf[0]);

grumble.  We bit-reverse it, fiddle a couple of bits and then
bit-reverse it again.  Lazy.

Why not leave it bit-reversed and just bit-reverse the constants? 
Extra marks are awarded for coming up with a compile-time bitrev8() ;)

> +	return s35390a_set_reg(s35390a, S35390A_CMD_STATUS2, buf, sizeof(buf));
> +}
