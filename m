Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab0HPTYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 15:24:52 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41479 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007Ab0HPTYu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 15:24:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dAlpDhs4Sdn1TZoHQ14mdXSORnqZIMob1SerrVnFlbFgUDIyoNki/KS6cPFI4SAHub
         0Qzq0Kc+3b36bDngPnVjsU/4Sn0+4/UTs+JtVvv5NWQHXgMXID8kzh9ZjzafsshmQk7Y
         +PfoAHllzJ+I3tA7Qlu4P5CFQEfWEBK6lTc18=
MIME-Version: 1.0
In-Reply-To: <363bd749a38d0b785d8431e591bf54c38db4c2d7.1281956490.git.richard.cochran@omicron.at>
References: <cover.1281956490.git.richard.cochran@omicron.at>
	<363bd749a38d0b785d8431e591bf54c38db4c2d7.1281956490.git.richard.cochran@omicron.at>
Date: Mon, 16 Aug 2010 12:24:48 -0700
X-Google-Sender-Auth: OQLi_wnldUaMDRpMm_auyJnPSNs
Message-ID: <AANLkTik_2MKMhOuDGOmu8Kzyq-ipLe+Bxrb3FaD+Tv4U@mail.gmail.com>
Subject: Re: [PATCH 1/5] ptp: Added a brand new class driver for ptp clocks.
From: john stultz <johnstul@us.ibm.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, Krzysztof Halasa <khc@pm.waw.pl>,
        Rodolfo Giometti <giometti@linux.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 4:17 AM, Richard Cochran
<richardcochran@gmail.com> wrote:
> This patch adds an infrastructure for hardware clocks that implement
> IEEE 1588, the Precision Time Protocol (PTP). A class driver offers a
> registration method to particular hardware clock drivers. Each clock is
> exposed to user space as a character device with ioctls that allow tuning
> of the PTP clock.
>
> Signed-off-by: Richard Cochran <richard.cochran@omicron.at>

Hey Richard!
   Its very cool to see this work on lkml! I'm excited to see more
work done on ptp.  We had a short private thread discussion earlier (I
got busy and never replied to your last message, my apologies!), but I
wanted to bring up the concerns I have here as well.

A few comments below....

> +** PTP user space API
> +
> +   The class driver creates a character device for each registered PTP
> +   clock. User space programs may control the clock using standardized
> +   ioctls. A program may query, enable, configure, and disable the
> +   ancillary clock features. User space can receive time stamped
> +   events via blocking read() and poll(). One shot and periodic
> +   signals may be configured via an ioctl API with semantics similar
> +   to the POSIX timer_settime() system call.

As I mentioned earlier, I'm not a huge fan of the char device
interface for abstracted PTP clocks.
If it was just the direct hardware access, similar to RTC, which user
apps then use as a timesource, I'd not have much of a problem. But as
I mentioned in an earlier private mail, the abstraction level concerns
me.

1) The driver-like model exposes a char dev for each clock, which
allows for poorly-written userland applications to hit portability
issues  (ie: /dev/hpet vs /dev/rtc). Granted this isn't a huge flaw,
but good APIs should be hard to get wrong.

2) As Arnd already mentioned, the chardev interface seems to duplicate
the clock_gettime/settime() and adjtimex() interfaces.

3) I'm not sure I see the benefit of being able to have multiple
frequency corrected time domains.  In other words, what benefit would
you get from adjusting a PTP clock's frequency instead of just
adjusting the system's time freq? Having the PTP time as a reference
to correct the system time seems reasonable, but I'm not sure I see
why userland would want to adjust the PTP clock's freq.

thanks
-john
