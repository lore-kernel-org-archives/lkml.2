Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab1FASCG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 14:02:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46124 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab1FASCD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 14:02:03 -0400
MIME-Version: 1.0
X-Originating-IP: [212.159.75.221]
In-Reply-To: <20110601144313.GA9695@redhat.com>
References: <20110513203448.GA3523@gandalf>
	<20110516172513.GA2546@tuxdriver.com>
	<BANLkTi=JU2VkyArY4jrt1iE-sdwKp+JaAQ@mail.gmail.com>
	<20110601144313.GA9695@redhat.com>
Date: Wed, 1 Jun 2011 19:02:02 +0100
Message-ID: <BANLkTi=pmOMFqX+h9sRQ_NDeC7EVMB665Q@mail.gmail.com>
Subject: Re: BUG: scheduling while atomic 2.6.39-rc7 (iwl3945_irq_tasklet)
From: James Hogan <james@albanarts.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 June 2011 15:43, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Tue, May 17, 2011 at 09:41:42AM +0100, James Hogan wrote:
>> On 16 May 2011 18:25, John W. Linville <linville@tuxdriver.com> wrote:
>> > On Fri, May 13, 2011 at 09:34:49PM +0100, James Hogan wrote:
>> >> On 2.6.39-rc7 I've seen a panic due to "BUG: scheduling while atomic"
>> >> with the backtrace below (not much detail as it was written in a text
>> >> message while it was displayed on the screen!). All worked fine in
>> >> 2.6.38.
>> >>
>> >> This was soon after resuming from suspend (enough time to unlock the
>> >> screen, but not much else). I think it was the same bug I saw in rc2 but
>> >> didn't have time to track down. I can probably get it to happen again if
>> >> more detail is needed. It doesn't happen every suspend (I think it had
>> >> survived a couple of suspend/resume cycles at this point).
>> >>
>> >> I could bisect if necessary, but hopefully the backtrace will be enough
>> >> to see what's going on?
>> >
>> > A bisect might be very helpful -- time is short for 2.6.39 already.
>>
>> Hmm, it won't reproduce. I'll have to try and bisect this evening, as
>> it was in my home network that it hit the BUG before.
>
> We use mutex in atomic contex when changing channel. I'm not sure if
> this is the particular problem you have. If you found a way to
> reproduce, you may try this patch:

Thanks, I haven't managed to reproduce the problem at all
unfortunately so cannot bisect it (although I have had several failed
suspends, where it just boots up again from scratch instead of
resuming).

I'll try the patch when i get a chance

Cheers
James

>
> diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
> index 42df832..01244b2 100644
> --- a/drivers/net/wireless/iwlegacy/iwl-core.c
> +++ b/drivers/net/wireless/iwlegacy/iwl-core.c
> @@ -861,9 +861,7 @@ void iwl_legacy_chswitch_done(struct iwl_priv *priv, bool is_success)
>
>        if (priv->switch_rxon.switch_in_progress) {
>                ieee80211_chswitch_done(ctx->vif, is_success);
> -               mutex_lock(&priv->mutex);
>                priv->switch_rxon.switch_in_progress = false;
> -               mutex_unlock(&priv->mutex);
>        }
>  }
>  EXPORT_SYMBOL(iwl_legacy_chswitch_done);
>



-- 
James Hogan
