Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab1ABTpe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 14:45:34 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43795 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab1ABTpc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 14:45:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EO/G9p5KQdKNbL7v8FrxFKzkOKXNZSd6W7Jubc4LNF9o9W2J7prJJ5NEma09VVWXMD
         lHi8i0e8Q6ImFskYNngE1fXevfoNxVfypC422oxhUBGWDFRkyOgaWpJt0gJvfBYBb7Hl
         hZwNaFD9gdIbQeIZNmQMLGHL5q4tEFIcsUnRI=
MIME-Version: 1.0
In-Reply-To: <CE761E84DADF2947A4AF22FB8D97A47331E875CD@shsmsx501.ccr.corp.intel.com>
References: <1293023621-3077-1-git-send-email-tardyp@gmail.com>
	<41EFD7A46E18724CAB128DAD00733480193D2AE61C@shsmsx502.ccr.corp.intel.com>
	<AANLkTinYWODS785AefQ7hV+urPkAn1+En-fZEaFQygLG@mail.gmail.com>
	<CE761E84DADF2947A4AF22FB8D97A47331E86F6E@shsmsx501.ccr.corp.intel.com>
	<AANLkTimB7h0ZxvSOt2dUkO90RxE2c3Bu3CRqpasgzxw=@mail.gmail.com>
	<CE761E84DADF2947A4AF22FB8D97A47331E875CD@shsmsx501.ccr.corp.intel.com>
Date: Sun, 2 Jan 2011 20:45:31 +0100
Message-ID: <AANLkTimbTwKMHrpmREwnq+19vwWZv6qYwQCkB=jr3aUp@mail.gmail.com>
Subject: Re: [RFC] sdhci: use ios->clock to know when sdhci is idle
From: Pierre Tardy <tardyp@gmail.com>
To: "Gao, Yunpeng" <yunpeng.gao@intel.com>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
        "Yuan, Hang" <hang.yuan@intel.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>, Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Takashi Iwai <tiwai@suse.de>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 30, 2010 at 11:37 AM, Gao, Yunpeng <yunpeng.gao@intel.com> wrote:
>>> So, why we have to move to the 'aggressive clock gating framework'?
>>
>>The aggressive clock gating makes more sense since the different
>>drivers will know better how to handle the gating. ios with f=0 can
>>be interpreted differently. Else every driver has to register
>>runtime PM hooks for this, which is less elegant.
>
> Thanks for the response. I just curious that is this the only reason to change the framework? To my understanding, seems it's not a very strong reason :-)
>
> Take the example of sd/mmc card -
> by using the aggressive clock gating framework, it means the host controller will gate (clock gating or power gating) itself if not receiving requests for 8 clocks even if the request queue of mmc block driver is not empty at that time. So the host controller has to be gated / ungated repeatedly until the current request queue of mmc block driver becomes empty. I don't think this is elegant since most of the gating / ungating operations are not necessary.

I'm also concerned by thrashing. Please see my original patch. I am
using pm_runtime_put_autosuspend() so that suspend timeout can be
tweaked in user space.

Please also note that clock gating only platforms must also be
concerned by thrashing, as clock_disable() call might endup with PLL
power down that will have to be warmed up again later...

>
> Instead, if we do it in the mmc block driver by just call the pm_runtime_put() once the current request queue is empty and call pm_runtime_get() once any new request comes, then the host controller can be gated/ungated appropriately.
My original patch does not include any ignore_child() call. So that
children can decide wether they want to prevent suspension of their
parent.That will be the case of a wifi card who uses runtime_pm to
manage its own power, and still wants its sdio bus to suspend
automatically when not used (wifi idle)


Regards,
Pierre
