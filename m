Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab0DQJdb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 05:33:31 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:8924 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab0DQJd3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 05:33:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bPKH284WfGf14BvhC9Nl6f2h8i8FJX4JogrzSLuM6lersxnXC3O/t2bUBZunSVYZgB
         PaZElpQhjNLQr/oVzRidnbcsTMp1H+gyMz4/aCGfzsR1Z6tUUXXUMnK0TcM2L9Ci5Gyz
         XsiNCHjuy51xf90xphCiZ+en1vblOogsiu2gk=
MIME-Version: 1.0
In-Reply-To: <20100414205959.GB11838@core.coreip.homeip.net>
References: <r2x9e89675b1004080434yfea09b06x2c3c4680a9437a9@mail.gmail.com>
	 <g2v9e89675b1004130429w6f6f9775u2e34d4727de706e@mail.gmail.com>
	 <20100414205959.GB11838@core.coreip.homeip.net>
Date: Sat, 17 Apr 2010 11:33:27 +0200
Message-ID: <m2k9e89675b1004170233yb5ab19ach1713ccbee001883e@mail.gmail.com>
Subject: Re: [PATCH] input: handle bad parity PS/2 packets in mouse drivers 
	better
From: Damjan Jovanovic <damjan.jov@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Alessandro Rubini <rubini@cvml.unipv.it>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 10:59 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi Damjan,
>
> On Tue, Apr 13, 2010 at 01:29:20PM +0200, Damjan Jovanovic wrote:
>> This fixes a regression introduced in Linux 2.6.2 where mice that
>> sporadically produce bad parity go crazy and start jumping around and
>> clicking randomly, which never happens in any version of Windows
>> running on the same hardware. The bugzilla bug is
>> https://bugzilla.kernel.org/show_bug.cgi?id=6105
>>
>> The patch works by always accumulating a full PS/2 packet, then
>> ignoring the packet if any byte had a bad checksum. A month of testing
>> it against an affected mouse has revealed it works perfectly in
>> practice.
>>
>> This is the third resend, also CC'ed to lkml and Andrew Morton this
>> time, because the previous 2 emails to linux-input@vger.kernel.org and
>> the input/mouse maintainers from 28 March 2010 were ignored.
>>
>
> I am not sure whether we can rely on the mouse and KBC combo to always
> finish transmitting entire packet when parity error is detected,
> regardless of the protocol involved. However I had a chanceto observe
> several versions of the $OTHER_OS in presence of parity errors and
> they (at least when used with stock mouse driver) appear to simply
> ignore errors and process motion data as usual. Therefore I propose
> instead of your patch the patch below.
>
> Could you please try it on your box and see if it helps?
>
> Thanks.
>
> --
> Dmitry

Hi Dmitry and others

This patch works.

Thank you
Damjan Jovanovic





>
> Input: psmouse - ignore parity error for basic protocols
>
> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>
> Observing behavior of the other OS it appears that parity errors reported
> by the keyboard controller are being ignored and the data is processed
> as usual. Let's do the same for standard PS/2 protocols (bare, Intellimouse
> and Intellimouse Explorer) to provide better compatibility. Thsi should fix
> teh following bug:
>
>        https://bugzilla.kernel.org/show_bug.cgi?id=6105
>
> Thanks for Damjan Jovanovic for locating the source of issue and ideas
> for the patch.
>
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
>
>  drivers/input/mouse/psmouse-base.c |   18 +++++++++++++++---
>  drivers/input/mouse/psmouse.h      |    1 +
>  2 files changed, 16 insertions(+), 3 deletions(-)
>
>
> diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
> index d8c0c8d..cbc8072 100644
> --- a/drivers/input/mouse/psmouse-base.c
> +++ b/drivers/input/mouse/psmouse-base.c
> @@ -110,6 +110,7 @@ static struct workqueue_struct *kpsmoused_wq;
>  struct psmouse_protocol {
>        enum psmouse_type type;
>        bool maxproto;
> +       bool ignore_parity; /* Protocol should ignore parity errors from KBC */
>        const char *name;
>        const char *alias;
>        int (*detect)(struct psmouse *, bool);
> @@ -288,7 +289,9 @@ static irqreturn_t psmouse_interrupt(struct serio *serio,
>        if (psmouse->state == PSMOUSE_IGNORE)
>                goto out;
>
> -       if (flags & (SERIO_PARITY|SERIO_TIMEOUT)) {
> +       if (unlikely((flags & SERIO_TIMEOUT) ||
> +                    ((flags & SERIO_PARITY) && !psmouse->ignore_parity))) {
> +
>                if (psmouse->state == PSMOUSE_ACTIVATED)
>                        printk(KERN_WARNING "psmouse.c: bad data from KBC -%s%s\n",
>                                flags & SERIO_TIMEOUT ? " timeout" : "",
> @@ -759,6 +762,7 @@ static const struct psmouse_protocol psmouse_protocols[] = {
>                .name           = "PS/2",
>                .alias          = "bare",
>                .maxproto       = true,
> +               .ignore_parity  = true,
>                .detect         = ps2bare_detect,
>        },
>  #ifdef CONFIG_MOUSE_PS2_LOGIPS2PP
> @@ -786,6 +790,7 @@ static const struct psmouse_protocol psmouse_protocols[] = {
>                .name           = "ImPS/2",
>                .alias          = "imps",
>                .maxproto       = true,
> +               .ignore_parity  = true,
>                .detect         = intellimouse_detect,
>        },
>        {
> @@ -793,6 +798,7 @@ static const struct psmouse_protocol psmouse_protocols[] = {
>                .name           = "ImExPS/2",
>                .alias          = "exps",
>                .maxproto       = true,
> +               .ignore_parity  = true,
>                .detect         = im_explorer_detect,
>        },
>  #ifdef CONFIG_MOUSE_PS2_SYNAPTICS
> @@ -1222,6 +1228,7 @@ static void psmouse_disconnect(struct serio *serio)
>  static int psmouse_switch_protocol(struct psmouse *psmouse,
>                                   const struct psmouse_protocol *proto)
>  {
> +       const struct psmouse_protocol *selected_proto;
>        struct input_dev *input_dev = psmouse->dev;
>
>        input_dev->dev.parent = &psmouse->ps2dev.serio->dev;
> @@ -1245,9 +1252,14 @@ static int psmouse_switch_protocol(struct psmouse *psmouse,
>                        return -1;
>
>                psmouse->type = proto->type;
> -       } else
> +               selected_proto = proto;
> +       } else {
>                psmouse->type = psmouse_extensions(psmouse,
>                                                   psmouse_max_proto, true);
> +               selected_proto = psmouse_protocol_by_type(psmouse->type);
> +       }
> +
> +       psmouse->ignore_parity = selected_proto->ignore_parity;
>
>        /*
>         * If mouse's packet size is 3 there is no point in polling the
> @@ -1267,7 +1279,7 @@ static int psmouse_switch_protocol(struct psmouse *psmouse,
>                psmouse->resync_time = 0;
>
>        snprintf(psmouse->devname, sizeof(psmouse->devname), "%s %s %s",
> -                psmouse_protocol_by_type(psmouse->type)->name, psmouse->vendor, psmouse->name);
> +                selected_proto->name, psmouse->vendor, psmouse->name);
>
>        input_dev->name = psmouse->devname;
>        input_dev->phys = psmouse->phys;
> diff --git a/drivers/input/mouse/psmouse.h b/drivers/input/mouse/psmouse.h
> index e053bdd..593e910 100644
> --- a/drivers/input/mouse/psmouse.h
> +++ b/drivers/input/mouse/psmouse.h
> @@ -47,6 +47,7 @@ struct psmouse {
>        unsigned char pktcnt;
>        unsigned char pktsize;
>        unsigned char type;
> +       bool ignore_parity;
>        bool acks_disable_command;
>        unsigned int model;
>        unsigned long last;
>
